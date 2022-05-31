// SPDX-License-Identifier: MIT


pragma solidity >=0.7.0 <0.9.0;

interface IVotingContract{

//only one address should be able to add candidates
    function addCandidate() external returns(bool);

    
    function voteCandidate(uint candidateId) external returns(bool);

    //getWinner returns the name of the winner
    function getWinner() external returns(bytes32);
}

contract Ballot{
    mapping(address => bool) public candidateVote;
    uint public voteTime;
    address public creator;
    

    struct Candidate{
        bytes32 candidateId;
        uint voteCount;
        uint voteTime;
    }

    Candidate[] public candidates;
    mapping(address => bool) public voter;
    
    constructor(){
        creator = msg.sender;
    }

    function addCandidate(bytes32 _candidateId) external returns(bool){
        require(msg.sender == creator, "You are not authorized");
        require(block.timestamp <= voteTime + 180, "Time has ended for adding candidate");
        
        candidates.push(Candidate({
            candidateId: _candidateId,
            voteCount: 0,
            voteTime : block.timestamp + 180
        }));

        return true;

    }

    function voteCandidate(uint candidateId) external returns(bool){
        require(voter[msg.sender] != false, "You have previously voted");
        
        require(block.timestamp <= voteTime + 180, "Time has ended for adding candidate");

        voter[msg.sender] = true;
        candidates[candidateId].voteCount +=1;

        return true;

    }

    function getWinner() external view returns(bytes32){
        uint maxNumber = 0;
        uint tempi = 0;
        for(uint i=0; i< candidates.length; i++){
            if(candidates[i].voteCount > maxNumber){
                maxNumber = candidates[i].voteCount;
                tempi = i;
            }
        }
        bytes32 finals = candidates[tempi].candidateId;
        return finals;
    }
}
