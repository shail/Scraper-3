require './scraper.rb'

describe "Input" do
  before do
    @source= "test.yml"
    @input = Input.new(@source)
    
  end  
  
  
  it "Input class instantiates with YAML file location being passed" do
    @input.class.should == Input
  end
  
  it "parse_yaml method should return a hash" do
    @input.user_input.class.should == Hash
  end
  
  it "parse_yaml method parses hash successfully" do
     @input.user_input['craigslist_url'].length.should > 0
  end
  

end

describe "Email" do
  before do
    @email = Email.new('testerdbc@gmail.com', 'mvclover')
  end
  
  it "Email class instantiates with hash being passed" do
    @email.class.should == Email
  end
    
  
  
end

