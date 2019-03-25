def get_random_record klass
  klass.offset(rand(klass.count)).first
end

def generate_uniq_login
  generate = proc{ Faker::Cannabis.unique.strain.gsub(' ', '_').downcase }
  10.times do 
    login = generate.call
    next if Customer.find_by_login(login).present?
    return login
  end
end

def records_created_message klass
  puts '*******************************'
  puts "#{klass} was successfully created"
  puts '*******************************'
end

Hook.transaction do 
  begin
    [Customer, Video, Hook].each &:truncate!

    20.times do
      Customer.create! login: generate_uniq_login
    end
    records_created_message 'customers'

    30.times do
      Video.create! name: Faker::TvShows::RickAndMorty.unique.character,
                    duration: Faker::Number.rand(100..10000),
                    customer_id: get_random_record(Customer).id

    end 
    records_created_message 'videos'

    1000.times do 
      Hook.create! video_id:    get_random_record(Video).id,
                   customer_id: get_random_record(Customer).id
    end
    records_created_message 'hooks'
  rescue => e
    puts "Woops, error. Better luck next time)"
    puts "Here's some details, bro: "
    puts e
    raise ActiveRecord::Rollback
  end
end