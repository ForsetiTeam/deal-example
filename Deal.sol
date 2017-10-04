pragma solidity ^0.4.0;

import "./Structures.sol";
import "./DealExtension.sol";

contract Deal is DealExtension {

  Structures.DealInfo dealInfo;
  Structures.DealParty dealParty;
  Structures.ProposedChanges proposedChanges;

  address[] public executors;

  bool executorAcceptChanges;
  bool customerAcceptChanges;
  bool executorConfirmDeal;
  bool customerConfirmDeal;
  bool onTime;
  bool executorFinish;

  uint startDate;
  uint executorsAmount;

  modifier onlyMember {
    require(msg.sender == dealParty.customer || msg.sender == dealParty.executor);
    _;
  }

  modifier onlyCustomer {
    require(msg.sender == dealParty.customer);
    _;
  }
  modifier onlyExecutor {
    require(msg.sender == dealParty.executor);
    _;
  }


  function Deal(address customerAddress,string title, string description, string attachment, uint deposit, uint dealTime, uint payForWork) {
    require(payForWork <= deposit);
    dealInfo = Structures.DealInfo(title, description, attachment, deposit, dealTime, payForWork);
    dealParty.customer = customerAddress;

  }

  function getExecutors() returns(address[]) {
    return executors;
  }

  // test
  function getCustomer() returns(address) {
    return dealParty.customer;
  }

  function becomeExecutor()  {
    require(dealParty.executor == 0x0);
    executors.push(msg.sender);
    executorsAmount = executors.length;
  }

  function acceptExecutor(uint index) {
    dealParty.executor = executors[index];
  }

  function proposeChanges(string attachment, uint deposit, uint dealTime) onlyMember {
    require(executorConfirmDeal == false && customerConfirmDeal == false);
    proposedChanges = Structures.ProposedChanges(attachment, deposit, dealTime);
  }

  function acceptChanges() onlyMember {
    if (msg.sender == dealParty.executor) {
      executorAcceptChanges = true;
    }
    else {
      customerAcceptChanges = true;
    }
    if (customerAcceptChanges && executorAcceptChanges){
      dealInfo.attachment = proposedChanges.attachment;
      dealInfo.deposit = proposedChanges.deposit;
      dealInfo.dealTime = proposedChanges.dealTime;
    }
  }


  function depositMoney() payable {}

  function startDeal() onlyMember {

    require(this.balance >= dealInfo.deposit);
    require(dealParty.executor != 0x0);
    require(customerConfirmDeal && executorConfirmDeal);

    startDate = now;
  }

  function confirmDeal() onlyMember {
    if (msg.sender == dealParty.executor){
      executorConfirmDeal = true;
    }
    if (msg.sender == dealParty.customer){
      customerConfirmDeal = true;
    }
  }

  function finishWork() onlyExecutor {
    if ((now - startDate) > dealInfo.dealTime) {
      onTime = false;
    }
    else {
      onTime = true;
    }
    executorFinish = true;
  }

  function finishDeal() onlyCustomer {
    require(executorFinish);
    msg.sender.transfer(dealInfo.deposit);
  }
}
