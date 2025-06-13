SELECT 
fr.country  COUNTRY,
--to_char(fr.dim_datetime , 'YYYYMM')::int YEAR_MONTH,
COUNT(DISTINCT fr.user_id) USER_COUNT
FROM first_read fr 
GROUP BY --YEAR_MONTH, 
		 country
ORDER BY user_count DESC;

--- new read user count by count : 
-------------2018 Q1 total : 210022 

---------------------

SELECT 
COUNT(DISTINCT rr.user_id) USER_COUNT
FROM returning_read rr;

--- returning_read: 66231

--------------------------
SELECT 
COUNT(DISTINCT s.user_id) USER_COUNT
FROM sub s; 

--- sub : 7617

------------------------
-- power bi - revenue trend
SELECT
  fr.country,
  fr.source,
  fr.topic,
  to_char(trx.dim_datetime , 'YYYYMM')::int YEAR_MONTH,
  CASE WHEN trx.price = 8 THEN 'E-BOOK' ELSE 'Video-Course' END as Product,
  trx.price,
  COUNT(trx.user_id) AS trx_nr,
  trx.price * COUNT(trx.user_id) as Revenue
FROM jdstest.transactions trx
JOIN jdstest.first_read fr ON trx.user_id = fr.user_id
GROUP BY   trx.price
		 , YEAR_MONTH
		 , fr.country
		 , fr.source
  		 , fr.topic
ORDER BY year_month asc;

-------------
--- power bi - read count / country + trx count
SELECT 
fr.user_id,
fr.country ,
fr.source,
COUNT(t.event_type) trx_count,
SUM(t.price) total_spending,
read_tbl.read_count
FROM jdstest.first_read fr 
LEFT JOIN jdstest.transactions t ON fr.user_id = t.user_id
LEFT JOIN (
			SELECT 
					fr.user_id,
					COUNT(rr.event_type) read_count
			FROM jdstest.first_read fr 
			LEFT JOIN jdstest.returning_read rr  ON fr.user_id = rr.user_id
			GROUP BY fr.user_id 
		  ) as read_tbl ON fr.user_id = read_tbl.user_id
GROUP BY fr.user_id ,
		 read_tbl.read_count,
		 fr.country ,
		 fr.source
ORDER BY trx_count DESC;

--- conversion rate per country : 

WITH readers AS (              
    SELECT  country, user_id
    FROM    first_read         
),
buyers AS (                    
    SELECT  r.country,
            t.user_id
    FROM        transactions t
    JOIN        readers      r  ON r.user_id = t.user_id
    GROUP BY    r.country, t.user_id
)
SELECT  r.country,
        COUNT(DISTINCT r.user_id)                     AS readers,
        COUNT(DISTINCT b.user_id)                     AS buyers
FROM        readers r
LEFT JOIN   buyers  b USING (country, user_id)
GROUP BY    r.country;

--- funnel chart:
WITH readers   AS (SELECT DISTINCT user_id FROM first_read),
returners AS (SELECT DISTINCT user_id FROM returning_read),
subs      AS (SELECT DISTINCT user_id FROM sub),
buyers    AS (SELECT DISTINCT user_id FROM transactions)
SELECT 'Readers',   COUNT(*) FROM readers UNION ALL
SELECT 'Returners', COUNT(*) FROM returners UNION ALL
SELECT 'Subscribers', COUNT(*) FROM subs UNION ALL
SELECT 'Buyers', COUNT(*) FROM buyers;

