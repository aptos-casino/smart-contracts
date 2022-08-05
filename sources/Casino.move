module Casino {
    use std::string;

    struct StartedGameEvent has drop, store {
        client_seed_hash: u128,
        betAmount: u64,
        game_id: u64,
    }

    struct ApprovedBackendHashesEvent has drop, store {
        successful: bool
    }

    struct ApprovedClientHashesEvent has drop, store {
        successful: bool
    }

    struct DroppedDiceEvent has drop, store {
        number: u64,
        payout: u64,
        game_id: u64,
        betAmount: u64,
    }

    struct Casino{
        game_id: u64,
        client_seed: u128,
        client_seed_hash: u128,
        backend_seed: u128,
        backend_seed_hash: u128,
    	prediction: u8,
    	lucky_number: u8,
    	bet_amount: u64,
    	payout: u64,
    	multiplier: u64,
    	currency: string::String,
        start_game_event: EventHandle<StartGameEvent>,
        approved_backend_hashes_event: EventHandle<ApprovedBackendHashesEvent>,
        approved_client_hashes_event: EventHandle<ApprovedClientHashesEvent>,
        start_game_event: EventHandle<DroppedDiceEvent>,
    }
    
    create_game
    check_backend_seed_hash
    check_client_seed_hash
    check_sign
    generate_lucky_number


    start_roll
    set_prediction
    get_prediction
    set_bet_amount
    get_payout
    set_currency
    get_lucky_num
    
}
