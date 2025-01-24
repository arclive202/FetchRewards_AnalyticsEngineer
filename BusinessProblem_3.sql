-- When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
select rewardsReceiptStatus , round(AVG(totalSpent),2) Average_Spend from receipts r
where rewardsReceiptStatus in ('FINISHED','REJECTED')
group by rewardsReceiptStatus