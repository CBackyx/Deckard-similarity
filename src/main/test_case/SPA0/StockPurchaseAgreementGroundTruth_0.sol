pragma solidity 0.5.16;

// https://www.lawinsider.com/contracts/7Adpa4tlz462QG52N0pZ03/entech-solar-inc/stock-purchase-agreement/2011-10-11
// sheet line 5

contract StockPurchaseAgreement {

    address payable public seller;
    address payable[] public buyer;

    string public sellerName;
    string[] public buyerName;

    uint public EffectiveTime;
    uint public CloseTime;
    uint public OutSideClosingDate;

    // uint[1] public price;
    uint[1] public pricePayedByBuyer; // Temporarily stored on contract account

    bool[1] public purchaseSellerConfirmed;
    bool[1] public purchaseBuyerConfirmed;

    mapping(string => uint32) fileHashMap;

    bool[1] public terminateSellerConfirmed;
    bool[1] public terminateBuyerConfirmed;

    enum State { Created, Locked, Release, Transfered, Inactive }
    // The state variable has a default value of the first member, `State.created`
    State[1] public state;

    bool transferReceiveConfirm; 

    event Payed_0();
    event Released_0();
    event Closed();
    event Terminated(
        uint buyerIndex
    );
    event Terminated_OutOfDate();

    constructor() public payable {
        EffectiveTime = 0; // October 4, 2011
        CloseTime = 0;
        OutSideClosingDate = 0;

        sellerName = "Entech Solar";
        seller = address(0);

        buyerName = ["The Quercus Trust"];
        buyer = [address(0)];
    }

    function pay_0()
        public     
        payable
    {
        require(state[0] == State.Created || state[0] == State.Locked);
        require(msg.sender == buyer[0]);

        uint256 price = 100000; // 100000 USD
        require(msg.value == price);

        emit Payed_0();

        pricePayedByBuyer[0] = price; 

        state[0] = State.Locked;
    }

    /// Release pay by the buyer
    /// This will release the locked ether.
    function payRelease_0()
        public
    {
        require(msg.sender == buyer[0]);

        emit Released_0();

        state[0] = State.Release;

        seller.transfer(pricePayedByBuyer[0]);

        // clean the contract account
        pricePayedByBuyer[0] = 0;
    }


    function uploadFileHash(string memory fileName, uint32 hashCode)
        public
    {
        bool validSender = false;
        if (msg.sender == seller) {
            validSender = true;
        } else {
            uint buyerNum = buyerName.length;
            for (uint i=0; i<buyerNum; i++) {
                if (msg.sender == buyer[i]) {
                    validSender = true;
                    break;
                }
            }
        }
        require(validSender);

        fileHashMap[fileName] = hashCode;
    }

    function close()
        public
    {
        require(now >= CloseTime);
        emit Closed();

        uint buyerNum = buyerName.length;

        for (uint i=0; i<buyerNum; i++) {
            state[i] = State.Inactive;
        }

        // selfdestruct(seller);
    }
}