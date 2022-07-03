# TChlgSequra


## Introduction
In this tech challenge it was ask for me to implement a system that would calculate a weekly disbursement pass on to merchants according to a specified week orders. The company provided me with 3 JSON files: merchants.json, shoppers.json and orders.json. Each of these files contained a list of records regarding each of the components of the system to be implemented (merchants, shoppers and orders) in the following format.

### MERCHANTS
```
ID | NAME                      | EMAIL                             | CIF
1  | Treutel, Schumm and Fadel | info@treutel-schumm-and-fadel.com | B611111111
2  | Windler and Sons          | info@windler-and-sons.com         | B611111112
3  | Mraz and Sons             | info@mraz-and-sons.com            | B611111113
4  | Cummerata LLC             | info@cummerata-llc.com            | B611111114
```

### SHOPPERS

```
ID | NAME                 | EMAIL                              | NIF
1  | Olive Thompson       | olive.thompson@not_gmail.com       | 411111111Z
2  | Virgen Anderson      | virgen.anderson@not_gmail.com      | 411111112Z
3  | Reagan Auer          | reagan.auer@not_gmail.com          | 411111113Z
4  | Shanelle Satterfield | shanelle.satterfield@not_gmail.com | 411111114Z
```

### ORDERS

```
ID | MERCHANT ID | SHOPPER ID | AMOUNT | CREATED AT           | COMPLETED AT
1  | 25          | 3351       | 61.74  | 01/01/2017 00:00:00  | 01/07/2017 14:24:01
2  | 13          | 2090       | 293.08 | 01/01/2017 12:00:00  | nil
3  | 18          | 2980       | 373.33 | 01/01/2017 16:00:00  | nil
4  | 10          | 3545       | 60.48  | 01/01/2017 18:00:00  | 01/08/2017 15:51:26
5  | 8           | 1683       | 213.97 | 01/01/2017 19:12:00  | 01/08/2017 14:12:43
```


## Setup
In order to setup this project one only needs to checkout the repository and install the necessary gems.
There may be a need to install postgresql client manually in order for the pg gem to work and be installed correctly.
After everything is setup, just run the project like you would run a normal Ruby on Rails Project

```
rails s
```

## Decisions and Approach

Since the company provided me with json files containing records from a possible database, i decided to dump those files into a database.
I never had experience working with AWS but so i decided to setup an account and create a RDS Postgresql database.
After setting up a database on AWS i just connected the project to that database and created the necessary tables.
After that i started seeding the files on to those tables. This process took a bit of time since the orders.json file was of a decent size.


#### seeds.rb
```
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
```


The necessary tables were created through migrations in order to preserve the structure in case of a change of server or something like that.
The created tables are as follows:

#### merchants
```
id | name (varchar) | email (varchar) | cif (varchar)
```


#### shoppers
```
id | name (varchar) | email (varchar) | nif (varchar)
```


#### orders
```
id | merchant_id (integer -> FK) | shopper_id (integer -> FK) | amount (decimal) | created_at (timestamp) | completed_at (timestamp)
```


#### disbursement_rules
```
id | start_value (integer) | end_value (integer) | fee_percentage (decimal) | flg_active (boolean) | created_at (timestamp) | updated_at (timestamp)
```



#### weekly_disbursements
```
id | week_start_date (integer) | week_end_date (integer) | merchant_id (integer -> FK) | disbursement_value (decimal) | created_at (timestamp) | updated_at (timestamp)
```



I created two new tables that weren't specified in the initial specification: disbursement_rules and weekly_disbursements.
The table 'disbursement_rules' serves the role to store all the disbursement fees and their value ranges.
The table 'weekly_disbursement' serves the role for storing and persisting all the previously calculated disbursements for a given week and a given merchant.

From what i gathered from the challenge specification there should be a way to persist the calculations. And an API endpoint to expose the disbursements for a given week and a given merchant (being that the merchant is not a required parameter).
Therefore i decided to create two endpoints:

```
post 'orders/process_disbursements'
get 'orders/get_week_disbursements'
```

#### orders_controller.rb
As their name suggest the POST serves the role of triggering a disbursement calculation and the GET serves the role of exposing disbursements.
The POST however does not work as a normal REST api, per say. The POST calls an Active Job to run the calculations independently of the API response (process_disbursements_job.rb)
