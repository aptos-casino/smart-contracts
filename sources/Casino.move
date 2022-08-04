module Casino {
    use std::string;

    struct Casino{
    	rollingUnder: bool,
    	prediction: u8,
    	luckyNum: u8,
    	betAmount: u64,
    	payout: u64,
    	multiplier: u64,
    	curency: string::String,
    }
    
    public fun get_sequence_number set_rolling_under(addr: address) acquires Account
    {
        borrow_global_mut<Casino>(addr).rollingUnder = true;
    }
    
    roll_over
    start_roll
    set_prediction
    get_prediction
    set_bet_amount
    get_payout
    set_curency
    get_lucky_num
    
}
