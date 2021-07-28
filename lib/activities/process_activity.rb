require "activities/base_activity"
require "etc"

module EdrTreadmill
  module Activities
    class ProcessActivity < BaseActivity
      def initialize(command:)
        @command, @args = command.split(" ", 2)
      end

      def execute
        pid = Process.spawn(@command, @args)
        result(
          pid: pid,
          process_name: @command,
          command_line: "#{@command} #{@args}".strip
        )
      end
    end
  end
end
