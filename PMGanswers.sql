-- SQL Assessment Submission

-- 1. Write a query to get the sum of impressions by day.
SELECT date, SUM(impressions) AS total_impressions
FROM marketing_data
GROUP BY date;
-- This query calculates the total impressions for each day by summing up the impressions from the marketing_data table.

-- 2. Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?
WITH TopStates AS (
    SELECT TOP 3
        state,
        SUM(revenue) AS total_revenue
    FROM website_revenue
    GROUP BY state
    ORDER BY total_revenue DESC
)
SELECT
    state,
    total_revenue
FROM TopStates
ORDER BY total_revenue DESC;

SELECT state, SUM(revenue) AS total_revenue
FROM website_revenue
GROUP BY state
ORDER BY total_revenue DESC
OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY;
-- This query identifies the top three revenue-generating states and their total revenue from the website_revenue table.

-- 3. Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.
SELECT c.name AS campaign_name, 
       SUM(m.cost) AS total_cost,
       SUM(m.impressions) AS total_impressions,
       SUM(m.clicks) AS total_clicks,
       SUM(wr.revenue) AS total_revenue
FROM campaign_info c
JOIN marketing_data m ON c.id = m.campaign_id
JOIN website_revenue wr ON c.id = wr.campaign_id
GROUP BY c.name;
-- This query shows the total cost, impressions, clicks, and revenue for each campaign, along with the campaign name.

-- 4. Write a query to get the number of conversions of Campaign5 by state. Which state generated the most conversions for this campaign?
SELECT TOP 1
    wr.state,
    SUM(mp.conversions) AS total_conversions
FROM marketing_data mp
JOIN website_revenue wr ON mp.campaign_id = wr.campaign_id
WHERE mp.campaign_id = '99058240' -- Campaign5
GROUP BY wr.state
ORDER BY total_conversions DESC;
-- This query calculates the number of conversions for Campaign5 in each state and identifies the state with the most conversions.

-- 5. In your opinion, which campaign was the most efficient, and why?
WITH CampaignEfficiency AS (
    SELECT
        ci.name AS campaign_name,
        (SUM(wr.revenue) - SUM(md.cost)) / SUM(md.cost) AS roi
    FROM campaign_info ci
    JOIN marketing_data md ON ci.Id = md.campaign_id
    JOIN website_revenue wr ON ci.Id = wr.campaign_id
    GROUP BY ci.Id, ci.name
)
SELECT TOP 1 campaign_name, roi
FROM CampaignEfficiency
ORDER BY roi DESC;
-- This query determines the most efficient campaign based on the return on investment (ROI), considering the revenue and cost.

-- 6. Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.
WITH AvgPerformanceByDay AS (
      SELECT
        DATEPART(WEEKDAY, md.date) AS day_of_week,
        AVG(md.impressions) AS avg_impressions,
        AVG(md.clicks) AS avg_clicks,
        AVG(md.conversions) AS avg_conversions,
        ROW_NUMBER() OVER (ORDER BY AVG(md.impressions) DESC, AVG(md.clicks) DESC, AVG(md.conversions) DESC) AS row_num
    FROM marketing_data md
    GROUP BY DATEPART(WEEKDAY, md.date)
)
SELECT TOP 1
    CASE
        WHEN day_of_week = 1 THEN 'Sunday'
        WHEN day_of_week = 2 THEN 'Monday'
        WHEN day_of_week = 3 THEN 'Tuesday'
        WHEN day_of_week = 4 THEN 'Wednesday'
        WHEN day_of_week = 5 THEN 'Thursday'
        WHEN day_of_week = 6 THEN 'Friday'
        WHEN day_of_week = 7 THEN 'Saturday'
    END AS best_day_to_run_ads,
    avg_impressions,
    avg_clicks,
    avg_conversions
FROM AvgPerformanceByDay
ORDER BY row_num;
-- This query determines the best day of the week to run ads based on average performance metrics, including impressions, clicks, and conversions.

-- In conclusion, this submission aims to showcase analytical skills, query-writing proficiency, and the ability to derive meaningful insights from data sets.
