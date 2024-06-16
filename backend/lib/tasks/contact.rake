namespace :contact do
    desc '問い合わせのステータスが対応済みの場合、問い合わせを削除する'
    task destroy: :environment do
        logger = Logger.new($stdout)

        logger.info '=====Start====='
        begin
            delete_target_contact = Contact.where(status: 1)
            
            delete_target_contact.each do |contact|
                contact.destroy!
                logger.info 'destroy contact_id: ' + contact.id.to_s
            end
        rescue ActiveRecord::RecordNotDestroyed => e
            logger.info e.message
        rescue StandardError => e
            logger.info e.message
        end
        logger.info '=====End====='
    end
end
