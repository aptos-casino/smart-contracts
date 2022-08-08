module Casino {
    use std::string;
    use aptos_framework::system_addresses;

    const GAME_STATE_EMPTY: u8 = 0;
    const GAME_STATE_STARTED: u8 = 1;
    const GAME_STATE_ENDED: u8 = 2;

    struct StartedGameEvent has drop, store {
        client_seed_hash: u128,
        bet_amount: u64,
        game_id: u64,
    }

    struct InitedBackendSeedHashesEvent has drop, store {
        hash: u128
    }

    struct InitedClientSeedHashesEvent has drop, store {
        hash: u128
    }

    struct InitedBackendSeedEvent has drop, store {
        seed: u128
    }

    struct InitedClientSeedEvent has drop, store {
        seed: u128
    }

    struct CompletedGameEvent has drop, store {
        lucky_number: u64,
        payout: u64,
        game_id: u64,
        bet_amount: u64,
        player_addr: address,
    }

    struct GameState{
        game_id: u64,
        client_seed: u128,
        client_seed_hash: u128,
        backend_seed: u128,
        backend_seed_hash: u128,
    	prediction: u8,
    	lucky_number: u8,
    	bet_amount: u64,
    	payout: u64,
        game_state: u8,
        start_game_event: EventHandle<StartGameEvent>,
        approved_backend_hashes_event: EventHandle<ApprovedBackendHashesEvent>,
        approved_client_hashes_event: EventHandle<ApprovedClientHashesEvent>,
        start_game_event: EventHandle<DroppedDiceEvent>,
    }
    
    public fun start_roll(bet_amount: u64, client_seed_hash: u128, prediction: u8)
    {

    }

    public fun get_backend_seed_hash(game_id: u64)
    {

    }
    public fun get_client_seed_hash(game_id: u64)
    {

    }

   
    public fun get_game_state(game_id: u64): GameState
    {

    }

}
