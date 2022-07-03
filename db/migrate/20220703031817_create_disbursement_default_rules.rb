class CreateDisbursementDefaultRules < ActiveRecord::Migration[7.0]
    
    def up
        
        _rule = DisbursementRule.find_by(id: 1)
        
        if !_rule.present?
            
            _rule = DisbursementRule.new(id: 1, start_value: nil, end_value: 50, fee_percentage: 1)
            _rule.save
            
        end
        
        _rule = DisbursementRule.find_by(id: 2)
        
        if !_rule.present?
            
            _rule = DisbursementRule.new(id: 2, start_value: 50, end_value: 300, fee_percentage: 0.95)
            _rule.save
            
        end
        
        _rule = DisbursementRule.find_by(id: 3)
        
        if !_rule.present?
            
            _rule = DisbursementRule.new(id: 3, start_value: 300, end_value: nil, fee_percentage: 0.85)
            _rule.save
            
        end
        
    end
    
    def down
    
    
    
    end
end
