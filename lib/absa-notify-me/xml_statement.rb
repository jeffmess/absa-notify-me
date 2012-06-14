module Absa
  module NotifyMe
    
    class XmlStatement
      
      def self.file_to_hash(file)
        input_string = File.open(file, "rb").read
        self.string_to_hash(input_string)
      end
      
      def self.string_to_hash(string)
        hash = {type: 'document', data: {type: 'notifyme_account', data: []}}
        
        xml_doc = Nori.parse(string)
        
        xml_doc.each do |k,v|
          v.each do |key, value|
            if key == "NOTIF_HEADER"
              hash[:data][:data] << {
                type: 'header',
                data: {
                  daily_no: value["DAILY_NO"],
                  client_code: value["CLIENT_ID"],
                  client_name: value["SNAME"],
                  processing_date: value["CREATION_DATE"],
                  processing_time: value["CREATION_TIME"],
                  buss_dir_code: value["BUSS_DIR_CODE"]
                }
              }
            end
            if key == "DETAILS"
              value["TRANSACTION"].each do |transaction|
                hash[:data][:data] << {
                  type: "detail",
                  data: {
                    account_number: transaction["TRG_ACC"],
                    event_number: transaction["EVENT_NO"],
                    customer_reference: transaction["CLREF"],
                    currency: transaction["CURR"],
                    amount: (transaction["AMT"].to_f * 100).to_i.to_s,
                    account_balance_after_transaction: (transaction["ACC_BAL"].to_f * 100).to_i.to_s,
                    transaction_type: transaction["TRAN_TYPE"],
                    transaction_processing_date: transaction["PDATE"],
                    clearance_payment_indicator: transaction["CLR_PAYM_IND"],
                    transaction_description: transaction["PAYM_DESC"],
                    checksum: transaction["CHECKSUM"]
                  }
                }
              end
            end
            if key == "NOTIF_TRAILER"
              hash[:data][:data] << {
                type: "trailer",
                data: {
                  total_credit: (value["TOTAL_CR"].to_f * 100).to_i.to_s,
                  total_debit: (value ["TOTAL_DT"].to_f * 100).to_i.to_s,
                  total_recs: value["TOTAL_RECS"],
                  check_sum: value["CHECK_SUM"]
                }
              }
            end
          end
        end
        
        hash
      end
    end
  end
end
