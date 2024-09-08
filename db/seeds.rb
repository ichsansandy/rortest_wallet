# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Seed Users
user1 = User.create(name: "John Doe", email:"john.doe@email.com", password:"supersecretpassword")
user2 = User.create(name: "Jane Doe", email:"jane.doe@email.com", password:"supersecretpassword")

# Seed Teams
team1 = Team.create(name: "Alpha Team")
team2 = Team.create(name: "Beta Team")

# Seed Stocks
stock1 = Stock.create(name: "Tesla")
stock2 = Stock.create(name: "Apple")

puts "Seed data created successfully!"
