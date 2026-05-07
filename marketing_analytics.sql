-- Businesses spend heavily on digital advertisements across multiple platforms, audience segments, and ad formats, but often lack clarity on which campaigns actually drive clicks, conversions, and revenue.
-- This project analyzes the complete ad funnel—from impressions to clicks to conversions—to identify:
-- which platforms drive the most engagement
-- which platforms generate the most revenue
-- which customer segments are most profitable
-- which ad creatives perform best
-- The goal is to help marketing teams optimize budget allocation and improve ROI.

-- Section 1: Data generation
-- ads
-- ad_groups
-- impressions
-- clicks
-- conversions

CREATE TABLE ads_performance.campaigns(
campaign_id SERIAL PRIMARY KEY,
campaign_name TEXT NOT NULL,
budget DECIMAL(10,2) NOT NULL,
start_date DATE NOT NULL,
end_date DATE NOT NULL
);


CREATE TABLE ads_performance.ads_group(
ad_group_id SERIAL PRIMARY KEY,
campaign_id INT REFERENCES ads_performance.campaigns(campaign_id),
ad_group_name TEXT NOT NULL
);

CREATE TABLE ads_performance.ads(
ad_id SERIAL PRIMARY KEY,
ad_group_id INT REFERENCES ads_performance.ads_group(ad_group_id),
ad_name TEXT NOT NULL,
ad_type TEXT,
ad_platform TEXT,
ad_headline TEXT
);



CREATE TABLE ads_performance.impressions(
impression_id SERIAL PRIMARY KEY,
ads_id INT REFERENCES ads_performance.ads(ad_id),
userid INT,
impression_time TIMESTAMP NOT NULL,
platform TEXT,
location TEXT
);

CREATE TABLE ads_performance.clicks(
click_id SERIAL PRIMARY KEY,
impression_id INT REFERENCES ads_performance.impressions(impression_id),
click_time TIMESTAMP NOT NULL
);


CREATE TABLE ads_performance.conversions(
conversion_id SERIAL PRIMARY KEY,
click_id INT REFERENCES ads_performance.clicks(click_id),
conversion_time TIMESTAMP NOT NULL,
revenue DECIMAL (10,2)
);

INSERT INTO ads_performance.campaigns
(campaign_name,budget,start_date,end_date)
VALUES
('Diwali Sale',100000,'2024-10-01','2024-10-31'),
('Eid Sale',100000,'2024-09-01','2024-09-30'),
('New Year Campaign',150000,'2025-01-01','2025-01-15'),
('Christmas Sale',100000,'2025-12-01','2025-12-31'),
('Summer Sale',50000,'2025-04-01','2025-04-30');


SELECT*FROM ads_performance.campaigns;

TRUNCATE TABLE ads_performance.ads_group RESTART IDENTITY CASCADE;

SELECT*FROM ads_performance.ads_group;

INSERT INTO ads_performance.ads_group (campaign_id, ad_group_name)
VALUES
-- Campaign 1
(1, 'Working Professionals'),
(1, 'High Income Users'),
(1, 'Corporate Employees'),
(1, 'Freelancers'),

-- Campaign 2
(2, 'Tech Lovers'),
(2, 'Budget Buyers'),
(2, 'Gadget Enthusiasts'),
(2, 'Online Shoppers'),

-- Campaign 3
(3, 'Family Shoppers'),
(3, 'Fitness Enthusiasts'),
(3, 'Health Conscious'),
(3, 'Home Makers'),

-- Campaign 4
(4, 'Gift Buyers'),
(4, 'Premium Users'),
(4, 'Luxury Shoppers'),
(4, 'Occasional Buyers'),

-- Campaign 5
(5, 'Travel Lovers'),
(5, 'Discount Seekers'),
(5, 'Students'),
(5, 'Deal Hunters'),
(5, 'Seasonal Buyers'),
(5, 'Last Minute Shoppers');

-- CASCADE removes dependent data in related tables, and RESTART IDENTITY resets the auto-increment counter.

