---create table---
create table Supply_Chain(
Product_type varchar(15),
SKU varchar(10),
Price decimal(10,6),
Availability int,
Numbers_of_product_sold int,
Revenue_generated decimal(15,3),
Customer_demographics varchar(15),
Stock_level int,
Lead_time int,
Order_quantities int,
Shipping_times int,
Shipping_carries varchar(10),
Shipping_cost decimal(10,2),
Supplier_name varchar(15),
Location varchar(15),
Supplier_Lead_time int,
Production_volumes int,
Manufacturing_lead_time int,
maufacturing_costs decimal(10,5),
Inspection_results varchar(10),
Defect_rates decimal(10,5),
Transportation_modes varchar(10),
Routes varchar(10),
Costs decimal(10,1));

select * from Supply_Chain;

---import data---
copy Supply_Chain from  'C:\Program Files\PostgreSQL\16\data\data ressource\supply_chain_data.csv' csv header;

---1. Total revenue by product type---
select product_type, sum(revenue_generated) as Total_revenue
from Supply_Chain
group by product_type
order by Total_revenue desc;

---2. Average price and revenue by product type---
select product_type, round(avg(price)) as avg_price,
round(avg(revenue_generated)) as avg_revenue
from Supply_Chain
group by product_type;

---3. Revenue by customer demographics---
select coalesce(customer_demographics,'unknown') as customer_group,
sum(revenue_generated) as Total_revenue
from Supply_Chain
group by customer_group
order by Total_revenue desc;

---4. large orders with long lead times---
select product_type,SKU,order_quantities, lead_time
from Supply_Chain
where order_quantities >60 and lead_time >15;

---5. Most cost-efficient shipping carrier---
select shipping_carries,round(avg(shipping_cost),2) as avg_shipping_cost
from Supply_Chain
group by shipping_carries
order by avg_shipping_cost;

---6.Average shipping time by supplier---
select supplier_name,
round(avg(shipping_times),2) as avg_shipping_times
from Supply_Chain
group by supplier_name
order by avg_shipping_times;

---7.City with fastest average shipping---
select location,
round(avg(shipping_times),2) as avg_shipping_times
from Supply_Chain
group by location
order by avg_shipping_times;

select * from Supply_Chain;

---8.Highest production volume supplier---
select supplier_name,
sum(production_volumes) as total_production
from Supply_Chain
group by supplier_name
order by total_production desc
limit 1;

---9.Average defect rate by transport mode---
select transportation_modes,round(avg(defect_rates),2) as avg_defect_rates
from Supply_Chain
group by transportation_modes
order by avg_defect_rates desc;

select * from Supply_Chain;

---10.Transport modes used in successful inspections---
select transportation_modes,count(*) as successful_shipments
from Supply_Chain
where inspection_results ='Pass'
group by transportation_modes
order by successful_shipments desc;

---11.Average tansport cost by route---
select routes, round(avg(costs),2) as avg_costs
from Supply_Chain
group by Routes
order by avg_costs desc;

---12.Failied inspections with defect rates >3% ---
select product_type, SKU, inspection_Results, defect_rates
from Supply_Chain
where inspection_results = 'Fail' and defect_rates > 0.03;






