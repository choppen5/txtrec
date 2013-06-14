class TxtController < ApplicationController
  def index
  end

  def send_text_message (number_to_send_to, message)

    twilio_sid = ENV['TWILIO_SID'] 
    twilio_token =  ENV['TWILIO_TOKEN']  
    twilio_phone_number = "4156926291"
    
    puts "twilio sid = #{twilio_sid} and twilio token = #{twilio_token}"
    

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    @twilio_client.account.sms.messages.create(
      :from => "+1#{twilio_phone_number}",
      :to => number_to_send_to,
      :body => message
    )
  end
  
  def recieve_text_message 
      message_body = params["Body"]
      from_number = params["From"]

      logger.debug "******************#{from_number}, #{message_body}"  
      to = get_requests(from_number)
      # if there is a request from this number - send the request to sender 
      if to != 0
        #send message to
        logger.debug "******************Found a request, sending to #{to} =  #{message_body}"
        send_text_message(to, message_body)
        #remove request
        #Request.delete_all("to = '#{to}' AND from = '#{from_number}'")
        Request.where(:to => from_number, :from => to).destroy_all
        
      else 
        #no matching requests  - check that this incoming phone number is registered, and if so send off requests to all contacts
        #1. check requests from this number
        get_phone_number(from_number, message_body)
        
        #2. check for 
      end
      
  end

  def get_phone_number (number, message)
    @matches = User.where("usernumber = ?", number)
    
    logger.debug("Sorry,you are not registered on txtrec!")  unless @matches.any?  
  
    @matches.each do |usernumber|
       usernumber.registrations.each  do  |registration| 
         logger.debug "***************got rego #{registration.regname} = #{registration.renumber}"
         #add to requests table
         
         req = Request.create(:from => number, :to => registration.renumber)
         send_text_message(registration.renumber, message)
         # add to requests - scaffold
         # send message
       end
    end
    
  end
  
  
  def get_requests (from)
    @requests = Request.where("\"to\" = ?", from)
    
    logger.debug("***************No Requests") unless @requests.any?
    
    @requests.each do |req|
      logger.debug "*****************returning this number #{req.from}" 
      return req.from
    end
    
    return 0 #no matches
  end  
  
  #addressbook = matches.registrations 
  

      
 

end