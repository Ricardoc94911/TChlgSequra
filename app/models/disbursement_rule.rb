class DisbursementRule < ApplicationRecord
    
    default_scope where(:flg_active => true)
    
end
