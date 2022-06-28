#include <gtest/gtest.h>

#include <string>
#include <vector>

#include <Split.h>

TEST(StringSplit, EmptyString)
{
    const std::string str{ "" };

    auto result = split(str, ',');

    EXPECT_EQ(result.size(), 0);
}