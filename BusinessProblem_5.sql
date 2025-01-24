--5. Which brand has the most spend among users who were created within the past 6 months?
-- Approach: Find the list of users first and then look into the total spent by brands
--List of userIDs created in the last 6 months
with users_list AS 
(
	select distinct userID from users
	where createdDate >= DATE((select max(createdDate) from users), '-6 months')
	order by createdDate desc
)
select brandCode, sum(finalPrice*quantityPurchased) as total_spend from receiptsItemList
where receiptId in (
select distinct receiptId from receipts where userId in (select userID from users_list))
--and finalPrice != itemPrice 
group by brandCode 
order by 2 desc
limit 2