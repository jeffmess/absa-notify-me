module Absa
  module NotifyMe
    
    class XmlStatement
      
      def self.convert_hash(hash)
        # Recursive function to convert a nested hashes keys to
        # downcased sym links. Caters for values being Arrays of
        # Hashes.
        
        new_hash = {}
        hash.each do |k,v|
          new_hash.merge!({k.downcase.to_sym => v}) unless (v.is_a? Array) or (v.is_a? Hash)

          if v.is_a? Array
            v.each do |h|
              if new_hash.has_key? k.downcase.to_sym
                new_hash[k.downcase.to_sym] << convert_hash(h)
              else
                new_hash.merge!({k.downcase.to_sym => [convert_hash(h)]})
              end
            end
          end

          if v.is_a? Hash
            new_hash.merge!({k.downcase.to_sym => convert_hash(v)})
          end
        end
        new_hash
      end
      
      def self.file_to_hash(file)
        input_string = File.open(file, "rb").read
        self.string_to_hash(input_string)
      end
      
      def self.string_to_hash(string)
        hash = {type: 'document', data: {type: 'notifyme_account', data: []}}
        
        Nori.parser = :nokogiri
        xml_doc = Nori.parse(string)
        converted_xml_doc = self.convert_hash(xml_doc)
                
        converted_xml_doc.each do |k,v|
          v.each do |key, value|
            if key == :notif_header
              hash[:data][:data] << {
                type: 'header',
                data: {
                  daily_no: value[:daily_no],
                  client_code: value[:client_id],
                  client_name: value[:sname],
                  processing_date: value[:creation_date],
                  processing_time: value[:creation_time],
                  buss_dir_code: value[:buss_dir_code]
                }
              }
            end
            if key == :details
              transactions = value[:transaction].blank? ? value["TRANSACTION"] : value[:transaction]
              transactions.each do |transaction|
                amount = (transaction[:amt].to_f * 100).to_i.to_s
                account_balance = (transaction[:acc_bal].to_f * 100).to_i.to_s
                
                hash[:data][:data] << {
                  type: "detail",
                  data: {
                    account_number: transaction[:trg_acc],
                    event_number: transaction[:event_no],
                    customer_reference: transaction[:clref],
                    currency: transaction[:curr],
                    amount: amount,
                    account_balance_after_transaction: account_balance,
                    transaction_type: transaction[:tran_type],
                    transaction_processing_date: transaction[:pdate],
                    clearance_payment_indicator: transaction[:clr_paym_ind],
                    transaction_description: transaction[:paym_desc],
                    checksum: transaction[:checksum]
                  }
                }
              end
            end
            if key == :notif_trailer
              total_credit = (value[:total_cr].to_f * 100).to_i.to_s
              total_debit = (value[:total_dt].to_f * 100).to_i.to_s
              
              hash[:data][:data] << {
                type: "trailer",
                data: {
                  total_credit: total_credit,
                  total_debit: total_debit,
                  total_recs: value[:total_recs],
                  check_sum: value[:check_sum]
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
