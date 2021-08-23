set(BOOST_VERSION "1.77.0")
string(REPLACE "." "_" BOOST_VERSION_UNDERSCORE ${BOOST_VERSION})
set(BOOST_URL "https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_UNDERSCORE}.tar.bz2")
set(BOOST_HASH "SHA256=fc9f85fc030e233142908241af7a846e60630aa7388de9a5fafb1f3a26840854")

set(CATCH_URL "https://github.com/catchorg/Catch2.git")
set(CATCH_TAG "b1b5cb812277f367387844aab46eb2d3b15d03cd")

set(SPDLOG_URL "https://github.com/gabime/spdlog.git")
set(SPDLOG_TAG "v1.9.2")

set(STREAMING_PERCENTILES_URL "https://github.com/sengelha/streaming-percentiles.git")
set(STREAMING_PERCENTILES_TAG "v3.1.0")

set(PULSAR_URL "https://github.com/apache/pulsar.git")
set(PULSAR_TAG "v2.7.3")
