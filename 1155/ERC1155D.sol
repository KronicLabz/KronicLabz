// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;

import "http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Strings.sol";
import "http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";

contract ERC1155NFT is ERC1155, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_ID_PLUS_ONE = 11;
    uint256 public constant PRICE = 0.05 ether;
    uint256 public currentIndex = 1;
    string public name = "collection name";
    string public baseURI = "ipfs://.../";

    constructor() ERC1155("") {}

    function mint() external payable {
        uint256 _currentIndex = currentIndex;
        require(_currentIndex < MAX_ID_PLUS_ONE);
        require(msg.value == PRICE, "wrong price");
        require(msg.sender == tx.origin, "no smart contracts");

        _mint(msg.sender, _currentIndex, 1, "");
        unchecked {
            _currentIndex++;
        }
        currentIndex = _currentIndex;
    }

    function uri(uint256 id) public view virtual override returns(string memory) {
        require(id <= MAX_ID_PLUS_ONE, "invalid id");
        return string(abi.encodePacked(baseURI, id.toString(), ".json"));
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
