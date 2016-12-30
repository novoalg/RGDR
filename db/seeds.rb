# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

    User.create(
        first_name: "Bob", 
        last_name: "Burger", 
        age: 45, email: "bob@b.com", 
        address_line_one: "Burger Avenue", 
        address_line_two: "", 
        city: "Collierville", 
        state: "TN", 
        zip: "38012", 
        phone: "1114440000", 
        password: "asdasd", 
        password_confirmation: "asdasd", 
        hierarchy: 0
    )

    StaticPage.create(
        about_us: Faker::Lorem.paragraph, 
        sidebar: Faker::Lorem.paragraph, 
        contact_us: Faker::Lorem.paragraph,
        help: Faker::Lorem.paragraph, 
        home_block_one: Faker::Lorem.paragraph, 
        woofs_for_help: Faker::Lorem.paragraph
    )
