// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

contract Voting {
    struct Voter {
        bool voted;
        string choice;
    }
    mapping (string => uint) candidates;

    mapping (address => Voter) ballot;
    string[] candidate_names;
    function unique(string calldata name) internal view returns (bool){
        for (uint i=0; i<candidate_names.length; i++){
            if (keccak256(bytes(name))==keccak256(bytes(candidate_names[i]))){
                return false;
            }
        }
        return true;
    }

    function register(string calldata name) public returns (bool) {
        require (unique(name), "Already registered");
        candidates[name]=0;
        candidate_names.push(name);
        return true;
    }
    function listCandidates() public view returns (string[] memory){
        return candidate_names;
    }

    function Vote(string calldata name) public returns (bool){
        require(!ballot[msg.sender].voted, "Already Voted");
        require(!unique(name), "No such candidate");
        ballot[msg.sender].voted = true;
        ballot[msg.sender].choice = name;
        candidates[name]+=1;
        return true;
    }

    function getResults() public view returns (string memory winner, uint votes){
        winner = candidate_names[0];
        votes = candidates[candidate_names[0]];
        for (uint i=0; i<candidate_names.length; i++){
            if (candidates[candidate_names[i]] > votes){
                winner = candidate_names[i];
                votes = candidates[candidate_names[i]];
            }
        }
    }
}