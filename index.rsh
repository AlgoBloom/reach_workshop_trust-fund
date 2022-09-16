'reach 0.1';

const common = {
  funded: Fun([], Null),
  ready : Fun([], Null),
  recvd : Fun([UInt], Null) };
  
export const main =
  Reach.App(
    {},
    [ Participant('Funder', {
      ...common,
      getParams: Fun([], Object({
        receiverAddr: Address,
        payment:      UInt,
        maturity:     UInt,
        refund:       UInt,
        dormant:      UInt })) }),
      Participant('Receiver', common),
      Participant('Bystander', common) ],
    (Funder, Receiver, Bystander) => {

// 1. The Funder publishes the parameters of the fund and makes the initial deposit.
// 2. The consensus remembers who the Receiver is.
// 3. Everyone waits for the fund to mature.
// 4. The Receiver may extract the funds with a deadline of `refund`.
// 5. The Funder may extract the funds with a deadline of `dormant`.
// 6. The Bystander may extract the funds with no deadline.
