// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
contract Registration{
  address YOK;
  address TOBB;
  address CB;

  enum Unvan { DR, AS_PROF, PROF,MD }

   struct University
    {
      bool status;
      string name;
    }
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
     struct PublicInstitution
    {
      bool status;
      string name;
    }
    mapping(address=>University) public universities;
    mapping(address=>Teacher) public teachers;
    mapping(address=>Company) public  companies;
    mapping(address=>PublicInstitution) public publicInstitutions;
    mapping(address=>Student) public students;

    event UniversityRegisteredLog(address _universityAddress,string  _name);
    event StudentRegisteredLog(address _studentAddress,string  _name,string  _surname,string  _department,string  _university);
    event TeacherRegisteredLog(address _teacherAddress,string  _name,string  _surname,string  _department,string  _university,Unvan _unvan);
    event CompanyRegisteredLog(address _companyAddress,string  _name, uint _identityNumber,string  _country);
    event PublicInstitutionRegisteredLog(address _institutionAddress,string  _name);

    constructor (address _yok,address _tobb,address _cb){
        YOK=_yok;
        TOBB=_tobb;
        CB=_cb;
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
    modifier onlyCB{
      require(msg.sender == CB,
      "Sadece CB bu islemi yapabilir."
      );
      _;
    }    
    modifier onlyUniversity{
      require(universities[msg.sender].status,
      "Sadece Universite bu islemi yapabilir."
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
      function isPublicInstitution(address _address) public view returns(bool){
        return publicInstitutions[_address].status;
    }
      function isUniversity(address _address) public view returns(bool){
        return universities[_address].status;
    }
      function isRecipient(address _address) public view returns(bool){
        return companies[_address].status||publicInstitutions[_address].status;
    }
 function registerUniversity(address _universityAddress,string memory _name) 
  public onlyYOK{
        require(!universities[_universityAddress].status,
            "University exists already"
            );
            
        universities[_universityAddress].status=true;
        universities[_universityAddress].name=_name;

        emit UniversityRegisteredLog( _universityAddress, _name);
       
    }
    function updateUniversity(address _universityAddress,string memory _name,bool _status) 
  public onlyYOK{
        require(universities[_universityAddress].status,
            "University not exists"
            );
            
        universities[_universityAddress].status=_status;
        universities[_universityAddress].name=_name;

        emit UniversityRegisteredLog( _universityAddress, _name);
       
    }
  function registerStudent(address _studentAddress,string memory _name,string memory _surname,string memory _department,string memory _university) 
  public onlyUniversity{
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
     function updateStudent(address _studentAddress,string memory _name,string memory _surname,string memory _department,string memory _university,bool _status) 
  public onlyUniversity{
        require(students[_studentAddress].status,
            "Student not exists"
            );
            
        students[_studentAddress].status=_status;
        students[_studentAddress].name=_name;
        students[_studentAddress].surname=_surname;
        students[_studentAddress].university=_university;
        students[_studentAddress].department=_department;
        emit StudentRegisteredLog( _studentAddress,  _name,  _surname,  _department,  _university);
    }

     function registerTeacher(address _teacherAddress,string memory _name,string memory _surname,string memory _department,string memory _university,Unvan _unvan) 
  public onlyUniversity{
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
     function updateTeacher(address _teacherAddress,string memory _name,string memory _surname,string memory _department,string memory _university,Unvan _unvan,bool _status) 
  public onlyUniversity{
        require(teachers[_teacherAddress].status,
            "Teacher not exists"
            );
            
        teachers[_teacherAddress].status=_status;
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

    function updateCompany(address _companyAddress,string memory _name, uint _identityNumber,string memory _country,bool _status) 
  public onlyTOBB{
        require(companies[_companyAddress].status,
            "Company not exists "
            );
            
        companies[_companyAddress].status=_status;
         companies[_companyAddress].name=_name;
         companies[_companyAddress].country=_country;
        companies[_companyAddress].identityNumber=_identityNumber;

        emit CompanyRegisteredLog( _companyAddress,  _name,  _identityNumber,  _country);
       
    }
     function registerPublicInstitution(address _institutionAddress,string memory _name) 
     public onlyCB{
        require(!publicInstitutions[_institutionAddress].status,
            "Public Institution exists already"
            );
            
        publicInstitutions[_institutionAddress].status=true;
        publicInstitutions[_institutionAddress].name=_name;

        emit PublicInstitutionRegisteredLog( _institutionAddress,  _name);
       
    }

     function updatePublicInstitution(address _institutionAddress,string memory _name,bool _status) 
     public onlyCB{
        require(publicInstitutions[_institutionAddress].status,
            "Public Institution not exists "
            );
            
        publicInstitutions[_institutionAddress].status=_status;
        publicInstitutions[_institutionAddress].name=_name;

        emit PublicInstitutionRegisteredLog( _institutionAddress,  _name);
       
    }
}

