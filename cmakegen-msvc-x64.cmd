@echo off

pushd %~dp0
set SCRIPT_DIR=%CD%
popd

set PROJECT_DIR=%SCRIPT_DIR%

set VS_VERSION=16

echo [43mGenerating development project[0m
echo.

:: Check dev env set up
where cl.exe > NUL 2>&1
if "%errorlevel%" neq "0" (
    echo [WARNING] cl.exe not found. Try to init dev env first.
    call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
)

echo [36mUse Visual Studio %VS_VERSION% generator[0m
 
:: Configure build variables.
set CMAKE_GENERATOR=-G "Visual Studio %VS_VERSION% 2019" -A x64 -T v142

set BUILD_DIR=%PROJECT_DIR%\build

echo [36mCreating a build directory[0m
if not exist %BUILD_DIR% mkdir %BUILD_DIR%

pushd %BUILD_DIR%

echo [36m[Conan] Downloading third-party packages[0m
conan install ^
    --build missing ^
    -s build_type=Debug ^
    -s compiler="Visual Studio" ^
    -s compiler.version=%VS_VERSION% ^
    %PROJECT_DIR%

if errorlevel 1 goto :error

echo [36m[CMake] Generating the project[0m
cmake ^
    %CMAKE_GENERATOR% ^
    %PROJECT_DIR%

if errorlevel 1 goto :error

echo.
echo [32mProject has been generated successfully![0m
echo.
popd

goto :eof

:error
echo.
echo [31m[ERROR] Failed to generate the project.[0m
echo.
popd

exit /b 1
