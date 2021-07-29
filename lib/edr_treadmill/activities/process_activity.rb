require "edr_treadmill/activities/base_activity"
require "etc"

module EdrTreadmill
  module Activities
    class ProcessActivity < BaseActivity
      self.activity_description = "Spawn a new process"
      self.activity_options = {
        command: {
          required: true,
          type: :string,
          desc: "Process to spawn. Can include arguments."
        }
      }

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
