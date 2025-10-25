-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Oct 25, 2025 at 08:05 AM
-- Server version: 9.1.0
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pronote`
--

-- --------------------------------------------------------

--
-- Table structure for table `absence`
--

DROP TABLE IF EXISTS `absence`;
CREATE TABLE IF NOT EXISTS `absence` (
  `ABSENCE_ID` int NOT NULL,
  `STUDY_SESSION_ID` int NOT NULL,
  `ABSENCE_DATE_AND_TIME` datetime DEFAULT NULL,
  `ABSENCE_MOTIF` varchar(30) DEFAULT NULL,
  `ABSENCE_OBSERVATION` varchar(258) DEFAULT NULL,
  PRIMARY KEY (`ABSENCE_ID`),
  KEY `FK_ABSENCE_TAKES_PLA_STUDY_SE` (`STUDY_SESSION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `administrator`
--

DROP TABLE IF EXISTS `administrator`;
CREATE TABLE IF NOT EXISTS `administrator` (
  `ADMINISTRATOR_ID` int NOT NULL,
  `USER_ID` int NOT NULL,
  `ADMINISTRATOR_FIRST_NAME` varchar(24) DEFAULT NULL,
  `ADMINISTRATOR_LAST_NAME` varchar(24) DEFAULT NULL,
  `ADMINISTRATOR_POSITION` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`ADMINISTRATOR_ID`),
  KEY `FK_ADMINIST_ADMINISTR_USER_ACC` (`USER_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `administrator`
--

INSERT INTO `administrator` (`ADMINISTRATOR_ID`, `USER_ID`, `ADMINISTRATOR_FIRST_NAME`, `ADMINISTRATOR_LAST_NAME`, `ADMINISTRATOR_POSITION`) VALUES
(0, 16, '', 'BADI', 'DGE'),
(1, 17, NULL, 'SIDI OUIS', 'DG'),
(2, 18, NULL, 'ROUABHIA', 'CB'),
(3, 19, NULL, 'YOUSFI', 'DESU');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `CATEGORY_ID` int NOT NULL,
  `CATEGORY_NAME` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`CATEGORY_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`CATEGORY_ID`, `CATEGORY_NAME`) VALUES
(0, 'EOA 1'),
(1, 'Master'),
(2, 'Etat-Major'),
(3, 'Spécialisation'),
(4, 'Recyclage'),
(5, 'EOA 2'),
(6, 'EOA 3'),
(7, 'CPO');

-- --------------------------------------------------------

--
-- Table structure for table `class`
--

