/*
SQLyog Community v8.62 
MySQL - 5.5.29-0ubuntu0.12.04.2-log : Database - caldav
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`caldav` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `caldav`;

/*Table structure for table `addressbooks` */

DROP TABLE IF EXISTS `addressbooks`;

CREATE TABLE `addressbooks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `principaluri` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `displayname` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'Default Address Book',
  `uri` varchar(200) COLLATE utf8_unicode_ci DEFAULT 'default',
  `description` text COLLATE utf8_unicode_ci,
  `ctag` int(11) unsigned NOT NULL DEFAULT '1',
  `shared_to` text COLLATE utf8_unicode_ci COMMENT 'Shared to user. Comma separated',
  PRIMARY KEY (`id`),
  UNIQUE KEY `principaluri` (`principaluri`,`uri`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `addressbooks` */

insert  into `addressbooks`(`id`,`principaluri`,`displayname`,`uri`,`description`,`ctag`,`shared_to`) values (1,'principals/COMPANY','Company.local','pim_company','GAL Addresses',0,'all'),(2,'principals/SHAREDTO','Shared addressbook 1','pim_shared_1','Shared 1',0,'all'),(3,'principals/admin','Admin User','pim_admin','Admin User',0,NULL),(4,'principals/SHAREDTO','Shared addressbook 2','pim_shared_2','Shared 2',0,'user1, user2');

/*Table structure for table `calendarobjects` */

DROP TABLE IF EXISTS `calendarobjects`;

CREATE TABLE `calendarobjects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `calendardata` mediumblob,
  `uri` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `calendarid` int(10) unsigned NOT NULL,
  `lastmodified` int(11) unsigned DEFAULT NULL,
  `etag` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` int(11) unsigned NOT NULL,
  `componenttype` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `firstoccurence` int(11) unsigned DEFAULT NULL,
  `lastoccurence` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `calendarid` (`calendarid`,`uri`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `calendarobjects` */

/*Table structure for table `calendars` */

DROP TABLE IF EXISTS `calendars`;

CREATE TABLE `calendars` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `principaluri` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `displayname` varchar(100) COLLATE utf8_unicode_ci DEFAULT 'Default calendar',
  `uri` varchar(200) COLLATE utf8_unicode_ci DEFAULT 'default',
  `ctag` int(10) unsigned NOT NULL DEFAULT '0',
  `description` text COLLATE utf8_unicode_ci,
  `calendarorder` int(10) unsigned NOT NULL DEFAULT '0',
  `calendarcolor` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `timezone` text COLLATE utf8_unicode_ci,
  `components` varchar(21) COLLATE utf8_unicode_ci DEFAULT 'VEVENT,VTODO,VJOURNAL',
  `transparent` tinyint(1) NOT NULL DEFAULT '0',
  `shared_to` text COLLATE utf8_unicode_ci COMMENT 'Shared to User. Comma separated',
  PRIMARY KEY (`id`),
  UNIQUE KEY `principaluri` (`principaluri`,`uri`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `calendars` */

insert  into `calendars`(`id`,`principaluri`,`displayname`,`uri`,`ctag`,`description`,`calendarorder`,`calendarcolor`,`timezone`,`components`,`transparent`,`shared_to`) values (1,'principals/COMPANY','Company Calendar','pim_company',0,'Company Calendar',0,'','','VEVENT,VTODO,VJOURNAL',0,'all'),(2,'principals/SHAREDTO','Shared 1','pim_shared_1',0,'Shared 1',0,'#F64F00',NULL,'VEVENT,VTODO,VJOURNAL',0,NULL),(3,'principals/SHAREDTO','Shared 2','pim_shared_2',0,'Shared 2',0,NULL,NULL,'VEVENT,VTODO,VJOURNAL',0,'user1,user2'),(4,'principals/admin','Default calendar','pim_admin',0,'Admin calendar',0,'#711A76','','VEVENT,VTODO,VJOURNAL',0,NULL);

/*Table structure for table `cards` */

DROP TABLE IF EXISTS `cards`;

CREATE TABLE `cards` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `addressbookid` int(11) unsigned NOT NULL,
  `carddata` mediumblob,
  `uri` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastmodified` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `cards` */

/*Table structure for table `groupmembers` */

DROP TABLE IF EXISTS `groupmembers`;

CREATE TABLE `groupmembers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `principal_id` int(10) unsigned NOT NULL,
  `member_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `principal_id` (`principal_id`,`member_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `groupmembers` */

insert  into `groupmembers`(`id`,`principal_id`,`member_id`) values (1,1,3),(2,2,3);

/*Table structure for table `locks` */

DROP TABLE IF EXISTS `locks`;

CREATE TABLE `locks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `timeout` int(10) unsigned DEFAULT NULL,
  `created` int(11) DEFAULT NULL,
  `token` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scope` tinyint(4) DEFAULT NULL,
  `depth` tinyint(4) DEFAULT NULL,
  `uri` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `token` (`token`),
  KEY `uri` (`uri`(333))
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `locks` */

/*Table structure for table `principals` */

DROP TABLE IF EXISTS `principals`;

CREATE TABLE `principals` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uri` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(80) COLLATE utf8_unicode_ci DEFAULT NULL,
  `displayname` varchar(80) COLLATE utf8_unicode_ci DEFAULT NULL,
  `vcardurl` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`,`uri`),
  UNIQUE KEY `uri` (`uri`)
) ENGINE=MyISAM AUTO_INCREMENT=100 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `principals` */

insert  into `principals`(`id`,`uri`,`email`,`displayname`,`vcardurl`) values (3,'principals/admin','admin@COMPANY.LOCAL','ADMIN',NULL),(1,'principals/COMPANY','COMPANY@COMPANY.local','COMPANY',''),(2,'principals/SHAREDTO','SHAREDTO@COMPANY.LOCAL','SHARED',NULL);

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `digesta1` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mod_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`,`username`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `users` */

insert  into `users`(`id`,`username`,`digesta1`,`mod_time`,`status`) values (2,'admin','','2014-10-27 14:19:01',1);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
