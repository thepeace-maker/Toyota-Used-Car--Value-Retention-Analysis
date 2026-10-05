SELECT model, COUNT(*) AS listings, AVG(price) AS avg_price,
       MIN(year) AS first_year, MAX(year) AS last_year
FROM dbo.cars
WHERE brand = 'Toyota'
GROUP BY model
ORDER BY listings DESC;


-- T01: Model mix (what dominates Toyota listings)
SELECT model,
       COUNT(*) AS listings,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_toyota,
       AVG(price) AS avg_price,
       AVG(NULLIF(mpg,0)) AS avg_mpg,
       MIN(year) AS first_year, MAX(year) AS last_year
FROM dbo.cars
WHERE brand = 'Toyota'
GROUP BY model
ORDER BY listings DESC;

-- T02: Value retention by model (same method as Benz vs BMW)
WITH latest AS (
    SELECT MAX(year) AS max_year FROM dbo.cars WHERE brand = 'Toyota'
),
m AS (
    SELECT c.model,
           SUM(CASE WHEN c.year >= l.max_year - 1 THEN 1 ELSE 0 END) AS n_new,
           SUM(CASE WHEN c.year BETWEEN l.max_year - 6 AND l.max_year - 4
                    THEN 1 ELSE 0 END) AS n_5yr,
           AVG(CASE WHEN c.year >= l.max_year - 1
                    THEN CAST(c.price AS FLOAT) END) AS avg_new,
           AVG(CASE WHEN c.year BETWEEN l.max_year - 6 AND l.max_year - 4
                    THEN CAST(c.price AS FLOAT) END) AS avg_5yr
    FROM dbo.cars c
    CROSS JOIN latest l
    WHERE c.brand = 'Toyota'
    GROUP BY c.model
)
SELECT model, n_new, n_5yr,
       ROUND(avg_new, 0) AS avg_new,
       ROUND(avg_5yr, 0) AS avg_5yr,
       ROUND(100.0 * avg_5yr / avg_new, 1) AS retained_pct
FROM m
WHERE n_new >= 30 AND n_5yr >= 30
ORDER BY retained_pct DESC;

-- T03: Hybrid vs petrol, same model, recent cars only
SELECT model, fuel_type,
       COUNT(*) AS listings,
       AVG(price) AS avg_price,
       AVG(NULLIF(mpg,0)) AS avg_mpg,
       AVG(tax) AS avg_tax,
       AVG(mileage) AS avg_mileage
FROM dbo.cars
WHERE brand = 'Toyota'
  AND year >= 2017
  AND fuel_type IN ('Petrol','Hybrid')
  AND model IN ('Yaris','Auris','C-HR','RAV4','Corolla')
GROUP BY model, fuel_type
HAVING COUNT(*) >= 20
ORDER BY model, fuel_type;

-- T04: Segment view (what the range looks like by car type)
WITH s AS (
    SELECT *,
           CASE
               WHEN model IN ('Aygo','Yaris','IQ') THEN 'City car'
               WHEN model IN ('Auris','Corolla','Prius','Avensis','Camry') THEN 'Family car'
               WHEN model IN ('C-HR','RAV4','Land Cruiser','Urban Cruiser') THEN 'SUV'
               WHEN model IN ('Verso','Verso-S') OR model LIKE 'PROACE%' THEN 'MPV / van'
               WHEN model IN ('GT86','Supra') THEN 'Sports'
               WHEN model = 'Hilux' THEN 'Pickup'
               ELSE 'Other'
           END AS segment
    FROM dbo.cars
    WHERE brand = 'Toyota'
)
SELECT segment,
       COUNT(*) AS listings,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_toyota,
       AVG(price) AS avg_price,
       AVG(NULLIF(mpg,0)) AS avg_mpg,
       AVG(tax) AS avg_tax,
       AVG(mileage) AS avg_mileage
FROM s
GROUP BY segment
ORDER BY listings DESC;
