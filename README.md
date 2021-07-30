# EDR Treadmill

Exercise your EDRs.

This is a command-line utility for generating various types of system activity
to verify that a (separately installed and configured) Endpoint
Detection and Response agent is functioning as expected.

**NOTE: Don't actually use this. It was written for demonstration purposes
only**


## Installation

This project is intentionally _NOT_ published to rubygems.org. I don't want to
pollute the public namespace with something that's not intended for use.

This project requires Ruby 2.6+, bundler, and git.

First, clone this repository.

    $ git clone https://github.com/masonjm/edr_treadmill.git

And then install the gem locally:

    $ bin/setup
    $ rake install

Verify the gem is installed correctly

    $ edr_treadmill help


## Usage

The `edr_treadmill` executable provides access to a set of activity commands.
You can see a list of available activities by running the `edr_treadmill`
command:

    $ edr_treadmill

    Commands:
      edr_treadmill file_create --filename=FILENAME --source=SOURCE                     # Create a new file by copying an existing file
      edr_treadmill file_delete --filename=FILENAME                                     # Delete a file
      edr_treadmill file_modify --filename=FILENAME --source=SOURCE                     # Modify a file by appending the contents of a second file
      edr_treadmill help [COMMAND]                                                      # Describe available commands or one specific command
      edr_treadmill network --content=CONTENT --host=HOST --port=N --protocol=PROTOCOL  # Send packets to HOST on PORT
      edr_treadmill process --command=COMMAND                                           # Spawn a new process

Use the `help` command to get more detailed help about individual activities:

    $ edr_treadmill help network

    Usage:
      edr_treadmill network --content=CONTENT --host=HOST --port=N --protocol=PROTOCOL

    Options:
      --host=HOST          # Hostname or IP address of destination for network packets
      --port=N             # IP port on HOST
      --protocol=PROTOCOL  # IP protocol for generated traffic
                           # Default: udp
                           # Possible values: tcp, udp
      --content=CONTENT    # Bytes to send to HOST

    Send packets to HOST on PORT

Use a command to generate activity on the system

    $ edr_treadmill network --host=example.com --port=80 --content="Verify our range to target"

    {"timestamp":"2021-01-02T03:04:05.678-09:00","pid":47738,"process_name":"/path/to/ruby/version/bin/edr_treadmill","command_line":"/path/to/ruby/version/bin/edr_treadmill network --host=example.com --port=80 --content=Verify our range to target","user":"masonjm","destination_host":"example.com","destination_port":80,"source_host":"10.11.12.13","source_port":424242,"data_size":26,"protocol":"udp"}

All activites output results in JSON format that can be piped to a local log
file or `curl`'d to a remote collection API.


## Design

The system is designed as a collection of light-weight, self-contained `Activity`
classes. Each class extends a common `BaseActivity` class to inherit default
configuration and output formatting utilities.

A single `CLI` class provides a human-friendly integration point that ties all
of the Activity implementations together and handles input processing and output
formatting.

Creating a new Activity implementation requires:

1. Extend `EdrTreadmill::Activities::BaseActivity`
2. Define an `initialize` method that excepts all parameters as keyword arguments
3. Define an `execute` method to perform the Activity
4. Use `self.activity_options` to tell the `CLI` how to handle user input
5. Put some tests in `spec/activities` so that we all know your code works


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/masonjm/edr_treadmill.


## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
