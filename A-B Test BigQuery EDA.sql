
-- Checking data for NULL values
# No NULL values present in the data set; all user_id are unique
SELECT
COUNT (DISTINCT user_id) AS unique_user_id, 
SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS user_id_null,
SUM(CASE WHEN version IS NULL THEN 1 ELSE 0 END) AS version_null,
SUM(CASE WHEN sum_gamerounds IS NULL THEN 1 ELSE 0 END) AS levels_null,
SUM(CASE WHEN retention_1 IS NULL THEN 1 ELSE 0 END) AS retention_1_null,
SUM(CASE WHEN retention_2 IS NULL THEN 1 ELSE 0 END) AS retention_2_null
FROM `turing_data_analytics.cookie_cats`;

-- Exploring the data spread through quantiles, mean and standard deviation
# Share of users in each group is approx. the same; maximum values are very large in both groups though.
SELECT version,
COUNT(user_id) AS user_count,
COUNT(user_id) / 90189 AS share_users,
APPROX_QUANTILES(sum_gamerounds, 4) AS quartiles,
AVG(sum_gamerounds) AS mean_levels,
STDDEV(sum_gamerounds) AS std_deviation
FROM `turing_data_analytics.cookie_cats`
GROUP BY version;

-- Checking the share of users that reach the relevant levels (30 and 40) in the dataset.
# For both groups, low percentage (30%) reach both levels and percentage are very similar to each other

WITH t1 AS (
SELECT version,
COUNT(*) AS total_users,
SUM(CASE WHEN sum_gamerounds >= 30 THEN 1 ELSE 0 END) AS count_level_30_users,
SUM(CASE WHEN sum_gamerounds >= 40 THEN 1 ELSE 0 END) AS count_level_40_users,
FROM `turing_data_analytics.cookie_cats`
GROUP BY version)

SELECT *,
(t1.count_level_30_users / t1.total_users) AS perc_level_30,
(t1.count_level_40_users / t1.total_users) AS perc_level_40
FROM t1
GROUP BY ALL;


-- Checking distribution of levels reached for each group.
SELECT sum_gamerounds,
COUNTIF(version = 'gate_30') AS group_30_retention,
COUNTIF(version = 'gate_40') AS group_40_retention
FROM `turing_data_analytics.cookie_cats`
GROUP BY sum_gamerounds
ORDER BY sum_gamerounds;

-- Calculating retentions for both groups

SELECT version,
COUNT(*) AS total_users,
SUM(CASE WHEN sum_gamerounds >= 30 THEN 1 ELSE 0 END) AS count_level_30_users,
SUM(CASE WHEN sum_gamerounds >= 40 THEN 1 ELSE 0 END) AS count_level_40_users,
SUM(CASE WHEN retention_1 IS true THEN 1 ELSE 0 END) AS count_retention_1,
SUM(CASE WHEN retention_2 IS true THEN 1 ELSE 0 END) AS count_retention_2,
SUM(CASE WHEN sum_gamerounds >= 30 AND retention_1 IS true THEN 1 ELSE 0 END) AS count_ret1_30_users,
SUM(CASE WHEN sum_gamerounds >= 30 AND retention_2 IS true THEN 1 ELSE 0 END) AS count_ret2_30_users,
SUM(CASE WHEN sum_gamerounds >= 40 AND retention_1 IS true THEN 1 ELSE 0 END) AS count_ret1_40_users,
SUM(CASE WHEN sum_gamerounds >= 40 AND retention_2 IS true THEN 1 ELSE 0 END) AS count_ret2_40_users,
AVG(sum_gamerounds) AS mean_levels
FROM `turing_data_analytics.cookie_cats`
GROUP BY version

