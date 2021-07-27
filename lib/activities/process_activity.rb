require "etc"

module EdrTreadmill
  module Activities
    class ProcessActivity
      def initialize(command:)
        @command, @args = command.split(" ", 2)
      end

      def execute
        pid = Process.spawn(@command, @args)
        {
          timestamp: Time.now,
          pid: pid,
          user: Etc.getpwuid(Process.uid).name,
          process_name: @command,
          command_line: "#{@command} #{@args}".strip
        }
      end
    end
  end
end
