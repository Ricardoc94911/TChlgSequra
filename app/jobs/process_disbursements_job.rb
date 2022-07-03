class ProcessDisbursementsJob < ApplicationJob
    queue_as :default
    
    def perform(params)
    
        if params[:week_date].blank?
            build_response({}, false, 500, 'A date for the week needs to be specified', 500) and return
        end
        
        _start_of_week = Time.at(params[:week_date].to_i).utc.beginning_of_week
        _end_of_week = Time.at(params[:week_date].to_i).utc.end_of_week
    
        if _end_of_week.to_i > Time.now.utc.to_i
            build_response({}, false, 500, 'Cannot process uncompleted weeks', 500) and return
        end
    
        _merchants = nil
        if params[:merchant_id].present?
            _merchants = Merchant.where(id: params[:merchant_id].to_i)
        else
            _merchants = Merchant.all
        end
    
        _disbursement_rules = DisbursementRule.all.map{|r| {
            id: r.id,
            start_value: r.start_value,
            end_value: r.end_value,
            fee_percentage: r.fee_percentage
        }}
    
        _merchants.each do |merchant|
        
            _disbursement = WeeklyDisbursement.where(week_start_date: _start_of_week.to_i, week_end_date: _end_of_week, merchant_id: merchant.id)
        
            next if _disbursement.present?
        
            _orders = merchant.orders.where('completed_at >= ? AND completed_at <= ?', _start_of_week, _end_of_week)
        
            _disbursement_value = 0.0
        
            _orders.each do |order|
            
                _rule = _disbursement_rules.find {|rule| (rule[:start_value] || -1) <= order.amount.to_f && (rule[:end_value] || Float::INFINITY) >= order.amount.to_f}
                
                _disbursement_value += (_rule[:fee_percentage].to_f / 100.0 * order.amount)
                
            end
            
            _disbursement = WeeklyDisbursement.new(week_start_date: _start_of_week.to_i, week_end_date: _end_of_week, merchant_id: merchant.id, disbursement_value: _disbursement_value.to_f)
            _disbursement.save
    
        end
        
    end
end
