/*

LeetCode 2084 is "Drop Type 1 Orders for Customers With Type 0 Orders". 
This is a Medium-level SQL question that frequently shows up in data engineering interviews. 
It perfectly tests conditional logic and data filtering!  

The Problem GoalYou are given an Orders table with columns: 
	order_id, customer_id, and order_type (which can be either 0 or 1).
The criteria to filter the rows is straightforward:
	If a customer has at least one order of type 0, you must drop all of their type 1 orders.
If a customer only has type 1 orders, you keep them.

*/

-- 1. Create the Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_type INT
);

-- 2. Insert test data
INSERT INTO Orders (order_id, customer_id, order_type) VALUES
(8,5,1),
(9,5,1),
(1, 1, 1),  -- Customer 1 has both types: this row should be dropped
(2, 1, 0),  -- Customer 1 has both types: this row should be kept
(3, 2, 1),  -- Customer 2 only has type 1: this row should be kept
(4, 3, 0),  -- Customer 3 only has type 0: this row should be kept
(5, 3, 0),  -- Customer 3 only has type 0: this row should be kept
(6, 4, 1),  -- Customer 4 has both types: this row should be dropped
(7, 4, 0);  -- Customer 4 has both types: this row should be kept

WITH CTE AS(
SELECT order_id, customer_id, order_type ,
MIN(order_type) OVER(PARTITION BY customer_id ORDER BY customer_id) as min_order
FROM Orders)

SELECT order_id, customer_id, order_type, min_order
FROM CTE 
WHERE min_order = order_type

/*

from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Initialize Spark Session
spark = SparkSession.builder.appName("DropType1Orders").getOrCreate()

# Create dummy data matching our SQL setup
data = [
    (1, 1, 1),
    (2, 1, 0),
    (3, 2, 1),
    (4, 3, 0),
    (5, 3, 0),
    (6, 4, 1),
    (7, 4, 0)
]
columns = ["order_id", "customer_id", "order_type"]
orders_df = spark.createDataFrame(data, schema=columns)

# -------------------------------------------------------------
# PySpark Window Function Logic
# -------------------------------------------------------------

# Step 1: Define the window spec (Equivalent to: OVER(PARTITION BY customer_id))
window_spec = Window.partitionBy("customer_id")

# Step 2: Apply the window function and filter (Equivalent to the WITH clause & final SELECT)
result_df = (
    orders_df
    # Add the min_type column using the window spec
    .withColumn("min_type", F.min("order_type").over(window_spec))
    # Filter rows where order_type matches the min_type
    .filter(F.col("order_type") == F.col("min_type"))
    # Select only the original required columns
    .select("order_id", "customer_id", "order_type")
)

# Show the final result
result_df.show()

*/
