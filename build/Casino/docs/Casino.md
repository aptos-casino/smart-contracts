
<a name="0x1234_Casino"></a>

# Module `0x1234::Casino`



-  [Struct `StartedGameEvent`](#0x1234_Casino_StartedGameEvent)
-  [Struct `InitedBackendSeedHashEvent`](#0x1234_Casino_InitedBackendSeedHashEvent)
-  [Struct `InitedClientSeedHashEvent`](#0x1234_Casino_InitedClientSeedHashEvent)
-  [Struct `InitedBackendSeedEvent`](#0x1234_Casino_InitedBackendSeedEvent)
-  [Struct `InitedClientSeedEvent`](#0x1234_Casino_InitedClientSeedEvent)
-  [Struct `CompletedGameEvent`](#0x1234_Casino_CompletedGameEvent)
-  [Resource `GameEvents`](#0x1234_Casino_GameEvents)
-  [Struct `GameState`](#0x1234_Casino_GameState)
-  [Resource `GameStateController`](#0x1234_Casino_GameStateController)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1234_Casino_initialize)


<pre><code><b>use</b> <a href="">0x1::event</a>;
<b>use</b> <a href="">0x1::signer</a>;
</code></pre>



<a name="0x1234_Casino_StartedGameEvent"></a>

## Struct `StartedGameEvent`



<pre><code><b>struct</b> <a href="Casino.md#0x1234_Casino_StartedGameEvent">StartedGameEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>player: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>client_seed_hash: <a href="">vector</a>&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>bet_amount: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>game_id: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1234_Casino_InitedBackendSeedHashEvent"></a>

## Struct `InitedBackendSeedHashEvent`



<pre><code><b>struct</b> <a href="Casino.md#0x1234_Casino_InitedBackendSeedHashEvent">InitedBackendSeedHashEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>game_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>hash: <a href="">vector</a>&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1234_Casino_InitedClientSeedHashEvent"></a>

## Struct `InitedClientSeedHashEvent`



<pre><code><b>struct</b> <a href="Casino.md#0x1234_Casino_InitedClientSeedHashEvent">InitedClientSeedHashEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>game_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>hash: <a href="">vector</a>&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1234_Casino_InitedBackendSeedEvent"></a>

## Struct `InitedBackendSeedEvent`



<pre><code><b>struct</b> <a href="Casino.md#0x1234_Casino_InitedBackendSeedEvent">InitedBackendSeedEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>game_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>seed: <a href="">vector</a>&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1234_Casino_InitedClientSeedEvent"></a>

## Struct `InitedClientSeedEvent`



<pre><code><b>struct</b> <a href="Casino.md#0x1234_Casino_InitedClientSeedEvent">InitedClientSeedEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>game_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>seed: <a href="">vector</a>&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1234_Casino_CompletedGameEvent"></a>

## Struct `CompletedGameEvent`



<pre><code><b>struct</b> <a href="Casino.md#0x1234_Casino_CompletedGameEvent">CompletedGameEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>lucky_number: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>payout: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>game_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>bet_amount: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>player_addr: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1234_Casino_GameEvents"></a>

## Resource `GameEvents`



<pre><code><b>struct</b> <a href="Casino.md#0x1234_Casino_GameEvents">GameEvents</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>started_game_event: <a href="_EventHandle">event::EventHandle</a>&lt;<a href="Casino.md#0x1234_Casino_StartedGameEvent">Casino::StartedGameEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>inited_backend_seed_event: <a href="_EventHandle">event::EventHandle</a>&lt;<a href="Casino.md#0x1234_Casino_InitedBackendSeedEvent">Casino::InitedBackendSeedEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>inited_client_seed_event: <a href="_EventHandle">event::EventHandle</a>&lt;<a href="Casino.md#0x1234_Casino_InitedClientSeedEvent">Casino::InitedClientSeedEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>inited_backend_seed_hash_event: <a href="_EventHandle">event::EventHandle</a>&lt;<a href="Casino.md#0x1234_Casino_InitedBackendSeedHashEvent">Casino::InitedBackendSeedHashEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>inited_client_seed_hash_event: <a href="_EventHandle">event::EventHandle</a>&lt;<a href="Casino.md#0x1234_Casino_InitedClientSeedHashEvent">Casino::InitedClientSeedHashEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>completed_game_event: <a href="_EventHandle">event::EventHandle</a>&lt;<a href="Casino.md#0x1234_Casino_CompletedGameEvent">Casino::CompletedGameEvent</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1234_Casino_GameState"></a>

## Struct `GameState`



<pre><code><b>struct</b> <a href="Casino.md#0x1234_Casino_GameState">GameState</a> <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>client_seed: <a href="">vector</a>&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>client_seed_hash: <a href="">vector</a>&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>backend_seed: <a href="">vector</a>&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>backend_seed_hash: <a href="">vector</a>&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>prediction: u8</code>
</dt>
<dd>

</dd>
<dt>
<code>lucky_number: u8</code>
</dt>
<dd>

</dd>
<dt>
<code>bet_amount: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>payout: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>game_state: u8</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1234_Casino_GameStateController"></a>

## Resource `GameStateController`



<pre><code><b>struct</b> <a href="Casino.md#0x1234_Casino_GameStateController">GameStateController</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>games: <a href="">vector</a>&lt;<a href="Casino.md#0x1234_Casino_GameState">Casino::GameState</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1234_Casino_ERR_ONLY_OWNER"></a>



<pre><code><b>const</b> <a href="Casino.md#0x1234_Casino_ERR_ONLY_OWNER">ERR_ONLY_OWNER</a>: u64 = 0;
</code></pre>



<a name="0x1234_Casino_GAME_STATE_EMPTY"></a>



<pre><code><b>const</b> <a href="Casino.md#0x1234_Casino_GAME_STATE_EMPTY">GAME_STATE_EMPTY</a>: u8 = 0;
</code></pre>



<a name="0x1234_Casino_GAME_STATE_ENDED"></a>



<pre><code><b>const</b> <a href="Casino.md#0x1234_Casino_GAME_STATE_ENDED">GAME_STATE_ENDED</a>: u8 = 2;
</code></pre>



<a name="0x1234_Casino_GAME_STATE_STARTED"></a>



<pre><code><b>const</b> <a href="Casino.md#0x1234_Casino_GAME_STATE_STARTED">GAME_STATE_STARTED</a>: u8 = 1;
</code></pre>



<a name="0x1234_Casino_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="Casino.md#0x1234_Casino_initialize">initialize</a>(account: <a href="">signer</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="Casino.md#0x1234_Casino_initialize">initialize</a>(account: <a href="">signer</a>) {
    <b>let</b> account_addr = <a href="_address_of">signer::address_of</a>(&account);
    <b>assert</b>!(account_addr == @CasinoAddress, <a href="Casino.md#0x1234_Casino_ERR_ONLY_OWNER">ERR_ONLY_OWNER</a>);

    <b>if</b> (!<b>exists</b>&lt;<a href="Casino.md#0x1234_Casino_GameEvents">GameEvents</a>&gt;(account_addr)) {
        <b>move_to</b>(&account, <a href="Casino.md#0x1234_Casino_GameEvents">GameEvents</a> {
            started_game_event: <a href="_new_event_handle">event::new_event_handle</a>&lt;<a href="Casino.md#0x1234_Casino_StartedGameEvent">StartedGameEvent</a>&gt;(&account),
            inited_backend_seed_event: <a href="_new_event_handle">event::new_event_handle</a>&lt;<a href="Casino.md#0x1234_Casino_InitedBackendSeedEvent">InitedBackendSeedEvent</a>&gt;(&account),
            inited_client_seed_event: <a href="_new_event_handle">event::new_event_handle</a>&lt;<a href="Casino.md#0x1234_Casino_InitedClientSeedEvent">InitedClientSeedEvent</a>&gt;(&account),
            inited_backend_seed_hash_event: <a href="_new_event_handle">event::new_event_handle</a>&lt;<a href="Casino.md#0x1234_Casino_InitedBackendSeedHashEvent">InitedBackendSeedHashEvent</a>&gt;(&account),
            inited_client_seed_hash_event: <a href="_new_event_handle">event::new_event_handle</a>&lt;<a href="Casino.md#0x1234_Casino_InitedClientSeedHashEvent">InitedClientSeedHashEvent</a>&gt;(&account),
            completed_game_event: <a href="_new_event_handle">event::new_event_handle</a>&lt;<a href="Casino.md#0x1234_Casino_CompletedGameEvent">CompletedGameEvent</a>&gt;(&account),
        });
    };

    <b>if</b> (!<b>exists</b>&lt;<a href="Casino.md#0x1234_Casino_GameStateController">GameStateController</a>&gt;(account_addr)) {
        <b>move_to</b>(&account, <a href="Casino.md#0x1234_Casino_GameStateController">GameStateController</a> {
            games: <a href="_empty">vector::empty</a>(),
        });
    }
}
</code></pre>



</details>
