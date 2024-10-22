# Project - MerkleDrop



## Transaction Types:

* Ethereum and Zksync share 4 types of transactions types:

    * Transaction Type 0 (Legacy Transactions): This was the very first transaction type that was introduced

    * Transaction Type 1 (0x01 Transaction Types): 

    * Transaction Type 2 (0x02 Transactions): 
        * Introduced in Ethereums `London Fork`
        * This transaction type is aimed to tackle high network fees and congestion and it was all around gas fees. The legacy transactions have `gasPrice` parameter which was replaced by `baseFee`.
        * Also added the following parameters:
            * `maxPriorityFeePerGas`: Maximum fee sender is willing to pay
            * `maxFeePerGas` : Maximum Total fee the sender is going to pay, we can also say `maxPriorityFeePerGas+baseFee` 

    * Transaction Type 3 (0x03: Blob Transaction):
        * This was introduced in `EIP-4844`. This was introduced in ethereum `dencun Fork`.
        * Provided initial scaling soultion for rollups, while there usage was still low.
        * Introduced couple of new parameters alongside those introduced in in type 0 and type 2 transactions:
            * `max_blob_per_fee_gas`: The maximum fee per gas the sender is willing to pay for the blob gas.
            * `blob_versioned_hashes`:

* ZKsync Specific Transaction Types:
    * 0x71: Typed Structured Data (EIP-712)
    * 0xff: Priority Transactions

