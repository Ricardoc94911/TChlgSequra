class ProcessDisbursementsJob < ApplicationJob
    queue_as :default
    
    def perform(params)
    
        if params[:week_date].blank? #A date is required, only the merchant param is optional
            build_response({}, false, 500, 'A date for the week needs to be specified', 500) and return
        end
        
        _start_of_week = Time.at(params[:week_date].to_i).utc.beginning_of_week #Define starting date for given week
        _end_of_week = Time.at(params[:week_date].to_i).utc.end_of_week #Define ending date for given week
    
        if _end_of_week.to_i > Time.now.utc.to_i #Only process completed weeks (Past)
            build_response({}, false, 500, 'Cannot process uncompleted weeks', 500) and return
        end
    
        _merchants = nil #Define the merchants to be processed according to the existence or absence of the merchant_id param
        if params[:merchant_id].present?
            _merchants = Merchant.where(id: params[:merchant_id].to_i)
        else
            _merchants = Merchant.all
        end
    
        #Get the disbursement rules that are active
        _disbursement_rules = DisbursementRule.all.map{|r| {
            id: r.id,
            start_value: r.start_value,
            end_value: r.end_value,
            fee_percentage: r.fee_percentage
        }}
    
        #process the disbursements for each merchant
        _merchants.each do |merchant|
        
            #avoid unnecessary calculations if there's already a calculated disbursement for the given week and merchant
            _disbursement = WeeklyDisbursement.where(week_start_date: _start_of_week.to_i, week_end_date: _end_of_week, merchant_id: merchant.id)
        
            next if _disbursement.present?
        
            #only account for orders that have been completed in the give week
            _orders = merchant.orders.where('completed_at >= ? AND completed_at <= ?', _start_of_week, _end_of_week)
        
            _disbursement_value = 0.0
        
            _orders.each do |order|
            
                #the disbursement value is calculated with the corresponding rule according to floor and ceiling of the previously specified rules
                _rule = _disbursement_rules.find {|rule| (rule[:start_value] || -1) <= order.amount.to_f && (rule[:end_value] || Float::INFINITY) >= order.amount.to_f}
                
                #the calculations are made so that a small percentage of each order is disbursed
                _disbursement_value += (_rule[:fee_percentage].to_f / 100.0 * order.amount)
                
            end
            
            #Finally the calculated disbursement is saved to the database
            _disbursement = WeeklyDisbursement.new(week_start_date: _start_of_week.to_i, week_end_date: _end_of_week, merchant_id: merchant.id, disbursement_value: _disbursement_value.to_f)
            _disbursement.save
    
        end
        
    end
end
