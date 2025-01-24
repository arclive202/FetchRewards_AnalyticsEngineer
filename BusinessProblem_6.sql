--6. Which brand has the most transactions among users who were created within the past 6 months?
-- Approach: Similar to the previous question, find the list of users created in the last 6 months 
-- and then looking at the receipts scanned by them we take a sum of the total quantityPurchased group by brandCode 
-- to take a look at the most transacted product.
with users_list AS 
(
	select distinct userID from users
	where createdDate >= DATE((select max(createdDate) from users), '-6 months')
	order by createdDate desc
)
select brandCode, sum(quantityPurchased) as total_transactions from receiptsItemList
where receiptId in (
select distinct receiptId from receipts where userId in (select userID from users_list))
group by brandCode 
order by 2 desc
limit 2