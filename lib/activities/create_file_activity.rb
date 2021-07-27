require "etc"
require "fileutils"

module EdrTreadmill
  module Activities
    class CreateFileActivity
      def initialize(filename:, source:)
        @filename = filename
        @source = source
      end

      def execute
        FileUtils.cp(@source, @filename)
        {
          timestamp: Time.now,
          pid: Process.pid,
          process_name: $0,
          command_line: "#{$0} #{ARGV.join(" ")}".strip,
          user: Etc.getpwuid(Process.uid).name,
          path: @filename,
          activity: "create"
        }
      end
    end
  end
end
