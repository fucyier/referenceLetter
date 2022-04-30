// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
import "./Registration.sol";

contract LetterProposal{
    Registration registrationContract;
    uint public letterID;
    enum status {
        Created,
        TeacherAdmitted,
        TeacherRejected,
        TeacherCompleted,
        SeenByCompany
    } 
    struct LetterDocument{
        bytes32 letterHash;
        uint writtenDate; 
    }
    struct letterType{
        address student;
        address teacher;
        address company;
        string proposalDescription;
        status letterStatus;
        LetterDocument letterDocument;

    }
    constructor(address registrationAddress)  {
        registrationContract=Registration(registrationAddress);
        letterID=uint(keccak256(abi.encodePacked(msg.sender,block.timestamp,address(this))));

    }
    mapping(uint=>letterType) public referenceLetters;
    
    event LetterCreated(uint letterID,address student,address teacher);

    event LetterEvaluated(uint letterID,address student,address teacher,uint evaluatedDate);

    event LetterAdmitted(uint letterID, address student,address teacher,uint admittedDate);

    event LetterRejected(uint letterID, address student,address teacher,string rejectReason,uint rejectedDate);

    event LetterAdded(uint letterID, address student,address teacher,uint addedDate);

    event LetterSeenByCompany(uint letterID, address student, address teacher,address company, uint seenDate );
    

    modifier onlyStudent{
      require(registrationContract.isStudent(msg.sender),
      "Bu islemi student yapabilir."
      );
      _;
    }   
    
    modifier onlyTeacher{
      require(registrationContract.isTeacher(msg.sender),
      "Bu islemi teacher yapabilir."
      );
      _;
    }   
    modifier onlyCompany{
      require(registrationContract.isCompany(msg.sender),
      "Bu islemi company yapabilir."
      );
      _;
    }

    
    function newLetterProposal(address _teacherAddress,address _companyAddress,string memory _proposalDescription) public onlyStudent {
        require(registrationContract.isTeacher(_teacherAddress),
        "Teacher address not recognized."
        );
          require(registrationContract.isCompany(_companyAddress),
        "Company address not recognized."
        );
        letterID++;
       
        referenceLetters[letterID]=letterType(msg.sender,_teacherAddress,_companyAddress,_proposalDescription,status.Created,LetterDocument(0,block.timestamp));
        
        emit LetterCreated(letterID, msg.sender,_teacherAddress);

    }
    
    function letterFirstEvaluate(uint _letterID) public onlyTeacher  returns(string memory) {
        require(referenceLetters[_letterID].letterStatus==status.Created,
        "Referans durumunun CREATED olmasi gerekir"
        );
        require(referenceLetters[_letterID].teacher==msg.sender,
        "Yalnizca kendinize atanan belgeye ulasabilirsiniz"
        );
  
        emit LetterEvaluated(_letterID, referenceLetters[letterID].student,msg.sender,block.timestamp);
        return referenceLetters[_letterID].proposalDescription;

    }

    function letterAcceptOrReject(uint _letterID, bool accepted,string memory rejectReason) public onlyTeacher{
         require(referenceLetters[_letterID].teacher==msg.sender,
        "Yalnizca kendinize atanan belgeye ulasabilirsiiniz"
        );
        require(referenceLetters[_letterID].letterStatus==status.Created,
        "referansin yeni olusturulmus durumda olmasi gerekir"
        );
        if(accepted){
            referenceLetters[_letterID].letterStatus=status.TeacherAdmitted;
      
          emit LetterAdmitted( _letterID,  referenceLetters[letterID].student, msg.sender, block.timestamp);
        }
        else{
            referenceLetters[letterID].letterStatus=status.TeacherRejected;
                emit LetterRejected( letterID,  referenceLetters[letterID].student, msg.sender, rejectReason,block.timestamp);
        }
    }
    
    
    function addLetter(uint _letterID, bytes32 _letterHash ) public onlyTeacher{
        require(referenceLetters[_letterID].teacher==msg.sender,
        "Yalnizca kendinize atanan belgeye ulasabilirsiiniz"
        );
       require(referenceLetters[_letterID].letterStatus==status.TeacherAdmitted,
        "referansin kabul edilmis durumda olmasi gerekir"
        );
        referenceLetters[_letterID].letterDocument.letterHash=_letterHash;
          referenceLetters[_letterID].letterDocument.writtenDate=block.timestamp;
        referenceLetters[_letterID].letterStatus=status.TeacherCompleted;
           emit LetterAdded( _letterID,  referenceLetters[_letterID].student, msg.sender, block.timestamp);

    }
    

    

} 