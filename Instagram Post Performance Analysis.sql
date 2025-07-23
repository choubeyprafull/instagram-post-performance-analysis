create database instagram;
use instagram;
drop table instagram_data;
CREATE TABLE instagram_data (
    Post_ID VARCHAR(20),
    Post_type VARCHAR(20),
    Date DATE,
    Impressions INT,
    From_Home INT,
    From_Hashtags INT,
    From_Explore INT,
    From_Other INT,
    Saves INT,
    Comments INT,
    Shares INT,
    Likes INT,
    Profile_Visits INT,
    Follows INT,
    Conversion_Rate FLOAT,
    Caption TEXT,
    Hashtags TEXT
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.1/Uploads/Instagram_data.csv'
INTO TABLE instagram_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

#Exploratory Data Analysis using SQL

#first five rows of the dataset;
SELECT * FROM instagram_data;



#summary statistics of the data
#Basic Count, Min, Max, and Average of Key Metrics
SELECT 
  COUNT(*) AS total_posts,
  ROUND(AVG(Impressions), 2) AS avg_impressions,
  MIN(Impressions) AS min_impressions,
  MAX(Impressions) AS max_impressions,
  
  ROUND(AVG(Likes), 2) AS avg_likes,
  MIN(Likes) AS min_likes,
  MAX(Likes) AS max_likes,
  
  ROUND(AVG(Saves), 2) AS avg_saves,
  ROUND(AVG(Shares), 2) AS avg_shares,
  ROUND(AVG(Comments), 2) AS avg_comments
FROM instagram_data;

#Total Engagements by Type
SELECT
  SUM(Likes) AS total_likes,
  SUM(Saves) AS total_saves,
  SUM(Comments) AS total_comments,
  SUM(Shares) AS total_shares,
  SUM(Profile_Visits) AS total_profile_visits,
  SUM(Follows) AS total_follows
FROM instagram_data;

#Traffic Source Summary
SELECT
  ROUND(AVG(From_Home), 2) AS avg_from_home,
  ROUND(AVG(From_Hashtags), 2) AS avg_from_hashtags,
  ROUND(AVG(From_Explore), 2) AS avg_from_explore,
  ROUND(AVG(From_Other), 2) AS avg_from_other
FROM instagram_data;

#Identifying Missing Data
SELECT 
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Post_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Post_ID,
    SUM(CASE WHEN Post_type IS NULL THEN 1 ELSE 0 END) AS Missing_Post_type,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Missing_Date,
    SUM(CASE WHEN Impressions IS NULL THEN 1 ELSE 0 END) AS Missing_Impressions,
    SUM(CASE WHEN From_Home IS NULL THEN 1 ELSE 0 END) AS Missing_From_Home,
    SUM(CASE WHEN From_Hashtags IS NULL THEN 1 ELSE 0 END) AS Missing_From_Hashtags,
    SUM(CASE WHEN From_Explore IS NULL THEN 1 ELSE 0 END) AS Missing_From_Explore,
    SUM(CASE WHEN From_Other IS NULL THEN 1 ELSE 0 END) AS Missing_From_Other,
    SUM(CASE WHEN Saves IS NULL THEN 1 ELSE 0 END) AS Missing_Saves,
    SUM(CASE WHEN Comments IS NULL THEN 1 ELSE 0 END) AS Missing_Comments,
    SUM(CASE WHEN Shares IS NULL THEN 1 ELSE 0 END) AS Missing_Shares,
    SUM(CASE WHEN Likes IS NULL THEN 1 ELSE 0 END) AS Missing_Likes,
    SUM(CASE WHEN Profile_Visits IS NULL THEN 1 ELSE 0 END) AS Missing_Profile_Visits,
    SUM(CASE WHEN Follows IS NULL THEN 1 ELSE 0 END) AS Missing_Follows,
    SUM(CASE WHEN Conversion_Rate IS NULL THEN 1 ELSE 0 END) AS Missing_Conversion_Rate
FROM instagram_data;


#Analyzing Distribution
#post type distribution
SELECT 
    Post_Type, 
    COUNT(*) AS Frequency
FROM instagram_data
GROUP BY Post_Type
ORDER BY Frequency DESC;

#Engagement Metrics
SELECT 
    Post_ID,
    ROUND(Likes / NULLIF(Impressions, 0), 4) AS Likes_Per_Impression,
    ROUND(Saves / NULLIF(Impressions, 0), 4) AS Saves_Per_Impression
FROM instagram_data;


#Trends over Time
SELECT 
    Date,
    SUM(Impressions) AS Total_Impressions,
    SUM(Likes) AS Total_Likes
FROM instagram_data
GROUP BY Date
ORDER BY Date ASC;

# Outlier Detection in Impressions (±2σ Method)
SELECT * 
FROM instagram_data
WHERE Impressions > (
    SELECT AVG(Impressions) + 2 * STDDEV(Impressions) FROM instagram_data
)
OR Impressions < (
    SELECT AVG(Impressions) - 2 * STDDEV(Impressions) FROM instagram_data
);