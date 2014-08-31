## Running the scheduling api

Requirements:
  * postgresql 9.2+
  * ruby 1.9.3+

Super simple just

  * bundle install
  * bundle exec rake db:create db:schema:load
  * bundle exec rails s
  * visit http://localhost:3000
