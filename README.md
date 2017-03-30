# README

This steps are necessary to get the application up and running.

Ruby version: 2.4.0
Rails version: 5.0.2

System dependencies
  * redis 3.2.6
  * PostgreSQL 9.6.1

Configuration
  * bundle install
  * rails db:setup

Run the test suite
  rspec spec

Start application
  foreman start (start Sidekiq and Application)

