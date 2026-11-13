USE DataWarehouse
GO

-- TABALE BRONZE.ARTIST
SELECT * FROM bronze.artist

-- Check for NULLs or Duplicates in Primary Key
SELECT 
artist_id,
COUNT (*)
FROM bronze.artist
GROUP BY artist_id
HAVING COUNT(*) > 1 OR artist_id IS NULL  -- no duplicates or NULLs! OK


-- Check where the Name is NULLs
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN full_name IS NULL THEN 1 ELSE 0 END) AS null_full_name,
    SUM(CASE WHEN first_name IS NULL THEN 1 ELSE 0 END) AS null_first_name,
    SUM(CASE WHEN middle_names IS NULL THEN 1 ELSE 0 END) AS null_middle_names,
    SUM(CASE WHEN last_name IS NULL THEN 1 ELSE 0 END) AS null_last_name,
    SUM(CASE WHEN nationality IS NULL THEN 1 ELSE 0 END) AS null_nationality,
    SUM(CASE WHEN style IS NULL THEN 1 ELSE 0 END) AS null_style,
    SUM(CASE WHEN birth IS NULL THEN 1 ELSE 0 END) AS null_birth,
    SUM(CASE WHEN death IS NULL THEN 1 ELSE 0 END) AS null_death
FROM bronze.artist; -- 273 NULLS in Middle Names, 0 for every other

-- Check theres no missing datas in Full, First and Last Name
SELECT *
FROM bronze.artist
WHERE
    NULLIF(TRIM(full_name), '') IS NULL
    OR NULLIF(TRIM(first_name), '') IS NULL
    OR NULLIF(TRIM(last_name), '') IS NULL; -- No missing data! OK

-- Check for unwanted Spaces
SELECT *
FROM bronze.artist
WHERE full_name != TRIM(full_name)
    OR first_name != TRIM(first_name)
    OR last_name != TRIM(last_name);  -- OK


-- Check validity of birth/death years
SELECT *
FROM bronze.artist
WHERE
    (birth IS NOT NULL AND (birth < 1 OR birth > YEAR(GETDATE())))
    OR
    (death IS NOT NULL AND (death < 1 OR death > YEAR(GETDATE())))
    OR
    (birth IS NOT NULL AND death IS NOT NULL AND death < birth); -- OK


-- TABLE BRONZE.CANVAS_SIZE
SELECT * FROM bronze.canvas_size

SELECT 
size_id,
COUNT (*)
FROM bronze.canvas_size
GROUP BY size_id
HAVING COUNT(*) > 1 OR size_id IS NULL  -- no duplicates or NULLs! OK

-- Check if there's always at least one dimension
SELECT *
FROM bronze.canvas_size
WHERE width IS NULL
  AND height IS NULL;

-- Check that for height = NULL there's the label Long Edge
SELECT *
FROM bronze.canvas_size
WHERE height IS NULL
  AND label NOT LIKE '%Long Edge%'; -- OK


-- TABLE BRONZE.IMAGE_LINK
SELECT * FROM bronze.image_link

SELECT 
work_id,
COUNT (*)
FROM bronze.image_link
GROUP BY work_id
HAVING COUNT(*) > 1 OR work_id IS NULL  -- yep 59 groups of duplicates

-- Check for pair (museum_id, day)
SELECT
    work_id,
    url,
    thumbnail_small_url,
    thumbnail_large_url,
    COUNT(*) AS total
FROM bronze.image_link
GROUP BY
    work_id,
    url,
    thumbnail_small_url,
    thumbnail_large_url
HAVING COUNT(*) > 1; -- all perfect duplicates

/* Duplicates:
work_id
122662
122691
181318
181331
181340
181349
181356
181363
181390
181396
181403
181412
181420
181427
181434
181441
181448
181457
181475
181483
181491
181499
181508
181517
181526
181533
181540
181547
181555
181562
181569
181576
181585
181594
181743
181752
181761
181777
181784
181791
181798
181805
181813
181820
181827
181834
181841
181848
181855
181864
181873
181882
181891
181900
181909
181918
181925
181932
181941
*/


-- TABLE BRONZE.MUSEUM
SELECT * FROM bronze.museum

SELECT 
museum_id,
COUNT (*)
FROM bronze.museum
GROUP BY museum_id
HAVING COUNT(*) > 1 OR museum_id IS NULL  -- no duplicates or NULLs! OK

-- Check theres no missing datas in name or address
SELECT *
FROM bronze.museum
WHERE
    NULLIF(TRIM(name), '') IS NULL
    OR NULLIF(TRIM(address), '') IS NULL -- No missing data! OK

-- Check for unwanted Spaces
SELECT *
FROM bronze.museum
WHERE 
    name != TRIM(name)
    OR address != TRIM(address) -- OK

-- Check for City to not contain strange values
SELECT *
FROM bronze.museum
WHERE city LIKE '%[0-9]%';

/* problems founds:
museum_id	Anomalia	                            Possibile soluzione Silver
34	        2 in city e Sankt-Peterburg in state	Spostare 2 in address e la città in city
36	        45128 in city e Essen in state	        Spostare i valori in postal e city
37	        38000 in city e Grenoble in state	    Spostare i valori in postal e city
38	        29000 in city e Quimper in state	    Spostare i valori in postal e city
40	        75001 in city e Paris in state	        Spostare i valori in postal e city
74	        6731 AW Otterlo interamente in city	    Separare postal e city
*/

SELECT
    museum_id,
    city,
    [state],
    postal,
    country
FROM bronze.museum
ORDER BY country, city;

