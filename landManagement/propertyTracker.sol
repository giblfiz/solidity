pragma solidity ^0.4.6;
contract RealEstateTracker{

uint8 constant JUDICIAL = 3;
uint8 constant FEDERAL = 2;
uint8 constant LOCAL = 1;

uint8 constant CREATE_REGION   = 17; //0x11
uint8 constant DISOLVE_REGION  = 18; //0x12
uint8 constant TRANSFER_REGION = 19; //0x13
uint8 constant CREATE_OFFICER  = 20; //0x14
uint8 constant REMOVE_OFFICER  = 21; //0x15


struct Region{
    uint8 ul_lat;
    uint8 ul_lng;
    uint8 lr_lat;
    uint8 lr_lng;
    string owner_name;
    string street_address;
    address owner;
}

mapping (bytes32 => Region) public region_record;
bytes32[] public region_hash_list;

mapping (address => uint8) public officer;

struct PendingAction{
    bytes32 region_hash;
    uint8 action_id;
    address owner_signature;
    address local_signature;
    address federal_signature;
    address judicial_signature;
}

mapping (bytes32 => PendingAction) pending_actions;


function RealEstateTracker(address _judicial, address _local){
    officer[msg.sender] = FEDERAL;
    officer[_judicial] = JUDICIAL;
    officer[_local] = LOCAL;
}

event debug(uint8 code);
event pendingAdded(bytes32 pa_hash);

function SignPending(bytes32 _region_hash, address _new_owner, uint8 _action_id){
    bytes32 pending_action_hash = sha3(_region_hash,_new_owner,_action_id);
    if(pending_actions[pending_action_hash].region_hash == ""){
        pending_actions[pending_action_hash].action_id = _action_id;
        pending_actions[pending_action_hash].region_hash = _region_hash;
    }
    if(officer[msg.sender] == 0 ){
        if(region_record[_region_hash].owner == msg.sender){
            pending_actions[pending_action_hash].owner_signature = msg.sender;
        }
    } else {
        if(officer[msg.sender] == LOCAL){
            pending_actions[pending_action_hash].local_signature = msg.sender;
        } else if(officer[msg.sender] == FEDERAL){
            pending_actions[pending_action_hash].federal_signature = msg.sender;
        } else if(officer[msg.sender] == JUDICIAL){
            pending_actions[pending_action_hash].judicial_signature = msg.sender;
        }
    }
}

function isPendingOwnerSigned(bytes32 _region_hash, address _new_owner, uint8 _action_id) returns (bool){
    bytes32 pending_action_hash = sha3(_region_hash,_new_owner,_action_id);
    if(pending_actions[pending_action_hash].owner_signature != 0x0){
        if(pending_actions[pending_action_hash].local_signature != 0x0){
            return true;
        }
    }
    return false;
}

function isPendingFormalSigned(bytes32 _region_hash, address _new_owner, uint8 _action_id) returns (bool){
    bytes32 pending_action_hash = sha3(_region_hash,_new_owner,_action_id);
    if(pending_actions[pending_action_hash].federal_signature != 0x0){
        if(pending_actions[pending_action_hash].judicial_signature != 0x0){
            if(pending_actions[pending_action_hash].local_signature != 0x0){
                return true;
            }
        }
    }
    return false;
}


event ActionExecuted(bytes32 indexed _region_hash, address _new_owner, uint8 indexed _action_id,
    address owner, address judicial, address federal, address indexed local);

function pendingExecuted(bytes32 _region_hash, address _new_owner, uint8 _action_id){
    bytes32 pending_action_hash = sha3(_region_hash,_new_owner,_action_id);
    ActionExecuted(_region_hash, _new_owner, _action_id,
    pending_actions[pending_action_hash].owner_signature,
    pending_actions[pending_action_hash].judicial_signature,
    pending_actions[pending_action_hash].federal_signature,
    pending_actions[pending_action_hash].local_signature);
    delete pending_actions[pending_action_hash];
}

event CreateRegionExecuted(bytes32 indexed region_hash, address judicial,
address federal, address local, address owner);

function CreateRegion(uint8 _ul_lat, uint8 _ul_lng, uint8 _lr_lat, uint8 _lr_lng
, address _new_owner, string _street_address){
    //MAYBE check for collisions first?
    bytes32 region_hash = sha3(_ul_lat,_ul_lng,_lr_lat,_lr_lng);
    SignPending(region_hash, _new_owner, CREATE_REGION);
    if(isPendingFormalSigned(region_hash,_new_owner,CREATE_REGION)){
        region_hash_list.push(region_hash);
        region_record[region_hash].ul_lat = _ul_lat;
        region_record[region_hash].ul_lng = _ul_lng;
        region_record[region_hash].lr_lat = _lr_lat;
        region_record[region_hash].lr_lng = _lr_lng;
        region_record[region_hash].owner = _new_owner;
        region_record[region_hash].street_address = _street_address;
        pendingExecuted(region_hash,_new_owner,CREATE_REGION);
    }
}

event DissolvedRegion(bytes32 indexed _region_hash, uint8 _ul_lat, uint8 _ul_lng,
                      uint8 _lr_lat, uint8 _lr_lng, string street_address);

function DisolveRegion(bytes32 _region_hash){
    SignPending(_region_hash, 0x0, DISOLVE_REGION);
    if(isPendingFormalSigned(_region_hash,0x0,DISOLVE_REGION)){

        //record the entire lat/ln of the disolved region
        DissolvedRegion(_region_hash,
        region_record[_region_hash].ul_lat,
        region_record[_region_hash].ul_lng,
        region_record[_region_hash].lr_lat,
        region_record[_region_hash].lr_lng,
        region_record[_region_hash].street_address);

        pendingExecuted(_region_hash,0x0,DISOLVE_REGION);

        //How can we clean up region_hash_list?
    }
}

event TransferedRegion(bytes32 indexed _region_hash, string indexed _owner_name);
function TransferRegion(bytes32 _region_hash,address _new_owner, string _new_owner_name){
    SignPending(_region_hash, _new_owner, TRANSFER_REGION);
    if(isPendingFormalSigned(_region_hash,_new_owner,TRANSFER_REGION)){
        TransferedRegion(_region_hash, region_record[_region_hash].owner_name);
        region_record[_region_hash].owner = _new_owner;
        region_record[_region_hash].owner_name = _new_owner_name;
        pendingExecuted(_region_hash,_new_owner,TRANSFER_REGION);
    }
}

function CreateOfficer(address _new_officer, uint8 _officer_type){
    //todo: unnessisary sha3, makes records less readable as well!
    //just did this to avoid having to refactor the bytes32 vs uint8 type
    SignPending(sha3(_officer_type), _new_officer, CREATE_OFFICER);
    if(isPendingFormalSigned(sha3(_officer_type),_new_officer,CREATE_OFFICER)){
        officer[_new_officer] = _officer_type;
        pendingExecuted(sha3(_officer_type), _new_officer, CREATE_OFFICER);
    }
}

function RemoveOfficer(address _new_officer){
    //todo: unnessisary sha3, makes records less readable as well!
    //just did this to avoid having to refactor the bytes32 vs uint8 type
    SignPending("remove", _new_officer, REMOVE_OFFICER);
    if(isPendingFormalSigned("remove",_new_officer,REMOVE_OFFICER)){
        delete officer[_new_officer];
        pendingExecuted("remove", _new_officer, REMOVE_OFFICER);

    }
}

//function GetRegionByOwner(address _owner); // note computation intensive... do not us when gas is needed
//function CheckForRegionConflict(bytes32 _region_hash);
    
}
