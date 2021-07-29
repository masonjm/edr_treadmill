require "etc"
require "active_support/core_ext/string/inflections"
require "active_support/core_ext/string/conversions"

module EdrTreadmill
  module Activities
    class BaseActivity
      def self.activity_name
        name.demodulize.underscore.sub(/_activity$/, "")
      end

      private

        def result(**kwargs)
          {
            timestamp: Time.now,
            pid: Process.pid,
            process_name: $0,
            command_line: "#{$0} #{ARGV.join(" ")}".strip,
            user: Etc.getpwuid(Process.uid).name
          }.merge(kwargs)
        end
    end
  end
end
