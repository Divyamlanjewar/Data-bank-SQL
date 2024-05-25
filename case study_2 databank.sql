---------------------------que and answer----------------------------
que:1 HOW MANY DIFFERENT NODES MAKE UP THE DATA BANK NETWORK?
SELECT COUNT(DISTINCT node_id)
as unique_nodes
from customer_nodes;
----------------------------------------------------
que2:
how many nodes are there in different region?
select region_id,count(node_id) as node_count
from customer_nodes
inner join regions
using(region_id)
group by region_id;
----------------------------------------------------
que3:
how many customer are divided among the region?
select region_id,count(distinct customer_id) as customers
from customer_nodes
inner join regions
using(region_id)
group by region_id;
----------------------------------------------
que5:
determine total amount of transctions for each region?
select region_name,sum(txn_amount) as 'total transction amount'
from regions,customer_nodes,customer_transactions
where regions.region_id=customer_nodes.region_id and
customer_nodes.customer_id=customer_transactions.customer_id 
group by region_name;
------------------------------------------------------
que5:
how long does it takes on an average to move clients to a new node?
SELECT ROUND(AVG(TIMESTAMPDIFF(DAY, start_date, end_date))) AS avg_days
FROM customer_nodes
WHERE end_date != '9999-12-31';
------------------------------------------------------------
que6: what is the unique count and total amount for each transaction type?
select txn_type,count(*) as unique_count,
sum(txn_amount) as total_amount
from customer_transactions
group by txn_type;
--------------------------------------------------------
que:7 what is the average number and size of past deposite accross all customer
select round(count(customer_id)/(select count(distinct customer_id)
from customer_transactions)) as average_deposit_amount from customer_transactions
where txn_type='deposit'
--------------------------------------------------
que8:for each month_ how many data bank customers make more than 1 deposite and at least either 1 purchase 
or 1 withdrawal in  single month?

WITH transaction_count_per_month_cte AS (
    SELECT
        customer_id,
        MONTH(txn_date) AS txn_month,
        SUM(IF(txn_type = 'deposit', 1, 0)) AS deposit_count,
        SUM(IF(txn_type = 'withdrawal', 1, 0)) AS withdrawal_count,
        SUM(IF(txn_type = 'purchase', 1, 0)) AS purchase_count
    FROM customer_transactions
    GROUP BY customer_id, MONTH(txn_date)
)
SELECT txn_month, COUNT(DISTINCT customer_id) AS customer_count
FROM transaction_count_per_month_cte
WHERE deposit_count > 1 AND (purchase_count = 1 OR withdrawal_count = 1)
GROUP BY txn_month;
----------------------------------------------------



