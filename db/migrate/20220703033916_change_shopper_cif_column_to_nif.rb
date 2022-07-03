class ChangeShopperCifColumnToNif < ActiveRecord::Migration[7.0]
    
    def change
        
        if table_exists? :shoppers
            
            if column_exists? :shoppers, :cif
                
                rename_column :shoppers, :cif, :nif
                
            end
            
        end
        
    end
    
end
