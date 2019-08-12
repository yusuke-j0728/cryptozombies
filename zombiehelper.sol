pragma solidity ^0.5.1;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
    
    uint levelUpFee = 0.001 ether;
    
    modifier abovelevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }
    
    function withdrawal() external onlyOwner {
        // Here is how to cast address to address payable /// https://ethereum.stackexchange.com/questions/65693/how-to-cast-address-to-address-payable-in-solidity-0-5-0
        address payable _owner = address(uint160(owner())); 
        _owner.transfer(address(this).balance);
    }
    
    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }
    
    function levelUp(uint _zombieId) external payable {
        require(msg.value == levelUpFee);
        // zombies[_zombieId].level++;
        zombies[_zombieId].level = zombies[_zombieId].level.add(1);
    }
    
    function changeName(uint _zombieId, string calldata  _newName) external abovelevel(2, _zombieId) onlyOwnerOf(_zombieId) {
        // require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;
    }
    
    function changeDna(uint _zombieId, uint _newDna) external abovelevel(20, _zombieId) onlyOwnerOf(_zombieId) {
        // require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].dna = _newDna;
    }
    
    function getZombiesByOwner(address _owner) external view returns(uint[] memory){
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;
        for(uint i = 0; i < zombies.length; i++) {
            if(zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}