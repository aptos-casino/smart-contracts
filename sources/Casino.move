module Casino {
    use aptos_std::event;
    use std::signer;
    use std::vector;

    const GAME_STATE_EMPTY: u8 = 0;
    const GAME_STATE_STARTED: u8 = 1;
    const GAME_STATE_ENDED: u8 = 2;

    struct StartedGameEvent has drop, store {
        player: address,
        client_seed_hash: vector<u8>,
        bet_amount: u64,
        game_id: u64,
    }

    struct InitedBackendSeedHashesEvent has drop, store {
        game_id: u64,
        hash: vector<u8>
    }

    struct InitedClientSeedHashesEvent has drop, store {
        game_id: u64,
        hash: vector<u8>
    }

    struct InitedBackendSeedEvent has drop, store {
        game_id: u64,
        seed: vector<u8>
    }

    struct InitedClientSeedEvent has drop, store {
        game_id: u64,
        seed: vector<u8>
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
        start_game_event: event::EventHandle<CompletedGameEvent>
    }

    struct GameState{
        client_seed: vector<u8>,
        client_seed_hash: vector<u8>,
        backend_seed: vector<u8>,
        backend_seed_hash: vector<u8>,
    	prediction: u8,
    	lucky_number: u8,
    	bet_amount: u64,
    	payout: u64,
        game_state: u8,
    }

    struct GameStateController has key{
        games: vector<GameState>
    }

    public entry fun initialize(account: &signer) {
        let account_addr = signer::address_of(account);
        assert!(account_addr == @CasinoAddress, ERR_ONLY_OWNER);

        if (!exists<GameEvents>(account_addr)) {
            move_to(&account, GameEvents {
                start_game_event: event::new_event_handle<StartGameEvent>(&account),
                inited_backend_seed_event: event::new_event_handle<InitedBackendSeedEvent>(&account),
                inited_client_seed_event: event::new_event_handle<InitedClientSeedEvent>(&account),
                inited_backend_seed_hash_event: event::new_event_handle<InitedBackendSeedHashEvent>(&account),
                inited_client_seed_hash_event: event::new_event_handle<InitedClientSeedHashEvent>(&account),
                start_game_event: event::new_event_handle<CompletedGameEvent>(&account),
            });
        }

        if (!exists<GameStateController>(account_addr)) {
            move_to(&account, GameStateController {
                games: vector::empty(),
            });
        }
    }
    
    public entry fun start_roll(bet_amount: u64, client_seed_hash: vector<u8>, prediction: u8)
    acquires GameEvents, GameStateController{
        let account_addr = signer::address_of(account);
        let game_events = borrow_global_mut<GameEvents>(account_addr);
        let states = borrow_global_mut<GameStateController>(account_addr);

        let state = GameState{
            bet_amount: bet_amount,
            client_seed_hash: client_seed_hash,
            prediction: prediction,
            game_state: GAME_STATE_STARTED,
        }
        
        vector::push_back(states.games, state);

        event::emit_event<StartedGameEvent>(
            &mut game_events.start_game_event,
            StartedGameEvent {
                account_addr,
                client_seed_hash,
                bet_amount,
                vector::length(states.games),
            },
        );
    }

    public fun set_backend_seed(game_id: u64, seed: vector<u8>)
    acquires GameEvents, GameStateController {
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);
        let inited_backend_seed_event = &mut borrow_global_mut<GameEvents>(@CasinoAddress).inited_backend_seed_event;
        let state = vector::borrow_mut(&mut states, game_id);
        state.backend_seed = seed;

        event::emit_event(inited_backend_seed_event, InitedBackendSeedEvent {
            seed,
            game_id,
        });
    }

    public fun set_backend_seed_hash(game_id: u64, seed_hash: vector<u8>)
    acquires GameEvents, GameStateController {
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);
        let inited_backend_seed_hashes_event = &mut borrow_global_mut<GameEvents>(@CasinoAddress).inited_backend_seed_hashes_event;
        let state = vector::borrow_mut(&mut states, game_id);
        state.backend_seed_hash = seed_hash;

        event::emit_event(inited_backend_seed_hashes_event, InitedBackendSeedHashesEvent {
            hash: seed_hash,
            game_id,
        });
    }

    public fun set_client_seed(player: signer, game_id: u64, seed: vector<u8>)
    acquires GameEvents, GameStateController {
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);
        let inited_client_seed_event = &mut borrow_global_mut<GameEvents>(@CasinoAddress).inited_client_seed_event;
        let state = vector::borrow_mut(&mut states, game_id);
        state.client_seed = seed;

        event::emit_event(inited_client_seed_event, InitedClientSeedEvent {
            seed,
            game_id,
        });
    }

    public fun set_client_seed_hash(game_id: u64, seed_hash: vector<u8>)
    acquires GameEvents, GameStateController {
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);
        let inited_client_seed_hashes_event = &mut borrow_global_mut<GameEvents>(@CasinoAddress).inited_client_seed_hashes_event;
        let state = vector::borrow_mut(&mut states, game_id);
        state.client_seed_hash = seed_hash;

        event::emit_event(inited_client_seed_hashes_event, InitedClientSeedHashesEvent {
            hash: seed_hash,
            game_id,
        });
    }
   
    public fun get_game_state(game_id: u64): GameState
    acquires GameStateController {
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);

        vector::borrow(&states, game_id)
    }

}
