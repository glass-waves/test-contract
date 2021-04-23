pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;


contract CoinContract {
    string initialMember = "bank";

    struct SlackAcc {
        string slackId;
        string name;
    } 

    uint256 private _totalSupply;
    string[] slackAccounts;

    event Transaction(address indexed custodial, string senderId, string receiverId, uint amount);

    mapping(string => uint256)balances;


    constructor() public{
        _totalSupply = 100;
        balances[initialMember] = 100;
        slackAccounts.push(initialMember);
    }

    function name() public pure returns (string memory) {
        return "duckToken";
    }
    function symbol() public pure returns (string memory) {
        return "ACL";
    }
    function burnCoin(string memory _slackId, uint amount) public returns(bool success) {
        uint burnerBalance = balances[_slackId];
        require(burnerBalance > amount, "You don't have enough coins for that transaction");
        balances[_slackId] = burnerBalance - amount;
        _totalSupply = _totalSupply - amount;
        return true;
    }
    
    function mintCoins(string memory _slackId, uint mintAmount) public returns(bool success){
        _totalSupply += mintAmount;
        uint perCapita = mintAmount/slackAccounts.length;
        for(uint i = 0; i< slackAccounts.length; i++) {
            string memory slackId = slackAccounts[i];
            balances[slackId] += perCapita;
        }
        uint minterBal = balances[_slackId];
        balances[_slackId] = minterBal - (perCapita/2);
        return true;
    }   

    function transferCoin(string memory _receiver, string memory _sender, uint amount) public returns (bool success){
        uint senderBalance = balances[_sender];
        require(senderBalance > amount, "You don't have enough coins for that transaction");
        bool isInArray = false;
        for(uint i=0; i < slackAccounts.length; i++){
            string memory temp = slackAccounts[i];
            if(keccak256(abi.encodePacked(temp)) == keccak256(abi.encodePacked(_receiver))) isInArray = true;
        }
        if(isInArray == false) {
            slackAccounts.push(_receiver);
            balances[_sender] += (amount/2);
            _totalSupply += (amount/2);
            //add an event to alert both sender and user that a new user has been sent coins
        }
        senderBalance = balances[_sender];
        balances[_sender] = senderBalance - amount;
        balances[_receiver] += amount;
        emit Transaction(msg.sender, _sender, _receiver, amount);
        return true;
    }
    function getAccountList() public view returns(string[] memory) {
        string[] memory tempArr = slackAccounts;
        return tempArr;
    }   
    function checkSlackBalance(string memory _slackId)  public view returns(uint amount) {
        return balances[_slackId];
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // function decimals() public view returns (uint8) {
    //     return 0;
    // }
    // function balanceOf(address custodial) public view returns (uint256 balance){
    //     return balances[slackId];
    // } 
    // function transfer(address _to, uint256 _value) public returns (bool success)
    // function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
    // function approve(address _spender, uint256 _value) public returns (bool success)
    // function allowance(address _owner, address _spender) public view returns (uint256 remaining)

}