INSERT INTO ads_performance.ads 
(ad_group_id, ad_name, ad_type, ad_platform, ad_headline)
VALUES
(1, 'Laptop Offer', 'Image', 'Facebook', 'Upgrade your work setup'),
(2, 'Luxury Watch', 'Image', 'Instagram', 'Time for luxury'),
(3, 'Office Software Ad', 'Video', 'LinkedIn', 'Boost productivity'),
(4, 'Freelancer Tools', 'Image', 'YouTube', 'Work smarter'),

(5, 'Smartphone Launch', 'Video', 'YouTube', 'Next-gen tech'),
(6, 'Budget Deals', 'Image', 'Facebook', 'Save more today'),
(7, 'Gaming Laptop', 'Video', 'Twitch', 'Level up gaming'),
(8, 'Online Shopping Fest', 'Image', 'Instagram', 'Big sale'),

(9, 'Family Grocery Pack', 'Image', 'Instagram', 'Save for family'),
(10, 'Gym Membership', 'Video', 'YouTube', 'Get fit now'),
(11, 'Organic Food', 'Image', 'Instagram', 'Healthy living'),
(12, 'Home Essentials', 'Image', 'Amazon', 'Daily needs'),

(13, 'Gift Hampers', 'Image', 'Facebook', 'Perfect gifts'),
(14, 'Premium Membership', 'Video', 'YouTube', 'Exclusive access'),
(15, 'Luxury Fashion', 'Image', 'Instagram', 'Style matters'),
(16, 'Occasional Deals', 'Image', 'Facebook', 'Limited offers'),

(17, 'Travel Packages', 'Video', 'YouTube', 'Explore world'),
(18, 'Discount Sale', 'Image', 'Flipkart', 'Best deals'),
(19, 'Student Offer', 'Image', 'Instagram', 'Student discounts'),
(20, 'Deal Hunters Ad', 'Image', 'Facebook', 'Grab deals'),
(21, 'Season Sale', 'Image', 'Amazon', 'Seasonal offers'),
(22, 'Last Minute Deals', 'Image', 'Flipkart', 'Hurry up');

SELECT*FROM ads_performance.ads;

TRUNCATE ads_performance.impressions 
RESTART IDENTITY CASCADE;


INSERT INTO ads_performance.impressions 
(ads_id, userid, platform, location, impression_time)

SELECT
    (random()*21 + 1)::int,
    (random()*500 + 100)::int,
    CASE 
        WHEN random() < 0.25 THEN 'Instagram'
        WHEN random() < 0.5 THEN 'Facebook'
        WHEN random() < 0.75 THEN 'YouTube'
        ELSE 'LinkedIn'
    END,
    CASE 
        WHEN random() < 0.2 THEN 'Mumbai'
        WHEN random() < 0.4 THEN 'Delhi'
        WHEN random() < 0.6 THEN 'Bangalore'
        WHEN random() < 0.8 THEN 'Pune'
        ELSE 'Hyderabad'
    END,
    NOW() - (random() * interval '7 days')

FROM generate_series(1,1000);

SELECT COUNT(*) FROM ads_performance.impressions;

INSERT INTO ads_performance.clicks (impression_id, click_time)
SELECT 
    impression_id,
    impression_time + (random() * interval '30 minutes')
FROM ads_performance.impressions
WHERE random() < 0.1;

INSERT INTO ads_performance.conversions (click_id, conversion_time, revenue)
SELECT
    click_id,
    click_time + (random() * interval '60 minutes'),
    ROUND((random()*2000 + 100)::numeric, 2)
FROM ads_performance.clicks
WHERE random() < 0.3;

SELECT*FROM ads_performance.clicks;

-- Section 2: Funnel analysis
-- total impressions
-- total clicks
-- total conversions
-- CTR
-- conversion rate

SELECT*FROM ads_performance.impressions;
SELECT*FROM ads_performance.clicks;

--Funnel Analysis
-- Out of total impressions, how many users clicked and how many converted?
SELECT
(SELECT COUNT(*) FROM ads_performance.impressions) as total_impressions,
(SELECT COUNT(*) FROM ads_performance.clicks) as total_clicks,
(SELECT COUNT(*) FROM ads_performance.conversions) as total_conversions;

