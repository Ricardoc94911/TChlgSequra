# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


if Shopper.count == 0
    _path = File.join(File.dirname(__FILE__), "../seed_files/shoppers.json")
    _records = JSON.parse(File.read(_path))
    
    _shoppers = _records['RECORDS']

    _shoppers.each do |record|
        Shopper.create!(record)
    end
    puts "Shoppers are seeded"
end

if Merchant.count == 0
    _path = File.join(File.dirname(__FILE__), "../seed_files/merchants.json")
    _records = JSON.parse(File.read(_path))
    
    _merchants = _records['RECORDS']

    _merchants.each do |record|
        Merchant.create!(record)
    end
    puts "Merchants are seeded"
end

if Order.count == 0
    _path = File.join(File.dirname(__FILE__), "../seed_files/orders.json")
    _records = JSON.parse(File.read(_path))
    
    _orders = _records['RECORDS']

    _orders.each do |record|
        
        record['created_at'] = record['created_at'].size > 0 ? DateTime.parse(record['created_at']) : DateTime.now
        record['completed_at'] = record['completed_at'].size > 0 ? DateTime.parse(record['completed_at']) : nil
        Order.create!(record)
    end
    puts "Orders are seeded"
end