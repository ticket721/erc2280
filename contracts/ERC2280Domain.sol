pragma solidity >=0.5.0 <0.6.0;

contract ERC2280Domain {

    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    struct EIP712Domain {
        string  name;
        string  version;
        uint256 chainId;
        address verifyingContract;
    }

    struct mTxParams {
        uint256 nonce;
        uint256 gasLimit;
        uint256 gasPrice;
        uint256 reward;
    }

    struct mActors {
        address signer;
        address relayer;
    }

    struct mTransfer {
        address recipient;
        uint256 amount;

        mActors actors;

        mTxParams txparams;
    }

    struct mApprove {
        address spender;
        uint256 amount;

        mActors actors;

        mTxParams txparams;
    }

    struct mTransferFrom {
        address sender;
        address recipient;
        uint256 amount;

        mActors actors;

        mTxParams txparams;
    }

    bytes32 constant MACTORS_TYPEHASH = keccak256(
        "mActors(address signer,address relayer)"
    );

    bytes32 constant MTXPARAMS_TYPEHASH = keccak256(
        "mTxParams(uint256 nonce,uint256 gasLimit,uint256 gasPrice,uint256 reward)"
    );

    bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256(
        "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
    );

    bytes32 constant MTRANSFER_TYPEHASH = keccak256(
    // solhint-disable-next-line max-line-length
        "mTransfer(address recipient,uint256 amount,mActors actors,mTxParams txparams)mActors(address signer,address relayer)mTxParams(uint256 nonce,uint256 gasLimit,uint256 gasPrice,uint256 reward)"
    );

    bytes32 constant MAPPROVE_TYPEHASH = keccak256(
    // solhint-disable-next-line max-line-length
        "mApprove(address spender,uint256 amount,mActors actors,mTxParams txparams)mActors(address signer,address relayer)mTxParams(uint256 nonce,uint256 gasLimit,uint256 gasPrice,uint256 reward)"
    );

    bytes32 constant MTRANSFERFROM_TYPEHASH = keccak256(
    // solhint-disable-next-line max-line-length
        "mTransferFrom(address sender,address recipient,uint256 amount,mActors actors,mTxParams txparams)mActors(address signer,address relayer)mTxParams(uint256 nonce,uint256 gasLimit,uint256 gasPrice,uint256 reward)"
    );

    bytes32 DOMAIN_SEPARATOR;

    constructor (string memory domain_name) public {
        DOMAIN_SEPARATOR = hash(EIP712Domain({
            name: domain_name,
            version: '1',
            chainId: 1,
            verifyingContract: address(this)
            }));
    }

    function hash(EIP712Domain memory eip712Domain) internal pure returns (bytes32) {
        return keccak256(abi.encode(
                EIP712DOMAIN_TYPEHASH,
                keccak256(bytes(eip712Domain.name)),
                keccak256(bytes(eip712Domain.version)),
                eip712Domain.chainId,
                eip712Domain.verifyingContract
            ));
    }

    function hash(mTransfer memory transfer) internal pure returns (bytes32) {
        return keccak256(abi.encode(
                MTRANSFER_TYPEHASH,
                transfer.recipient,
                transfer.amount,

                hash(transfer.actors),

                hash(transfer.txparams)
            ));
    }

    function hash(mApprove memory approve) internal pure returns (bytes32) {
        return keccak256(abi.encode(
                MAPPROVE_TYPEHASH,
                approve.spender,
                approve.amount,

                hash(approve.actors),

                hash(approve.txparams)
            ));
    }

    function hash(mActors memory actors) internal pure returns (bytes32) {
        return keccak256(abi.encode(
                MACTORS_TYPEHASH,
                actors.signer,
                actors.relayer
            ));
    }

    function hash(mTxParams memory txparams) internal pure returns (bytes32) {
        return keccak256(abi.encode(
                MTXPARAMS_TYPEHASH,
                txparams.nonce,
                txparams.gasLimit,
                txparams.gasPrice,
                txparams.reward
            ));
    }

    function hash(mTransferFrom memory transfer_from) internal pure returns (bytes32) {
        return keccak256(abi.encode(
                MTRANSFERFROM_TYPEHASH,
                transfer_from.sender,
                transfer_from.recipient,
                transfer_from.amount,

                hash(transfer_from.actors),

                hash(transfer_from.txparams)
            ));
    }


    function verify(mTransfer memory transfer, Signature memory signature) internal view returns (bool) {
        bytes32 digest = keccak256(abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                hash(transfer)
            ));
        return ecrecover(digest, signature.v, signature.r, signature.s) == transfer.actors.signer;
    }

    function verify(mApprove memory approve, Signature memory signature) internal view returns (bool) {
        bytes32 digest = keccak256(abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                hash(approve)
            ));
        return ecrecover(digest, signature.v, signature.r, signature.s) == approve.actors.signer;
    }

    function verify(mTransferFrom memory transfer_from, Signature memory signature) internal view returns (bool) {
        bytes32 digest = keccak256(abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                hash(transfer_from)
            ));
        return ecrecover(digest, signature.v, signature.r, signature.s) == transfer_from.actors.signer;
    }

}
