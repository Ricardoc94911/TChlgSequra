class CreateOrdersTable < ActiveRecord::Migration[7.0]
    def up
        
        if !table_exists? :orders
            
            create_table :orders do |t|
                
                t.integer :merchant_id
                t.integer :shopper_id
                t.decimal :amount
                t.timestamp :completed_at
                
                #audit fields
                t.timestamps null: false
            
            end
        
        end
    
    end
    
    def down
        
        if table_exists? :orders
            
            drop_table :orders
        
        end
    
    end
end
