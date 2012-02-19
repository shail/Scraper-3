require 'yaml'
require 'open-uri'
require 'rubygems'
require 'mail'
require 'nokogiri'

class Scraper
  def initialize user_parameters_file_location="test.yml"
    user_parameters = Input.new(user_parameters_file_location).user_parameters
    craigslist_urls = Parse.new(user_parameters['craigslist_url']).email_list
    Email.new(user_parameters['gmail_username'], user_parameters['password'], craigslist_urls)
  end
end

class Input
  attr_reader :user_parameters
  
  def initialize source
    parse_yaml_file source if is_yaml_file? source
  end
  
  def parse_yaml_file yaml_location
    @user_parameters = YAML.load_file(yaml_location)
  end

  private
  
  def is_yaml_file? source
    source.downcase.match(".yml")
  end

end




class Parse
  attr_reader :email_list
  
  def initialize list_url
    @email_list = []
    parse_page(get_url_list(list_url))
  end
   
  def get_url_list list_url
    link_list = []
    doc = Nokogiri::HTML(open(list_url))

    doc.css('a').each do |node|
      url = node.attributes['href'].to_s
      contents = node.children.to_s
      price = 0

      contents.scan(/\$(\d+)/) { price = $1}
      
      link_list << [url, price] if price.to_i > 0
    end
    
    return link_list
  end
  
  def parse_page link_list
    link_list.each do |url_array|  
      doc = Nokogiri::HTML(open(url_array[0]))
      email = ""


      doc.css('a').each do |node|
        link = node.children.to_s
        if link.match("@")
          email = link 
          @email_list << [email, url_array[1], url_array[0]]
          #puts "For link #{url_array[0]}: #{email}: $#{url_array[1]}"
          break
        end
      end
    end
    
  end
end


class Email
  def initialize username, password, email_list
    @username = username
    @password = password
    send_emails email_list
  end
  
  def exists_in_log? email_subject, email_message, target_email, variables
    #to be filled in later
    false
  end
  
  def add_to_log email_subject, email_message, target_email, variables
    #to be filled in later
  end
  
  def send_email email_subject, email_message, target_email, variables = {}
    unless exists_in_log?(email_subject, email_message, target_email, variables)
      
      
      Mail.defaults do
        delivery_method :smtp, { :address              => "smtp.gmail.com",
                                 :port                 => 587,
                                 :domain               => 'gmail.com',
                                 :user_name            => "testerdbc@gmail.com",
                                 :password             => 'mvclover',
                                 :authentication       => 'plain',
                                 :enable_starttls_auto => true  }
      end

      mail = Mail.new 

      mail['from'] = @username
      mail['to']    = target_email
      mail['subject'] = email_subject
      mail['body'] = email_message
      #mail.deliver!
      
      puts mail.to_s
    
    end
    
    

      
    
  end
  
  def send_emails email_list
    email_list.each do |info|
      email = info[0]
      price = info[1]
      url = info[2]
      send_email 'LOVE YOUR APARTMENT', "I love your apartment. I want to build a gun range in your home and hopefully there is space for my 15 cats", email
    end
    
  end
end

Scraper.new("test.yml")


 #emailobj = Email.new('testerdbc@gmail.com', "mvclover", [["rogergraves@gmail.com", "4400", "http://craigslist.org"]])
# emailobj.send_email("Test email", "This is the message", "rogergraves@gmail.com")

