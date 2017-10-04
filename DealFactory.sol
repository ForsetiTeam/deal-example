pragma solidity ^0.4.0;

import "./Deal.sol";
import "./PermissionExtension.sol";

contract DealFactory is PermissionExtension {

  address[] activeDeals;

  function createDeal(address customerAddress,string title, string description, string attachment, uint deposit, uint dealTime, uint payForWork) returns (address){
    address newDeal = new Deal(customerAddress, title, description, attachment, deposit, dealTime, payForWork);
    setPermission(newDeal, "changeReputation");
    return (newDeal);
  }
}