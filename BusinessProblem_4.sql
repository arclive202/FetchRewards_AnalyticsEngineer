--When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
select rewardsReceiptStatus, sum(purchasedItemCount) as totalItemsPurchased from receipts r 
where rewardsReceiptStatus in ('FINISHED','REJECTED')
group by rewardsReceiptStatus