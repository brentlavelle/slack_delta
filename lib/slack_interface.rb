require 'slack-ruby-client'

module SlacklDiff
  class SlackMonitor
    def initialize token
      Slack.configure do |config|
        config.token = token
      end

      @client = Slack::RealTime::Client.new
    end

    def when_message &block
      @client.on :message do |data|
        yield data
      end
    end

    def start
      @client.start!
    end
  end
end
