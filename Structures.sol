pragma solidity ^0.4.0;

library Structures {
  struct DealInfo {
  string title;
  string description;
  string attachment;

  uint deposit;
  uint dealTime;
  uint payForWork;
  }
  struct DealParty {
  address executor;
  address customer;
  }
  struct ProposedChanges {
  string attachment;
  uint deposit;
  uint dealTime;
  }
}
