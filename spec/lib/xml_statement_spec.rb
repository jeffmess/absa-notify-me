require 'spec_helper'

describe Absa::NotifyMe::XmlStatement do
  
  before(:each) do
    # @input_string = File.open("./spec/examples/test.xml", "rb").read
    # @hash = Absa::NotifyMe::XmlStatement.string_to_hash(@input_string)
    @hash = Absa::NotifyMe::XmlStatement.file_to_hash("./spec/examples/test.xml")
  end
  
  it "should be able to read the recon transmission header record" do
    @hash[:data][:data].first.should == { :type => "header", 
      :data => {
        :daily_no => "2326", 
        :client_code => "TEST", 
        :client_name => "TEST", 
        :processing_date => "20110509", 
        :processing_time => "13350612", 
        :buss_dir_code => "0310080"}
    }
  end
  
  it "should be able to read the recon transmission trailer record" do
    @hash[:data][:data].last.should == { :type => "trailer", 
      :data => {
        :total_credit => "31896728", 
        :total_debit => "0", 
        :total_recs => "          944", 
        :check_sum => "031A8EE087CFB656296FF93456B62639"}
    }
  end
end
