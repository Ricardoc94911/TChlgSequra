class OrdersController < ApplicationController
    
    def process_disbursements
        
        _params = params.permit(:merchant_id, :week_date)

        ProcessDisbursementsJob.perform_later(_params)

        build_response({}, true, 200, 'Disbursements for the specified week will be processed', 200)
    
    end
    
    def get_week_disbursements
    
        _params = params.permit(:merchant_id, :week_date)

        _start_of_week = Time.at(params[:week_date].to_i).utc.beginning_of_week
        _end_of_week = Time.at(params[:week_date].to_i).utc.end_of_week
    
        _ret_disbursements = WeeklyDisbursement.where(week_start_date: _start_of_week.to_i, week_end_date: _end_of_week)
        _ret_disbursements = _ret_disbursements.where(merchant_id: _params[:merchant_id]) if _params[:merchant_id].present?
    
        build_response({disbursements: _ret_disbursements}, true, 200, 'Success', 200)
        
    end

end
