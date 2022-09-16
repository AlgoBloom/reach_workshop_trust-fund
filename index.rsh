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