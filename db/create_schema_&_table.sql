-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS `social_network`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Select the social_network database
USE `social_network`;

-- Table: USER
CREATE TABLE `USER` (
  `user_id`         VARCHAR(36)   NOT NULL,
  `username`        VARCHAR(255)  NOT NULL,
  `email`           VARCHAR(255)  NOT NULL,
  `profile_picture` VARCHAR(255),
  `gender`          VARCHAR(10),
  `age`             INT,
  `bio`             TEXT,
  `location`        VARCHAR(255),
  `post_interest`   VARCHAR(255),
  `created_at`      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

-- Table: LOGIN
CREATE TABLE `LOGIN` (
  `login_id`  VARCHAR(36)   NOT NULL,
  `user_id`   VARCHAR(36)   NOT NULL,
  `IP`        VARCHAR(45),
  `login_at`  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`login_id`),
  INDEX (`user_id`),
  CONSTRAINT `fk_login_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `USER` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

-- Table: FOLLOW
CREATE TABLE `FOLLOW` (
  `follow_id`    VARCHAR(36)   NOT NULL,
  `follower_id`  VARCHAR(36)   NOT NULL,
  `followee_id`  VARCHAR(36)   NOT NULL,
  `created_at`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`follow_id`),
  UNIQUE (`follower_id`, `followee_id`),
  INDEX (`follower_id`),
  INDEX (`followee_id`),
  CONSTRAINT `fk_follow_follower`
    FOREIGN KEY (`follower_id`)
    REFERENCES `USER` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_follow_followee`
    FOREIGN KEY (`followee_id`)
    REFERENCES `USER` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

-- Table: POST
CREATE TABLE `POST` (
  `post_id`       VARCHAR(36)   NOT NULL,
  `user_id`       VARCHAR(36)   NOT NULL,
  `caption`       TEXT,
  `location`      VARCHAR(255),
  `post_category` VARCHAR(45),
  `created_at`    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`post_id`),
  INDEX (`user_id`),
  CONSTRAINT `fk_post_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `USER` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

-- Table: COMMENT
CREATE TABLE `COMMENT` (
  `comment_id`  VARCHAR(36)   NOT NULL,
  `post_id`     VARCHAR(36)   NOT NULL,
  `user_id`     VARCHAR(36)   NOT NULL,
  `content`     TEXT,
  `created_at`  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  INDEX (`post_id`),
  INDEX (`user_id`),
  CONSTRAINT `fk_comment_post`
    FOREIGN KEY (`post_id`)
    REFERENCES `POST` (`post_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `USER` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

-- Table: EMOTION
-- Stores possible emotions for reactions
CREATE TABLE `EMOTION` (
  `emotion_id`   VARCHAR(36)   NOT NULL,       -- Unique emotion ID
  `emotion_name` VARCHAR(50)   NOT NULL,       -- Name of the emotion (e.g., like, love)
  PRIMARY KEY (`emotion_id`),
  UNIQUE (`emotion_name`)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;
  
-- Table: POST_REACTIONS
CREATE TABLE `POST_REACTION` (
  `post_react_id` VARCHAR(36)   NOT NULL,
  `user_id`       VARCHAR(36)   NOT NULL,
  `post_id`       VARCHAR(36)   NOT NULL,
  `emotion_id`    VARCHAR(36)   NOT NULL,
  `created_at`    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`post_react_id`),
  UNIQUE (`user_id`, `post_id`),
  INDEX (`post_id`),
  INDEX (`emotion_id`),
  CONSTRAINT `fk_pr_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `USER` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pr_post`
    FOREIGN KEY (`post_id`)
    REFERENCES `POST` (`post_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pr_emotion`
    FOREIGN KEY (`emotion_id`)
    REFERENCES `EMOTION` (`emotion_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

-- Table: COMMENT_REACTIONS
CREATE TABLE `COMMENT_REACTION` (
  `comment_react_id` VARCHAR(36) NOT NULL,
  `user_id`          VARCHAR(36) NOT NULL,
  `comment_id`       VARCHAR(36) NOT NULL,
  `emotion_id`       VARCHAR(36) NOT NULL,
  `created_at`       DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_react_id`),
  UNIQUE (`user_id`, `comment_id`),
  INDEX (`user_id`),
  INDEX (`comment_id`),
  INDEX (`emotion_id`),
  CONSTRAINT `fk_cr_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `USER` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cr_comment`
    FOREIGN KEY (`comment_id`)
    REFERENCES `COMMENT` (`comment_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cr_emotion`
    FOREIGN KEY (`emotion_id`)
    REFERENCES `EMOTION` (`emotion_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

-- Table: MEDIA
CREATE TABLE `MEDIA` (
  `media_id`      VARCHAR(36)   NOT NULL,
  `post_id`       VARCHAR(36)   NOT NULL,
  `media_url`     VARCHAR(255)  NOT NULL,
  `media_type`    VARCHAR(50)   DEFAULT 'image',
  `media_size_kb` INT,
  `created_at`    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`media_id`),
  UNIQUE (`media_url`),
  INDEX (`post_id`),
  CONSTRAINT `fk_media_post`
    FOREIGN KEY (`post_id`)
    REFERENCES `POST` (`post_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

-- Table: HASHTAG
CREATE TABLE `HASHTAG` (
  `hashtag_id`    VARCHAR(36)   NOT NULL,
  `post_id`       VARCHAR(36)   NOT NULL,
  `hashtag_name`  VARCHAR(50)   NOT NULL,
  `created_at`    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`hashtag_id`),
  INDEX (`post_id`),
  CONSTRAINT `fk_hashtag_post`
    FOREIGN KEY (`post_id`)
    REFERENCES `POST` (`post_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;