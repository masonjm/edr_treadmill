require "activities/base_activity"

module EdrTreadmill
  module Activities
    class NetworkActivity < BaseActivity
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
          end
        end
    end
  end
end
