// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

/*Build two ERC20 contracts: RareCoin and SkillsCoin (you can change the name if you like).
Anyone can mint SkillsCoin, but the only way to obtain RareCoin is to send SkillsCoin to the RareCoin contract.
You’ll need to remove the restriction that only the owner can mint SkillsCoin.

Here is the workflow:
mint() SkillsCoin to yourself, could be anyone.
SkillsCoin.approve(address rareCoinAddress, uint256 yourBalanceOfSkillsCoin) RareCoin to take coins from you (minter).
RareCoin.trade() This will cause RareCoin to SkillsCoin.transferFrom(address you, address RareCoin, uint256 yourBalanceOfSkillsCoin)
Remember, RareCoin can known its own address with address(this)
RareCoin.balanceOf(address you) should return the amount of coin you originally minted for SkillsCoin.

Remember ERC20 tokens(aka contract) can own other ERC20 tokens. So when you call RareCoin.trade(),
it should call SkillsCoin.transferFrom and transfer your SkillsCoin to itself, I.e. address(this).
*/

contract RareCoin {
    uint256 public rareCoinBalance;
    address public skillsCoinAddress;

    constructor(address _skillsCoinAddress) {
        skillsCoinAddress = _skillsCoinAddress;
    }

    function askTheMeaningOfLife(address source) public returns (uint256) {
        (bool ok, bytes memory result) = source.call(abi.encodeWithSignature("meaningOfLifeAndAllExistence()"));
        require(ok, "call failed");

        return abi.decode(result, (uint256));
    }

    function balanceOf() public view returns (uint256) {
        return rareCoinBalance;
    }

    // This will cause RareCoin to SkillsCoin.transferFrom(address you (the minter), 
    // address RareCoin, uint256 yourBalanceOfSkillsCoin) 
    // Remember, RareCoin can known its own address with address(this)
    function trade(address from, uint256 amount) public returns (uint256) {
        // call another contracts function, bool is added to return tuple, no need to return in remote function.
        (bool ok, bytes memory result) = skillsCoinAddress.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", from, address(this), amount));
        // this will fail if there is insufficient approval or balance
        require(ok, "trade() call failed");
        rareCoinBalance += amount;
        return abi.decode(result, (uint256));
    }
}

// mint tokens, anyone can mint
contract SkillsCoin {
    string public name;  // SkillCoin
    string public symbol;  // SKC

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;  // msg.sender allow spender to spend this amount
    address public owner;  // person who deployed contract
    uint8 public decimals;

    uint256 public totalSupply;  // required, how many tokens have ever been created.

    //constructor(string memory _name, string memory _symbol) {
    constructor() {
        name = 'SkillsCoin';
        symbol = 'SKC';
        decimals = 18;
        owner = msg.sender; // person who deployed contract
    }

    // 
    function approve(address spender, uint256 amount) public returns (bool) {
        amount = balanceOf[msg.sender];
        allowance[msg.sender][spender] = amount;

        return true;
    }

     function meaningOfLifeAndAllExistence() public pure returns (uint256) {
        return 42;
    }

   // tokens go into the minters balance.
    function mint(address minter, uint256 amount) public {
        balanceOf[minter] += amount;  // minter = one who calls the function
        totalSupply += amount;
    }

   function transferFrom(address from, address to, uint256 amount) public returns (uint256) {
        require(to != address(0), "cannot send to address(0)");

        if (msg.sender != from) {
            require(allowance[from][msg.sender] >= amount, "not enough allowance");

            allowance[from][msg.sender] -= amount;
        }

        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        
        return amount;
    }
}

