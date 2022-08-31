module CasinoAddress::Casino {
    use aptos_std::event;
    use std::signer;
    use std::vector;
    use std::hash;
    use aptos_framework::account;
    use aptos_framework::aptos_account;
    use aptos_framework::timestamp;

    const GAME_STATE_EMPTY: u8 = 0;
    const GAME_STATE_STARTED: u8 = 1;
    const GAME_STATE_ENDED: u8 = 2;

    const ERR_ONLY_OWNER: u64 = 0;
    const ERR_ONLY_PLAYER: u64 = 1;
    const ERR_WRONG_PREDICTION: u64 = 2;
    const ERR_WRONG_BET_AMOUNT: u64 = 3;
    const ERR_WRONG_SEED: u64 = 4;
    const ERR_WRONG_SEED_HASH_LENGTH: u64 = 5;
    const ERR_WRONG_GAME_ID: u64 = 6;

    const MIN_BET_AMOUNT: u64 = 100;

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

    struct InitedBackendSeedEvent has drop, store {
        game_id: u64,
        seed: vector<u8>
    }

    struct InitedClientSeedEvent has drop, store {
        game_id: u64,
        seed: vector<u8>
    }

    struct CompletedGameEvent has drop, store {
        lucky_number: u8,
        payout: u64,
        game_id: u64,
        bet_amount: u64,
        player_addr: address,
        time: u64,
        prediction: u8,
    }

    struct GameState has drop, store {
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
        inited_backend_seed_event: event::EventHandle<InitedBackendSeedEvent>,
        inited_client_seed_event: event::EventHandle<InitedClientSeedEvent>,
        completed_game_event: event::EventHandle<CompletedGameEvent>,
    }

    struct GameStateController has key {
        games: vector<GameState>,
    }

    public entry fun initialize(account: &signer) {
        let sender_address = signer::address_of(account);
        assert!(sender_address == @CasinoAddress, ERR_ONLY_OWNER);
        if (!exists<EventsStore>(signer::address_of(account))) {
            move_to(
                account,
                EventsStore {
                    start_game_event: account::new_event_handle<StartedGameEvent>(account),
                    inited_backend_seed_hashes_event: account::new_event_handle<InitedBackendSeedHashesEvent>(account),
                    inited_backend_seed_event: account::new_event_handle<InitedBackendSeedEvent>(account),
                    inited_client_seed_event: account::new_event_handle<InitedClientSeedEvent>(account),
                    completed_game_event: account::new_event_handle<CompletedGameEvent>(account),
                },
            );
        };
        if (!exists<GameStateController>(sender_address)) {
            move_to(account, GameStateController {
                games: vector::empty(),
            });
        };
    }

    public entry fun start_roll(player: signer, bet_amount: u64, client_seed_hash: vector<u8>, prediction: u8)
    acquires EventsStore, GameStateController {
        let player_addr = signer::address_of(&player);
        assert!(player_addr != @CasinoAddress, ERR_ONLY_PLAYER);
        assert!(prediction >= 2 && prediction <= 96, ERR_WRONG_PREDICTION);
        assert!(bet_amount >= MIN_BET_AMOUNT, ERR_WRONG_BET_AMOUNT);
        assert!(vector::length(&client_seed_hash) > 0, ERR_WRONG_SEED_HASH_LENGTH);
        aptos_account::transfer(&player, @CasinoAddress, bet_amount);

        let state = GameState {
            player: player_addr,
            client_seed: vector::empty<u8>(),
            client_seed_hash,
            backend_seed: vector::empty<u8>(),
            backend_seed_hash: vector::empty<u8>(),
            prediction,
            lucky_number: 255,
            bet_amount,
            payout: 0,
            game_state: GAME_STATE_STARTED,
        };
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);
        vector::push_back(&mut states.games, state);

        let start_game_event = &mut borrow_global_mut<EventsStore>(@CasinoAddress).start_game_event;
        event::emit_event(start_game_event, StartedGameEvent {
            player: player_addr,
            client_seed_hash,
            bet_amount,
            game_id: vector::length(&mut states.games) - 1,
        });
    }

    public fun get_random_lucky_number(seed1: vector<u8>, seed2: vector<u8>): u8 {
        let seed = vector::empty<u8>();
        vector::append(&mut seed, seed1);
        vector::append(&mut seed, seed2);
        let hash = hash::sha3_256(seed);
        let lucky_number = *vector::borrow(&mut hash, 0) % 101;
        lucky_number
    }

    public fun check_seed_and_hash(seed: &vector<u8>, hash: &vector<u8>): bool {
        let seed_hash = hash::sha3_256(*seed);
        if (vector::length(&seed_hash) != vector::length(hash)) {
            return false
        };
        let i = 0;
        while (i < vector::length(&seed_hash)) {
            if (vector::borrow(&seed_hash, i) != vector::borrow(hash, i)) {
                return false
            };
            i = i + 1;
        };
        true
    }

    public entry fun set_backend_seed(backend: signer, game_id: u64, seed: vector<u8>)
    acquires EventsStore, GameStateController {
        let backend_addr = signer::address_of(&backend);
        assert!(backend_addr == @CasinoAddress, ERR_ONLY_OWNER);
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);
        assert!(game_id >= 0 && game_id < vector::length(&states.games), ERR_WRONG_GAME_ID);
        assert!(vector::length(&seed) > 0, ERR_WRONG_SEED);

        let game_state = vector::borrow_mut(&mut states.games, game_id);
        let events_store = borrow_global_mut<EventsStore>(@CasinoAddress);

        assert!(check_seed_and_hash(&seed, &game_state.backend_seed_hash), ERR_WRONG_SEED);
        assert!(vector::length(&game_state.backend_seed) == 0, ERR_WRONG_GAME_ID);
        assert!(vector::length(&game_state.client_seed) > 0, ERR_WRONG_GAME_ID);

        game_state.backend_seed = seed;
        let inited_backend_seed_event = &mut events_store.inited_backend_seed_event;
        event::emit_event(inited_backend_seed_event, InitedBackendSeedEvent {
            seed,
            game_id,
        });

        game_state.lucky_number = get_random_lucky_number(game_state.client_seed, game_state.backend_seed);
        if (game_state.lucky_number <= game_state.prediction) {
            assert!(game_state.prediction > 1, ERR_WRONG_PREDICTION);
            game_state.payout = (game_state.bet_amount * 98) / ((game_state.prediction as u64) - 1);
            if (game_state.payout > 0) {
                aptos_account::transfer(&backend, game_state.player, game_state.payout);
            }
        };
        game_state.game_state = GAME_STATE_ENDED;

        let completed_game_event = &mut events_store.completed_game_event;
        event::emit_event(completed_game_event, CompletedGameEvent {
            lucky_number: game_state.lucky_number,
            payout: game_state.payout,
            game_id,
            bet_amount: game_state.bet_amount,
            player_addr: game_state.player,
            time: timestamp::now_microseconds(),
            prediction: game_state.prediction,
        });
    }

    public entry fun set_backend_seed_hash(backend: signer, game_id: u64, seed_hash: vector<u8>)
    acquires EventsStore, GameStateController {
        let backend_addr = signer::address_of(&backend);
        assert!(backend_addr == @CasinoAddress, ERR_ONLY_OWNER);
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);
        assert!(game_id >= 0 && game_id < vector::length(&states.games), ERR_WRONG_GAME_ID);
        assert!(vector::length(&seed_hash) > 0, ERR_WRONG_SEED_HASH_LENGTH);

        let game_state = vector::borrow_mut(&mut states.games, game_id);

        assert!(vector::length(&game_state.backend_seed) == 0, ERR_WRONG_GAME_ID);
        assert!(vector::length(&game_state.client_seed) == 0, ERR_WRONG_GAME_ID);

        game_state.backend_seed_hash = seed_hash;

        let inited_backend_seed_hashes_event = &mut borrow_global_mut<EventsStore>(@CasinoAddress).inited_backend_seed_hashes_event;
        event::emit_event(inited_backend_seed_hashes_event, InitedBackendSeedHashesEvent {
            hash: seed_hash,
            game_id,
        });
    }

    public entry fun set_client_seed(player: signer, game_id: u64, seed: vector<u8>)
    acquires EventsStore, GameStateController {
        let player_addr = signer::address_of(&player);
        assert!(player_addr != @CasinoAddress, ERR_ONLY_PLAYER);
        let states = borrow_global_mut<GameStateController>(@CasinoAddress);
        assert!(game_id >= 0 && game_id < vector::length(&states.games), ERR_WRONG_GAME_ID);
        assert!(vector::length(&seed) > 0, ERR_WRONG_SEED);

        let game_state = vector::borrow_mut(&mut states.games, game_id);

        assert!(check_seed_and_hash(&seed, &game_state.client_seed_hash), ERR_WRONG_SEED);
        assert!(vector::length(&game_state.client_seed) == 0, ERR_WRONG_GAME_ID);

        game_state.client_seed = seed;

        let inited_client_seed_event = &mut borrow_global_mut<EventsStore>(@CasinoAddress).inited_client_seed_event;
        event::emit_event(inited_client_seed_event, InitedClientSeedEvent {
            seed,
            game_id,
        });
    }
}
