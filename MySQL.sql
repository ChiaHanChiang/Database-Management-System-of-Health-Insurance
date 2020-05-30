/*Display the policy holder id, name and amount of installment paid every cycle of an individual who pays the highest installment amount yearly from the insurance database*/Answer:

select c.Holder_id, p.name,c.Amount_of_installmentcycle
from policyholder p, policyholdercycle c
where p.holderid=c.holder_id and c.Amount_of_installmentcycle in 
(
select max(amount_of_installmentcycle)
from policyholdercycle
)
and c.Type_of_cycle='yearly';


/*Display maximum claim amount given to an individual and the average claim amount given by the insurance company per individual*/

select max(amount_claimed) as MaximumClaimGiven,
 avg(amount_claimed) as AverageAmountSpent
from claims
where Claim_status='Given';


/*Display the Policy holder id, name, age, insurance id and health history of the individuals born after 1900*/

select p.holder_id, h.name, p.health_history_disease,
           h.Insurance_id, FLOOR(DATEDIFF('2020-04-16',h.dob) / 365.25) as Age
from policy_holder_health_history p inner join policyholder h on p.Holder_id=h.Holderid
where h.DOB>'1990';

/*Create a view and display details of policy holders(id,name,previous health history,age) who paid maximum money to the company for every type of cycle and their difference from average amount. Also, print the minimum of each cycle*/

create view v as(
select p.holder_id, h.name, p.health_history_disease, h.Insurance_id,
           FLOOR(DATEDIFF('2020-04-16',h.dob) / 365.25) as Age,
           c.Amount_of_installmentcycle, c.Type_of_cycle
from policy_holder_health_history p inner join policyholder h on p.Holder_id=h.Holderid
         inner join policyholdercycle c on c.Holder_id=h.Holderid
);
select holder_id,name,age,health_history_disease as previousDisease,
           max(amount_of_installmentcycle) as Amount_Paid_by_holder, type_of_cycle,
           min(amount_of_installmentcycle) as Cycle_Minimum_Amount,
           avg(amount_of_installmentcycle) as Cycle_Average_Amount,
           max(amount_of_installmentcycle)-avg(amount_of_installmentcycle) as Diff_from_average
from v
group by type_of_cycle;
