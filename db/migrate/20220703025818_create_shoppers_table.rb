class CreateShoppersTable < ActiveRecord::Migration[7.0]
    def up
        
        if !table_exists? :shoppers
            
            create_table :shoppers do |t|
                
                t.string :name
                t.string :email
                t.string :cif
                
                #audit fields
                t.timestamps null: false
            
            end
        
        end
    
    end
    
    def down
        
        if table_exists? :shoppers
            
            drop_table :shoppers
        
        end
    
    end
end
