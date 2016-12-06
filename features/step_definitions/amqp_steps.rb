Then(/^the outgoing amqp queue should have a message with fields:$/) do |table|
  message = AmqpHelper::Connector[:default].with_parsed_message(Settings.amqp.outgoing_queue) {|m | m}
  table.raw.each do |key, value|
    expect(message[key].to_s).to eq(value.to_s)
  end
end

And(/^the incoming amqp queue has a message with fields:$/) do |table|
  Hash.new.tap do |message|
    table.raw.each do |key, value|
      message[key] = value
    end
    AmqpHelper::Connector[:default].send_message(Settings.amqp.incoming_queue, message)
  end
end

When(/^I process the incoming amqp queue$/) do
  AmqpReceiver.process_messages
end