module CasinoAddress::Casino {
    use aptos_std::event;
    use std::signer;
    use std::vector;

    const GAME_STATE_EMPTY: u8 = 0;
    const GAME_STATE_STARTED: u8 = 1;
    const GAME_STATE_ENDED: u8 = 2;

    const ERR_ONLY_OWNER: u64 = 0;

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

    struct GameState {
        player: address,
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

    struct EventsStore has key {
        start_game_event: event::EventHandle<StartedGameEvent>,
        inited_backend_seed_hashes_event: event::EventHandle<InitedBackendSeedHashesEvent>,
        inited_client_seed_hashes_event: event::EventHandle<InitedClientSeedHashesEvent>,
        inited_backend_seed_event: event::EventHandle<InitedBackendSeedEvent>,
        inited_client_seed_event: event::EventHandle<InitedClientSeedEvent>,
    }

    public entry fun initialize(account: &signer) {
        let sender_address = signer::address_of(account);
        assert!(sender_address == @CasinoAddress, ERR_ONLY_OWNER);
        if (!exists<EventsStore>(signer::address_of(account))) {
            move_to(
                account,
                EventsStore {
                    start_game_event: event::new_event_handle<StartedGameEvent>(account),
                    inited_backend_seed_hashes_event: event::new_event_handle<InitedBackendSeedHashesEvent>(account),
                    inited_client_seed_hashes_event: event::new_event_handle<InitedClientSeedHashesEvent>(account),
                    inited_backend_seed_event: event::new_event_handle<InitedBackendSeedEvent>(account),
                    inited_client_seed_event: event::new_event_handle<InitedClientSeedEvent>(account),
                },
            );
        }
    }

    public entry fun start_roll(player: signer, bet_amount: u64, client_seed_hash: vector<u8>, prediction: u8)
    acquires EventsStore {
        let creator_addr = signer::address_of(&player);
        let start_game_event = &mut borrow_global_mut<EventsStore>(@CasinoAddress).start_game_event;
        event::emit_event(start_game_event, StartedGameEvent {
            player: creator_addr,
            client_seed_hash,
            bet_amount,
            game_id: 5151,
        });
    }

    public entry fun set_backend_seed(backend: signer, game_id: u64, seed: vector<u8>)
    acquires EventsStore {
        let inited_backend_seed_event = &mut borrow_global_mut<EventsStore>(@CasinoAddress).inited_backend_seed_event;
        event::emit_event(inited_backend_seed_event, InitedBackendSeedEvent {
            seed,
            game_id,
        });
    }

    public entry fun set_backend_seed_hash(backend: signer, game_id: u64, seed_hash: vector<u8>)
    acquires EventsStore {
        let inited_backend_seed_hashes_event = &mut borrow_global_mut<EventsStore>(@CasinoAddress).inited_backend_seed_hashes_event;
        event::emit_event(inited_backend_seed_hashes_event, InitedBackendSeedHashesEvent {
            hash: seed_hash,
            game_id,
        });
    }

    public entry fun set_client_seed(player: signer, game_id: u64, seed: vector<u8>)
    acquires EventsStore {
        let inited_client_seed_event = &mut borrow_global_mut<EventsStore>(@CasinoAddress).inited_client_seed_event;
        event::emit_event(inited_client_seed_event, InitedClientSeedEvent {
            seed,
            game_id,
        });
    }

    public entry fun set_client_seed_hash(backend: signer, game_id: u64, seed_hash: vector<u8>)
    acquires EventsStore {
        let inited_client_seed_hashes_event = &mut borrow_global_mut<EventsStore>(@CasinoAddress).inited_client_seed_hashes_event;
        event::emit_event(inited_client_seed_hashes_event, InitedClientSeedHashesEvent {
            hash: seed_hash,
            game_id,
        });
    }

    public fun get_game_state(game_id: u64): GameState {
        let vec = vector::empty<u8>();
        vector::push_back(&mut vec, 1);
        vector::push_back(&mut vec, 2);
        vector::push_back(&mut vec, 3);
        GameState {
            player: @0x0000000000000000000000000000000000000000000000000000000000000b0b,
            client_seed: copy vec,
            client_seed_hash: copy vec,
            backend_seed: copy vec,
            backend_seed_hash: copy vec,
            prediction: 45,
            lucky_number: 33,
            bet_amount: 515145,
            payout: 53453,
            game_state: GAME_STATE_STARTED,
        }
    }
}
