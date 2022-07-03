class CreateDisbursementRulesTable < ActiveRecord::Migration[7.0]
    
    def up
        
        if !table_exists? :disbursement_rules
    
            create_table :disbursement_rules do |t|
        
                t.decimal :start_value
                t.decimal :end_value
                t.decimal :fee_percentage
        
                #audit fields
                t.boolean :flg_active, default: true
                t.timestamps null: false
    
            end
            
        end
        
    end
    
    def down
    
        if table_exists? :disbursement_rules
            
            drop_table :disbursement_rules
            
        end
    
    end
    
end
