#include <plog/Log.h>
#include <plog/Appenders/ColorConsoleAppender.h>
#include <plog/Formatters/TxtFormatter.h>

#include <gtest/gtest.h>

int main(int argc, char** argv)
{
    // Init logging
    static auto& logger = plog::init(plog::Severity::debug);
    static plog::ColorConsoleAppender<plog::TxtFormatter> debugAppender;
    logger.addAppender(&debugAppender);
    logger.setMaxSeverity(plog::Severity::verbose);

    ::testing::InitGoogleTest(&argc, argv);

    return RUN_ALL_TESTS();
}