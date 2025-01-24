--How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
/*
Approach: Identifying the Top 5 Brands for the previous month and Current Month remains the same (by count desc)
However, displaying the data is where there is a difference.
I selected the top 5 Brands from the Previous Month and Current Months and displayed their performance Side by Side in the following format */
--Recent Month Rankings
with recent_month_data as (
select strftime('%Y-%m', max(dateScanned)) as recent_month from receipts
),
recent_receipts as (
select receiptId from receipts r
where STRFTIME('%Y-%m',dateScanned)=(select recent_month from recent_month_data) 
),
recent_month_brand_counts as
(
select 
	recent_month
	, brandCode
	, count(1) as  brandCounts
	, rank() over (order by count(*) desc) as brandRank from recent_month_data
left join receiptsItemList on 1=1
where receiptId in (select receiptId from recent_receipts)
group by brandCode
order by brandRank
),
--Previous Month Rankings
previous_month_data as (
select strftime('%Y-%m', max(dateScanned), '-1 month') as previous_month from receipts --Condition for selecting the previous month
),
previous_receipts as (
select receiptId from receipts r
where STRFTIME('%Y-%m',dateScanned)=(select previous_month from previous_month_data) 
),
previous_month_brand_counts as
(
select 
	previous_month
	, brandCode
	, count(1) as  brandCounts
	, rank() over (order by count(*) desc) as brandRank from previous_month_data
left join receiptsItemList on 1=1
where receiptId in (select receiptId from previous_receipts)
group by brandCode
order by brandRank
)
--Union of Rankings by Month, BrandCode, BrandCounts, BrandRank
select 
	COALESCE (recent_month_brand_counts.brandCode, previous_month_brand_counts.brandCode) as BrandCode
	, recent_month_brand_counts.brandCounts as Recent_Month_Counts
	, recent_month_brand_counts.brandRank as Recent_Month_Rank
	, previous_month_brand_counts.brandCounts as Previous_Month_Counts
	, previous_month_brand_counts.brandRank as Previous_Month_Rank
from recent_month_brand_counts
full outer join previous_month_brand_counts on recent_month_brand_counts.brandCode = previous_month_brand_counts.brandCode
where recent_month_brand_counts.brandRank<=5 or previous_month_brand_counts.brandRank <=5
