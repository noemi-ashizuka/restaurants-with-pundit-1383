require 'yaml'
require 'open-uri'


puts 'Removing the restaurants...'
Restaurant.destroy_all

CHEFS = %w[Justin Syrene Rashad Miho Raecine Eduard Megumi Taka Jane Sho Laurice Martin Osama Vincent Tiger]
CATEGORIES = %W[burger burgers ramen sushi desserts healthy kebabs pizza tacos sandwiches dumplings soup curry rice pasta steakhouse vegan bakery juice salads seafood brunch wings cafe bbq deli pies buffet pub brasserie shakes creamery grill]

def get_category(name)
  last_word = name.split.last.downcase
  CATEGORIES.include?(last_word) ? last_word : CATEGORIES.sample
end

addresses_url = 'https://gist.githubusercontent.com/trouni/599e03440e2552e803c54c62916f874c/raw/cc7aff8deeb27c3f22ee501b6723766a8cb68f2b/addresses.yml'
serialized_addresses = URI.open(addresses_url).read
addresses = YAML.load(serialized_addresses)

puts "Creating #{CHEFS.count} Restaurants..."
CHEFS.shuffle.each do |name|
  restaurant_name = Faker::Restaurant.unique.name
  restaurant = Restaurant.new(
    name: "#{name}'s #{restaurant_name}",
    address: addresses.sample,
    rating: rand(1..5),
    description: Faker::Restaurant.description,
    category: get_category(restaurant_name),
    chef_name: name
  )
  restaurant.user = User.all.sample
  restaurant.save!
end
puts "...created #{Restaurant.count} restaurants"
