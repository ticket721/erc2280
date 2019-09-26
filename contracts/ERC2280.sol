pragma solidity >=0.5.0 <0.6.0;

/// @title ERC-2280: ERC-20 extension for native meta transactions support
interface ERC2280 {

    /// @notice Return the current expected nonce for given `account`.
    ///
    /// @return The current nonce for `account`
    ///
    function nonceOf(address acc) external view returns (uint256);

    /// @notice Verifies that a transfer to `recipient` from `signer` of `amount` tokens
    ///         is possible with the provided signature and with current contract state.
    ///
    /// @dev The function MUST throw if the `mTransfer` payload signature is
    ///      invalid (resulting signer is different than provided `signer`).
    ///
    /// @dev The function MUST throw if real `nonce` is not high enough to
    ///      match the `nonce` provided in the `mTransfer` payload.
    ///
    /// @dev The function MUST throw if provided `gas` is not high enough
    ///      to match the `gasLimit` provided in the `mTransfer` payload.
    ///      This should be checked as soon as the function starts. (`gasleft() >= gasLimit`)
    ///
    /// @dev The function MUST throw if provided `gasPrice` is not high enough
    ///      to match the `gasLimit` provided in the `mTransfer` payload. (`tx.gasprice >= gasPrice`)
    ///
    /// @dev The function MUST throw if provided `relayer` is not `address(0)` AND `relayer`
    ///      is different than `msg.sender`.
    ///
    /// @dev The function SHOULD throw if the `signer`’s account balance does not have enough
    ///      tokens to spend on transfer and on reward (`balanceOf(signer) >= amount + reward`).
    ///
    /// @param recipient Target address of the transfer
    /// @param amount Amount of token to transfer from `signer`'s balance to `recipient`'s balance
    /// @param actors Array of `address`es that contains `signer` as `actors[0]` and `relayer` as `actors[1]` in this
    ///               precise order.
    /// @param txparams Array of `uint256` that MUST contain `nonce` as `txparams[0]`, `gasLimit` as `txparams[1]`,
    ///                 `gasPrice` as `txparams[2]` and `reward` as `txparams[3]` in this precise order.
    ///
    // solhint-disable-next-line max-line-length
    function verifyTransfer(address recipient, uint256 amount, address[2] calldata actors, uint256[4] calldata txparams, bytes calldata signature) external view returns (bool);

    /// @notice Transfers `amount` amount of tokens to address `recipient`, and fires the Transfer event.
    ///
    /// @dev The function MUST throw if the `mTransfer` payload signature is
    ///      invalid (resulting signer is different than provided `signer`).
    ///
    /// @dev The function MUST throw if real `nonce` is not high enough to
    ///      match the `nonce` provided in the `mTransfer` payload.
    ///
    /// @dev The function MUST throw if provided `gas` is not high enough
    ///      to match the `gasLimit` provided in the `mTransfer` payload.
    ///      This should be checked as soon as the function starts. (`gasleft() >= gasLimit`)
    ///
    /// @dev The function MUST throw if provided `gasPrice` is not high enough
    ///      to match the `gasLimit` provided in the `mTransfer` payload. (`tx.gasprice >= gasPrice`)
    ///
    /// @dev The function MUST throw if provided `relayer` is not `address(0)` AND `relayer`
    ///      is different than `msg.sender`.
    ///
    /// @dev The function SHOULD throw if the `signer`’s account balance does not have enough
    ///      tokens to spend on transfer and on reward (`balanceOf(signer) >= amount + reward`).
    ///
    /// @param recipient Target address of the transfer
    /// @param amount Amount of token to transfer from `signer`'s balance to `recipient`'s balance
    /// @param actors Array of `address`es that contains `signer` as `actors[0]` and `relayer` as `actors[1]` in this
    ///               precise order.
    /// @param txparams Array of `uint256` that MUST contain `nonce` as `txparams[0]`, `gasLimit` as `txparams[1]`,
    ///                 `gasPrice` as `txparams[2]` and `reward` as `txparams[3]` in this precise order.
    ///
    // solhint-disable-next-line max-line-length
    function signedTransfer(address recipient, uint256 amount, address[2] calldata actors, uint256[4] calldata txparams, bytes calldata signature) external returns (bool);

