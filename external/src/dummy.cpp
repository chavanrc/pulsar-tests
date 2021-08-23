#include <boost/program_options.hpp>
#include <iostream>

using namespace boost::program_options;

int main(int argc, const char *argv[]) {
    int port = 9001;
    try {
        options_description desc{"Options"};
        desc.add_options()("help,h", "Help screen")("port", value<int>()->default_value(port), "Port");
        variables_map vm;
        store(parse_command_line(argc, argv, desc), vm);
        notify(vm);
        if (vm.count("help")) {
            std::cout << desc << '\n';
            return 0;
        } else if (vm.count("port")) {
            port = vm["port"].as<int>();
        } else {
            return 0;
        }
    } catch (const error &ex) {
        std::cerr << ex.what() << '\n';
    }
}