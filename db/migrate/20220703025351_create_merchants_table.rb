class CreateMerchantsTable < ActiveRecord::Migration[7.0]
    def up
        
        if !table_exists? :merchants
            
            create_table :merchants do |t|
                
                t.string :name
                t.string :email
                t.string :cif
                
                #audit fields
                t.timestamps null: false
            
            end
        
        end
    
    end
    
    def down
        
        if table_exists? :merchants
            
            drop_table :merchants
            
        end
        
    end
end
