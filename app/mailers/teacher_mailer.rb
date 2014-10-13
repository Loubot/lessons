class TeacherMailer < ActionMailer::Base

  def test_mail

    begin
      mandrill = Mandrill::API.new 'YOUR_API_KEY'
      message = {"google_analytics_campaign"=>"message.from_email@example.com",
       "merge"=>true,
       "important"=>false,
       "text"=>"Example text content",
       "attachments"=>
          [{"name"=>"myfile.txt",
              "type"=>"text/plain",
              "content"=>"ZXhhbXBsZSBmaWxl"}],
       "metadata"=>{"website"=>"www.example.com"},
       "merge_vars"=>
          [{"rcpt"=>"louisangelini@gmail.com",
              "vars"=>[{"name"=>"merge2", "content"=>"merge2 content"}]}],
       "global_merge_vars"=>[{"name"=>"merge1", "content"=>"merge1 content"}],
       "from_email"=>"message.from_email@example.com",
       "view_content_link"=>nil,
       "html"=>"<p>Example HTML content</p>",
       "recipient_metadata"=>
          [{"values"=>{"user_id"=>123456}, "rcpt"=>"recipient.email@example.com"}],
       "subaccount"=>"customer-123",
       "tags"=>["password-resets"],
       "to"=>
          [{"name"=>"Recipient Name",
              "email"=>"recipient.email@example.com",
              "type"=>"to"}],
       "auto_html"=>nil,
       "from_name"=>"Example Name",
       "subject"=>"example subject",
       "signing_domain"=>nil,
       "preserve_recipients"=>nil,
       "auto_text"=>nil,
       "headers"=>{"Reply-To"=>"message.reply@example.com"},
       "images"=>
          [{"name"=>"IMAGECID", "type"=>"image/png", "content"=>"ZXhhbXBsZSBmaWxl"}],
       "google_analytics_domains"=>["example.com"],
       "return_path_domain"=>nil,
       "inline_css"=>nil,
       "tracking_domain"=>nil,
       "url_strip_qs"=>nil,
       "track_opens"=>nil,
       "bcc_address"=>"message.bcc_address@example.com",
       "track_clicks"=>nil}
      async = false
      ip_pool = "Main Pool"
      
      result = mandrill.messages.send message, async, ip_pool
          # [{"reject_reason"=>"hard-bounce",
          #     "status"=>"sent",
          #     "_id"=>"abc123abc123abc123abc123abc123",
          #     "email"=>"recipient.email@example.com"}]
      
  rescue Mandrill::Error => e
      # Mandrill errors are thrown as exceptions
      logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
      # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
      raise
    end
  end
end