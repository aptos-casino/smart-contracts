module Casino {
    use std::string;
    use aptos_framework::system_addresses;
    use std::event;

    const GAME_STATE_EMPTY: u8 = 0;
    const GAME_STATE_STARTED: u8 = 1;
    const GAME_STATE_ENDED: u8 = 2;

    struct StartedGameEvent has drop, store {
        client_seed_hash: u128,
        bet_amount: u64,
        game_id: u64,
    }

    struct InitedBackendSeedHashEvent has drop, store {
        hash: u128
    }

    struct InitedClientSeedHashEvent has drop, store {
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

    struct GameEvents has key{
        start_game_event: event::EventHandle<StartGameEvent>,
        inited_backend_seed_event: event::EventHandle<InitedBackendSeedEvent>,
        inited_client_seed_event: event::EventHandle<InitedClientSeedEvent>,
        inited_backend_seed_hash_event: event::EventHandle<InitedBackendSeedHashEvent>,
        inited_client_seed_hash_event: event::EventHandle<InitedClientSeedHashEvent>,
        start_game_event: event::EventHandle<DroppedDiceEvent>
    }

    struct GameState has key{
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
    }

    public entry fun initialize()
    {

    }
    
    public fun start_roll(player_addr: address, bet_amount: u64, client_seed_hash: u128, prediction: u8)
    acquires GameState, GameEvents{
        let state = borrow_global<GameState>(player_addr);
        let game_events = borrow_global_mut<GameEvents>(player_addr);
        event::emit_event<StartedGameEvent>(
            &mut game_events.start_game_event,
            StartedGameEvent {
                client_seed_hash,
                state.bet_amount,
                state.game_id,
            },
        );
    }

    public fun get_backend_seed_hash(game_id: u64)
    acquires GameState, GameEvents{
        let state = borrow_global<GameState>(player_addr);
        let game_events = borrow_global_mut<GameEvents>(player_addr);
        event::emit_event<InitedBackendSeedHashEvent>(
            &mut game_events.inited_backend_seed_hash_event,
            InitedBackendSeedHashEvent {
                state.backend_seed_hash,
            },
        );        
    }

    public fun get_client_seed_hash(game_id: u64)
    acquires GameState, GameEvents{
        let state = borrow_global<GameState>(player_addr);
        let game_events = borrow_global_mut<GameEvents>(player_addr);
        event::emit_event<InitedClientSeedHashEvent>(
            &mut game_events.inited_client_seed_hash_event,
            InitedClientSeedHashEvent {
                state.client_seed_hash,
            },
        );
    }

    public fun get_backend_seed(game_id: u64)
    acquires GameState, GameEvents{
        let state = borrow_global<GameState>(player_addr);
        let game_events = borrow_global_mut<GameEvents>(player_addr);
        event::emit_event<InitedBackendSeedEvent>(
            &mut game_events.inited_backend_seed_event,
            InitedBackendSeedEvent {
                state.backend_seed,
            },
        );
    }

    public fun get_client_seed(game_id: u64)
    acquires GameState, GameEvents{
        let state = borrow_global<GameState>(player_addr);
        let game_events = borrow_global_mut<GameEvents>(player_addr);
        event::emit_event<InitedClientSeedEvent>(
            &mut game_events.inited_client_seed_event,
            InitedClientSeedEvent {
                state.client_seed,
            },
        );
    }
   
    public fun get_game_state(game_id: u64): GameState {

    }

}
