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
        SeenByRecipient
    } 
    struct LetterDocument{
        bytes32 letterHash;
        uint writtenDate; 
        uint seenDate;
    }
    struct ReferenceLetter{
        address student;
        address teacher;
        address recipient;
        string proposalDescription;
        status letterStatus;
        LetterDocument letterDocument;

    }
    constructor(address registrationAddress)  {
        registrationContract=Registration(registrationAddress);
        letterID=uint(keccak256(abi.encodePacked(msg.sender,block.timestamp,address(this))));

    }
    mapping(uint=>ReferenceLetter) public referenceLetters;
    
    event LetterCreated(uint letterID,address student,address teacher);

    event LetterEvaluated(uint letterID,address student,address teacher,uint evaluatedDate);

    event LetterAdmitted(uint letterID, address student,address teacher,uint admittedDate);

    event LetterRejected(uint letterID, address student,address teacher,string rejectReason,uint rejectedDate);

    event LetterAdded(uint letterID, address student,address teacher,uint addedDate);

    event LetterSeenByRecipient(uint letterID, address student, address teacher, uint seenDate );
    

    modifier onlyStudent{
      require(registrationContract.isStudent(msg.sender),
      "Bu islemi sadece ogrenci yapabilir."
      );
      _;
    }   
    
    modifier onlyTeacher{
      require(registrationContract.isTeacher(msg.sender),
      "Bu islemi sadece akademisyen yapabilir."
      );
      _;
    }   
    modifier onlyRecipient{
      require(registrationContract.isRecipient(msg.sender),
      "Bu islemi sadece ozel veya resmi kurumlar yapabilir."
      );
      _;
    }

    
    function newLetterProposal(address _teacherAddress,address _recipientAddress,string memory _proposalDescription) public onlyStudent {
        require(registrationContract.isTeacher(_teacherAddress),
        "Akademisyen adresi tanimlanamadi."
        );
          require(registrationContract.isCompany(_recipientAddress)||registrationContract.isPublicInstitution(_recipientAddress),
        "Ozel/resmi kurum adresi tanimlanamadi."
        );
        letterID++;
       
        referenceLetters[letterID]=ReferenceLetter(msg.sender,_teacherAddress,_recipientAddress,_proposalDescription,status.Created,LetterDocument(0,block.timestamp,0));
        
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
    
    function letterSeenByRecipient(uint _letterID) public onlyRecipient{
        require(referenceLetters[_letterID].recipient==msg.sender,
        "Yalnizca kendinize atanan belgeye ulasabilirsiiniz"
        );
       require(referenceLetters[_letterID].letterStatus==status.TeacherCompleted,
        "referansin kabul edilmis durumda olmasi gerekir"
        );
       
        referenceLetters[_letterID].letterDocument.seenDate=block.timestamp;
        referenceLetters[_letterID].letterStatus=status.SeenByRecipient;
        emit LetterSeenByRecipient(_letterID, referenceLetters[_letterID].student, referenceLetters[_letterID].teacher, block.timestamp );

    }
    

} 