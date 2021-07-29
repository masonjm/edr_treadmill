require "socket"
require "edr_treadmill/activities/base_activity"

module EdrTreadmill
  module Activities
    class NetworkActivity < BaseActivity
      self.activity_description = "Send packets to HOST on PORT"
      self.activity_options = {
        host: {
          required: true,
          type: :string,
          desc: "Hostname or IP address of destination for network packets"
        },
        port: {
          required: true,
          type: :numeric,
          desc: "IP port on HOST"
        },
        protocol: {
          required: true,
          type: :string,
          enum: %w[tcp udp],
          default: "udp",
          desc: "IP protocol for generated traffic"
        },
        content: {
          required: true,
          type: :string,
          desc: "Bytes to send to HOST"
        }
      }

      def initialize(host:, port:, protocol:, content:)
        @host     = host
        @port     = port
        @protocol = protocol
        @content  = content
      end

      def execute
        socket_address = with_socket do |sock|
          sock.send(@content, 0)
        end

        result(
          destination_host: @host,
          destination_port: @port,
          source_host: socket_address.ip_address,
          source_port: socket_address.ip_port,
          data_size: @content.length,
          protocol: @protocol
        )
      end

      private

        def with_socket
          sock = create_socket
          yield(sock)
          sock.local_address
        ensure
          sock.close
        end

        def create_socket
          case @protocol
          when "udp"
            UDPSocket.new.tap do |sock|
              sock.connect(@host, @port)
            end
          when "tcp"
            TCPSocket.new(@host, @port)
          else
            $stderr.puts "Unknown protocol #{@protocol}"
            exit(1)
          end
        end
    end
  end
end
