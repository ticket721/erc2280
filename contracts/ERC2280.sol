pragma solidity >=0.5.0 <0.6.0;

/// @title ERC-2280: ERC-20 extension for native meta transactions support
interface ERC2280 {

    /// @notice Return the current expected nonce for given `account`.
    ///
    /// @return The current nonce for `account`
    ///
    function nonceOf(address account) external view returns (uint256);

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
    /// @dev `signer` is the address signing the meta transaction (`actors[0]`)
    /// @dev `relayer` is the address posting the meta transaction to the contract (`actors[1]`)
    /// @dev `recipient` is the address receiving the token transfer (`actors[2]`)
    /// @dev `nonce` is the meta transaction count on this specific token for `signer` (`txparams[0]`)
    /// @dev `gasLimit` is the wanted gas limit, set by `signer`, should be respected by `relayer` (`txparams[1]`)
    /// @dev `gasPrice` is the wanted gas price, set by `signer`, should be respected by `relayer` (`txparams[2]`)
    /// @dev `reward` is the amount of tokens that are given to `relayer` from `signer` (`txparams[3]`)
    /// @dev `amount` is the amount of tokens transferred from `signer` to `recipient` (`txparams[4]`)
    ///
    /// @param actors Array of `address`es that contains `signer` as `actors[0]`, `relayer` as `actors[1]`,
    ///               `recipient` as `actors[2]` in this precise order.
    ///
    /// @param txparams Array of `uint256` that MUST contain `nonce` as `txparams[0]`, `gasLimit` as `txparams[1]`,
    ///                 `gasPrice` as `txparams[2]`, `reward` as `txparams[3]` and `amount` as `txparams[4]`.
    ///
    // solhint-disable-next-line max-line-length
    function verifyTransfer(address[3] calldata actors, uint256[5] calldata txparams, bytes calldata signature) external view returns (bool);

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
    /// @dev `signer` is the address signing the meta transaction (`actors[0]`)
    /// @dev `relayer` is the address posting the meta transaction to the contract (`actors[1]`)
    /// @dev `recipient` is the address receiving the token transfer (`actors[2]`)
    /// @dev `nonce` is the meta transaction count on this specific token for `signer` (`txparams[0]`)
    /// @dev `gasLimit` is the wanted gas limit, set by `signer`, should be respected by `relayer` (`txparams[1]`)
    /// @dev `gasPrice` is the wanted gas price, set by `signer`, should be respected by `relayer` (`txparams[2]`)
    /// @dev `reward` is the amount of tokens that are given to `relayer` from `signer` (`txparams[3]`)
    /// @dev `amount` is the amount of tokens transferred from `signer` to `recipient` (`txparams[4]`)
    ///
    /// @param actors Array of `address`es that contains `signer` as `actors[0]`, `relayer` as `actors[1]`,
    ///               `recipient` as `actors[2]` in this precise order.
    ///
    /// @param txparams Array of `uint256` that MUST contain `nonce` as `txparams[0]`, `gasLimit` as `txparams[1]`,
    ///                 `gasPrice` as `txparams[2]`, `reward` as `txparams[3]` and `amount` as `txparams[4]`.
    ///
    // solhint-disable-next-line max-line-length
    function signedTransfer(address[3] calldata actors, uint256[5] calldata txparams, bytes calldata signature) external returns (bool);

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
    /// @dev `signer` is the address signing the meta transaction (`actors[0]`)
    /// @dev `relayer` is the address posting the meta transaction to the contract (`actors[1]`)
    /// @dev `spender` is the address being approved by `signer` (`actors[2]`)
    /// @dev `nonce` is the meta transaction count on this specific token for `signer` (`txparams[0]`)
    /// @dev `gasLimit` is the wanted gas limit, set by `signer`, should be respected by `relayer` (`txparams[1]`)
    /// @dev `gasPrice` is the wanted gas price, set by `signer`, should be respected by `relayer` (`txparams[2]`)
    /// @dev `reward` is the amount of tokens that are given to `relayer` from `signer` (`txparams[3]`)
    /// @dev `amount` is the amount of tokens approved by `signer` to `spender` (`txparams[4]`)
    ///
    /// @param actors Array of `address`es that contains `signer` as `actors[0]`, `relayer` as `actors[1]`,
    ///               `spender` as `actors[2]` in this precise order.
    ///
    /// @param txparams Array of `uint256` that MUST contain `nonce` as `txparams[0]`, `gasLimit` as `txparams[1]`,
    ///                 `gasPrice` as `txparams[2]`, `reward` as `txparams[3]` and `amount` as `txparams[4]`.
    ///
    // solhint-disable-next-line max-line-length
    function verifyApprove(address[3] calldata actors, uint256[5] calldata txparams, bytes calldata signature) external view returns (bool);

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
    /// @dev `signer` is the address signing the meta transaction (`actors[0]`)
    /// @dev `relayer` is the address posting the meta transaction to the contract (`actors[1]`)
    /// @dev `spender` is the address being approved by `signer` (`actors[2]`)
    /// @dev `nonce` is the meta transaction count on this specific token for `signer` (`txparams[0]`)
    /// @dev `gasLimit` is the wanted gas limit, set by `signer`, should be respected by `relayer` (`txparams[1]`)
    /// @dev `gasPrice` is the wanted gas price, set by `signer`, should be respected by `relayer` (`txparams[2]`)
    /// @dev `reward` is the amount of tokens that are given to `relayer` from `signer` (`txparams[3]`)
    /// @dev `amount` is the amount of tokens approved by `signer` to `spender` (`txparams[4]`)
    ///
    /// @param actors Array of `address`es that contains `signer` as `actors[0]`, `relayer` as `actors[1]`,
    ///               `spender` as `actors[2]` in this precise order.
    ///
    /// @param txparams Array of `uint256` that MUST contain `nonce` as `txparams[0]`, `gasLimit` as `txparams[1]`,
    ///                 `gasPrice` as `txparams[2]`, `reward` as `txparams[3]` and `amount` as `txparams[4]`.
    ///
    // solhint-disable-next-line max-line-length
    function signedApprove(address[3] calldata actors, uint256[5] calldata txparams, bytes calldata signature) external returns (bool);

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
    /// @dev `signer` is the address signing the meta transaction (`actors[0]`)
    /// @dev `relayer` is the address posting the meta transaction to the contract (`actors[1]`)
    /// @dev `sender` is the account sending the tokens, and should have approved `signer` (`actors[2]`)
    /// @dev `recipient` is the account receiving the tokens (`actors[3]`)
    /// @dev `nonce` is the meta transaction count on this specific token for `signer` (`txparams[0]`)
    /// @dev `gasLimit` is the wanted gas limit, set by `signer`, should be respected by `relayer` (`txparams[1]`)
    /// @dev `gasPrice` is the wanted gas price, set by `signer`, should be respected by `relayer` (`txparams[2]`)
    /// @dev `reward` is the amount of tokens that are given to `relayer` from `signer` (`txparams[3]`)
    /// @dev `amount` is the amount of tokens transferred from `sender` to `recipient` (`txparams[4]`)
    ///
    /// @param actors Array of `address`es that contains `signer` as `actors[0]` and `relayer` as `actors[1]`, `sender`
    ///               as `actors[2]` and `recipient` as `actors[3]`
    /// @param txparams Array of `uint256` that MUST contain `nonce` as `txparams[0]`, `gasLimit` as `txparams[1]`,
    ///                 `gasPrice` as `txparams[2]`, `reward` as `txparams[3]` and `amount` as `txparams[4]`.
    ///
    // solhint-disable-next-line max-line-length
    function verifyTransferFrom(address[4] calldata actors, uint256[5] calldata txparams, bytes calldata signature) external view returns (bool);

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
    /// @dev `signer` is the address signing the meta transaction (`actors[0]`)
    /// @dev `relayer` is the address posting the meta transaction to the contract (`actors[1]`)
    /// @dev `sender` is the account sending the tokens, and should have approved `signer` (`actors[2]`)
    /// @dev `recipient` is the account receiving the tokens (`actors[3]`)
    /// @dev `nonce` is the meta transaction count on this specific token for `signer` (`txparams[0]`)
    /// @dev `gasLimit` is the wanted gas limit, set by `signer`, should be respected by `relayer` (`txparams[1]`)
    /// @dev `gasPrice` is the wanted gas price, set by `signer`, should be respected by `relayer` (`txparams[2]`)
    /// @dev `reward` is the amount of tokens that are given to `relayer` from `signer` (`txparams[3]`)
    /// @dev `amount` is the amount of tokens transferred from `sender` to `recipient` (`txparams[4]`)
    ///
    /// @param actors Array of `address`es that contains `signer` as `actors[0]` and `relayer` as `actors[1]`, `sender`
    ///               as `actors[2]` and `recipient` as `actors[3]`
    /// @param txparams Array of `uint256` that MUST contain `nonce` as `txparams[0]`, `gasLimit` as `txparams[1]`,
    ///                 `gasPrice` as `txparams[2]`, `reward` as `txparams[3]` and `amount` as `txparams[4]`.
    ///
    // solhint-disable-next-line max-line-length
    function signedTransferFrom(address[4] calldata actors, uint256[5] calldata txparams, bytes calldata signature) external returns (bool);

}
