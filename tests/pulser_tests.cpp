#include <catch2/catch.hpp>
#include <pulsar/Client.h>
#include <thread>
#include <vector>

void RunProducer() {
    using namespace pulsar;
    Client client("pulsar://localhost:6650");

    Producer producer;
    Result result = client.createProducer("persistent://public/default/my-topic", producer);
    if (result != ResultOk) {
        std::cout << "Error creating producer: " << result << '\n';
        return;
    }

    // Send synchronously
    Message msg = MessageBuilder().setContent("content").build();
    Result res = producer.send(msg);
    std::cout << "Message sent: " << res << '\n';

    client.close();
}

void RunConsumer() {
    using namespace pulsar;
    Client client("pulsar://localhost:6650");

    Consumer consumer;
    Result result = client.subscribe("persistent://public/default/my-topic", "consumer-1", consumer);
    if (result != ResultOk) {
        std::cout << "Failed to subscribe: " << result << '\n';
        return;
    }
    Message msg;

    while (true) {
        consumer.receive(msg);
        std::cout << "Received: " << msg << "  with payload '" << msg.getDataAsString() << "'\n";

        consumer.acknowledge(msg);
    }

    client.close();
}

TEST_CASE("pulsar test", "[unit]") {
    std::vector<std::thread> threads;
    threads.emplace_back(RunProducer);
    threads.emplace_back(RunConsumer);
    for (auto &th : threads) {
        if (th.joinable()) {
            th.join();
        }
    }
}