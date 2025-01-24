# Fetch Rewards - Analytics Engineering

## Tools Used  
- **Python**: Jupyterhub (Data Transformation & Cleaning)  
- **SQL**: SQLite Engine via DBeaver (Business Problem Queries)  

---

## **Overview**  
This project focuses on transforming unstructured JSON datasets into a structured relational data model for effective querying and analysis. 
The process includes data cleaning, transformation, and modeling to address specific business problems and provide insights.

---

## **Dataset Description**  
Three main datasets are provided:  
1. **Receipts**: Contains receipt details, such as the number of points earned, item lists, purchase dates, and other receipt-related information.  
2. **Brands**: Includes details about brands, such as barcodes, category codes, and other brand-related data.  
3. **Users**: Contains user information, such as account creation date, last login date, and sign-up source.  

The source files for all datasets are in JSON format.


## **High-Level Documentation**  

### **Phase 1: Review and Relational Data Model Design**  
- **Source Identification**:  
  The datasets (Receipts, Brands, and Users) were analyzed to determine the structure, cadence, file types, size, and metadata, which influence resource utilization and cost.  

- **Metadata Observations**:  
  - Dataset sizes:  
    - `Receipts`: 1119 records  
    - `Brands`: 1167 records  
    - `Users`: 495 records  
  - Null values were observed across multiple columns in all datasets, requiring null handling.  
  - `_id` is used as the primary key in all datasets and needs to be renamed appropriately.  
  - Nested JSON objects and inconsistent formats were observed across the datasets.  
  - The column `rewardsReceiptItemList` in the `Receipts` dataset contains unstructured data stored as a dictionary, requiring unpacking and schema standardization.  

---

### **Phase 2: Data Cleaning and Transformation**  
Transformations were performed systematically to clean and structure the data for analysis:  

1. **Data Ingestion**:  
   - JSON files were loaded into respective DataFrames: `users_df`, `brands_df`, and `receipts_df`.  

2. **Unpacking Nested Objects**:  
   - For `brands_df`, the `cpg` column was unpacked into two new columns: `cpg_id` and `ref`.  
   - Data from `rewardsReceiptItemList` in `receipts_df` was unpacked and stored in a new DataFrame named `receiptsItemList`.  

3. **Storing Raw and Transformed Data**:  
   - Transformed data was saved into new DataFrames (`users`, `brands`, and `receipts`) to simulate the process of storing raw files in transient objects, preventing the need to re-run ingestion in case of infrastructure challenges.  

4. **Null Value Treatment**:  
   - **String columns**: Replaced null values with `'Unknown'`.  
   - **Integer/Float columns**: Replaced null values with `0`.  
   - **Boolean columns**: Null values were retained, as `True` and `False` carry specific business significance and will be treated based on business requirements.  

5. **ReceiptsItemList Table Creation**:  
   - A new table, `receiptsItemList`, was created by unpacking the `rewardsReceiptItemList` column from the `Receipts` dataset.  
   - A unique identifier, `receiptItemListId`, was generated using `uuid5`, based on a combination of `receiptId` and `partnerItemId`.  

6. **Data Type Conversion**:  
   - Converted columns to appropriate data types to facilitate querying and comparison in SQL engines for reporting and analysis.  

---

## **Proposed Relational Data Model**  
- **Users Table**  
- **Brands Table**  
- **Receipts Table**  
- **ReceiptsItemList Table** (newly created to handle item-level details)

---

## **Key Considerations**  
1. **Data Quality**:  
   - Handling duplicates, null values, and unstructured data ensures consistency and reliability.  
2. **Scalability**:  
   - The pipeline and schema design allow for scalability to accommodate growing data volumes.  
3. **Business Use Cases**:  
   - Enables effective analysis of brand performance, user activity, and other metrics.  

---

## **How to Use**  
1. Clone the repository and load the provided JSON files into the `data/` directory.  
2. Open the Jupyter Notebook to view data cleaning and transformation steps.  
3. Use the SQLite Engine via DBeaver to run business problem queries on the transformed datasets.  

---

**Note**: The metadata section and further details can be found in the accompanying Jupyter Notebook along with the solution to the Business Problem Statement made available in the HLD Document.
