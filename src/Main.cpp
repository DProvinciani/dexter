#include <Definitions.h>

#include <plog/Log.h>
#include <plog/Appenders/ColorConsoleAppender.h>
#include <plog/Formatters/TxtFormatter.h>

int main(int argc, char** argv)
{
    // Init logging
    static auto& logger = plog::init(plog::Severity::debug);
    static plog::ColorConsoleAppender<plog::TxtFormatter> debugAppender;
    logger.addAppender(&debugAppender);
    logger.setMaxSeverity(plog::Severity::verbose);

    if (argc < 2) {
        // report version
        LOGD << argv[0] << " Version " << dexter_VERSION_MAJOR << "."
            << dexter_VERSION_MINOR << std::endl;
        return 1;
    }
}