    /// @notice Verifies that an approval for `spender` of `amount` tokens on
    ///         `signer`'s balance is possible with the provided signature and with current contract state.
    ///
    /// @dev The function MUST throw if the `mTransfer` payload signature is
    ///      invalid (resulting signer is different than provided `signer`).
    ///
    /// @dev The function MUST throw if real `nonce` is not high enough to
    ///      match the `nonce` provided in the `mTransfer` payload.
    ///
    /// @dev The function MUST throw if provided `gas` is not high enough
    ///      to match the `gasLimit` provided in the `mTransfer` payload.
    ///      This should be checked as soon as the function starts. (`gasleft() >= gasLimit`)
    ///
    /// @dev The function MUST throw if provided `gasPrice` is not high enough
    ///      to match the `gasLimit` provided in the `mTransfer` payload. (`tx.gasprice >= gasPrice`)
    ///
    /// @dev The function MUST throw if provided `relayer` is not `address(0)` AND `relayer`
    ///      is different than `msg.sender`.
    ///
    /// @dev The function SHOULD throw if the `signer`’s account balance does not have enough tokens
    ///      to spend on allowance and on reward (`balanceOf(signer) >= amount + reward`).
    ///
    /// @param spender Target address of the approval
    /// @param amount Amount of token to approve from `signer`'s balance to `recipient`'s account
    /// @param actors Array of `address`es that contains `signer` as `actors[0]` and `relayer` as `actors[1]` in this
    ///               precise order.
    /// @param txparams Array of `uint256` that MUST contain `nonce` as `txparams[0]`, `gasLimit` as `txparams[1]`,
    ///                 `gasPrice` as `txparams[2]` and `reward` as `txparams[3]` in this precise order.
    ///
    // solhint-disable-next-line max-line-length
    function verifyApprove(address spender, uint256 amount, address[2] calldata actors, uint256[4] calldata txparams, bytes calldata signature) external view returns (bool);

    /// @notice Approves `amount` amount of tokens from `signer`'s balance to address `spender`, and
    ///         MUST fire the Approve event.
    ///
    /// @dev The function MUST throw if the `mTransfer` payload signature is
    ///      invalid (resulting signer is different than provided `signer`).
    ///
    /// @dev The function MUST throw if real `nonce` is not high enough to
    ///      match the `nonce` provided in the `mTransfer` payload.
    ///
    /// @dev The function MUST throw if provided `gas` is not high enough
    ///      to match the `gasLimit` provided in the `mTransfer` payload.
    ///      This should be checked as soon as the function starts. (`gasleft() >= gasLimit`)
    ///
    /// @dev The function MUST throw if provided `gasPrice` is not high enough
    ///      to match the `gasLimit` provided in the `mTransfer` payload. (`tx.gasprice >= gasPrice`)
    ///
    /// @dev The function MUST throw if provided `relayer` is not `address(0)` AND `relayer`
    ///      is different than `msg.sender`.
    ///
    /// @dev The function SHOULD throw if the `signer`’s account balance does not have enough tokens
    ///      to spend on allowance and on reward (`balanceOf(signer) >= amount + reward`).
    ///
    /// @param spender Target address of the approval
    /// @param amount Amount of token to approve from `signer`'s balance to `recipient`'s account
    /// @param actors Array of `address`es that contains `signer` as `actors[0]` and `relayer` as `actors[1]` in this
    ///               precise order.
    /// @param txparams Array of `uint256` that MUST contain `nonce` as `txparams[0]`, `gasLimit` as `txparams[1]`,
    ///                 `gasPrice` as `txparams[2]` and `reward` as `txparams[3]` in this precise order.
    ///
    // solhint-disable-next-line max-line-length
    function signedApprove(address spender, uint256 amount, address[2] calldata actors, uint256[4] calldata txparams, bytes calldata signature) external returns (bool);

