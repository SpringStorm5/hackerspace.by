unless Rails.env.production?
  Project.destroy_all
  User.destroy_all
  Device.destroy_all
  Event.destroy_all
  News.destroy_all

  User.create(email: 'developer@hackerspace.by', password: '111111')
  User.create(email: 'developer2@hackerspace.by', password: '111111')

  7.times do
    Project.create!(name: Faker::Commerce.product_name,
                    short_desc: Faker::Lorem.paragraph(rand(2..4)),
                    full_desc: Faker::Lorem.paragraph(rand(7..20)),
                    user: User.all.sample,
                    photo: File.open(Dir['public/images/*.jpg'].sample))
  end
  7.times do
    News.create!(title: Faker::Commerce.product_name,
                 short_desc: Faker::Lorem.paragraph(rand(5..12)),
                 description: Faker::Lorem.paragraph(rand(7..20)),
                 public: true,
                 markup_type: 'html',
                 photo: File.open(Dir['public/images/*.jpg'].sample))
  end

  Device.create(name: 'device1', password: '111111')
  Device.create(name: 'device2', password: '111111')

  60.times do
    Event.create(event_type: %w(light dark).sample, value: %w(on off).sample, device: Device.all.sample)
  end

  Device.all.each(&:mark_repeated_events)
end