--CTR= Click through rate (How many people clicked after seeing the ad)
SELECT
(
(SELECT COUNT(*) FROM ads_performance.clicks)::decimal/
(SELECT COUNT(*) FROM ads_performance.impressions)
)*100 as ctr_percentage;

--Conversion Rate (How many people turn intp buyers)
SELECT
(
(SELECT COUNT(*) FROM ads_performance.conversions)::decimal/
(SELECT COUNT(*) FROM ads_performance.clicks)
)*100
as conversion_percent;

--The ad generated 1000 impressions, out of 115 clicked on the ad and 33 users completed actions (purchase/sign up)
--So the ctr is 11.5% and conversion rate is 28.69%

-- Section 3: Platform analysis
-- highest clicks
-- highest revenue

--Which platform is generating highest clicks
SELECT i.platform, COUNT(c.click_id) as total_clicks
FROM ads_performance.impressions i
JOIN ads_performance.clicks c 
ON i.impression_id=c.impression_id
GROUP BY i.platform
ORDER BY total_clicks DESC;
--YouTube ads are generating the highest user engagement/highest traffic (clicks)
--so this platform is currently performing best in driving traffic


--Which platform generates the most revenue?
SELECT*FROM ads_performance.impressions;
SELECT*FROM ads_performance.clicks;
SELECT*FROM ads_performance.conversions;

SELECT i.platform,SUM(conv.revenue) as total_revenue
FROM ads_performance.impressions i
JOIN ads_performance.clicks c
ON c.impression_id=i.impression_id
JOIN ads_performance.conversions conv
ON c.click_id=conv.click_id
GROUP BY i.platform
ORDER BY total_revenue DESC;

--Youtube is currently the strongest performing platform
--Increase budget allocation toward YouTube campaigns since it is generating the strongest ROI potential.

-- Section 4: Audience analysis
-- highest revenue segment

-- Which audience segment makes the most money?
SELECT*FROM ads_performance.ads_group;
SELECT*FROM ads_performance.ads;
SELECT*FROM ads_performance.impressions;
SELECT*FROM ads_performance.clicks;
SELECT*FROM ads_performance.conversions;

-- Which audience segment makes the most money?
SELECT a.ad_group_name,SUM(conv.revenue) as total_revenue FROM ads_performance.ads_group a
JOIN ads_performance.ads a1
ON a.ad_group_id=a1.ad_group_id
JOIN ads_performance.impressions i
ON a1.ad_id=i.ads_id
JOIN ads_performance.clicks c
ON i.impression_id=c.impression_id
JOIN ads_performance.conversions conv
ON c.click_id=conv.click_id
GROUP BY a.ad_group_name
ORDER BY total_revenue DESC;

-- Deal Hunters generate highest revenue
-- Budget Buyers also perform well
-- Underperforming segments should be reviewed for budget optimization

-- Section 5: Ad type analysis
-- image vs video revenue

-- Are video ads generating more revenue than image ads?
SELECT*FROM ads_performance.ads;
SELECT*FROM ads_performance.impressions;
SELECT*FROM ads_performance.clicks;
SELECT*FROM ads_performance.conversions;

SELECT a.ad_type,SUM(conv.revenue) as total_revenue
FROM ads_performance.ads a
JOIN ads_performance.impressions i
ON a.ad_id=i.ads_id
JOIN ads_performance.clicks c
ON i.impression_id=c.impression_id
JOIN ads_performance.conversions conv
ON c.click_id=conv.click_id
GROUP BY a.ad_type
ORDER BY total_revenue DESC;

-- Image ads outperform video ads in revenue generation
-- Marketing team should prioritize image-based campaigns

-- I built a marketing analytics project using PostgreSQL where 
-- I simulated ad campaign data and analyzed funnel performance, platform effectiveness, audience behavior, 
-- and ad creative performance to derive business recommendations

SELECT CURRENT_DATABASE();