    /// @notice Verifies that a transfer from `sender` to `recipient` of `amount` tokens and that
    ///         `signer` has at least `amount` allowance from `sender` is possible with the
    ///         provided signature and with current contract state.
    ///
    /// @dev The function MUST throw if the `mTransfer` payload signature is
    ///      invalid (resulting signer is different than provided `signer`).
    ///
    /// @dev The function MUST throw if real `nonce` is not high enough to
    ///      match the `nonce` provided in the `mTransfer` payload.
    ///
    /// @dev The function MUST throw if provided `gas` is not high enough
    ///      to match the `gasLimit` provided in the `mTransfer` payload.
    ///      This should be checked as soon as the function starts. (`gasleft() >= gasLimit`)
    ///
    /// @dev The function MUST throw if provided `gasPrice` is not high enough
    ///      to match the `gasLimit` provided in the `mTransfer` payload. (`tx.gasprice >= gasPrice`)
    ///
    /// @dev The function MUST throw if provided `relayer` is not `address(0)` AND `relayer`
    ///      is different than `msg.sender`.
    ///
    /// @dev The function SHOULD throw if the `signer`’s account balance does not have enough tokens to spend
    ///      on reward (`balanceOf(signer) >= reward`).
    ///
    /// @dev The function SHOULD throw if the `signer`’s account allowance from `sender` is at least `amount`
    ///      (`allowance(sender, signer) >= amount`).
    ///
    /// @param sender Account that is send tokens
    /// @param recipient Account that is receiving the tokens
    /// @param amount Amount of token to transfer from `sender` to `recipient`. `signer` should have at least
    ///               least `amount` allowance from `sender`.
    /// @param actors Array of `address`es that contains `signer` as `actors[0]` and `relayer` as `actors[1]` in this
    ///               precise order.
    /// @param txparams Array of `uint256` that MUST contain `nonce` as `txparams[0]`, `gasLimit` as `txparams[1]`,
    ///                 `gasPrice` as `txparams[2]` and `reward` as `txparams[3]` in this precise order.
    ///
    // solhint-disable-next-line max-line-length
    function verifyTransferFrom(address sender, address recipient, uint256 amount, address[2] calldata actors, uint256[4] calldata txparams, bytes calldata signature) external view returns (bool);

    /// @notice Triggers transfer from `sender` to `recipient` of `amount` tokens. `signer`
    ///         MUST have at least `amount` allowance from `sender`.
    ///         It MUST trigger a Transfer event.
    ///
    /// @dev The function MUST throw if the `mTransfer` payload signature is
    ///      invalid (resulting signer is different than provided `signer`).
    ///
    /// @dev The function MUST throw if real `nonce` is not high enough to
    ///      match the `nonce` provided in the `mTransfer` payload.
    ///
    /// @dev The function MUST throw if provided `gas` is not high enough
    ///      to match the `gasLimit` provided in the `mTransfer` payload.
    ///      This should be checked as soon as the function starts. (`gasleft() >= gasLimit`)
    ///
    /// @dev The function MUST throw if provided `gasPrice` is not high enough
    ///      to match the `gasLimit` provided in the `mTransfer` payload. (`tx.gasprice >= gasPrice`)
    ///
    /// @dev The function MUST throw if provided `relayer` is not `address(0)` AND `relayer`
    ///      is different than `msg.sender`.
    ///
    /// @dev The function SHOULD throw if the `signer`’s account balance does not have enough tokens to spend
    ///      on reward (`balanceOf(signer) >= reward`).
    ///
    /// @dev The function SHOULD throw if the `signer`’s account allowance from `sender` is at least `amount`
    ///      (`allowance(sender, signer) >= amount`).
    ///
    /// @param sender Account that is send tokens
    /// @param recipient Account that is receiving the tokens
    /// @param amount Amount of token to transfer from `sender` to `recipient`. `signer` should have at least
    ///               least `amount` allowance from `sender`.
    /// @param actors Array of `address`es that contains `signer` as `actors[0]` and `relayer` as `actors[1]` in this
    ///               precise order.
    /// @param txparams Array of `uint256` that MUST contain `nonce` as `txparams[0]`, `gasLimit` as `txparams[1]`,
    ///                 `gasPrice` as `txparams[2]` and `reward` as `txparams[3]` in this precise order.
    ///
    // solhint-disable-next-line max-line-length
    function signedTransferFrom(address sender, address recipient, uint256 amount, address[2] calldata actors, uint256[4] calldata txparams, bytes calldata signature) external returns (bool);

}
