// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract LandRegistry{
    struct Land{
        address owner;
        string location;
        uint size;

    }
    mapping(bytes32 => Land) private landRecords;

    event LandRegistered(bytes32 indexed landId,address indexed owner,string location,uint size);
    event OwnershipTransferred(bytes32 indexed landId,address indexed from, address indexed to);

    function registerLand(uint _landId,string memory _location,uint _size)public{
        bytes32 landId=generateLandId(_landId);
        require(landRecords[landId].owner==address(0),"Land is already registered");

        Land memory newLand = Land(msg.sender,_location, _size);
        landRecords[landId]=newLand;

        emit LandRegistered(landId, msg.sender, _location, _size);

    }

    function transferOwnership(uint _landId,address _to)public{
        bytes32 landId=generateLandId(_landId);
        require (landRecords[landId].owner==msg.sender,"Ownership not transferrable");

        Land storage land=landRecords[landId];
        address previousOwner = land.owner;
        land.owner=_to;
        emit OwnershipTransferred(landId, previousOwner, _to);

        
    }
    function getLandDetails(uint _landId)public view  returns (address owner,string memory,uint size ){
        bytes32 landId=generateLandId(_landId);
        Land storage land=landRecords[landId];
        require(land.owner!= address(0),"Land is not registered");
        return ( land.owner,  land.location ,   land.size );

    }

    function generateLandId(uint _landId)internal pure returns (bytes32){
         return keccak256(abi.encodePacked(_landId));
    }
}
