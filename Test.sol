pragma solidity >=0.4.22 <0.6.0 ;

contract Test
{
    enum RequestType{NewHome, EditHome}
    
    struct Ownership
    {
        string homeAddress;
        address owner;
        uint p;
    }   
    
    struct Owner{
        string name;
        uint passSer;
        uint passNum;
        uint256 date;
        string phoneNumber;
    }
    
    struct Home
    {
        string homeAddress;
        uint area;
        uint cost;
    }
    struct Request
    {
        RequestType requestType;
        Home home;
        uint result;
        address adr;
    }
    struct Employee
    {
        string nameEmployee;
        string position;
        string phoneNumber;
    }
    
    mapping(string => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
    
    
    //-------------------------------Home---------------------------------------
    
    function AddHome(string memory _adr, uint _area, uint _cost) public {
        Home memory h;
        h.homeAddress = _adr;
        h.area = _area;
        h.cost = _cost;
        homes[_adr] = h;
    }
    function GetHome(string memory adr) public returns (uint _area, uint _cost){
        return (homes[adr].area, homes[adr].cost);
    }
    
    function EditHome(string memory _adr, uint _newArea, uint _newCost) public {
        Home storage h = homes[_adr];
        h.area = _newArea;
        h.cost = _newCost;
    }
    
    
    
    //-------------------------------Employee-------------------------------------
    
    function AddEmployee(string memory _nameEmployee, string memory _position, string memory _phoneNumber) public {
        Employee memory e;
        e.nameEmployee = _nameEmployee;
        e.position = _position;
        e.phoneNumber = _phoneNumber;
        employees[_nameEmployee] = e;
    }
    
    function GetEmployee(string memory nameEmployee) public returns (string memory _position, string memory _phoneNumber){
        return (employees[nameEmployee].position, employees[nameEmployee].phoneNumber);
    }
    
    function EditEmployee(string memory _nameEmployee, string memory _newPosition, string memory _newPhoneNumber) public {
        Employee storage e = employees[_nameEmployee];
        e.position = _newPosition;
        e.phoneNumber = _newPhoneNumber;
    }
    
}