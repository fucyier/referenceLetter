// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
contract Registration{
  address YOK;
  address TOBB;
  enum Unvan { DR, AS_PROF, PROF,MD }
  struct Teacher
    {
      bool status;
      string university;
      string department;
      Unvan unvan; 
      string name;
      string surname;
    }
   struct  Student
    {
      bool status;
      string university;
      string department;
      string name;
      string surname;
    }
   struct Company
    {
      bool status;
      string country;
      uint identityNumber;
      string name;
    }
    
    mapping(address=>Teacher) public teachers;
    mapping(address=>Company) public  companies;
    mapping(address=>Student) public students;

    // mapping(address=>bool) public isTeacher;
    // mapping(address=>bool) public isCompany;
    // mapping(address=>bool) public isStudent;

    event StudentRegisteredLog(address _studentAddress,string  _name,string  _surname,string  _department,string  _university);
    event TeacherRegisteredLog(address _teacherAddress,string  _name,string  _surname,string  _department,string  _university,Unvan _unvan);
    event CompanyRegisteredLog(address _companyAddress,string  _name, uint _identityNumber,string  _country);

    constructor (address yok,address tobb){
        YOK=yok;
        TOBB=tobb;
    }
    
    modifier onlyYOK{
      require(msg.sender == YOK,
      "Sadece YOK bu islemi yapabilir."
      );
      _;
    }    
    
    modifier onlyTOBB{
      require(msg.sender == TOBB,
      "Sadece TOBB bu islemi yapabilir."
      );
      _;
    }    

     function isStudent(address _address) public view returns(bool){
        return students[_address].status;
    }
         function isTeacher(address _address) public view returns(bool){
        return teachers[_address].status;
    }
         function isCompany(address _address) public view returns(bool){
        return companies[_address].status;
    }
  function registerStudent(address _studentAddress,string memory _name,string memory _surname,string memory _department,string memory _university) 
  public onlyYOK{
        require(!students[_studentAddress].status,
            "Student exists already"
            );
            
        students[_studentAddress].status=true;
        students[_studentAddress].name=_name;
        students[_studentAddress].surname=_surname;
        students[_studentAddress].university=_university;
        students[_studentAddress].department=_department;
        emit StudentRegisteredLog( _studentAddress,  _name,  _surname,  _department,  _university);
    }

     function registerTeacher(address _teacherAddress,string memory _name,string memory _surname,string memory _department,string memory _university,Unvan _unvan) 
  public onlyYOK{
        require(!teachers[_teacherAddress].status,
            "Teacher exists already"
            );
            
        teachers[_teacherAddress].status=true;
        teachers[_teacherAddress].unvan=_unvan;
        teachers[_teacherAddress].name=_name;
        teachers[_teacherAddress].surname=_surname;
        teachers[_teacherAddress].university=_university;
        teachers[_teacherAddress].department=_department;

        emit TeacherRegisteredLog( _teacherAddress,  _name,  _surname,  _department,  _university, _unvan);
    }
  function registerCompany(address _companyAddress,string memory _name, uint _identityNumber,string memory _country) 
  public onlyTOBB{
        require(!companies[_companyAddress].status,
            "Company exists already"
            );
            
        companies[_companyAddress].status=true;
         companies[_companyAddress].name=_name;
         companies[_companyAddress].country=_country;
        companies[_companyAddress].identityNumber=_identityNumber;

        emit CompanyRegisteredLog( _companyAddress,  _name,  _identityNumber,  _country);
       
    }
}

