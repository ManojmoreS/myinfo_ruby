require "myinfo_ruby/version"
require "myinfo_ruby/client"

module MyinfoRuby
  class << self
    def new config
      @client ||= MyinfoRuby::Client.new config
    end
  end
end
