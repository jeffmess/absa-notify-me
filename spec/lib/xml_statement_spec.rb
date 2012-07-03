require 'spec_helper'

describe Absa::NotifyMe::XmlStatement do
  
  before(:each) do
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
  
  context "Cater for an empty xml document" do
    before(:each) do
      @hash = Absa::NotifyMe::XmlStatement.file_to_hash("./spec/examples/empty_test.xml")
      @hash2 = Absa::NotifyMe::XmlStatement.file_to_hash("./spec/examples/test_with_one_record.xml")
    end
    
    it "should not contain a detail record" do
      @hash[:data][:data].select {|record| record[:type] == "detail"}.should be_blank
    end

    it "should contain a detail record" do
      @hash2[:data][:data].select {|record| record[:type] == "detail"}.count.should == 1
      puts @hash2.inspect
    end
  end
end
