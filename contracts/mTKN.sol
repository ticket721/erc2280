pragma solidity >=0.5.0 <0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/introspection/ERC165.sol";
import "./IERC2280.sol";
import "./ERC2280Domain.sol";

contract mTKN is IERC2280, ERC20, ERC20Detailed, ERC2280Domain, ERC165 {

    mapping (address => uint256) private nonces;

    bytes4 constant public MTKN_ERC165_SIGNATURE = // 0x25961920
    bytes4(keccak256('nonceOf(address)')) ^
    bytes4(keccak256('verifyTransfer(address[3],uint256[5],bytes)')) ^
    bytes4(keccak256('signedTransfer(address[3],uint256[5],bytes)')) ^
    bytes4(keccak256('verifyApprove(address[3],uint256[5],bytes)')) ^
    bytes4(keccak256('signedApprove(address[3],uint256[5],bytes)')) ^
    bytes4(keccak256('verifyTransferFrom(address[4],uint256[5],bytes)')) ^
    bytes4(keccak256('signedTransferFrom(address[4],uint256[5],bytes)'));

    constructor (string memory name, string memory symbol, uint8 decimals) ERC20Detailed(name, symbol, decimals)
    ERC2280Domain(name, "1", 1)
    ERC165()
    public {
        _registerInterface(MTKN_ERC165_SIGNATURE);
        _registerInterface(0x36372b07); // ERC-20
        _registerInterface(0x06fdde03); // ERC-20::name
        _registerInterface(0x95d89b41); // ERC-20::symbol
        _registerInterface(0x313ce567); // ERC-20::decimals
    }

    function _splitSignature(bytes memory signature) private pure returns (Signature memory sig) {
        require(signature.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := and(mload(add(signature, 65)), 255)
        }

        if (v < 27) {
            v += 27;
        }

        require(v == 27 || v == 28, "Invalid v argument");
        return Signature({
            v: v,
            r: r,
            s: s
            });
    }

    modifier gasBarrier(uint256 gas_left, uint256 expected_gas, uint256 expected_gasPrice) {
        require(expected_gas <= gas_left, "Insufficient gas provided by the relayer");
        require(expected_gasPrice <= tx.gasprice, "Insufficient gasPrice provided by the relayer");
        _;
    }

    modifier nonceBarrier(address signer, uint256 nonce) {
        require(nonces[signer] == nonce, "Invalid nonce");
        _;
    }

    modifier relayerBarrier(address relayer) {
        if (relayer == address(0)) {
            _;
        } else {
            require(relayer == msg.sender, "Relayer restriction not met");
            _;
        }
    }

    function _signedTransfer(mTransfer memory mtransfer, Signature memory signature, uint256 gas_left)
    nonceBarrier(mtransfer.actors.signer, mtransfer.txparams.nonce)
    gasBarrier(gas_left, mtransfer.txparams.gasLimit, mtransfer.txparams.gasPrice)
    relayerBarrier(mtransfer.actors.relayer)
    internal {
        require(verify(mtransfer, signature), "Invalid signer");

        ERC20._transfer(mtransfer.actors.signer, mtransfer.recipient, mtransfer.amount);
        ERC20._transfer(mtransfer.actors.signer, msg.sender, mtransfer.txparams.reward);

        nonces[mtransfer.actors.signer] = nonces[mtransfer.actors.signer].add(1);
    }

    function verifyTransfer(
        address[3] calldata actors, uint256[5] calldata txparams, bytes calldata signature
    )
    nonceBarrier(actors[0], txparams[0])
    relayerBarrier(actors[1])
    gasBarrier(gasleft(), txparams[1], txparams[2])
    external view returns (bool) {

        {
            mTransfer memory mtransfer = mTransfer({

                recipient: actors[2],
                amount: txparams[4],

                actors: mActors({
                    signer: actors[0],
                    relayer: actors[1]
                    }),

                txparams: mTxParams({
                    nonce: txparams[0],
                    gasLimit: txparams[1],
                    gasPrice: txparams[2],
                    reward: txparams[3]
                    })

                });

            Signature memory sig = _splitSignature(signature);

            require(verify(mtransfer, sig), "Invalid signer");
        }

        require(balanceOf(actors[0]) >= txparams[4] + txparams[3], "Signer has not enough funds for transfer + reward");

        return true;

    }

    function signedTransfer(
        address[3] calldata actors, uint256[5] calldata txparams, bytes calldata signature
    ) external returns (bool) {

        uint256 gas_left_approximation = gasleft();

        Signature memory sig = _splitSignature(signature);

        _signedTransfer(

            mTransfer({

            recipient: actors[2],
            amount: txparams[4],

            actors: mActors({
                signer: actors[0],
                relayer: actors[1]
                }),

            txparams: mTxParams({
                nonce: txparams[0],
                gasLimit: txparams[1],
                gasPrice: txparams[2],
                reward: txparams[3]
                })


            }),

            sig,

            gas_left_approximation

        );

        return true;

    }

    function _signedApprove(mApprove memory mapprove, Signature memory signature, uint256 gas_left)
    nonceBarrier(mapprove.actors.signer, mapprove.txparams.nonce)
    gasBarrier(gas_left, mapprove.txparams.gasLimit, mapprove.txparams.gasPrice)
    relayerBarrier(mapprove.actors.relayer)
    internal {
        require(verify(mapprove, signature), "Invalid signer");

        ERC20._approve(mapprove.actors.signer, mapprove.spender, mapprove.amount);
        ERC20._transfer(mapprove.actors.signer, msg.sender, mapprove.txparams.reward);
        nonces[mapprove.actors.signer] = nonces[mapprove.actors.signer].add(1);
    }

    function verifyApprove(
        address[3] calldata actors, uint256[5] calldata txparams, bytes calldata signature
    )
    nonceBarrier(actors[0], txparams[0])
    relayerBarrier(actors[1])
    gasBarrier(gasleft(), txparams[1], txparams[2])
    external view returns (bool) {

        {
            mApprove memory mapprove = mApprove({

                spender: actors[2],
                amount: txparams[4],

                actors: mActors({
                    signer: actors[0],
                    relayer: actors[1]
                    }),

                txparams: mTxParams({
                    nonce: txparams[0],
                    gasLimit: txparams[1],
                    gasPrice: txparams[2],
                    reward: txparams[3]
                    })

                });

            Signature memory sig = _splitSignature(signature);

            require(verify(mapprove, sig), "Invalid signer");
        }

        require(balanceOf(actors[0]) >= txparams[4] + txparams[3], "Signer has not enough funds for approval + reward");

        return true;

    }

    function signedApprove(
        address[3] calldata actors, uint256[5] calldata txparams, bytes calldata signature
    ) external returns (bool) {

        uint256 gas_left_approximation = gasleft();

        Signature memory sig = _splitSignature(signature);

        _signedApprove(

            mApprove({

            spender: actors[2],
            amount: txparams[4],

            actors: mActors({
                signer: actors[0],
                relayer: actors[1]
                }),

            txparams: mTxParams({
                nonce: txparams[0],
                gasLimit: txparams[1],
                gasPrice: txparams[2],
                reward: txparams[3]
                })

            }),

            sig,

            gas_left_approximation

        );

        return true;
    }

    function _signedTransferFrom(mTransferFrom memory mtransfer_from, Signature memory signature, uint256 gas_left)
    nonceBarrier(mtransfer_from.actors.signer, mtransfer_from.txparams.nonce)
    gasBarrier(gas_left, mtransfer_from.txparams.gasLimit, mtransfer_from.txparams.gasPrice)
    relayerBarrier(mtransfer_from.actors.relayer)
    internal {
        require(verify(mtransfer_from, signature), "Invalid signer");

        ERC20._transfer(mtransfer_from.sender, mtransfer_from.recipient, mtransfer_from.amount);
        ERC20._approve(mtransfer_from.sender, mtransfer_from.actors.signer,
            ERC20.allowance(mtransfer_from.sender, mtransfer_from.actors.signer).sub(mtransfer_from.amount));

        ERC20._transfer(mtransfer_from.actors.signer, msg.sender, mtransfer_from.txparams.reward);
        nonces[mtransfer_from.actors.signer] = nonces[mtransfer_from.actors.signer].add(1);
    }

    function verifyTransferFrom(
        address[4] calldata actors, uint256[5] calldata txparams, bytes calldata signature
    )
    nonceBarrier(actors[0], txparams[0])
    relayerBarrier(actors[1])
    gasBarrier(gasleft(), txparams[1], txparams[2])
    external view returns (bool) {

        mTransferFrom memory mtransfer_from = mTransferFrom({

            sender: actors[2],
            recipient: actors[3],
            amount: txparams[4],

            actors: mActors({
                signer: actors[0],
                relayer: actors[1]
                }),

            txparams: mTxParams({
                nonce: txparams[0],
                gasLimit: txparams[1],
                gasPrice: txparams[2],
                reward: txparams[3]
                })

            });

        require(verify(mtransfer_from, _splitSignature(signature)), "Invalid signer");

        require(balanceOf(actors[2]) >= txparams[4], "Sender has not enough funds for transfer");
        require(balanceOf(actors[0]) >= txparams[3], "Signer has not enough funds for reward");

        return true;
    }

    function signedTransferFrom(
        address[4] calldata actors, uint256[5] calldata txparams, bytes calldata signature
    ) external returns (bool) {

        uint256 gas_left_approximation = gasleft();

        Signature memory sig = _splitSignature(signature);

        _signedTransferFrom(

            mTransferFrom({

            sender: actors[2],
            recipient: actors[3],
            amount: txparams[4],

            actors: mActors({
                signer: actors[0],
                relayer: actors[1]
                }),

            txparams: mTxParams({
                nonce: txparams[0],
                gasLimit: txparams[1],
                gasPrice: txparams[2],
                reward: txparams[3]
                })

            }),

            sig,

            gas_left_approximation

        );

        return true;
    }

    function nonceOf(address account) external view returns (uint256) {
        return nonces[account];
    }

    function test__mint(address owner, uint256 amount) public {
        ERC20._mint(owner, amount);
    }
}
