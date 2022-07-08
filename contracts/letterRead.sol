// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./Registration.sol";
import "./LetterProposal.sol";

contract LetterRead{

Registration registrationContract;
LetterProposal letterProposalContract;

    constructor(address registrationAddress,address letterProposalAddress)  {
        registrationContract=Registration(registrationAddress);
        letterProposalContract=LetterProposal(letterProposalAddress);
    }
    modifier onlyRecipient{
      require(registrationContract.isRecipient(msg.sender),
      "Bu islemi sadece ozel veya resmi kurumlar yapabilir."
      );
      _;
    }


    event LetterSeenByRecipient(uint letterID, address student, address teacher, uint seenDate );
    function letterSeenByRecipient(uint _letterID) public onlyRecipient{
    
        require(letterProposalContract.getReferenceLetter(_letterID).recipient==msg.sender,
        "Yalnizca kendinize atanan belgeye ulasabilirsiiniz"
        );
       require(letterProposalContract.getReferenceLetter(_letterID).letterStatus==LetterProposal.status.TeacherCompleted,
        "referansin kabul edilmis durumda olmasi gerekir"
        );
       
        letterProposalContract.getReferenceLetter(_letterID).letterDocument.seenDate=block.timestamp;
        letterProposalContract.getReferenceLetter(_letterID).letterStatus=LetterProposal.status.SeenByRecipient;
       
        emit LetterSeenByRecipient(_letterID, letterProposalContract.getReferenceLetter(_letterID).student, letterProposalContract.getReferenceLetter(_letterID).teacher, block.timestamp );

    }
    

} 