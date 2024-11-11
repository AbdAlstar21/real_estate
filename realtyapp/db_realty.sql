-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Aug 11, 2023 at 03:20 PM
-- Server version: 5.7.31
-- PHP Version: 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_realty`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `cat_id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cat_image` varchar(1700) COLLATE utf8mb4_bin DEFAULT NULL,
  `cat_thumbnail` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL,
  `cat_date` date DEFAULT NULL,
  PRIMARY KEY (`cat_id`)
) ENGINE=MyISAM AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`cat_id`, `cat_name`, `cat_image`, `cat_thumbnail`, `cat_date`) VALUES
(34, 'مخزن', '91c9183fba085abc82296f1a1e09584f.png', '33ccd8a6a560b9d2f9c13f7469ddf7e8.png', '2023-08-04'),
(45, 'قصر', '44137b7894fd6c408b18b602a13a69e0.jpg', 'dea1a5b1ab7650fb6eff7396bf4e4eff.jpg', '2023-08-06'),
(28, 'مزرعة', 'd94707febc91b5e55cd8993b3424ed06.png', '354c81359ee62b18d0441dcf22c515a1.png', '2023-08-04'),
(30, 'شقة', '70b9d812ceac1ed06429ac41045965b7.png', 'b0ac98a9f937c34f8a2b9e243e503f5f.png', '2023-08-04'),
(31, 'محل', '3619a7543a726e64cd09d2435c2c3ce4.jpg', 'c668a76acda8d7d24736f79b071d2c0d.jpg', '2023-08-04'),
(26, 'أرض', 'fc5b89a02c2f8bf66d2c08eac5b803f5.png', '09d61c5cb3adf5e45e464f0a9b66b991.png', '2023-08-04'),
(32, 'بناية', 'f37ff7c9b9c0349cf56e24e979c2fc78.png', '4ae32433a7b0b7a26ed495cebce7e1e3.png', '2023-08-04'),
(33, 'بيت عربي', '81583762000153411793de3b31d693b5.png', '869123ed466a3b3aeb14499382b37730.png', '2023-08-04');

-- --------------------------------------------------------

--
-- Table structure for table `favorite`
--

DROP TABLE IF EXISTS `favorite`;
CREATE TABLE IF NOT EXISTS `favorite` (
  `fav_id` int(11) NOT NULL AUTO_INCREMENT,
  `realty_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `fav_date` datetime DEFAULT NULL,
  PRIMARY KEY (`fav_id`)
) ENGINE=MyISAM AUTO_INCREMENT=813 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `favorite`
--

INSERT INTO `favorite` (`fav_id`, `realty_id`, `user_id`, `fav_date`) VALUES
(812, 157, 167, '2023-08-11 11:17:35'),
(437, 138, 160, '2023-07-31 20:04:07'),
(809, 157, 145, '2023-08-10 00:05:37'),
(436, 139, 159, '2023-07-31 18:10:24'),
(810, 6, 145, '2023-08-10 00:07:48');

-- --------------------------------------------------------

--
-- Table structure for table `realtys`
--

DROP TABLE IF EXISTS `realtys`;
CREATE TABLE IF NOT EXISTS `realtys` (
  `realty_id` int(64) NOT NULL AUTO_INCREMENT,
  `cat_id` int(11) NOT NULL,
  `realty_short_title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `number_phone` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `realty_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `realty_block` tinyint(1) DEFAULT NULL,
  `realty_summary` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `realty_date` date DEFAULT NULL,
  `realty_token` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `realty_image` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL,
  `realty_thumbnail` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL,
  `realty_file` varchar(112) COLLATE utf8mb4_bin DEFAULT NULL,
  `realty_fav_number` int(11) DEFAULT NULL,
  `realty_publisher` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL,
  `realty_price` text COLLATE utf8mb4_bin,
  PRIMARY KEY (`realty_id`)
) ENGINE=MyISAM AUTO_INCREMENT=164 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `realtys`
--

