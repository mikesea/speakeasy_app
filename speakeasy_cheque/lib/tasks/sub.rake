task :subscribe => :environment do
  CHANNELS = ['created_messages', 'created_rooms', 'destroyed_rooms', 'created_permissions', 'created_users']

  SpeakeasyOnTap::subscribe_to_channels(CHANNELS) do |channel, data|
    puts channel.classify.constantize.create_from_on_tap(data)
  end
end
