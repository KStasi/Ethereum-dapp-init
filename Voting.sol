pragma solidity >=0.4.22 <0.6.0;

contract Passport {
    struct Info {
        string name;
        string surname;
        uint age;
        bytes32 id;
    }
    mapping(address => Info) public passports;
    
    function registr(string name, string surname, uint age) public {
        passports[msg.sender] = Info(name, surname, age, bytes32(msg.sender));
    }
}

contract Election {
    Passport public passportCenter;
    address public owner;
    address public leader;
    bool public isOpen;
    struct Candidate {
        bool active;
        uint votes;
    }
    
    mapping(address => Candidate) public rating;
    mapping(address => bool) public voters;
    modifier onlyOwner()
    {
        require(
            msg.sender == owner,
            "Sender not authorized."
        );
        _;
    }
    
    constructor() public {
        passportCenter = new Passport();
        owner = msg.sender;
    }
    
    function addCandidate(address candidate) public onlyOwner {
        rating[candidate] = Candidate(true, 0);
    }

    function terminateElection() public onlyOwner {
        isOpen = false;
    }
    
    function openElection() public onlyOwner {
        isOpen = true;
    }

    function vote(address candidate) public {
        require(isOpen, "Election is closed");
        (string memory name, string memory surname, uint age, bytes32 id) = passportCenter.passports(msg.sender);
        require(id != bytes32(0), "You are not registred");
        require(!voters[msg.sender], "You have participated");
        require(rating[candidate].active, "Candidate is not allowed");
        voters[msg.sender] = true;
        rating[candidate].votes += 1;
        if (rating[candidate].votes > rating[leader].votes) {
            leader = candidate;
        }
        
    }
}