INSERT INTO `realtys` (`realty_id`, `cat_id`, `realty_short_title`, `number_phone`, `realty_type`, `realty_block`, `realty_summary`, `realty_date`, `realty_token`, `realty_image`, `realty_thumbnail`, `realty_file`, `realty_fav_number`, `realty_publisher`, `realty_price`) VALUES
(2, 30, 'شقة طابق 2 في معرة مصرين', '+3404605026568', 'آجار', 0, 'شقة طابق 2 مكونة من 5 غرف ومطبخ وحمام ،\nالعنوان : معرة مصرين - طريق كفر يحمول', '2023-08-04', 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '792136ea8258e2a35f40b86dd3291e19.jpg', 'aeb540d935725f8fb63bbfd434d96e4e.jpg', NULL, 2, '', '100'),
(3, 28, 'مزرعة طابقين مع مسبح - بنش', '+3069489027646', 'بيع', 0, 'مزرعة طابقين كل طابق مكون من 9 غرف ومطبخ وحمام ، يوجد مسبح عمق 3 متر أبعاد 5*4 .\r\nالعنوان : طريق بنش الفوعة.', '2023-08-04', 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', 'a5e54b76a1c5281ecbac1f3201563300.jpg', 'dc2388cf6db5d61253665c9b50be8696.jpg', NULL, 5, '', '80000'),
(4, 33, 'بيت عربي - سرمين', '+85552245212113', 'آجار', 0, 'بيت عربي ضمن مدينة سرمين 8 غرف للآجار \r\nالعنوان :سرمين  ', '2023-08-04', 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', 'e5b6cc1b6318ef8bd42fb88dccadbb90.jpg', '76a3bc84bff053a5ce491962fcc9df48.jpg', NULL, 12, '', '70'),
(156, 28, 'مزرعة طابقين مع مسبح - بنش', '+3069489027646', 'بيع', 0, 'مزرعة طابقين كل طابق مكون من 9 غرف ومطبخ وحمام ، يوجد مسبح عمق 3 متر أبعاد 5*4 .\nالعنوان : طريق بنش الفوعة.', '2023-08-04', 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', 'a5e54b76a1c5281ecbac1f3201563300.jpg', 'dc2388cf6db5d61253665c9b50be8696.jpg', NULL, 7, '', '80000'),
(157, 33, 'بيت عربي - بنش', '+85552245212113', 'آجار', 0, 'بيت عربي ضمن مدينة بنش 3 غرف للآجار \nالعنوان :بالقرب من الجامع الكبير في بنش', '2023-08-04', 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '87a51002a2f420fd2206738b5f7364fe.jpg', '937e6ea3d4d539f651d98d4860f59df9.jpg', NULL, 26, '', '20'),
(5, 28, 'مزرعة طابقين مع مسبح - بنش', '+3069489027646', 'بيع', 0, 'مزرعة طابقين كل طابق مكون من 9 غرف ومطبخ وحمام ، يوجد مسبح عمق 3 متر أبعاد 5*4 .\r\nالعنوان : طريق بنش الفوعة.', '2023-08-04', 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', 'a5e54b76a1c5281ecbac1f3201563300.jpg', 'dc2388cf6db5d61253665c9b50be8696.jpg', NULL, 5, '', '80000'),
(7, 26, 'أرض زراعية - طريق بنش - تفتناز', '+96396396393936', 'بيع', 0, 'أرض زراعية 15 دونم - تحوي 30 شجرة زيتون و 20 تين \nللبيع بسعر 30000 دولار ، العنوان طريق بنش تفتناز ', '2023-08-04', 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '281fc37421c4f0175f9a6bf1a3b3022c.jpg', 'ceb9c593484c42938dbf2c00ecd15238.jpg', NULL, 18, '', '30000'),
(8, 28, 'مزرعة حول مدينة إدلب', '+9639693707778', 'بيع', 0, 'مزرعة طابقين مساحة 200 م غربي مدينة إدلب بالقرب من دوار الفلاحين', '2023-08-04', 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '1a0d87bf218bbca93caf9d52bf09b76e.jpg', 'e28811899b7fdfe29999d934e2de9c55.jpg', NULL, 9, '', '25000'),
(9, 31, 'محل للآجار طريق ادلب بنش', '+3404605026568', 'آجار', 0, 'مجموعة من المحلات آجار كل محل 100 دولار ، العنوان : دوار المحراب - طرق ادلب - بنش', '2023-08-04', 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '892f5866e65f1abe03d30d6eafcb1959.jpg', '0927afc9076cfff5f8defba13ae7ddb3.jpg', NULL, 2, '', '100'),
(10, 31, 'محل للآجار مدينة ادلب دوار الساعة', '+5504605026568', 'آجار', 0, 'محل للآجار ضمن مدينة ادلب \nالعنوان:  دوار الساعة - محلات السعد', '2023-08-04', 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '471007398871d43f43fc0d61ade75c43.jpg', '71d06cac20f6d68cc9a7a65f523e3157.jpg', NULL, 2, '', '200');

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
CREATE TABLE IF NOT EXISTS `reports` (
  `rep_id` int(11) NOT NULL AUTO_INCREMENT,
  `realty_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rep_note` varchar(1024) COLLATE utf8mb4_bin NOT NULL,
  `rep_datetime` datetime NOT NULL,
  `realty_short_title` varchar(560) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`rep_id`)
) ENGINE=MyISAM AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`rep_id`, `realty_id`, `user_id`, `rep_note`, `rep_datetime`, `realty_short_title`) VALUES
(110, 10, 145, '5555', '2023-08-10 00:20:14', 'محل للآجار مدينة ادلب دوار الساعة'),
(113, 6, 167, 'ملاحظة', '2023-08-11 11:16:55', 'بيت عربي - سلقين'),
(96, 162, 145, '55454545', '2023-08-09 22:33:01', 'مزرعة حول مدينة إدلب'),
(111, 7, 145, '2312323', '2023-08-10 00:24:50', 'أرض زراعية - طريق بنش - تفتناز');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(250) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `user_email` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `user_password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_datetime` datetime NOT NULL,
  `user_active` tinyint(1) DEFAULT NULL,
  `user_token` varchar(500) COLLATE utf8mb4_bin NOT NULL,
  `user_lastdate` datetime NOT NULL,
  `user_note` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_image` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_thumbnail` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=168 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `user_email`, `user_password`, `user_datetime`, `user_active`, `user_token`, `user_lastdate`, `user_note`, `user_image`, `user_thumbnail`) VALUES
(2, 'admin', 'admin', 'admin', '2022-08-04 17:31:04', 0, 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '2022-08-04 17:31:04', '', '029c03fe5eaaa73745fdcc0dbb575572.jpg', 'f550098ed3ee0561cf54e622be6a91ae.jpg'),
(145, 'AbdAlsattar Alshiekh', 'abdalstaralshek21@gmail.com', '123456789', '2022-08-03 20:55:02', 0, 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '2022-08-03 21:18:09', 'مالك ومشرف', 'fb735488c69125a5f8aeb6580a2f4e52.png', 'e1cafe810fc47a0b5276ee9479e39c1b.png'),
(154, 'جميل خالد الأحمد', 'gameel216@gmial.com', '123456789', '2022-08-04 17:29:55', 0, 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '2022-08-04 17:29:55', '', '0866a3ce0080e96155501cf9c8141ba5.jpg', 'a6a022e3e5ed18b3fb11da4627ec6bc0.jpg'),
(151, 'أحمد الخالد', 'ahmead123@gmail.com', '123456789', '2022-08-04 17:25:44', 0, 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '2022-08-04 17:25:44', '', '905c22ef5f0389144d1eac22ddc3b5ae.jpg', 'e9b83b1641bd77018ebd53be7c2cb17d.jpg'),
(152, 'Mohamed Kamel', 'Moh1341@gmail.com', '123456789', '2022-08-04 17:27:05', 0, 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '2022-08-04 17:27:05', '', '4f50a31ee17bd7f74b83b3fa2ff1d1e8.png', '57e76568de52d4b4bd3b09f6b2858d54.png'),
(157, 'Ahmed Almoas', 'ahmma1@gmail.com', 'kcxm,czxm,.', '2022-08-04 17:33:02', 0, 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '2022-08-04 17:33:02', '', '', ''),
(1, 'admin', 'admin@gmail.com', '12345678', '2022-09-10 06:54:53', 1, 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '2022-09-10 06:54:53', '', 'c3da709836c3a1ce3e6ce597024f3995.jpg', 'fee69635a310c141d1e5feea69945e11.jpg'),
(159, 'bbb', 'bbb@gmail.com', '123456789', '2022-09-10 13:26:56', 0, 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '2022-09-10 13:26:56', '', '64536a82ce1bd41fd72a34bc8ecf6e40.jpg', '278be87aa2613d2b9402305c32f1b890.jpg'),
(160, 'aaa', 'aaa@gmail.com', '123456789', '2022-09-10 13:30:55', 0, 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '2022-09-10 13:30:55', '', '74f455bc76e2791a61f7a26ec5d4f967.jpg', '9bb8d1f121ba625c5f32f6bf1fd8e16d.jpg'),
(161, 'ahmed', 'ahmed@gmail.com', '123456789', '2022-09-10 14:06:33', 0, 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '2022-09-10 14:06:33', '', '141fd0db03c6c14511ddff238d8840ef.jpg', '843d1e754ceff5a5322461d1ad52875a.jpg'),
(162, 'kaled', 'kaled@gmail.com', '123456789', '2022-11-05 08:16:47', 0, 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '2022-11-05 08:16:47', '', '1475ca42481f1a09606ddf9bbc2f0dbe.jpg', 'ded14df99f2113289178012f863034c9.jpg'),
(167, 'it', 'it@gmail.com', '123456789', '2023-08-11 10:25:46', 0, 'dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688', '2023-08-11 10:25:46', '', 'fb1a9b3e9f14fc5f4a334b24cf18e78a.jpg', 'e9bbb40839e6618aafbad554ab0f5eb5.jpg');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
