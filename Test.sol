pragma solidity >=0.8.0;
pragma experimental ABIEncoderV2;


contract Owned {
    
    address payable private owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    modifier OnlyOwner{
        require
        (
            msg.sender == owner,
            'Need to be owner'
        );
        _;
    }
    
    function ChangeOwner(address payable _owner) public OnlyOwner {
        owner = _owner;
    }
    
    function GetOwner() public returns (address){
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
        bool result;
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
    mapping(address => Request) private requests;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
    address[] requestInitiator;
    uint private fee = 1e12;
    
    function ChangeFee(uint _fee) public OnlyOwner
    {
        fee = _fee;
    }
    
    
    //---------------------------ModifierStart---------------------------------------
    
    modifier OnlyEmployee {
        require(
            employees[msg.sender].isset != false,
            'Only employee car run this function'
            );
        _;

    }
    
    modifier Costs(uint value){
        require(
            msg.value >= value,
            'Not enough funds!!'
            );
        _;
    }
    //---------------------------ModifiersEnd-----------------------------------------
    
    //-------------------------------HomeStart----------------------------------------
    
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
    
    //-------------------------------HomeEnd-------------------------------------------
    
    //-------------------------------EmployeeStart-------------------------------------
    
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
    
    //-------------------------------EmployeeEnd-----------------------------------------
    
    //-------------------------------RequestStart----------------------------------------
    
    function AddRequest(uint rType, string memory homeAddress, uint area, uint cost, address newOwner) public Costs(1e12) payable returns (bool){
        Home memory h;
        h.homeAddress = homeAddress;
        h.area = area;
        h.cost = cost;
        Request memory r;
        r.add = rType==0 ? address(0) : newOwner;
        r.requestType = rType == 0? RequestType.NewHome: RequestType.EditHome;
        r.home = h; 
        r.result = false;
        requests[msg.sender] = r;
        requestInitiator.push(msg.sender);
    }
    
    function GetRequestList() public OnlyEmployee returns (uint[] memory, uint[] memory, string[] memory)
    {
        uint[] memory ids = new uint[](requestInitiator.length);
        uint[] memory types = new uint[](requestInitiator.length);
        string[] memory homeAddresses = new string[](requestInitiator.length);
        for(uint i=0;i!=requestInitiator.length;i++){
            ids[i] = i;
            types[i] = requests[requestInitiator[i]].requestType == RequestType.NewHome ? 0: 1;
            homeAddresses[i] = requests[requestInitiator[i]].home.homeAddress;
        }
        return (ids, types, homeAddresses);
    }
    
    //-------------------------------RequestEnd------------------------------------------
    
    
    
}
