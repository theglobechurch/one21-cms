# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create([
  {email: 'james@globe.church', password: 'password'},
  {email: 'info@globe.church', password: 'password'}
]);

Church.create([
  {church_name: 'The Globe Church', email: 'info@globe.church', url: 'https://www.globe.church', city: 'London'},
  {church_name: 'Hope Church Vauxhall', email: 'info@hopevauxhall.co.uk', url: 'https://hopevauxhall.co.uk', city: 'London', verified: true}
])
