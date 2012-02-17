require 'yaml'
require 'open-uri'
require 'rubygems'
require 'mail'

class Input
  attr_reader :user_input
  
  def initialize source
    if source.scan(".yml")
      @user_input = parse_yaml source
    end
    
  end
  
  def parse_yaml yaml_location
    YAML.load_file(yaml_location)
  end
end

class Email
  def initialize username, password
    @username = username
    @password = password
  end
end