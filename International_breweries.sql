
SELECT * FROM [International Breweries].dbo.International_Breweries;

SELECT distinct [brands] 
FROM International_Breweries;

SELECT distinct [COUNTRIES] 
FROM International_Breweries;

SELECT distinct [YEARS] 
FROM International_Breweries;

SELECT distinct [REGION]
FROM International_Breweries;


--SESSION A: PROFIT ANALYSIS

/*1. Within the space of the last three years, what was the profit worth of the breweries,
	inclusive of the anglophone and the francophone territories?*/
	SELECT SUM([profit]) AS Total_profit
	FROM International_Breweries;
		--ANSWER = 105,587,420


/*2. Compare the total profit between these two territories in order for the territory manager,
	Mr. Stone made a strategic decision that will aid profit maximization in 2020.*/
	SELECT SUM(CASE when [countries] IN ('Nigeria', 'Ghana') Then [profit] else 0 END) AS Anglophone,
			SUM(CASE when [countries] IN ('Senegal', 'Benin', 'Togo') Then [profit] else 0 END) AS Francophone	
	FROM International_Breweries;
		--ANSWER = Anglophone:42,389,260  Francophone:63,198,160


--3. Country that generated the highest profit in 2019
	SELECT TOP 1 SUM([profit]) AS Profit,
			 [Countries]
	FROM International_Breweries
	WHERE [YEARS] = 2019
	GROUP BY [COUNTRIES]
	ORDER BY Profit DESC; 
		--ANSWER = Ghana

--4. Help him find the year with the highest profit.
	SELECT TOP 1 SUM([profit]) AS Profit,[Years]
	FROM International_Breweries
	GROUP BY [YEARS]
	ORDER BY [Profit] DESC;
	 --ANSWER = 2017
	

--5. Which month in the three years was the least profit generated?
	SELECT  TOP 1 SUM([profit]) AS Profit, 
			[Months], [Years]
	FROM  International_Breweries
	GROUP BY [MONTHS],[YEARS]
	ORDER BY [Profit];
	--(By checking on a yearly basis, february made the least)
		--ANSWER = February

	SELECT  TOP 1 SUM([profit]) AS Profit, [Months]
	FROM  International_Breweries
	GROUP BY [MONTHS]
	ORDER BY [Profit];
	--(By checking for all months in the 3yrs combined, april made the least)

	SELECT [years], [months], [profit]
	FROM International_Breweries
	GROUP BY [years], [months], [profit]
	ORDER BY [profit];
	--(By checking on a yearly basis per country, December made the least)
	

--6. What was the minimum profit in the month of December 2018?
	SELECT TOP 1 [profit], [Months], [Years]
	FROM International_Breweries
	WHERE [YEARS] = 2018 AND [MONTHS] = 'December'
	GROUP BY [YEARS], [MONTHS], [PROFIT]
	ORDER BY [Profit] ASC;
	

--7. Compare the profit in percentage for each of the month in 2019
	WITH profit_percentage AS(
		SELECT  [months], 
				SUM(([Profit])) AS profit_per_month,
				SUM(SUM([Profit])) OVER()  AS total_profit
		FROM International_Breweries
		WHERE [YEARS] = 2019
		GROUP BY [MONTHS]
				)
	SELECT [MONTHS],
			CONCAT(ROUND([profit_per_month] * 100/[total_profit] ,1), '%') AS profit_percent
	FROM profit_percentage;

				-- OR --
	SELECT  [months], 
		CONCAT(ROUND(SUM([Profit])*100/SUM(SUM([Profit])) over(), 1),'%')  AS profit_percent
	FROM International_Breweries
	WHERE [YEARS] = 2019
	GROUP BY [MONTHS];


--8. Which particular brand generated the highest profit in Senegal?
	SELECT TOP 1 SUM([Profit]) AS profit, [Brands]
	FROM International_Breweries
	WHERE [COUNTRIES] ='Senegal'
	GROUP BY [BRANDS] 
	ORDER BY profit DESC


--SESSION B: BRAND ANALYSIS

/*1. Within the last two years, the brand manager wants to know the top three brands
	consumed in the francophone countries */
	SELECT  top 3 SUM([QUANTITY]) AS total_quantity,  
			 [Brands]
	FROM International_Breweries
	WHERE [COUNTRIES] IN ('Senegal', 'Benin', 'Togo') AND [YEARS] IN (2019, 2018)
	GROUP BY [BRANDS]
	ORDER BY total_quantity DESC;


