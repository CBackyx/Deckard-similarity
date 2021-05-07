pragma solidity 0.5.16;

// https://www.lawinsider.com/contracts/bVAMyg5rls0
// sheet line 11

contract StockPurchaseAgreement {
    address payable public seller;
    address payable public buyer;
    string public sellerName;
    string public buyerName;
    uint public CloseTime;
    uint public OutSideClosingDate;
    bool public terminateBuyerConfirmed;
    bool public terminateSellerConfirmed;
    bool public purchaseSellerConfirmed_0;
    bool public purchaseBuyerConfirmed_0;
    mapping(string => uint32) fileHashMap;
    enum State {
        Created, Locked, Release, Transfered, Inactive }
    State public state;
    bool transferFromSellerToBuyerReceiveConfirm;
    bool transferFromBuyerToSellerReceiveConfirm;
    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this.");
        _;
    }
    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this.");
        _;
    }
    event Terminated();
    event Payed();
    event ShareReceived();
    event Transfered();
    event Closed();
    constructor() public payable {
        seller = msg.sender;
        CloseTime = 0;
        OutSideClosingDate = 0;
        sellerName = "A_Inc";
        buyerName = "B_Inc";
    }
    function terminateConfirm() public {
        if(msg.sender == seller) {
            terminateSellerConfirmed = true;
        }
        if(msg.sender == buyer) {
            terminateBuyerConfirmed = true;
        }
    }
    function terminateByOutsideClosingDate() public {
        require(now > CloseTime + 86400000);
        require(msg.sender == seller || msg.sender == buyer);
        require(terminateSellerConfirmed);
        require(terminateBuyerConfirmed);
        emit Terminated();
        state = State.Inactive;
        buyer.transfer(address(this).balance);
    }
    function terminateByBuyer() public {
        require(now < CloseTime - 5184000);
        require(msg.sender == buyer);
        require(terminateSellerConfirmed);
        require(terminateBuyerConfirmed);
        emit Terminated();
        state = State.Inactive;
        buyer.transfer(address(this).balance);
    }
    function terminateBySeller() public {
        require(now < CloseTime - 5184000);
        require(msg.sender == seller);
        require(terminateSellerConfirmed);
        require(terminateBuyerConfirmed);
        emit Terminated();
        state = State.Inactive;
        buyer.transfer(address(this).balance);
    }
    function terminateByBuyerAndSeller() public {
        require(now < CloseTime);
        require(msg.sender == seller || msg.sender == buyer);
        require(terminateSellerConfirmed);
        require(terminateBuyerConfirmed);
        emit Terminated();
        state = State.Inactive;
        buyer.transfer(address(this).balance);
    }
    function pay_0() public payable {
        require(now <= CloseTime); // January 5, 2022
        require(state == State.Created || state == State.Locked);
        if(state == State.Locked) {
            require(buyer == msg.sender);
        }
        require(purchaseBuyerConfirmed_0);
        require(purchaseSellerConfirmed_0);
        uint256 purchasePrice = 1500000;
        require(msg.value == purchasePrice);
        emit Payed();
        buyer = msg.sender;
        state = State.Locked;
    }
    function purchaseConfirm_0() public {
        if(msg.sender == seller) {
            purchaseSellerConfirmed_0 = true;
        }
        if(msg.sender == buyer) {
            purchaseBuyerConfirmed_0 = true;
        }
    }
    function releasePay() onlyBuyer public {
        require(now < CloseTime);
        require(state == State.Locked);
        emit ShareReceived();
        state = State.Release;
        seller.transfer(address(this).balance);
    }
    function uploadFileHash(string memory fileName, uint32 hashCode) public {
        require(msg.sender == seller || msg.sender == buyer);
        fileHashMap[fileName] = hashCode;
    }
    function confirmTransferFromSellerToBuyerReceive() public {
        require(now >= CloseTime && now <= CloseTime + 5184000);
        require(msg.sender == buyer);
        transferFromSellerToBuyerReceiveConfirm = true;
    }
    function confirmTransferFromBuyerToSellerReceive() public {
        require(now >= CloseTime && now <= CloseTime - 5184000);
        require(msg.sender == seller);
        transferFromBuyerToSellerReceiveConfirm = true;
    }
    function close() public {
        require(now >= CloseTime);
        emit Closed();
        state = State.Inactive;
    }
}