/*
ID	Valori attuali	                    Interpretazione
34	city = 2, state = Sankt-Peterburg	2 appartiene all'indirizzo; la città è Sankt-Peterburg
36	city = 45128, state = Essen	        CAP = 45128; città = Essen
37	city = 38000, state = Grenoble	    CAP = 38000; città = Grenoble
38	city = 29000, state = Quimper	    CAP = 29000; città = Quimper
40	city = 75001, state = Paris	        CAP = 75001; città = Paris
74	city = 6731 AW Otterlo	            CAP = 6731 AW; città = Otterlo
86	city = Stran, state = London	    Probabile inversione: città = London, state = NULL

ID	Valori attuali	                                    DA verificare
41	city = London, state = SE10 9NF, postal = NULL	    Il CAP sembra essere finito in state
42	city = Boston, postal = 2115	                    Il CAP potrebbe essere 02115: sembra mancare lo zero iniziale
48	city = Den Haag, postal = 2511	                    Il codice postale olandese potrebbe essere incompleto: normalmente ha 4 cifre e 2 lettere
70	city = Firenze, state = FL, country = Italy	        FL non sembra coerente con la città e il Paese
84	city = Nové Měst	                                Possibile nome troncato; verificare il valore originale
86	city = Stran, state = London	                    Possibile dato troncato o disallineamento delle colonne
*/

-- Check phone number
SELECT *
FROM bronze.museum
WHERE NULLIF(TRIM(phone), '') IS NULL; -- no NULLs

-- Check urls
SELECT *
FROM bronze.museum
WHERE url IS NOT NULL
  AND TRIM(url) <> ''
  AND TRIM(url) NOT LIKE 'http://%' 
  AND TRIM(url) NOT LIKE 'https://%'; -- OK


-- TABLE BRONZE.MUSEUM_HOURS
SELECT * FROM bronze.museum_hours

-- Check for pair (museum_id, day)
SELECT
    museum_id,
    day,
    COUNT(*) AS total
FROM bronze.museum_hours
GROUP BY
    museum_id,
    day
HAVING COUNT(*) > 1;

SELECT *
FROM bronze.museum_hours
WHERE museum_id = 80
  AND day = 'Saturday';
-- perfect duplicate, pair (80, Saturday)

-- Check the days
SELECT
    day,
    COUNT(*) AS total
FROM bronze.museum_hours
GROUP BY day
ORDER BY day; -- Error: 'Thusday' 17 times instead of 'Thursday'

-- Check for unwanted Spaces
SELECT *
FROM bronze.museum_hours
WHERE day != TRIM(day)
   OR [open] != TRIM([open])
   OR [close] != TRIM([close]); -- OK

SELECT *
FROM bronze.museum_hours
WHERE [open] LIKE '% %'
   OR [close] LIKE '% %'; -- unwanted space: in close '08 :00:PM'


-- TABLE BRONZE.PRODUCT_SIZE
SELECT * FROM bronze.product_size

-- Check for pair (work_id, size_id) if there's duplicates
SELECT
    work_id,
    size_id,
    COUNT(*) AS total
FROM bronze.product_size
GROUP BY
    work_id,
    size_id
HAVING COUNT(*) > 1; -- yeah

SELECT
    COUNT(*) AS duplicate_groups,
    SUM(total) AS rows_in_duplicate_groups
FROM (
    SELECT
        work_id,
        size_id,
        sale_price,
        regular_price,
        COUNT(*) AS total
    FROM bronze.product_size
    GROUP BY
        work_id,
        size_id,
        sale_price,
        regular_price
    HAVING COUNT(*) > 1
) AS d; 
-- we find 686 distinct combinations of values ​​that appear at least twice,
-- for a total of 1,373 rows involved.

SELECT
    work_id,
    size_id,
    COUNT(*) AS total,
    COUNT(DISTINCT CONCAT(sale_price, '|', regular_price)) AS different_price_combinations
FROM bronze.product_size
GROUP BY work_id, size_id
HAVING COUNT(*) > 1
   AND COUNT(DISTINCT CONCAT(sale_price, '|', regular_price)) > 1;
-- every (work_id, size_id) combination has the same price, so
-- they are all perfect duplicates


-- TABLE BRONZE.SUBJECT
SELECT * FROM bronze.subject

SELECT 
work_id,
COUNT (*)
FROM bronze.subject
GROUP BY work_id
HAVING COUNT(*) > 1 OR work_id IS NULL  

SELECT
    work_id,
    subject,
    COUNT(*) AS total
FROM bronze.subject
GROUP BY
    work_id,
    subject
HAVING COUNT(*) > 1; -- yeah all perfect duplicates


-- TABLE BRONZE.WORK
SELECT * FROM bronze.work

-- Check for duplicates
SELECT 
work_id,
COUNT (*)
FROM bronze.work
GROUP BY work_id
HAVING COUNT(*) > 1 OR work_id IS NULL  

SELECT
    work_id,
    artist_id,
    name,
    COUNT(*) AS total
FROM bronze.work
GROUP BY
    work_id,
    artist_id,
    name
HAVING COUNT(*) > 1; -- yeah

SELECT
    work_id,
    artist_id,
    name,
    style,
    museum_id,
    COUNT(*) AS total
FROM bronze.work
GROUP BY
    work_id,
    artist_id,
    name,
    style,
    museum_id
HAVING COUNT(*) > 1
ORDER BY total DESC;

/* Perfect duplicates concentrated on two artist:
- 770: 56 groups duplicates with 2 occurrences and one (work_id = 181925) with 3 occurrences
! all of them have both style and museum_id NULLs

- 862: 2 groups duplicates with 2 occurrences
! style = Realism but museum_id is NULL

There are no duplicates for painting with museum_id != from NULL
*/