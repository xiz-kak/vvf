require 'database_cleaner'

# TODO
# using database_rewinder would be better performance
RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.before(:suite) do
    load Rails.root.join('db', 'seeds.rb')
    DatabaseCleaner.clean_with :truncation, except: %w(languages)
  end
end
