class CreateWeeklyDisbursementsTable < ActiveRecord::Migration[7.0]
    
    def up
        
        if !table_exists? :weekly_disbursements
            
            create_table :weekly_disbursements do |t|
                
                t.integer :week_start_date
                t.integer :week_end_date
                t.integer :merchant_id
                t.decimal :disbursement_value
                
                #audit fields
                t.timestamps null: false
            
            end
        
        end
    
    end
    
    def down
    
        if table_exists? :weekly_disbursements
            
            drop_table :weekly_disbursements
            
        end
        
    end
end
