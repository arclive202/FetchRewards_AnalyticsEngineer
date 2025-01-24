-- What are the top 5 brands by receipts scanned for most recent month?
/*
Approach: Looking at the Month field of the Most recent dateScanned from receipts 
and ranking order the brands partitioned by brandCode and ordered by Count of each brands in descending order.*/
---Getting details on the most recent month that was scanned and uploaded by a user
with recent_month_data as (
select strftime('%Y-%m', max(dateScanned)) as recent_month from receipts
),
-- Generating a list of receipt IDs for the most recent month
recent_receipts as (
select receiptId from receipts r
where STRFTIME('%Y-%m',dateScanned)=(select recent_month from recent_month_data) 
),
--Rank ordering the brands by receipts scanned for the month
recent_month_brand_counts as
(
select 
	recent_month as 'month'
	, brandCode
	, count(1) as  brandCounts
	, rank() over (order by count(*) desc) as brandRank from recent_month_data
left join receiptsItemList on 1=1
where receiptId in (select receiptId from recent_receipts)
group by brandCode
order by 2 desc
)
-- Displaying the top 5 brands with their details
select * from recent_month_brand_counts
where brandRank <= 5
