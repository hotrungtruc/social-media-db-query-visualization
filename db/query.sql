-- 1. Top 10 users with the highest number of posts, comments, and reactions combined
SELECT u.user_id, u.username, 
       COUNT(DISTINCT p.post_id) AS post_count,
       COUNT(DISTINCT c.comment_id) AS comment_count,
       COUNT(DISTINCT pr.post_react_id) AS reaction_count,
       (COUNT(DISTINCT p.post_id) + COUNT(DISTINCT c.comment_id) + COUNT(DISTINCT pr.post_react_id)) AS total_engagement
FROM USER u
LEFT JOIN POST p ON u.user_id = p.user_id
LEFT JOIN COMMENT c ON u.user_id = c.user_id
LEFT JOIN POST_REACTION pr ON u.user_id = pr.user_id
GROUP BY u.user_id
ORDER BY total_engagement DESC
LIMIT 10;

-- 2. Most active hours for user logins
SELECT HOUR(login_at) AS login_hour, 
       DAYOFWEEK(login_at) AS day_of_week, 
       COUNT(*) AS login_count
FROM LOGIN
GROUP BY login_hour, day_of_week
ORDER BY login_count DESC;

-- 3. Post categories with the most posts
SELECT post_category, COUNT(*) AS post_count
FROM POST
GROUP BY post_category
ORDER BY post_count DESC;

-- 4. User growth by day
SELECT DATE(created_at) AS day, COUNT(*) AS daily_users
FROM USER
GROUP BY day
ORDER BY day;

-- 5. Top 5 posts with the most reactions
SELECT p.post_id, p.caption, COUNT(pr.post_react_id) AS reaction_count
FROM POST p
LEFT JOIN POST_REACTION pr ON p.post_id = pr.post_id
GROUP BY p.post_id
ORDER BY reaction_count DESC
LIMIT 5;

-- 6. Posts by location
SELECT p.location, 
       COUNT(p.post_id) AS num_posts
FROM POST p
GROUP BY p.location
ORDER BY num_posts DESC
LIMIT 10;  -- Get only the top 10 location

-- 7. Distribution of users by gender and age group
SELECT gender, 
       CASE 
           WHEN age < 18 THEN 'Under 18'
           WHEN age BETWEEN 18 AND 24 THEN '18-24'
           WHEN age BETWEEN 25 AND 34 THEN '25-34'
           WHEN age BETWEEN 35 AND 44 THEN '35-44'
           WHEN age BETWEEN 45 AND 54 THEN '45-54'
           WHEN age BETWEEN 55 AND 64 THEN '55-64'
           ELSE '65 and above'
       END AS age_group,
       COUNT(*) AS user_count
FROM USER
GROUP BY gender, age_group
ORDER BY gender, age_group;

-- 8. Top 10 users with the most followers
SELECT u.user_id, u.username, COUNT(f.follower_id) AS follower_count
FROM USER u
LEFT JOIN FOLLOW f ON u.user_id = f.followee_id
GROUP BY u.user_id
ORDER BY follower_count DESC
LIMIT 10;

-- 9. Most commonly used hashtags
SELECT hashtag_name, COUNT(*) AS usage_count
FROM HASHTAG
GROUP BY hashtag_name
ORDER BY usage_count DESC
LIMIT 10;

-- 10. Distribution of different types of reactions to posts
SELECT e.emotion_name, COUNT(pr.post_react_id) AS reaction_count
FROM POST_REACTION pr
JOIN EMOTION e ON pr.emotion_id = e.emotion_id
GROUP BY e.emotion_name
ORDER BY reaction_count DESC;