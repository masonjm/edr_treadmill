require "activities/network_activity"
require "socket"

RSpec.describe EdrTreadmill::Activities::NetworkActivity do
  DATA = {
    received_content: ""
  }
  before(:each) do
    DATA[:received_content] = ""
  end

  let(:content) { "Mission Accomplished" }
  subject do
    EdrTreadmill::Activities::NetworkActivity
      .new(
        host: "127.0.0.1",
        port: 4444,
        protocol: protocol,
        content: content
      )
      .execute
  end

  shared_examples "a network activity" do
    its([:timestamp])        { is_expected.to be_a(Time) }
    its([:user])             { is_expected.to eq(ENV["USER"])}
    its([:destination_host]) { is_expected.to eq("127.0.0.1")}
    its([:destination_port]) { is_expected.to eq(4444) }
    its([:source_host])      { is_expected.to eq("127.0.0.1") }
    its([:source_port])      { is_expected.to be_an(Integer) }
    its([:data_size])        { is_expected.to eq(20) }
    its([:protocol])         { is_expected.to eq(protocol) }
    its([:process_name])     { is_expected.to match(/rspec$/) }
    its([:command_line])     { is_expected.to match(/rspec/) }
    its([:pid])              { is_expected.to be_an(Integer) }

    it "sends content to destination address" do
      subject # send it!
      sleep(0.1) # give the server thread a chance to process the data
      expect(DATA[:received_content]).to eq(content)
    end
  end

  context "using udp protocol" do
    let(:protocol) { "udp" }

    before(:all) do
      Thread.new do
        Socket.udp_server_loop(4444) do |msg, _msg_src|
          DATA[:received_content] = msg
        end
      end
      sleep 0.1 # give the server time to bind before starting the tests
    end

    it_behaves_like "a network activity"
  end

  context "using tcp protocol" do
    let(:protocol) { "tcp" }

    before(:all) do
      Thread.new do
        server = TCPServer.new(4444)
        loop do
          request = server.accept
          DATA[:received_content] = request.gets
        end
      end
      sleep 0.1 # give the server time to bind before starting the tests
    end

    it_behaves_like "a network activity"
  end
end
