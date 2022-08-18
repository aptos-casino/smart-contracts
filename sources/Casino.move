module CasinoAddress::Casino {
    use aptos_std::event;
    use std::signer;
    use std::vector;

    const GAME_STATE_EMPTY: u8 = 0;
    const GAME_STATE_STARTED: u8 = 1;
    const GAME_STATE_ENDED: u8 = 2;

    const ERR_ONLY_OWNER: u64 = 0;

    struct StartedGameEvent has drop, store {
        player_addr: address,
        client_seed_hash: vector<u8>,
        bet_amount: u64,
        game_id: u64,
    }

    struct InitedBackendSeedHashEvent has drop, store {
        game_id: u64,
        hash: vector<u8>
    }

    struct InitedClientSeedHashEvent has drop, store {
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
        started_game_event: event::EventHandle<StartedGameEvent>,
        inited_backend_seed_event: event::EventHandle<InitedBackendSeedEvent>,
        inited_client_seed_event: event::EventHandle<InitedClientSeedEvent>,
        inited_backend_seed_hash_event: event::EventHandle<InitedBackendSeedHashEvent>,
        inited_client_seed_hash_event: event::EventHandle<InitedClientSeedHashEvent>,
        completed_game_event: event::EventHandle<CompletedGameEvent>
    }

    struct GameState has store, copy{
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

    public entry fun initialize(account: signer) {
        let account_addr = signer::address_of(&account);
        assert!(account_addr == @CasinoAddress, ERR_ONLY_OWNER);

        if (!exists<GameEvents>(account_addr)) {
            move_to(&account, GameEvents {
                started_game_event: event::new_event_handle<StartedGameEvent>(&account),
                inited_backend_seed_event: event::new_event_handle<InitedBackendSeedEvent>(&account),
                inited_client_seed_event: event::new_event_handle<InitedClientSeedEvent>(&account),
                inited_backend_seed_hash_event: event::new_event_handle<InitedBackendSeedHashEvent>(&account),
                inited_client_seed_hash_event: event::new_event_handle<InitedClientSeedHashEvent>(&account),
                completed_game_event: event::new_event_handle<CompletedGameEvent>(&account),
            });
        };

        if (!exists<GameStateController>(account_addr)) {
            move_to(&account, GameStateController {
                games: vector::empty(),
            });
        }
    }
    
    public entry fun start_roll(bet_amount: u64, client_seed_hash: vector<u8>, prediction: u8)
    acquires GameEvents, GameStateController{
        let addr = @CasinoAddress;
        let game_events = borrow_global_mut<GameEvents>(addr);
        let states = borrow_global_mut<GameStateController>(addr);
        let roll_num = 0;//todo
        let pay = 0;//todo

        let state = GameState {
            client_seed: vector::empty(),
            client_seed_hash: client_seed_hash,
            backend_seed: vector::empty(),
            backend_seed_hash: vector::empty(),
            prediction: prediction,
            lucky_number: roll_num,
            bet_amount: bet_amount,
            payout: pay,
            game_state: GAME_STATE_STARTED,
        };
        
        vector::push_back(&mut states.games, state);
        let len = vector::length(&mut states.games);

        event::emit_event<StartedGameEvent>(
            &mut game_events.started_game_event,
            StartedGameEvent {
                player_addr: addr,
                client_seed_hash,
                bet_amount,
                game_id: len,
            },
        );
    }

    public fun set_backend_seed(game_id: u64, seed: vector<u8>)
    acquires GameEvents, GameStateController {
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);
        let inited_backend_seed_event = &mut borrow_global_mut<GameEvents>(@CasinoAddress).inited_backend_seed_event;
        let state = vector::borrow_mut(&mut states.games, game_id);
        state.backend_seed = seed;

        event::emit_event(inited_backend_seed_event, InitedBackendSeedEvent {
            seed,
            game_id,
        });
    }

    public fun set_backend_seed_hash(game_id: u64, seed_hash: vector<u8>)
    acquires GameEvents, GameStateController {
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);
        let inited_backend_seed_hash_event = &mut borrow_global_mut<GameEvents>(@CasinoAddress).inited_backend_seed_hash_event;
        let state = vector::borrow_mut(&mut states.games, game_id);
        state.backend_seed_hash = seed_hash;

        event::emit_event(inited_backend_seed_hash_event, InitedBackendSeedHashEvent {
            hash: seed_hash,
            game_id,
        });
    }

    public fun set_client_seed(game_id: u64, seed: vector<u8>)
    acquires GameEvents, GameStateController {
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);
        let inited_client_seed_event = &mut borrow_global_mut<GameEvents>(@CasinoAddress).inited_client_seed_event;
        let state = vector::borrow_mut(&mut states.games, game_id);
        state.client_seed = seed;

        event::emit_event(inited_client_seed_event, InitedClientSeedEvent {
            seed,
            game_id,
        });
    }

    public fun set_client_seed_hash(game_id: u64, seed_hash: vector<u8>)
    acquires GameEvents, GameStateController {
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);
        let inited_client_seed_hash_event = &mut borrow_global_mut<GameEvents>(@CasinoAddress).inited_client_seed_hash_event;
        let state = vector::borrow_mut(&mut states.games, game_id);
        state.client_seed_hash = seed_hash;

        event::emit_event(inited_client_seed_hash_event, InitedClientSeedHashEvent {
            hash: seed_hash,
            game_id,
        });
    }
   
    public fun get_game_state(game_id: u64): GameState
    acquires GameStateController {
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);

        *vector::borrow(& states.games, game_id)
    }

}
