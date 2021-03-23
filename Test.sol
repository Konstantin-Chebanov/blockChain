pragma solidity >=0.8.0;


contract Owned {
    
    address private owner;
    
    constructor() public
    {
        owner = msg.sender;
    }
    
    modifier OnlyOwner
    {
        require
        (
            msg.sender == owner,
            'Need to be owner'
        );
        _;
    }
    
    function ChangeOwner(address _owner) public OnlyOwner 
    {
        owner = _owner;
    }
    
    function GetOwner() public returns (address)
    {
        return owner;
    }
    
    
}


contract Test is Owned
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
        address add;
        RequestType requestType;
        Home home;
        uint result;
    }
    struct Employee
    {
        string nameEmployee;
        string position;
        string phoneNumber;
        bool isset;
    }
    
    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(uint => Request) private requests;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    uint reqAmount = 0;
    
    modifier OnlyEmployee {
        require(
            employees[msg.sender].isset != false,
            'Only employee car run this function'
            );
        _;

    }
    
    //-------------------------------Home---------------------------------------
    
    function AddHome(string memory _adr, uint _area, uint _cost) OnlyEmployee public {
        Home memory h;
        h.homeAddress = _adr;
        h.area = _area;
        h.cost = _cost;
        homes[_adr] = h;
    }
    function GetHome(string memory adr) public returns (uint _area, uint _cost){
        return (homes[adr].area, homes[adr].cost);
    }
    
    function EditHome(string memory _adr, uint _newArea, uint _newCost) OnlyEmployee public {
        Home storage h = homes[_adr];
        h.area = _newArea;
        h.cost = _newCost;
    }
    
    
    
    //-------------------------------Employee-------------------------------------
    
    function AddEmployee(address empl, string memory _nameEmployee, string memory _position, string memory _phoneNumber) public OnlyOwner{
        Employee memory e;
        e.nameEmployee = _nameEmployee;
        e.position = _position;
        e.phoneNumber = _phoneNumber;
        e.isset = true;
        employees[empl] = e;
    }
    
    function GetEmployee(address empl, string memory nameEmployee) public OnlyOwner returns (string memory _nameEmployee, string memory _position, string memory _phoneNumber){
        return (employees[empl].nameEmployee, employees[empl].position, employees[empl].phoneNumber);
    }
    
    function EditEmployee(address empl, string memory _nameEmployee, string memory _newPosition, string memory _newPhoneNumber) public OnlyOwner {
        Employee storage e = employees[empl];
        e.nameEmployee = _nameEmployee;
        e.position = _newPosition;
        e.phoneNumber = _newPhoneNumber;
    }
    function DeleteEmployee(address empl) public OnlyOwner returns(bool) {
        if(employees[empl].isset == true)
            {delete employees[empl];
            return true;
            }
        return false;
    }
    
    //-------------------------------Request-------------------------------------
    
    function NewHomeRequest(address req, string memory homeAddress, uint area, uint cost) public{
        Home memory h;
        h.homeAddress = homeAddress;
        h.area = area;
        h.cost = cost;
        Request memory r;
        r.add = req;
        r.requestType = RequestType.NewHome;
        r.home = h; 
        r.result=0;
        requests[reqAmount] = r;
        reqAmount++;
        
    }
    
    function GetRequestsList()  public OnlyEmployee view returns (string[] memory requestType, string[] memory homeAddress, uint[] memory area, uint[] memory cost)
    {
        string[] memory requestTypes = new string[](reqAmount);
        string[] memory homeAddresses = new string[](reqAmount);
        uint[] memory areas =  new uint[](reqAmount);
        uint[] memory costs =  new uint[](reqAmount);
        for (uint i = 0; i < reqAmount; i++){
            requestTypes[i] = requests[i].requestType == RequestType.NewHome ? "NewHome" : "EditHome";
            homeAddresses[i] = requests[i].home.homeAddress;
            areas[i] = requests[i].home.area;
            costs[i] = requests[i].home.cost;
        }
        
        return (requestTypes, homeAddresses, areas, costs);
    }
    
    
}
