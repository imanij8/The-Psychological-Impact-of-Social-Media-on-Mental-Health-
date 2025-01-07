DROP DATABASE IF EXISTS social_impact;
CREATE DATABASE  IF NOT EXISTS social_impact;
USE social_impact;

 -- PARTICIPANT TABLE
 DROP TABLE IF EXISTS participants;
 CREATE TABLE participants (
	participant_id int primary key AUTO_INCREMENT,
    age int,
    gender  VARCHAR(10),
    location VARCHAR(50),
    occupation VARCHAR(50),
    mental_health_conditions TEXT,
    platform_usage TEXT
);

-- SOCIAL MEDIA USAGE TABLE
DROP TABLE IF EXISTS social_media_usage;
CREATE TABLE social_media_usage (
	usage_id INT PRIMARY KEY AUTO_INCREMENT,
    participant_id INT,
    platform_name VARCHAR(50),
    hours_per_day DECIMAL(4,2),
    interaction_level ENUM("Low", "Medium", "High"),
    type_of_content ENUM("Positive", "Neutral", "Negative"),
    FOREIGN KEY (participant_id) REFERENCES participants(participant_id) 
);

-- MENTAL HEALTH ASSESSMENT TABLE
DROP TABLE IF EXISTS mental_health;
CREATE TABLE mental_health (
participant_id int primary key,
anxiety_level INT,                      
depression_level INT,
self_esteem_level INT, 
social_comparison_level INT,
FOREIGN KEY (participant_id) REFERENCES participants(participant_id) 
);



-- PARTICIPANT DATA
INSERT INTO participants(age, gender, location, occupation, mental_health_conditions, platform_usage)
VALUES
(19, "Female", "Massachusetts", "Student", "Anxiety", "Instagram, Snapchat, TikTok"),
(19, "Male", "Virginia", "Student", "None", "Twitter/X, Reddit"),
(20, "Female", "New Jersey", "Student", "Social Anxiety", "Instagram, Snapchat, TikTok, Twitter/X"),
(18, "Female", "Connecticut", "Student", "None", "Instagram, TikTok"),
(19, "Female", "Florida", "Student", "Depression, Anxiety", "Instagram , Twitter/X , Tiktok"),
(19, "Male", "New York", "Student", "Depression", "TikTok");


-- SOCIAL MEDIA USAGE DATA
INSERT INTO social_media_usage (participant_id, platform_name, hours_per_day, interaction_level, type_of_content)
VALUES
(1, 'Instagram', 3.5, 'Medium', "Positive"),
(1, "Snapchat", 1, "Medium", "Positive"),
(1, "TikTok", 3, "High", "Neutral"),
(2, "Twitter", 0.5, 'Low', "Neutral"),
(2, "Reddit", 1, "Low", "Neutral"),
(3, "Instagram", 2, 'High', "Positive"),
(3, "Snapchat", 1, "Low", "Positive"),
(3, "TikTok", 5.5, "High", "Neutral"),
(3, "Twitter/X", 1, "High", "Negative"),
(4, "Instagram", 1, "Low", "Positive"),
(4, "Tiktok", 0.5, "Low", "Neutral"),
(5, "Instagram", 3.5, "Medium", "Negative"),
(5, "Twitter/X", 1, "Low", "Positive"),
(5, "TikTok", 2, "High", "Positive"),
(6, "TikTok", 6, "Medium", "Negative");



-- MENTAL HEALTH ASSESSMENT DATA
INSERT INTO mental_health (participant_id, anxiety_level, depression_level, self_esteem_level, social_comparison_level)
VALUES
    (1, 10, 0, 9, 2),
    (2, 0, 0, 10, 4),
    (3, 8, 0, 2, 9),
    (4, 0, 0, 8, 5),
    (5, 10, 9, 4, 5),
    (6, 6, 10, 3, 5);
        

-- QUERIES TO FOCUS ON THE RELATIONSHIP BETWEEN SOCIAL MEDIA USAGE AND SPECIFIC MENTAL HEALTH LEVELS

-- comparing social media usage and anxiety
SELECT smu.platform_name, AVG(smu.hours_per_day) AS avg_hours, AVG(mha.anxiety_level) AS avg_anxiety_level
FROM social_media_usage smu
JOIN mental_health mha ON smu.participant_id = mha.participant_id
GROUP BY smu.platform_name;