DROP TABLE IF EXISTS `class`;
CREATE TABLE IF NOT EXISTS `class` (
  `CLASS_ID` int NOT NULL,
  `USER_ID` int NOT NULL,
  `CLASS_NAME` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`CLASS_ID`),
  KEY `FK_CLASS_CLASS_USE_USER_ACC` (`USER_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `class`
--

INSERT INTO `class` (`CLASS_ID`, `USER_ID`, `CLASS_NAME`) VALUES
(0, 0, 'Class 1'),
(10, 10, 'Class 11'),
(9, 9, 'Class 10'),
(8, 8, 'Class 9'),
(7, 7, 'Class 8'),
(6, 6, 'Class 7'),
(5, 5, 'Class 6'),
(4, 4, 'Class 5'),
(3, 3, 'Class 4'),
(2, 2, 'Class 3'),
(1, 1, 'Class 2'),
(11, 11, 'Class 12'),
(12, 12, 'Class 13'),
(13, 13, 'Class 14'),
(14, 14, 'Class 15'),
(15, 15, 'Class 16');

-- --------------------------------------------------------

--
-- Table structure for table `major`
--

DROP TABLE IF EXISTS `major`;
CREATE TABLE IF NOT EXISTS `major` (
  `MAJOR_ID` varchar(12) NOT NULL,
  `MAJOR_NAME` varchar(48) DEFAULT NULL,
  PRIMARY KEY (`MAJOR_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `major`
--

INSERT INTO `major` (`MAJOR_ID`, `MAJOR_NAME`) VALUES
('0', 'Algorithms 1'),
('1', 'Algorithms 2');

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
CREATE TABLE IF NOT EXISTS `notification` (
  `NOTIFICATION_ID` int NOT NULL,
  PRIMARY KEY (`NOTIFICATION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `observation`
--

DROP TABLE IF EXISTS `observation`;
CREATE TABLE IF NOT EXISTS `observation` (
  `OBSERVATION_ID` int NOT NULL,
  `STUDY_SESSION_ID` int NOT NULL,
  PRIMARY KEY (`OBSERVATION_ID`),
  KEY `FK_OBSERVAT_HAPPENS_I_STUDY_SE` (`STUDY_SESSION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `receives`
--

DROP TABLE IF EXISTS `receives`;
CREATE TABLE IF NOT EXISTS `receives` (
  `NOTIFICATION_ID` int NOT NULL,
  `ADMINISTRATOR_ID` int NOT NULL,
  PRIMARY KEY (`NOTIFICATION_ID`,`ADMINISTRATOR_ID`),
  KEY `FK_RECEIVES_RECEIVES_ADMINIST` (`ADMINISTRATOR_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `section`
--

DROP TABLE IF EXISTS `section`;
CREATE TABLE IF NOT EXISTS `section` (
  `SECTION_ID` int NOT NULL,
  `CATEGORY_ID` int NOT NULL,
  `SECTION_NAME` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`SECTION_ID`),
  KEY `FK_SECTION_BELONGS_T_CATEGORY` (`CATEGORY_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `section`
--

INSERT INTO `section` (`SECTION_ID`, `CATEGORY_ID`, `SECTION_NAME`) VALUES
(0, 0, 'Section 1 EOA 1'),
(1, 0, 'Section 2 EOA 1'),
(2, 0, 'Section 3 EOA 1'),
(3, 0, 'Section 4 EOA 1'),
(5, 5, 'Section 1 EOA 2'),
(4, 1, 'Section Master'),
(6, 5, 'Section 2 EOA 2'),
(7, 5, 'Section 3 EOA 2'),
(8, 5, 'Section 4 EOA 2'),
(9, 6, 'Section 1 EOA 3'),
(10, 6, 'Section 2 EOA 3'),
(11, 6, 'Section 3 EOA 3'),
(12, 6, 'Section 4 EOA 3'),
(13, 7, 'Section 1 CPO '),
(14, 7, 'Section 2 CPO '),
(15, 2, 'Section 1 Etat-Major'),
(16, 2, 'Section 1 Etat-Major'),
(17, 4, 'Section 1 Recyclage '),
(18, 4, 'Section 2 Recyclage '),
(19, 3, 'Section Spécialisation');

-- --------------------------------------------------------

--
-- Table structure for table `sends`
--

DROP TABLE IF EXISTS `sends`;
CREATE TABLE IF NOT EXISTS `sends` (
  `NOTIFICATION_ID` int NOT NULL,
  `CLASS_ID` int NOT NULL,
  PRIMARY KEY (`NOTIFICATION_ID`,`CLASS_ID`),
  KEY `FK_SENDS_SENDS_CLASS` (`CLASS_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
CREATE TABLE IF NOT EXISTS `student` (
  `STUDENT_SERIAL_NUMBER` varchar(16) NOT NULL,
  `CATEGORY_ID` int NOT NULL,
  `SECTION_ID` int NOT NULL,
  `STUDENT_FIRST_NAME` varchar(24) DEFAULT NULL,
  `STUDENT_LAST_NAME` varchar(24) DEFAULT NULL,
  `STUDNET_GRADE` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`STUDENT_SERIAL_NUMBER`),
  KEY `FK_STUDENT_BELONGS_T_SECTION` (`SECTION_ID`),
  KEY `FK_STUDENT_IS_OF_CAT_CATEGORY` (`CATEGORY_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`STUDENT_SERIAL_NUMBER`, `CATEGORY_ID`, `SECTION_ID`, `STUDENT_FIRST_NAME`, `STUDENT_LAST_NAME`, `STUDNET_GRADE`) VALUES
('0', 0, 0, 'Ahmad', 'MAHMOUD', 'EOA'),
('1', 0, 0, 'Yazid', 'BELFRAG', 'EOA'),
('2', 0, 1, 'Mohamed Wassim', 'OUHAB', 'EOA');

-- --------------------------------------------------------

--
-- Table structure for table `student_gets_absent`
--

DROP TABLE IF EXISTS `student_gets_absent`;
CREATE TABLE IF NOT EXISTS `student_gets_absent` (
  `STUDENT_SERIAL_NUMBER` varchar(16) NOT NULL,
  `ABSENCE_ID` int NOT NULL,
  PRIMARY KEY (`STUDENT_SERIAL_NUMBER`,`ABSENCE_ID`),
  KEY `FK_STUDENT__STUDENT_G_ABSENCE` (`ABSENCE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `studies`
--

DROP TABLE IF EXISTS `studies`;
CREATE TABLE IF NOT EXISTS `studies` (
  `SECTION_ID` int NOT NULL,
  `MAJOR_ID` varchar(12) NOT NULL,
  PRIMARY KEY (`SECTION_ID`,`MAJOR_ID`),
  KEY `FK_STUDIES_STUDIES_MAJOR` (`MAJOR_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `studies`
--

INSERT INTO `studies` (`SECTION_ID`, `MAJOR_ID`) VALUES
(0, '0'),
(1, '0');

-- --------------------------------------------------------

--
-- Table structure for table `studies_in`
--

DROP TABLE IF EXISTS `studies_in`;
CREATE TABLE IF NOT EXISTS `studies_in` (
  `SECTION_ID` int NOT NULL,
  `STUDY_SESSION_ID` int NOT NULL,
  PRIMARY KEY (`SECTION_ID`,`STUDY_SESSION_ID`),
  KEY `FK_STUDIES__STUDIES_I_STUDY_SE` (`STUDY_SESSION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `study_session`
--

DROP TABLE IF EXISTS `study_session`;
CREATE TABLE IF NOT EXISTS `study_session` (
  `STUDY_SESSION_ID` int NOT NULL,
  `TEACHER_SERIAL_NUMBER` varchar(16) NOT NULL,
  `STUDY_SESSION_DATE` date DEFAULT NULL,
  `STUDY_SESSION_START_TIME` time DEFAULT NULL,
  `STUDY_SESSION_END_TIME` time DEFAULT NULL,
  PRIMARY KEY (`STUDY_SESSION_ID`),
  KEY `FK_STUDY_SE_TEACHES_I_TEACHER` (`TEACHER_SERIAL_NUMBER`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `teacher`
--

DROP TABLE IF EXISTS `teacher`;
CREATE TABLE IF NOT EXISTS `teacher` (
  `TEACHER_SERIAL_NUMBER` varchar(16) NOT NULL,
  `TEACHER_GRADE` varchar(24) DEFAULT NULL,
  `TEACHER_FIRST_NAME` varchar(24) DEFAULT NULL,
  `TEACHER_LAST_NAME` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`TEACHER_SERIAL_NUMBER`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `teacher`
--

INSERT INTO `teacher` (`TEACHER_SERIAL_NUMBER`, `TEACHER_GRADE`, `TEACHER_FIRST_NAME`, `TEACHER_LAST_NAME`) VALUES
('0', 'PCA', 'Mohamed', 'MERINE'),
('1', 'PCA', 'Mustapha', 'AHMED');

-- --------------------------------------------------------

--
-- Table structure for table `teacher_makes_an_observation_for_a_student`
--

DROP TABLE IF EXISTS `teacher_makes_an_observation_for_a_student`;
CREATE TABLE IF NOT EXISTS `teacher_makes_an_observation_for_a_student` (
  `STUDENT_SERIAL_NUMBER` varchar(16) NOT NULL,
  `OBSERVATION_ID` int NOT NULL,
  `TEACHER_SERIAL_NUMBER` varchar(16) NOT NULL,
  `OBSERVATION_DATE_AND_TIME` datetime DEFAULT NULL,
  `OBSERVATION_MOTIF` varchar(30) DEFAULT NULL,
  `OBSERVATION_NOTE` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`STUDENT_SERIAL_NUMBER`,`OBSERVATION_ID`,`TEACHER_SERIAL_NUMBER`),
  KEY `FK_TEACHER__TEACHER_M_TEACHER` (`TEACHER_SERIAL_NUMBER`),
  KEY `FK_TEACHER__TEACHER_M_OBSERVAT` (`OBSERVATION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `teaches`
--

DROP TABLE IF EXISTS `teaches`;
CREATE TABLE IF NOT EXISTS `teaches` (
  `MAJOR_ID` varchar(12) NOT NULL,
  `TEACHER_SERIAL_NUMBER` varchar(16) NOT NULL,
  PRIMARY KEY (`MAJOR_ID`,`TEACHER_SERIAL_NUMBER`),
  KEY `FK_TEACHES_TEACHES_TEACHER` (`TEACHER_SERIAL_NUMBER`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `teaches`
--

INSERT INTO `teaches` (`MAJOR_ID`, `TEACHER_SERIAL_NUMBER`) VALUES
('0', '0'),
('1', '0');

-- --------------------------------------------------------

--
-- Table structure for table `user_account`
--

DROP TABLE IF EXISTS `user_account`;
CREATE TABLE IF NOT EXISTS `user_account` (
  `USER_ID` int NOT NULL,
  `USERNAME` varchar(30) DEFAULT NULL,
  `PASSWORD_HASH` varchar(1024) DEFAULT NULL,
  `EMAIL` varchar(60) DEFAULT NULL,
  `ROLE` varchar(15) DEFAULT NULL,
  `ACCOUNT_STATUS` varchar(12) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `LAST_LOGIN_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`USER_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_account`
--

INSERT INTO `user_account` (`USER_ID`, `USERNAME`, `PASSWORD_HASH`, `EMAIL`, `ROLE`, `ACCOUNT_STATUS`, `CREATED_AT`, `LAST_LOGIN_AT`) VALUES
(0, 'class1', '$2y$10$eG.G4uYboUptUl1aZgks2OgL8xm3635WwiEyye2eenq2hYppEhhrK', 'class1@esam.com', 'Class', 'Active', NULL, NULL),
(10, 'class11', '$2y$10$/R0OW2XX72Xc5S1zKOEJkeEGbZnvsuXypHAjout9keVAFTMaVMCyy', 'class11@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(9, 'class10', '$2y$10$qMbXavmNkD4giHSVOe7v.uz7Ob9QxdMdkxUIPzKGWWbhN.R/HZ6Mm', 'class10@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(8, 'class9', '$2y$10$1k4bZr8zTF.KQ8gaMUGwROy9K/IOYiW.DkAuX.fUgYsjBUTgjE.lW', 'class9@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(7, 'class8', '$2y$10$n1sILIqqUgRa8OmrMG.S2u9hjoS45XZPaVZB40Yp2wfiC5Gc4Q8HC', 'class8@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(6, 'class7', '$2y$10$ivPlKI//OCN21Xzf581MgeFVYwh3qhzjVVl9mSQkLqUtKifWsIfAq', 'class7@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(5, 'class6', '$2y$10$SKZO9lQbuH6m1GGefxCaNuK8sddbSi6r2ozV4I2UrcR.Lre0Akqi2', 'class6@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(4, 'class5', '$2y$10$FLRkxbppIpIysqQQwS4WTu9VXBVJa3IaylffkZloRYoe4z8s8vIWW', 'class5@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(3, 'class4', '$2y$10$BKEm5CMF/1b/SDFv6p8LteBmClLiHzyACx31SdDiINDZtJOYJoUuO', 'class4@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(2, 'class3', '$2y$10$AbfPv14f3QA0dKGj/rrxiOMiyqLQ3DfMDcNbM5kJ4UlomNuamEiFS', 'class3@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(1, 'class2', '$2y$10$4DQ47Ba962Qzh/39oXFgee3.ipBKFnPq/BNz9/GiUlTUMYWnnW6I2', 'class2@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(11, 'class12', '$2y$10$EWiEJIgsqg7bBNl7s7EMDOlytJPpkXafd5tZYbXlb/rA5mKxyup8m', 'class12@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(12, 'class13', '$2y$10$PcAnxb1wyPszF3IrfOxJD.TSERpPmIO9qswIyRz40AuvJnC8HzT9q', 'class13@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(13, 'class14', '$2y$10$Gd3WmwpZ6FZdvVKTr0FRteWI4TBrkxtVkH1jBRX2GLfO9DQubOk12', 'class14@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(14, 'class15', '$2y$10$io4iRUEzbh1uNj4iWbgHGewsaNek6NvuEE7LK9/Saw6aK0C46LWXK', 'class15@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(15, 'class16', '$2y$10$ih.JnG/bNkI6MEMpF8Y.F.2sHhCSqunyVOaPcWiQ0RlXiZJUcquem', 'class16@esam.com', 'Class', 'Active', '2025-10-20 15:16:19', NULL),
(16, 'DGE', '$2y$10$.qFVX3ttdXaaDOhwup9A2.A80MVvdXJG2yOQ/GvgpqrGuzUSSEvfm', 'dge@esam.com', 'Admin', 'Active', '2025-10-20 15:10:28', NULL),
(17, 'PC', '$2y$10$geNifHuPtB5ovVRDBEu00elU3LFvmAd9OqVA5exUKJMzTpAw4TD72', 'pc@esam.com', 'Admin', 'Active', '2025-10-20 15:10:28', NULL),
(18, 'brigade', '$2y$10$/ka2KF8Ve8uLUoCoLfKVhOFX.menm8WAVwupitFDufV0YXWdoLB/S', 'brigade@esam.com', 'Admin', 'Active', NULL, NULL),
(19, 'DESU', '$2y$10$mgBz33/39eAKEivE50mxFedWY2RcM11909hf0lUe2G0JTk344HEYC', 'desu@esam.com', 'Admin', 'Active', NULL, NULL);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
