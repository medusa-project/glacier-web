module AmqpReceiver

  module_function

  def process_messages
    continue = true
    while continue do
      AmqpHelper::Connector[:default].with_parsed_message(Settings.amqp.incoming_queue) do |message|
        if message
          process_message(message)
        else
          continue = false
        end
      end
    end
  end

  def process_message(message)
    case message['status']
      when 'success'
        process_success_message(message)
      when 'error'
        process_error_message(message)
      else
        raise RuntimeError, 'Unrecognized message status'
    end
  end

  def process_success_message(message)
    case message['action']
      when 'backup'
        process_backup_message(message)
      when 'file_info'
        process_file_info_message(message)
      else
        raise RuntimeError, 'Unrecognized message type'
    end
  end

  def process_error_message(message)
    ErrorMailer.error(message).deliver_now
  end

  def process_backup_message(message)
    job = Archive.find(message['archive_id']).job_archive_backup
    job.message = message
    job.save!
    job.put_in_queue(new_state: 'process_response')
  end

  def process_file_info_message(message)
    job = Root.find_by(path: message['root_path']).job_root_backup
    job.message = message
    job.save!
    job.put_in_queue(new_state: 'process_manifest')
  end

end