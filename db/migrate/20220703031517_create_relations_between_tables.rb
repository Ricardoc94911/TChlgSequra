class CreateRelationsBetweenTables < ActiveRecord::Migration[7.0]
    
    def change
        
        if table_exists? :shoppers
            
            if table_exists? :merchants
                
                if table_exists? :orders
                    
                    add_foreign_key :orders, :shoppers, column: :shopper_id, primary_key: :id
                    add_foreign_key :orders, :merchants, column: :merchant_id, primary_key: :id
                    
                end
                
            end
            
        end
        
    end
    
end
