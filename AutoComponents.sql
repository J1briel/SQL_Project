--Inspecting Data
select * from dbo.sales_data_sample

--Checking unique values
select distinct status from dbo.sales_data_sample
select distinct year_id from dbo.sales_data_sample
select distinct PRODUCTLINE from dbo.sales_data_sample
select distinct COUNTRY from dbo.sales_data_sample
select distinct DEALSIZE from dbo.sales_data_sample
select distinct TERRITORY from dbo.sales_data_sample

--What is the decrease of sales in 2005?
select distinct MONTH_ID from dbo.sales_data_sample
where YEAR_ID = 2005


--Analysis 
select PRODUCTLINE, sum(sales) Revenue
from dbo.sales_data_sample
group by ProductLine 
order by 2 desc


select YEAR_ID, sum(sales) Revenue
from dbo.sales_data_sample
group by YEAR_ID 
order by 2 desc


select DEAlSIZE, sum(sales) revenue
from dbo.sales_data_sample
group by DEALSIZE
order by 2 desc 


--What was the best month for sales ina specific year? How much was earned that month?
select MONTH_ID, sum(sales) revenue, count(ORDERNUMBER) Frequency
from dbo.sales_data_sample
where YEAR_ID = 2003  --chnage year to see the rest
group by MONTH_ID
order by 2 desc 


--November seems to be the month, what product do they sell in November
select MONTH_ID, PRODUCTLINE, sum(sales) revenue, count(ORDERNUMBER) Frequency
from dbo.sales_data_sample
where YEAR_ID = 2004  --chnage year to see the rest
group by MONTH_ID, PRODUCTLINE
order by 3 desc 

--Who is our best customer (Answered with RFM)Past purchase behavior to segment customers
;with rfm as 
(
	select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue, 
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
			(select max(ORDERDATE) from dbo.sales_data_sample) max_order_date,
			DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from dbo.sales_data_sample)) Recency 
	from dbo.sales_data_sample
	group by CUSTOMERNAME
)
select r.*,
	NTILE(4) OVER (order by Recency) rfm_recency,
	NTILE(4) OVER (order by Frequency) rfm_frequency,
	NTILE(4) OVER (order by AvgMonetaryValue) rfm_montary
from rfm r


select 
	c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
	cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary  as varchar)rfm_cell_string
into #rfm
from rfm_calc c

select CUSTOMERNAME , rfm_recency, rfm_frequency, rfm_monetary,
	case 
		when rfm_cell_string in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) then 'lost_customers'  --lost customers
		when rfm_cell_string in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping away, cannot lose' -- (Big spenders who haven’t purchased lately) slipping away
		when rfm_cell_string in (311, 411, 331) then 'new customers'
		when rfm_cell_string in (222, 223, 233, 322) then 'potential churners'
		when rfm_cell_string in (323, 333,321, 422, 332, 432) then 'active' --(Customers who buy often & recently, but at low price points)
		when rfm_cell_string in (433, 434, 443, 444) then 'loyal'
	end rfm_segment

from #rfm


--What products are most often sold together? 
--select * from [dbo].[sales_data_sample] where ORDERNUMBER =  10411

select distinct OrderNumber, stuff(

	(select ',' + PRODUCTCODE
	from [dbo].[sales_data_sample] p
	where ORDERNUMBER in 
		(

			select ORDERNUMBER
			from (
				select ORDERNUMBER, count(*) rn
				FROM [PortfolioDB].[dbo].[sales_data_sample]
				where STATUS = 'Shipped'
				group by ORDERNUMBER
			)m
			where rn = 3
		)
		and p.ORDERNUMBER = s.ORDERNUMBER
		for xml path (''))

		, 1, 1, '') ProductCodes

from [dbo].[sales_data_sample] s
order by 2 desc


---EXTRAs----
--What city has the highest number of sales in a specific country
select city, sum (sales) Revenue
from [PortfolioDB].[dbo].[sales_data_sample]
where country = 'UK'
group by city
order by 2 desc



---What is the best product in United States?
select country, YEAR_ID, PRODUCTLINE, sum(sales) Revenue
from [PortfolioDB].[dbo].[sales_data_sample]
where country = 'USA'
group by  country, YEAR_ID, PRODUCTLINE
order by 4 desc