-- comparing social media usage and depression
SELECT smu.platform_name, AVG(smu.hours_per_day) AS avg_hours, AVG(mha.depression_level) AS avg_depression_level
FROM social_media_usage smu
JOIN mental_health mha ON smu.participant_id = mha.participant_id
GROUP BY smu.platform_name;

-- comparing social media usage and social comparison
SELECT smu.platform_name, AVG(smu.hours_per_day) AS avg_hours, AVG(mha.social_comparison_level) AS avg_social_comparison_level
FROM social_media_usage smu
JOIN mental_health mha ON smu.participant_id = mha.participant_id
GROUP BY smu.platform_name;

-- comparing social media usage and self esteem
SELECT smu.platform_name, AVG(smu.hours_per_day) AS avg_hours, AVG(mha.self_esteem_level) AS avg_self_esteem
FROM social_media_usage smu
JOIN mental_health mha ON smu.participant_id = mha.participant_id
GROUP BY smu.platform_name;

-- QUERIES TO ANSWER QUESTIONS

-- Do the participants who spend more time on social media with high interaction have high anxiety levels?
-- what about medium interaction? Low?
-- these queries gives us the average mental health condition level for each type of participant
SELECT smu.interaction_level, 
    AVG(mha.anxiety_level) AS avg_anxiety
FROM mental_health mha
JOIN social_media_usage smu ON mha.participant_id = smu.participant_id
GROUP BY smu.interaction_level;

-- Do the participants who spend more time on social media with high interaction have high depression levels?
SELECT smu.interaction_level, 
    AVG(mha.depression_level) AS avg_depression
FROM mental_health mha
JOIN social_media_usage smu ON mha.participant_id = smu.participant_id
GROUP BY smu.interaction_level;

-- Do the participants who spend more time on social media with high interaction have high self esteem levels?
SELECT smu.interaction_level, 
    AVG(mha.self_esteem_level) AS avg_self_esteem
FROM mental_health mha
JOIN social_media_usage smu ON mha.participant_id = smu.participant_id
GROUP BY smu.interaction_level;

-- Do the participants who spend more time on social media with high interaction have high social comparison levels?
SELECT smu.interaction_level, 
    AVG(mha.social_comparison_level) AS avg_social_comparison
FROM mental_health mha
JOIN social_media_usage smu ON mha.participant_id = smu.participant_id
GROUP BY smu.interaction_level;

-- Does Negative content produce higher depression levels?
-- Does Neutral content produce higher depression levels?
-- Does Positive content produce lower depression levels?
SELECT smu.type_of_content, AVG(mha.depression_level) AS avg_depression
FROM social_media_usage smu
JOIN mental_health mha ON smu.participant_id = mha.participant_id
GROUP BY smu.type_of_content;


-- RECOMENDATION/ADVICE QUERIES
-- on a case by case basis this query gives reccommendations for each participant depending on their data
-- QUESTION: What recommendations/advice can we give to participants to further help with mental health?
SELECT 
    smu.participant_id, 
    smu.platform_name,
    CASE
        WHEN smu.platform_name = 'TikTok' AND smu.hours_per_day > 3 AND mh.anxiety_level > 7 THEN
            'Reduce time spent on TikTok to less than 2 hours/day to lower anxiety.'
        WHEN smu.platform_name = 'Instagram' AND mh.self_esteem_level < 5 THEN
            'Engage with more positive content on Instagram to boost self-esteem.'
        WHEN smu.platform_name = 'Twitter/X' AND smu.type_of_content = 'Negative' AND mh.depression_level > 7 THEN
            'Consider limiting exposure to negative content on Twitter/X.'
        WHEN smu.interaction_level = 'High' AND mh.social_comparison_level > 4 THEN
            'Reduce social comparison by moderating engagement with highly interactive content.'
        WHEN smu.hours_per_day > 3 THEN
            'Consider a digital detox to reduce excessive screen time across platforms.'
        WHEN mh.anxiety_level > 7 AND mh.self_esteem_level < 5 THEN
            'Seek mental health support; high anxiety and low self-esteem detected.'
        ELSE
            'No specific recommendation; maintain healthy usage habits.'
    END AS recommendation
FROM social_media_usage smu
JOIN mental_health mh ON smu.participant_id = mh.participant_id;



