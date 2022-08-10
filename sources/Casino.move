module CasinoAddress::Casino {
    use aptos_std::event;
    use std::signer;
    use std::vector;

    native fun create_address(bytes: vector<u8>): address;

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

    public fun start_roll(player: signer, bet_amount: u64, client_seed_hash: vector<u8>, prediction: u8): u128
    acquires EventsStore {
        let creator_addr = signer::address_of(&player);
        let start_game_event = &mut borrow_global_mut<EventsStore>(creator_addr).start_game_event;
        event::emit_event(start_game_event, StartedGameEvent {
            player: creator_addr,
            client_seed_hash,
            bet_amount,
            game_id: 5151,
        });

        5151
    }

    public fun set_backend_seed(backend: signer, game_id: u64, seed: vector<u8>)
    acquires EventsStore {
        let creator_addr = signer::address_of(&backend);
        let inited_backend_seed_event = &mut borrow_global_mut<EventsStore>(creator_addr).inited_backend_seed_event;
        event::emit_event(inited_backend_seed_event, InitedBackendSeedEvent {
            seed,
            game_id,
        });
    }

    public fun set_backend_seed_hash(backend: signer, game_id: u64, seed_hash: vector<u8>)
    acquires EventsStore {
        let creator_addr = signer::address_of(&backend);
        let inited_backend_seed_hashes_event = &mut borrow_global_mut<EventsStore>(creator_addr).inited_backend_seed_hashes_event;
        event::emit_event(inited_backend_seed_hashes_event, InitedBackendSeedHashesEvent {
            hash: seed_hash,
            game_id,
        });
    }

    public fun set_client_seed(player: signer, game_id: u64, seed: vector<u8>)
    acquires EventsStore {
        let creator_addr = signer::address_of(&player);
        let inited_client_seed_event = &mut borrow_global_mut<EventsStore>(creator_addr).inited_client_seed_event;
        event::emit_event(inited_client_seed_event, InitedClientSeedEvent {
            seed,
            game_id,
        });
    }

    public fun set_client_seed_hash(backend: signer, game_id: u64, seed_hash: vector<u8>)
    acquires EventsStore {
        let creator_addr = signer::address_of(&backend);
        let inited_client_seed_hashes_event = &mut borrow_global_mut<EventsStore>(creator_addr).inited_client_seed_hashes_event;
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
            player: create_address(x"0000000000000000000000000000000000000000000000000000000000000b0b"),
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
