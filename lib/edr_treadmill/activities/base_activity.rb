require "etc"
require "active_support/core_ext/string/inflections"
require "active_support/core_ext/string/conversions"
require "active_support/core_ext/class/attribute"

module EdrTreadmill
  module Activities
    class BaseActivity
      class_attribute :activity_name
      def self.activity_name
        name.demodulize.underscore.sub(/_activity$/, "")
      end

      class_attribute :activity_description, default: ""

      # Metadata for Thor to render command-line help.
      # See https://github.com/rails/thor/wiki/Method-Options for available
      # options.
      class_attribute :activity_options, default: {}

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
