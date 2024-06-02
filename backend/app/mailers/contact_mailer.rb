class ContactMailer < ApplicationMailer
  def complete
    mail(to: ENV["DEVELOPMENT_MAIL_TO"], subject: "お問合せが届きました") do |format|
      format.text { render plain: email_body }
    end
  end

  private

    def email_body
      "お問合せが届いたので確認してください"
    end
end
