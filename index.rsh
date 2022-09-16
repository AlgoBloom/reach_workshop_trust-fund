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
Funder.publish(receiverAddr, payment, maturity, refund, dormant )
  .pay(payment);

// 2. The consensus remembers who the Receiver is.
Receiver.set(receiverAddr);
commit();

// 3. Everyone waits for the fund to mature.
wait(maturity);

// 4. The Receiver may extract the funds with a deadline of `refund`.
Receiver.publish()
  .timeout(refund,
    () => {
     // 5. The Funder may extract the funds with a deadline of `dormant`.
      Funder.publish()
        .timeout(dormant,
          () => {
            // 6. The Bystander may extract the funds with no deadline.
            Bystander.publish();
            transfer(payment).to(Bystander);
            commit();
            exit(); });
       transfer(payment).to(Funder);
       commit();
       exit(); });
transfer(payment).to(Receiver);
commit();
exit();