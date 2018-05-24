drop database if exists hashtag;
CREATE DATABASE `hashtag` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE TABLE `hashtag`.`hashtag` (
  `id` bigint(20) unsigned zerofill NOT NULL,
  `title` varchar(45) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `creator` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


drop database if exists external_content;
CREATE DATABASE `external_content` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE TABLE `external_content`.`external_content` (
  `id` bigint(20) unsigned zerofill NOT NULL,
  `title` text CHARACTER SET utf8,
  `domain` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  `original_url` varchar(2048) COLLATE utf8_unicode_ci NOT NULL,
  `icon_url` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  `first_image_url` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  `author` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pub_date` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `summary` text COLLATE utf8_unicode_ci,
  `content` text COLLATE utf8_unicode_ci,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modified_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

drop database if exists my_saved;
CREATE DATABASE `my_saved` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE TABLE `my_saved`.`my_saved` (
  `id` bigint(20) unsigned zerofill NOT NULL,
  `owner` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `entity_type` tinyint(4) NOT NULL,
  `entity_id` bigint(20) NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modified_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `title` text COLLATE utf8_unicode_ci,
  `icon_url` text COLLATE utf8_unicode_ci,
  `first_image_url` text COLLATE utf8_unicode_ci,
  `url` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_owner_entity` (`owner`,`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


drop database if exists learning_play;
CREATE DATABASE `learning_play` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE TABLE `learning_play`.`learning_play` (
  `id` bigint(20) unsigned zerofill NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `creator` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `recommended` tinyint(4) DEFAULT '0',
  `recommended_date` timestamp NULL DEFAULT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modified_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_title_creator` (`title`,`creator`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `learning_play`.`learning_play_content` (
  `id` bigint(20) unsigned zerofill NOT NULL,
  `learning_play_id` bigint(20) unsigned zerofill NOT NULL,
  `content_type` tinyint(4) NOT NULL,
  `content_ref_id` bigint(20) unsigned zerofill NOT NULL,
  `content_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_icon_url` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_img_url` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_link` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_order` int(11) DEFAULT '0',
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modified_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_lp_type_refid` (`learning_play_id`,`content_type`,`content_ref_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `learning_play`.`learning_play_hashtag` (
  `id` bigint(20) unsigned zerofill NOT NULL,
  `learning_play_id` bigint(20) unsigned zerofill NOT NULL,
  `hashtag_title` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modified_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_lp_title` (`learning_play_id`,`hashtag_title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `learning_play`.`learning_play_rating` (
  `id` bigint(20) unsigned zerofill NOT NULL,
  `learning_play_id` bigint(20) unsigned zerofill NOT NULL,
  `rating` tinyint(4) NOT NULL,
  `rater` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modified_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_lp_rater` (`learning_play_id`,`rater`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

drop database if exists user;
CREATE DATABASE `user` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE TABLE `user`.`interests` (
  `id` bigint(20) unsigned zerofill NOT NULL,
  `user_id` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modified_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

drop database if exists HR_NOTIFICATION;
CREATE DATABASE `HR_NOTIFICATION` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE TABLE `HR_NOTIFICATION`.`notification_msg` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `description` varchar(50) NOT NULL,
  `message` varchar(1000) NOT NULL,
  `action_ref` varchar(20) NOT NULL,
  `action_url` varchar(20) DEFAULT NULL,
  `module` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;

CREATE TABLE `HR_NOTIFICATION`.`login_device` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employeeId` varchar(50) DEFAULT NULL,
  `deviceId` varchar(45) DEFAULT NULL,
  `deviceToken` varchar(450) DEFAULT NULL,
  `deviceType` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employeeId_UNIQUE` (`employeeId`)
) ENGINE=InnoDB AUTO_INCREMENT=8911 DEFAULT CHARSET=utf8;

CREATE TABLE `HR_NOTIFICATION`.`notification_icon` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employeeId` varchar(50) NOT NULL,
  `createTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employeeId_UNIQUE` (`employeeId`)
) ENGINE=InnoDB AUTO_INCREMENT=264 DEFAULT CHARSET=utf8;

CREATE TABLE `HR_NOTIFICATION`.`notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` varchar(45) DEFAULT NULL,
  `notif_msg_id` mediumint(9) NOT NULL,
  `json_data` varchar(4096) DEFAULT NULL,
  `msg_type` tinyint(4) NOT NULL DEFAULT '0',
  `created_dt` datetime NOT NULL,
  `sent_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notif_msg_id_FK` (`notif_msg_id`),
  CONSTRAINT `notif_msg_id_FK` FOREIGN KEY (`notif_msg_id`) REFERENCES `notification_msg` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2005392 DEFAULT CHARSET=utf8;


drop database if exists search;
CREATE DATABASE `search` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE TABLE `search`.`history` (
  `id` bigint(20) unsigned zerofill NOT NULL,
  `user_id` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `search_content` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `search_times` int(11) DEFAULT '1',
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_modified_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


ALTER TABLE `HR_PERFORMANCE`.`objective_entity_rel` 
CHANGE COLUMN `entity_id` `entity_id` BIGINT(20) NOT NULL ;