--2. Find out the top two choice of consumer brands in Ghana
	SELECT  TOP 2 SUM([Quantity]) AS total_quantity, 
			[Brands]
	FROM International_Breweries
	WHERE [COUNTRIES] = 'Ghana'
	GROUP BY [BRANDS] 
	ORDER BY total_quantity DESC;


--3. Find out the details of beers consumed in the past three years in the most oil reached country in West Africa.
	SELECT [Brands],  
			SUM([Quantity]) AS Quantity_Consumed,
			SUM([Cost]) AS Total_Cost,
			SUM([Profit]) AS Total_profit
	FROM International_Breweries
	WHERE [Countries] = 'Nigeria' AND [BRANDS] NOT LIKE '%malt%'
	GROUP BY [BRANDS]
	ORDER BY [Quantity_Consumed] Desc;


--4. Favorites malt brand in Anglophone region between 2018 and 2019
	SELECT TOP 1 SUM([Quantity]) AS total_quantity, [Brands]
	FROM International_Breweries
	WHERE [BRANDS] IN ('beta malt', 'grand malt') AND [COUNTRIES] IN ('Nigeria', 'Ghana')
			AND [YEARS] IN (2018, 2019)
	GROUP BY [BRANDS]
	ORDER BY [total_quantity] Desc;


--5. Which brands sold the highest in 2019 in Nigeria?
	SELECT TOP 1 SUM([QUANTITY]) AS Quantity_Sold, 
			[BRANDS] 
	FROM International_Breweries
	WHERE [COUNTRIES] = 'Nigeria' AND [YEARS] = 2019
	GROUP BY [BRANDS] ORDER BY Quantity_Sold desc; 


--6. Favorites brand in South_South region in Nigeria
	SELECT TOP 1 SUM([QUANTITY]) AS Quantity_Sold , 
			[BRANDS]
	FROM International_Breweries
	WHERE [COUNTRIES] = 'Nigeria' AND [REGION] = 'southsouth'
	GROUP BY [BRANDS] 
	ORDER BY Quantity_Sold desc;

--7. Beer consumption in Nigeria
	SELECT [Brands],
			SUM([Quantity]) AS total_consumption
	FROM International_Breweries
	WHERE [BRANDS] NOT IN ('beta malt', 'grand malt') AND [COUNTRIES] = 'Nigeria'
	GROUP BY [BRANDS]
	ORDER BY [total_consumption] Desc;


--8. Level of consumption of Budweiser in the regions in Nigeria
	SELECT [BRANDS], [Region], 
			SUM([QUANTITY]) AS Quantity_Consumed 
	FROM International_Breweries
	WHERE [COUNTRIES] = 'Nigeria' AND [BRANDS] = 'budweiser'
	GROUP BY [BRANDS], [REGION] ORDER BY [Quantity_Consumed];


--9. Level of consumption of Budweiser in the regions in Nigeria in 2019 (Decision on Promo)
	SELECT [BRANDS], [Region], 
			SUM([QUANTITY]) AS Quantity_Consumed 
	FROM International_Breweries
	WHERE [COUNTRIES] = 'Nigeria'  AND [BRANDS] = 'budweiser' 
			AND [YEARS] = 2019
	GROUP BY [BRANDS], [REGION] ORDER BY [Quantity_Consumed]; 


--Session C :COUNTRIES ANALYSIS

--1. Country with the highest consumption of beer.
	SELECT TOP 1 SUM([Quantity]) AS total_consumption, 
			[Countries]
	FROM International_Breweries
	WHERE [BRANDS] NOT IN ('beta malt', 'grand malt') 
	GROUP BY [COUNTRIES]
	ORDER BY [total_consumption] Desc;


--2. Highest sales personnel of Budweiser in Senegal
	SELECT TOP 1 SUM([QUANTITY]) AS Quantity_Sold , 
			[SALES_REP] 
	FROM International_Breweries
	WHERE [COUNTRIES] = 'Senegal'  AND [BRANDS] = 'budweiser' 
	GROUP BY [SALES_REP]
	ORDER BY [Quantity_Sold] DESC; 


--3. Country with the highest profit of the fourth quarter in 2019
	SELECT TOP 1 SUM([Profit]) AS Total_profit, 
			[Countries]
	FROM International_Breweries
	WHERE [YEARS] = 2019 AND [MONTHS] IN ('October', 'November', 'December')
	GROUP BY [COUNTRIES]
	ORDER BY [Total_profit] DESC; 
