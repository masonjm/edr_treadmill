require "etc"

module EdrTreadmill
  module Activities
    class BaseActivity
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
