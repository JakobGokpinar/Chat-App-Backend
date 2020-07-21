-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: 21. Jul, 2020 19:58 PM
-- Tjener-versjon: 5.7.30
-- PHP Version: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ahmetgkp_chatApp`
--

DELIMITER $$
--
-- Prosedyrer
--
CREATE  PROCEDURE `addFriend` (`adder` VARCHAR(25), `added` VARCHAR(25))  BEGIN
    call deleteRequest(adder,added);
    INSERT INTO friends (person1, person2) VALUES(adder, added);
END$$

CREATE  PROCEDURE `addNotification` (IN `sender` VARCHAR(25), IN `receiver` VARCHAR(25), IN `counts` INT)  BEGIN
    IF (EXISTS (SELECT * FROM notiftable WHERE notiftable.sender = sender AND notiftable.receiver = receiver))
    THEN
        UPDATE notiftable SET notiftable.counts = notiftable.counts + counts WHERE notiftable.sender = sender AND notiftable.receiver = receiver;
    ELSE
        INSERT INTO notiftable(sender, receiver, counts) VALUES(sender, receiver, counts);
    END IF;
END$$

CREATE  PROCEDURE `addProfilePhoto` (`user` VARCHAR(25), `profilePhoto` LONGBLOB)  BEGIN
    UPDATE users SET photo = profilePhoto WHERE username = user;
END$$

CREATE  PROCEDURE `deleteRequest` (`person1` VARCHAR(25), `person2` VARCHAR(25))  BEGIN
    DELETE FROM requeststable WHERE (receiver=person1 AND sender=person2) OR (sender=person2 AND receiver=person1);
END$$

CREATE  PROCEDURE `getFriends` (IN `person` VARCHAR(25))  BEGIN
	CREATE TEMPORARY TABLE tmp2_erasmus_muharrem AS 
    (
        SELECT id, sender, receiver, msg, IFNULL(history, NOW()) as history FROM (
            SELECT id, sender, receiver, msg, history from messagetable WHERE
            messagetable.receiver = person
            UNION
            SELECT id, receiver as sender, sender as receiver, msg, history from messagetable WHERE 
            messagetable.sender = person 
        ) AS `mehmet_bahceli`
    );

    SELECT temp_friends.friend, IFNULL(temp_notif.counts, 0) as counts, IFNULL(temp_messages.msg, "no message") as lastmsg, IFNULL( TIMEDIFF(NOW(), temp_messages.history), "no date") as lastdate
    FROM 
    (
        SELECT person2 as friend  FROM friends WHERE person1= person
        UNION
        SELECT person1 as friend FROM friends WHERE person2=person
    ) AS `temp_friends`
    LEFT JOIN 
    (
        SELECT sender, counts FROM notiftable WHERE receiver = person
    ) AS `temp_notif`
    ON temp_notif.sender = temp_friends.friend
    LEFT JOIN
    ( 
        SELECT * FROM (
            SELECT DISTINCT sender, receiver, msg, history FROM 
            `tmp2_erasmus_muharrem`
            ORDER BY id DESC LIMIT 18446744073709551615  
        ) AS `mehmet_bacheli_2`
        GROUP BY
        sender, receiver
    ) AS `temp_messages`
    ON temp_messages.sender = temp_friends.friend;
END$$

CREATE  PROCEDURE `getMessage` (IN `sender` VARCHAR(25), IN `receiver` VARCHAR(25))  BEGIN
    SELECT * FROM messagetable WHERE messagetable.sender = sender AND messagetable.receiver = receiver
    UNION
    SELECT * FROM messagetable WHERE messagetable.sender = receiver AND messagetable.receiver = sender
    ORDER BY id;
END$$

CREATE  PROCEDURE `getNotification` (IN `receiver` VARCHAR(25), IN `sender` VARCHAR(25))  BEGIN
    IF (EXISTS (SELECT * FROM notiftable WHERE notiftable.sender = sender AND notiftable.receiver = receiver))
    THEN
        SELECT (counts) FROM notiftable WHERE notiftable.sender = sender AND notiftable.receiver = receiver;
    ELSE
        SELECT 0 as counts;
    END IF;
END$$

CREATE  PROCEDURE `getRejected` (`blockerUser` VARCHAR(25), `blockedUser` VARCHAR(25))  BEGIN
    SELECT blocker as rejectuser FROM blacklist WHERE blocker = blockerUser AND blocked = blockedUser;
END$$

CREATE  PROCEDURE `getRequests` (`person` VARCHAR(25))  BEGIN
    SELECT sender as request FROM requeststable WHERE receiver=person;
END$$

CREATE  PROCEDURE `rejectUser` (`blocker` VARCHAR(25), `blocked` VARCHAR(25))  BEGIN
    DELETE FROM requeststable WHERE receiver=blocker AND sender=blocked;
    INSERT INTO blacklist(blocker, blocked) VALUES(blocker, blocked);
END$$

CREATE  PROCEDURE `sendMessage` (IN `sender` VARCHAR(25), IN `receiver` VARCHAR(25), IN `msg` VARCHAR(255))  BEGIN
    INSERT INTO messagetable(sender,receiver,msg,history) VALUES(sender, receiver, msg, NOW());
    CALL addNotification(sender, receiver, 1);
END$$

CREATE  PROCEDURE `setNotification` (`receiver` VARCHAR(25), `sender` VARCHAR(25), `sayi` INTEGER)  BEGIN
    UPDATE notiftable SET notiftable.counts = sayi WHERE notiftable.sender = sender AND notiftable.receiver = receiver;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `blacklist`
--

CREATE TABLE `blacklist` (
  `id` int(11) NOT NULL,
  `blocker` varchar(25) NOT NULL,
  `blocked` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dataark for tabell `blacklist`
--

INSERT INTO `blacklist` (`id`, `blocker`, `blocked`) VALUES
(1, 'altan', 'enes'),
(2, 'hakan', 'kaan'),
(3, 'ahmet', 'jailor');

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `friends`
--

CREATE TABLE `friends` (
  `id` int(11) NOT NULL,
  `person1` varchar(25) NOT NULL,
  `person2` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dataark for tabell `friends`
--

INSERT INTO `friends` (`id`, `person1`, `person2`) VALUES
(6, 'altan', 'enes'),
(8, 'ahmet', 'hakan'),
(9, 'ahmet', 'omar'),
(14, 'altan', 'hakan'),
(15, 'ahmet', 'altan'),
(16, 'hakan', 'hakan'),
(17, 'ahmet', 'ihlasUser'),
(18, 'ahmet', 'ITC ENVER'),
(19, 'Mathias', 'ahmet'),
(20, 'Mathias', 'benim adim berkcan'),
(21, 'ITC ENVER', 'Mathias'),
(22, 'benim adim berkcan', 'ITC ENVER'),
(23, 'ihlasUser', 'ITC ENVER');

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `messagetable`
--

CREATE TABLE `messagetable` (
  `id` int(11) NOT NULL,
  `sender` varchar(25) NOT NULL,
  `receiver` varchar(25) NOT NULL,
  `msg` varchar(255) NOT NULL,
  `history` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dataark for tabell `messagetable`
--

INSERT INTO `messagetable` (`id`, `sender`, `receiver`, `msg`, `history`) VALUES
(3, 'ahmet', 'hakan', 'hellow orld!!!', '2020-07-04 00:00:00'),
(4, 'ahmet', 'hakan', 'abi kalp at', '2020-07-04 00:00:00'),
(5, 'ahmet', 'hakan', 'keko', '2020-07-04 00:00:00'),
(6, 'ahmet', 'hakan', 'ekÅŸici hakan', '2020-07-04 00:00:00'),
(7, 'ahmet', 'hakan', 'oha lannnn', '2020-07-04 00:00:00'),
(8, 'ahmet', 'hakan', 'Ã§alÄ±ÅŸÄ±orrr', '2020-07-04 00:00:00'),
(9, 'ahmet', 'hakan', 'h', '2020-07-04 00:00:00'),
(10, 'ahmet', 'hakan', 'a', '2020-07-04 00:00:00'),
(11, 'ahmet', 'hakan', 'k', '2020-07-04 00:00:00'),
(12, 'ahmet', 'hakan', 'a', '2020-07-04 00:00:00'),
(13, 'ahmet', 'hakan', 'n', '2020-07-04 00:00:00'),
(14, 'ahmet', 'altan', 'naber', '2020-07-04 00:00:00'),
(15, 'ahmet', 'altan', 'altna', '2020-07-04 00:00:00'),
(16, 'ahmet', 'hakan', 'geri', '2020-07-04 00:00:00'),
(17, 'ahmet', 'hakan', 'gelsemese', '2020-07-04 00:00:00'),
(18, 'ahmet', 'hakan', 'dÄ±rÄ±dÄ±dÄ±rdÄ±rÄ±drÄ±dÄ±rdrÄ±dÄ±rdÄ±rÄ±rdÄ±frdÄ±rÄ±rÄ±dÄ±rÄ±dÄ±rdrÄ±dÄ±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±Ä±', '2020-07-04 00:00:00'),
(19, 'ahmet', 'hakan', 'Merhabalar.24. sayÄ± ile karÅŸÄ±nÄ±zdayÄ±m. Bu hafta ilgi Ã§ekici 17 tane java yazÄ±sÄ± sizi bekliyor. FaydalÄ± olacaÄŸÄ±nÄ± umuyorum.Keyifli okumalarâ€¦The Best of Java Collections [Tutorials] (dzone.com)How to Create a Maven Plugin (dzone.com)Building J', '2020-07-04 00:00:00'),
(20, 'ahmet', 'hakan', 'kjk', '2020-07-06 00:00:00'),
(21, 'ahmet', 'hakan', 'sana', '2020-07-06 00:00:00'),
(22, 'ahmet', 'hakan', 'spam', '2020-07-06 00:00:00'),
(23, 'ahmet', 'hakan', 'yaptÄ±m', '2020-07-06 00:00:00'),
(24, 'ahmet', 'hakan', 'jfkas', '2020-07-06 00:00:00'),
(25, 'ahmet', 'hakan', 'jfksa', '2020-07-06 00:00:00'),
(26, 'ahmet', 'hakan', 'kasÄ±yor amk', '2020-07-06 00:00:00'),
(27, 'hakan', 'ahmet', 'ses', '2020-07-06 00:00:00'),
(28, 'hakan', 'ahmet', 'nie', '2020-07-06 00:00:00'),
(29, 'hakan', 'ahmet', 'alo', '2020-07-06 00:00:00'),
(30, 'hakan', 'ahmet', 'hjhjh', '2020-07-06 00:00:00'),
(31, 'hakan', 'ahmet', 'gg hakan', '2020-07-06 00:00:00'),
(32, 'hakan', 'ahmet', 'fdsafasd', '2020-07-06 00:00:00'),
(33, 'ahmet', 'hakan', 'k', '2020-07-06 00:00:00'),
(34, 'ahmet', 'hakan', 'sa', '2020-07-06 00:00:00'),
(35, 'ahmet', 'hakan', 'hi', '2020-07-06 00:00:00'),
(36, 'hakan', 'ahmet', 'kol', '2020-07-06 00:00:00'),
(37, 'ahmet', 'hakan', 'tm', '2020-07-06 00:00:00'),
(38, 'ahmet', 'hakan', 'fsafsa', '2020-07-06 00:00:00'),
(39, 'ahmet', 'hakan', 'a', '2020-07-06 00:00:00'),
(40, 'ahmet', 'hakan', 'kl', '2020-07-06 00:00:00'),
(41, 'ahmet', 'hakan', 'Ã§alÄ±ÅŸtÄ±', '2020-07-06 00:00:00'),
(42, 'ahmet', 'hakan', 'yeminle', '2020-07-06 00:00:00'),
(43, 'ahmet', 'hakan', 'alta', '2020-07-06 00:00:00'),
(44, 'ahmet', 'hakan', 'geliyor', '2020-07-06 00:00:00'),
(45, 'hakan', 'ahmet', 'dogru', '2020-07-06 00:00:00'),
(46, 'hakan', 'ahmet', 'kfajkfa', '2020-07-06 00:00:00'),
(47, 'ahmet', 'hakan', 'fas', '2020-07-06 00:00:00'),
(48, 'ahmet', 'hakan', 'mk', '2020-07-06 00:00:00'),
(49, 'ahmet', 'hakan', 'kl', '2020-07-06 00:00:00'),
(50, 'ahmet', 'hakan', 'l', '2020-07-06 00:00:00'),
(51, 'ahmet', 'hakan', 'k', '2020-07-06 00:00:00'),
(52, 'ahmet', 'hakan', 'm', '2020-07-06 00:00:00'),
(53, 'ahmet', 'hakan', 'n', '2020-07-06 00:00:00'),
(54, 'ahmet', 'hakan', 'b', '2020-07-06 00:00:00'),
(55, 'ahmet', 'hakan', 'm', '2020-07-06 00:00:00'),
(56, 'ahmet', 'hakan', 'l', '2020-07-06 00:00:00'),
(57, 'ahmet', 'hakan', 'n', '2020-07-06 00:00:00'),
(58, 'ahmet', 'hakan', 'n', '2020-07-06 00:00:00'),
(59, 'ahmet', 'hakan', 'n', '2020-07-06 00:00:00'),
(60, 'ahmet', 'hakan', 'fsa', '2020-07-07 00:00:00'),
(61, 'ahmet', 'hakan', 'fdsa', '2020-07-07 00:00:00'),
(62, 'ahmet', 'hakan', 'jakjfa', '2020-07-07 00:00:00'),
(63, 'ahmet', 'hakan', 'fsdafsa', '2020-07-07 00:00:00'),
(64, 'ahmet', 'hakan', 'sa', '2020-07-07 00:00:00'),
(65, 'hakan', 'ahmet', 'lk', '2020-07-07 00:00:00'),
(66, 'hakan', 'ahmet', '1', '2020-07-07 00:00:00'),
(67, 'hakan', 'ahmet', '2', '2020-07-07 00:00:00'),
(68, 'hakan', 'ahmet', '3', '2020-07-07 00:00:00'),
(69, 'hakan', 'ahmet', '4', '2020-07-09 22:17:00'),
(70, 'ahmet', 'hakan', 'hadi bakim', '2020-07-07 00:00:00'),
(71, 'ahmet', 'hakan', 'kl', '2020-07-07 00:00:00'),
(72, 'ahmet', 'omar', 'as', '2020-07-07 22:59:28'),
(73, 'ahmet', 'omar', 'mk', '2020-07-07 23:00:49'),
(74, 'ahmet', 'omar', 'selam', '2020-07-07 23:00:56'),
(75, 'ahmet', 'hakan', 'bana bak muharrem', '2020-07-09 22:19:30'),
(76, 'ahmet', 'hakan', 'hadi', '2020-07-10 21:54:02'),
(77, 'ahmet', 'hakan', 'lezizÃ¼l aliz', '2020-07-11 21:50:12'),
(78, 'ahmet', 'hakan', 'pardon', '2020-07-11 21:50:20'),
(79, 'hakan', 'ahmet', 'yok', '2020-07-11 21:51:36'),
(80, 'hakan', 'ahmet', 'k', '2020-07-11 21:52:10'),
(81, 'hakan', 'ahmet', 'fsa', '2020-07-11 21:56:59'),
(82, 'ahmet', 'hakan', 'a', '2020-07-11 21:57:19'),
(83, 'ahmet', 'hakan', 'a', '2020-07-11 22:01:10'),
(84, 'ahmet', 'hakan', 'm', '2020-07-11 22:10:27'),
(85, 'ahmet', 'hakan', 'm', '2020-07-11 22:11:10'),
(86, 'ahmet', 'hakan', 'a', '2020-07-11 22:16:00'),
(87, 'ahmet', 'hakan', 'a', '2020-07-11 22:16:03'),
(88, 'ahmet', 'hakan', 'tek', '2020-07-11 22:24:30'),
(89, 'ahmet', 'hakan', 'l', '2020-07-11 22:25:01'),
(90, 'ahmet', 'hakan', 'g', '2020-07-11 22:25:30'),
(91, 'ahmet', 'hakan', 'm', '2020-07-11 22:26:31'),
(92, 'ahmet', 'hakan', 'm', '2020-07-11 22:42:55'),
(93, 'ahmet', 'hakan', 'a', '2020-07-11 23:00:28'),
(94, 'ahmet', 'hakan', 'mÃ¼ko', '2020-07-11 23:00:41'),
(95, 'ahmet', 'hakan', 'oldu', '2020-07-11 23:00:44'),
(96, 'ahmet', 'hakan', 'helal', '2020-07-11 23:00:46'),
(97, 'ahmet', 'hakan', 'sana', '2020-07-11 23:00:49'),
(98, 'ahmet', 'hakan', ' hakan', '2020-07-11 23:00:51'),
(99, 'hakan', 'ahmet', 'kardes', '2020-07-11 23:01:20'),
(100, 'hakan', 'ahmet', 'ne', '2020-07-11 23:01:28'),
(101, 'hakan', 'ahmet', 'spam', '2020-07-11 23:01:30'),
(102, 'hakan', 'ahmet', 'yapÄ±yon', '2020-07-11 23:01:34'),
(103, 'hakan', 'ahmet', 'bes saaat sonra', '2020-07-11 23:01:41'),
(104, 'ahmet', 'hakan', 'hakna', '2020-07-11 23:03:21'),
(105, 'ahmet', 'hakan', 'helal', '2020-07-11 23:03:24'),
(106, 'ahmet', 'hakan', 'bi', '2020-07-11 23:03:27'),
(107, 'ahmet', 'hakan', 'tÄ±k', '2020-07-11 23:03:28'),
(108, 'ahmet', 'hakan', 'daha ', '2020-07-11 23:03:30'),
(109, 'ahmet', 'hakan', 'seri', '2020-07-11 23:03:31'),
(110, 'ahmet', 'hakan', 'kfjdask', '2020-07-11 23:03:35'),
(111, 'ahmet', 'hakan', 'kfjdsakfsa', '2020-07-11 23:03:39'),
(112, 'ahmet', 'enes', 'enes', '2020-07-11 23:04:03'),
(113, 'ahmet', 'enes', 'naber', '2020-07-11 23:04:09'),
(114, 'enes', 'ahmet', 'sana ne lannn', '2020-07-11 23:08:21'),
(115, 'ahmet', 'hakan', 'fajfa', '2020-07-12 21:42:30'),
(116, 'ahmet', 'hakan', 'kfasjkfa', '2020-07-12 21:42:32'),
(117, 'ahmet', 'hakan', 'm', '2020-07-12 21:42:33'),
(118, 'ahmet', 'hakan', 'q', '2020-07-12 21:42:35'),
(119, 'ahmet', 'hakan', 'ph be', '2020-07-12 22:38:20'),
(120, 'ahmet', 'hakan', 'abis en nasÄ±n ya', '2020-07-12 23:11:46'),
(121, 'ahmet', 'hakan', 'hello world', '2020-07-12 23:13:08'),
(122, 'hakan', 'ahmet', 'fjdaskfjalk', '2020-07-12 23:13:17'),
(123, 'ahmet', 'hakan', 'delay delay', '2020-07-12 23:13:37'),
(124, 'hakan', 'ahmet', 'efso oldu efsoooooooooooooooooooooooooo', '2020-07-12 23:13:57'),
(125, 'hakan', 'ahmet', 'deneme', '2020-07-12 23:16:55'),
(126, 'hakan', 'ahmet', 'helal', '2020-07-12 23:17:02'),
(127, 'ahmet', 'hakan', 'hela', '2020-07-12 23:17:05'),
(128, 'ahmet', 'hakan', 'helal', '2020-07-12 23:17:11'),
(129, 'hakan', 'ahmet', 'helal', '2020-07-12 23:17:15'),
(130, 'ahmet', 'hakan', 'hei', '2020-07-14 18:11:59'),
(131, 'hakan', 'ahmet', 'hei', '2020-07-14 18:14:37'),
(132, 'ahmet', 'mathias', 'mdsajhflwf', '2020-07-14 18:20:05'),
(133, 'ahmet', 'hakan', 'dasda', '2020-07-14 18:27:02'),
(134, 'ahmet', 'mathias', 'hei', '2020-07-14 18:32:51'),
(135, 'ahmet', 'mathias', 'hey corc', '2020-07-15 21:13:54'),
(136, 'ahmet', 'hakan', 'olmuyor be moruq', '2020-07-16 23:53:25'),
(137, 'hakan', 'ahmet', 'asd', '2020-07-18 20:21:51'),
(138, 'ahmet', 'hakan', 'wtf', '2020-07-18 20:21:59'),
(139, 'ahmet', 'hakan', 'hocam', '2020-07-18 20:22:03'),
(140, 'hakan', 'ahmet', 'mesajlaÅŸak', '2020-07-18 20:22:07'),
(141, 'hakan', 'ahmet', 'hocam nasÄ±lsÄ±nÄ±', '2020-07-18 20:22:16'),
(142, 'ahmet', 'hakan', 'messagÄ±mÄ± aldÄ±n mÄ±', '2020-07-18 20:22:17'),
(143, 'hakan', 'ahmet', 'hakan bey uygulamanÄ±za bok gibi dedi', '2020-07-18 20:22:25'),
(144, 'ahmet', 'hakan', 'onun ben aq :) :)', '2020-07-18 20:22:43'),
(145, 'hakan', 'ahmet', 'hocam sesli mesaj ne zman gelir', '2020-07-18 20:22:54'),
(146, 'hakan', 'ahmet', 'toprak koÃ§', '2020-07-18 20:22:58'),
(147, 'hakan', 'ahmet', '', '2020-07-18 20:23:03'),
(148, 'ahmet', 'hakan', 'ÅŸeÅŸli meÅŸaj yohh', '2020-07-18 20:23:11'),
(149, 'hakan', 'ahmet', '', '2020-07-18 20:23:12'),
(150, 'ahmet', 'hakan', 'jfkasfa', '2020-07-18 20:23:21'),
(151, 'hakan', 'ahmet', 'setnotif getnotif', '2020-07-18 20:23:23'),
(152, 'hakan', 'ahmet', 'hocam altanÄ± ekleyeyim', '2020-07-18 20:23:29'),
(153, 'altan', 'enes', 'sa', '2020-07-18 20:24:16'),
(154, 'altan', 'hakan', 'calisiyo lan', '2020-07-18 20:26:26'),
(155, 'altan', 'ahmet', 'as', '2020-07-18 20:27:52'),
(156, 'altan', 'ahmet', 'internal server error', '2020-07-18 20:28:19'),
(157, 'ahmet', 'altan', 'sa', '2020-07-18 20:28:21'),
(158, 'altan', 'ahmet', 'as', '2020-07-18 20:28:32'),
(159, 'altan', 'ahmet', 'aa', '2020-07-18 20:28:46'),
(160, 'altan', 'ahmet', '..', '2020-07-18 20:29:10'),
(161, 'altan', 'ahmet', 'sektir', '2020-07-18 20:29:19'),
(162, 'altan', 'ahmet', 'ikonlar seks gibi knk', '2020-07-18 20:29:28'),
(163, 'altan', 'ahmet', 'kanka mailbox tusuna bas', '2020-07-18 20:30:12'),
(164, 'altan', 'ahmet', 'kapa', '2020-07-18 20:30:19'),
(165, 'altan', 'ahmet', 'mik kapalÄ± mecbur burdan iletisim yapcaz asdfkasd', '2020-07-18 20:30:38'),
(166, 'ahmet', 'altan', 'dfjsalkjfka', '2020-07-18 20:30:45'),
(167, 'altan', 'ahmet', 'hardore level', '2020-07-18 20:30:47'),
(168, 'ahmet', 'altan', 'Ã¶kÃ¼z gibi kastÄ±rdÄ± amk jdaksfjlksajf', '2020-07-18 20:31:02'),
(169, 'altan', 'ahmet', 'amk pc Ã§Ã¶kcek zannediom asdfa', '2020-07-18 20:31:09'),
(170, 'ahmet', 'altan', 'uzun mesaj atÄ±nca daha Ã§ok kasÄ±your lol', '2020-07-18 20:31:20'),
(171, 'altan', 'ahmet', 'knk koda bi baksana', '2020-07-18 20:31:34'),
(172, 'altan', 'ahmet', 'thread iÃ§inde mi deil mi', '2020-07-18 20:31:40'),
(173, 'ahmet', 'altan', 'mÃ¼q', '2020-07-18 20:31:41'),
(174, 'altan', 'ahmet', 'ss', '2020-07-18 20:32:13'),
(175, 'altan', 'ahmet', 'tilt ediyo', '2020-07-18 20:34:45'),
(176, 'altan', 'ahmet', 'AYKUT ISLAK KEK VAR YÄ°CEN MÄ°', '2020-07-18 20:35:35'),
(177, 'altan', 'ahmet', 'panaroma harem ', '2020-07-18 20:35:42'),
(178, 'altan', 'ahmet', 'felsefemin yeni penceresi', '2020-07-18 20:35:50'),
(179, 'altan', 'ahmet', '<>s', '2020-07-18 20:36:06'),
(180, 'altan', 'ahmet', '<script>window.location.href=\"index.php\"</script>', '2020-07-18 20:36:37'),
(181, 'altan', 'ahmet', '5', '2020-07-18 20:36:54'),
(182, 'altan', 'ahmet', '0', '2020-07-18 20:37:00'),
(183, 'altan', 'ahmet', '0', '2020-07-18 20:37:10'),
(184, 'altan', 'ahmet', 'I', '2020-07-18 20:37:17'),
(185, 'altan', 'ahmet', 'N', '2020-07-18 20:37:23'),
(186, 'ahmet', 'altan', 'knk', '2020-07-18 20:37:32'),
(187, 'ahmet', 'altan', 'daah yavaÅŸ', '2020-07-18 20:37:44'),
(188, 'altan', 'ahmet', 'A', '2020-07-18 20:37:52'),
(189, 'ahmet', 'altan', 'Ã§ÅŸÄŸ', '2020-07-18 20:38:03'),
(190, 'altan', 'ahmet', '', '2020-07-18 20:38:18'),
(191, 'altan', 'ahmet', '', '2020-07-18 20:38:19'),
(192, 'altan', 'ahmet', '', '2020-07-18 20:38:24'),
(193, 'altan', 'ahmet', '', '2020-07-18 20:38:29'),
(194, 'altan', 'ahmet', '', '2020-07-18 20:38:39'),
(195, 'ahmet', 'altan', 'hjhj', '2020-07-18 20:41:39'),
(196, 'hakan', 'altan', 'asd', '2020-07-18 20:42:10'),
(197, 'hakan', 'altan', 'dfadsfas', '2020-07-18 20:42:24'),
(198, 'hakan', 'altan', 'optimizasyon bok', '2020-07-18 20:43:07'),
(199, 'ahmet', 'altan', 'fjdaskfja', '2020-07-18 20:45:46'),
(200, 'hakan', 'hakan', 'asd', '2020-07-18 20:54:41'),
(201, 'hakan', 'hakan', 'asd', '2020-07-18 20:54:52'),
(202, 'ahmet', 'hakan', 'tmm hocam', '2020-07-18 20:55:16'),
(203, 'hakan', '', 'selam', '2020-07-18 20:56:13'),
(204, 'hakan', '', 'selam', '2020-07-18 20:56:58'),
(205, 'hakan', 'SYSADMIN', 'selam', '2020-07-18 20:57:34'),
(206, 'ahmet', 'hakan', ':laughing:', '2020-07-18 20:59:35'),
(207, 'hakan', 'SYSADMIN', 'selam', '2020-07-18 21:01:58'),
(208, 'hakan', 'SYSADMIN', '??', '2020-07-18 21:02:10'),
(209, 'hakan', 'ahmet', '??', '2020-07-18 21:02:37'),
(210, 'hakan', 'hakan', '??', '2020-07-18 21:02:56'),
(211, 'hakan', 'hakan', 'geldi lan', '2020-07-18 21:03:03'),
(212, 'hakan', 'hakan', 'ðŸ•', '2020-07-18 21:03:13'),
(213, 'hakan', 'hakan', '', '2020-07-18 21:03:17'),
(214, 'hakan', 'hakan', 'ðŸ•ðŸŸ', '2020-07-18 21:03:22'),
(215, 'hakan', 'hakan', 'ðŸ•ðŸŸðŸ¿', '2020-07-18 21:03:35'),
(216, 'hakan', 'hakan', '', '2020-07-18 21:03:40'),
(217, 'hakan', 'hakan', '', '2020-07-18 21:03:44'),
(218, 'hakan', 'hakan', '', '2020-07-18 21:03:46'),
(219, 'hakan', 'hakan', '', '2020-07-18 21:03:52'),
(220, 'hakan', 'hakan', '', '2020-07-18 21:03:54'),
(221, 'hakan', 'hakan', '', '2020-07-18 21:03:58'),
(222, 'hakan', 'hakan', '', '2020-07-18 21:04:07'),
(223, 'hakan', 'hakan', '', '2020-07-18 21:04:13'),
(224, 'hakan', 'hakan', 'ðŸ”¥', '2020-07-18 21:04:19'),
(225, 'hakan', 'hakan', 'yeter amkkkk yeterrr', '2020-07-18 21:04:27'),
(226, 'hakan', 'hakan', 'kasÄ±yo kafayÄ± yicm', '2020-07-18 21:04:34'),
(227, 'hakan', 'hakan', 'tÃ¼plÃ¼ televizyon mu bu aw', '2020-07-18 21:04:34'),
(228, 'hakan', 'ahmet', ':ses', '2020-07-18 21:04:52'),
(229, 'hakan', 'hakan', 'as', '2020-07-18 21:06:20'),
(230, 'hakan', 'hakan', 'asd', '2020-07-18 21:07:07'),
(231, 'hakan', 'ahmet', 'fjaks', '2020-07-18 21:07:15'),
(232, 'hakan', 'ahmet', 'seks mÃ¼ptelasÄ± hakan', '2020-07-18 21:07:57'),
(233, 'hakan', 'ahmet', 'burada', '2020-07-18 21:08:12'),
(234, 'hakan', 'ahmet', 'hoce', '2020-07-18 21:08:18'),
(235, 'hakan', 'hakan', 'bla bla', '2020-07-18 21:08:19'),
(236, 'hakan', 'ahmet', 'hoceh', '2020-07-18 21:08:21'),
(237, 'hakan', 'ahmet', 'oce', '2020-07-18 21:08:28'),
(238, 'hakan', 'ahmet', 'hoce', '2020-07-18 21:08:33'),
(239, 'hakan', 'ahmet', 'hakan sen misin lan', '2020-07-18 21:08:39'),
(240, 'hakan', 'ahmet', 'benim hocam', '2020-07-18 21:08:46'),
(241, 'hakan', 'hakan', 'hakan mÄ±sÄ±n la sen', '2020-07-18 21:08:47'),
(242, 'hakan', 'ahmet', '%2fEÃœÄžðŸ•', '2020-07-18 21:09:05'),
(243, 'ahmet', 'hakan', 'cdsfs', '2020-07-18 22:48:16'),
(244, 'ahmet', 'omar', 'fdjak', '2020-07-18 23:14:31'),
(245, 'ahmet', 'omar', 'fjka', '2020-07-18 23:14:37'),
(246, 'ahmet', 'hakan', 'fdas', '2020-07-18 23:15:23'),
(247, 'ahmet', 'hakan', 'fasfa', '2020-07-18 23:15:33'),
(248, 'ahmet', 'hakan', 'ko', '2020-07-18 23:16:11'),
(249, 'ahmet', 'hakan', 'dsa', '2020-07-18 23:17:27'),
(250, 'ahmet', 'altan', 'fad', '2020-07-18 23:19:15'),
(251, 'ahmet', 'hakan', 'ko', '2020-07-18 23:19:33'),
(252, 'ahmet', 'hakan', 'hjhj', '2020-07-18 23:20:57'),
(253, 'ahmet', 'hakan', 'dsa', '2020-07-18 23:22:29'),
(254, 'ahmet', 'hakan', 'fjdas', '2020-07-18 23:25:01'),
(255, 'ahmet', 'hakan', 'fkasdjfkas', '2020-07-19 19:23:53'),
(256, 'ahmet', 'hakan', 'fdjksa', '2020-07-19 19:23:57'),
(257, 'ahmet', 'hakan', 'fjksa', '2020-07-19 19:24:01'),
(258, 'ahmet', 'hakan', 'fksajfkas', '2020-07-19 19:24:04'),
(259, 'ahmet', 'hakan', 'kfdskfjksa', '2020-07-19 19:24:06'),
(260, 'ahmet', 'hakan', 'jfkasfjkas', '2020-07-19 19:24:12'),
(261, 'ahmet', 'hakan', 'fjalkfjsak', '2020-07-19 19:24:15'),
(262, 'ahmet', 'hakan', 'fkdjsak', '2020-07-19 19:24:28'),
(263, 'ahmet', 'hakan', 'fksdajk', '2020-07-19 19:25:30'),
(264, 'ahmet', 'hakan', 'fjksa', '2020-07-19 19:25:32'),
(265, 'ahmet', 'hakan', 'fkjsk', '2020-07-19 19:25:33'),
(266, 'ahmet', 'hakan', 'fjskafksa', '2020-07-19 19:25:41'),
(267, 'ahmet', 'hakan', 'fjsakfjsa', '2020-07-19 19:25:42'),
(268, 'ahmet', 'hakan', 'kfjsakfsa', '2020-07-19 19:25:47'),
(269, 'ahmet', 'hakan', 'fjksfjks', '2020-07-19 19:25:50'),
(270, 'ahmet', 'hakan', 'dask', '2020-07-19 19:27:44'),
(271, 'ahmet', 'hakan', 'fskfas', '2020-07-19 19:27:46'),
(272, 'ahmet', 'hakan', 'kfjdska', '2020-07-19 19:27:47'),
(273, 'ahmet', 'hakan', 'fjska', '2020-07-19 19:27:49'),
(274, 'ahmet', 'hakan', 'jfksa', '2020-07-19 19:27:50'),
(275, 'ahmet', 'hakan', 'fjsdak', '2020-07-19 19:27:52'),
(276, 'ahmet', 'hakan', 'fksjk', '2020-07-19 19:27:54'),
(277, 'ahmet', 'hakan', 'jfksda', '2020-07-19 19:27:56'),
(278, 'ahmet', 'hakan', 'fjksaf', '2020-07-19 19:27:58'),
(279, 'ahmet', 'altan', 'fksafjs', '2020-07-19 19:28:49'),
(280, 'ahmet', 'altan', 'fkdsafjsak', '2020-07-19 19:28:51'),
(281, 'ahmet', 'altan', 'fkdjsk', '2020-07-19 19:28:57'),
(282, 'ahmet', 'altan', 'fdjsakfsa', '2020-07-19 19:28:59'),
(283, 'ahmet', 'altan', 'fjdskjfksa', '2020-07-19 19:29:01'),
(284, 'ahmet', 'altan', 'jkjk', '2020-07-19 19:29:12'),
(285, 'ahmet', 'hakan', 'fksaj', '2020-07-19 19:34:37'),
(286, 'ahmet', 'hakan', 'fjksfs', '2020-07-19 19:34:39'),
(287, 'ahmet', 'hakan', 'jfksajfsa', '2020-07-19 19:34:41'),
(288, 'ahmet', 'hakan', 'fjdskafjsa', '2020-07-19 19:34:44'),
(289, 'ahmet', 'hakan', 'fkjskfjsa', '2020-07-19 19:34:45'),
(290, 'ahmet', 'hakan', 'fjsak', '2020-07-19 19:35:37'),
(291, 'ahmet', 'hakan', 'kfjdsak', '2020-07-19 19:35:49'),
(292, 'ahmet', 'hakan', 'hjhj', '2020-07-19 19:36:56'),
(293, 'ahmet', 'hakan', 'jkj', '2020-07-19 19:37:34'),
(294, 'ahmet', 'hakan', 'jk', '2020-07-19 19:38:08'),
(295, 'ahmet', 'hakan', 'fjdksk', '2020-07-19 19:42:51'),
(296, 'ahmet', 'hakan', 'fjskafjsa', '2020-07-19 19:43:05'),
(297, 'ahmet', 'hakan', 'fjdskfjsa', '2020-07-19 19:43:25'),
(298, 'ahmet', 'hakan', 'fjkdsfjsa', '2020-07-19 19:43:54'),
(299, 'ahmet', 'hakan', 'fjskfjsa', '2020-07-19 19:58:58'),
(300, 'ahmet', 'hakan', 'fjdskfjsa', '2020-07-19 20:00:44'),
(301, 'ahmet', 'hakan', 'fjdksfjsak', '2020-07-19 20:00:51'),
(302, 'ahmet', 'hakan', 'jkjkj', '2020-07-19 20:00:58'),
(303, 'ahmet', 'hakan', 'jkjk', '2020-07-19 20:01:02'),
(304, 'ahmet', 'hakan', 'jkjk', '2020-07-19 20:01:06'),
(305, 'ahmet', 'hakan', 'jkjk', '2020-07-19 20:01:20'),
(306, 'ahmet', 'hakan', 'jfsak', '2020-07-19 20:08:34'),
(307, 'ahmet', 'hakan', 'jfksa', '2020-07-19 20:08:44'),
(308, 'ahmet', 'hakan', 'fksaj', '2020-07-19 20:08:51'),
(309, 'ahmet', 'hakan', 'jfksjfsa', '2020-07-19 20:11:06'),
(310, 'ahmet', 'altan', 'fkjsakfsa', '2020-07-19 20:15:43'),
(311, 'ahmet', 'hakan', 'fksajkfjsa', '2020-07-19 20:16:47'),
(312, 'ahmet', 'altan', 'jfaksjfaj', '2020-07-19 20:17:21'),
(313, 'ahmet', 'altan', 'fjksajfsa', '2020-07-19 20:17:29'),
(314, 'ahmet', 'altan', 'fjaskfjdsa', '2020-07-19 20:17:35'),
(315, 'ahmet', 'altan', 'fjksjfksafjdksajfksa', '2020-07-19 20:17:53'),
(316, 'ahmet', 'altan', 'fjsakjfksa', '2020-07-19 20:18:18'),
(317, 'ahmet', 'altan', 'fjksajfsa', '2020-07-19 20:19:48'),
(318, 'ahmet', 'altan', 'jfksajfsa', '2020-07-19 20:19:56'),
(319, 'ahmet', 'altan', 'fjsakjfasks', '2020-07-19 20:20:08'),
(320, 'ahmet', 'altan', 'kdsjkafsa', '2020-07-19 20:28:04'),
(321, 'ahmet', 'altan', 'fjksafjksa', '2020-07-19 20:28:23'),
(322, 'ahmet', 'altan', 'jfdksjfsa', '2020-07-19 20:29:55'),
(323, 'ahmet', 'altan', 'fsdjfksaj', '2020-07-19 20:30:01'),
(324, 'ahmet', 'altan', 'kfjaksfjsa', '2020-07-19 20:30:06'),
(325, 'ahmet', 'hakan', 'ok', '2020-07-19 20:57:53'),
(326, 'hakan', 'ahmet', 'kanka sa', '2020-07-19 20:58:41'),
(327, 'hakan', 'ahmet', 'sa', '2020-07-19 21:07:30'),
(328, 'hakan', 'ahmet', 'as', '2020-07-19 21:07:35'),
(329, 'ahmet', 'hakan', 'selam', '2020-07-19 21:07:42'),
(330, 'hakan', 'ahmet', 'kanka simdi', '2020-07-19 21:07:47'),
(331, 'ahmet', 'hakan', 'selamke', '2020-07-19 21:07:52'),
(332, 'hakan', 'ahmet', '2 kat daa iyi olmustur', '2020-07-19 21:07:57'),
(333, 'hakan', 'ahmet', 'sa', '2020-07-19 21:08:49'),
(334, 'hakan', 'ahmet', 'as', '2020-07-19 21:08:51'),
(335, 'ahmet', 'hakan', 'dsa', '2020-07-19 21:08:59'),
(336, 'hakan', 'ahmet', 'sa', '2020-07-19 21:09:05'),
(337, 'ahmet', 'hakan', 'fdsa', '2020-07-19 21:09:23'),
(338, 'hakan', 'ahmet', 'UPDATE YA RESULALLAH', '2020-07-19 21:09:31'),
(339, 'hakan', 'ahmet', '(req, res) => res.send(\"cCc tÃ¼rkler geliyor cCc\")', '2020-07-19 21:10:34'),
(340, 'hakan', 'ahmet', 'cCc tÃ¼rkler gidiyor cCc', '2020-07-19 21:10:40'),
(341, 'ahmet', 'hakan', 'ji', '2020-07-19 21:11:23'),
(342, 'hakan', 'ahmet', 'asd', '2020-07-19 21:11:38'),
(343, 'ahmet', 'hakan', 'fjdsa', '2020-07-19 21:11:40'),
(344, 'ahmet', 'hakan', 'fjdask', '2020-07-19 21:11:44'),
(345, 'ahmet', 'hakan', 'aq', '2020-07-19 21:11:56'),
(346, 'hakan', 'ahmet', 'sa', '2020-07-19 21:11:58'),
(347, 'ahmet', 'hakan', 'k', '2020-07-19 21:12:14'),
(348, 'hakan', 'ahmet', 's', '2020-07-19 21:12:14'),
(349, 'hakan', 'ahmet', 's', '2020-07-19 21:12:19'),
(350, 'ihlasUser', 'Error', 'asd', '2020-07-20 19:33:59'),
(351, 'ihlasUser', 'ahmet', 'insallah appget user', '2020-07-20 19:37:18'),
(352, 'ihlasUser', 'ahmet', 'user download unix', '2020-07-20 19:37:23'),
(353, 'ihlasUser', 'ahmet', 'unix start', '2020-07-20 19:37:29'),
(354, 'ihlasUser', 'ahmet', 'ihlas error', '2020-07-20 19:37:33'),
(355, 'ihlasUser', 'ahmet', 'ihlas 500: internal ahiret error', '2020-07-20 19:37:43'),
(356, 'ITC ENVER', 'Error', 'asd', '2020-07-20 19:41:36'),
(357, 'ITC ENVER', 'Error', 'ww', '2020-07-20 19:41:39'),
(358, 'ITC ENVER', 'Error', 'www.ihlasunix.tc', '2020-07-20 19:41:48'),
(359, 'ITC ENVER', 'ahmet', '', '2020-07-20 19:44:14'),
(360, 'ITC ENVER', 'ahmet', 'asdf', '2020-07-20 19:44:21'),
(361, 'ITC ENVER', 'ahmet', 'asdf', '2020-07-20 19:44:35'),
(362, 'ITC ENVER', 'ahmet', 'asdf', '2020-07-20 19:44:37'),
(363, 'ITC ENVER', 'ahmet', 'asdf', '2020-07-20 19:44:38'),
(364, 'ITC ENVER', 'ahmet', 'asdf', '2020-07-20 19:44:39'),
(365, 'ITC ENVER', 'ahmet', 'asdf', '2020-07-20 19:44:40'),
(366, 'ITC ENVER', 'ahmet', 'asdf', '2020-07-20 19:44:45'),
(367, 'ITC ENVER', 'ahmet', 'instada kaç kýzý takip ediyon knk', '2020-07-20 19:44:59'),
(368, 'ITC ENVER', 'ahmet', ';) DROP TABLE users --', '2020-07-20 19:45:27'),
(369, 'ITC ENVER', 'ahmet', 'ss', '2020-07-20 19:46:00'),
(370, 'ITC ENVER', 'ahmet', 'a', '2020-07-20 19:46:41'),
(371, 'ITC ENVER', 'ahmet', 'a', '2020-07-20 19:46:44'),
(372, 'ITC ENVER', 'ahmet', 's', '2020-07-20 19:46:47'),
(373, 'ITC ENVER', 'ahmet', 'asd', '2020-07-20 19:47:04'),
(374, 'ahmet', 'hakan', 'haksÄ±z mÄ±yÄ±m hocam', '2020-07-20 19:47:58'),
(375, 'ahmet', 'hakan', 'fkjas', '2020-07-20 19:48:58'),
(376, 'ahmet', 'ihlasUser', 'moruq', '2020-07-20 19:49:56'),
(377, 'ahmet', 'ihlasUser', 'online??', '2020-07-20 19:50:09'),
(378, 'ihlasUser', 'ahmet', 'asd', '2020-07-20 19:52:13'),
(379, 'ihlasUser', 'ahmet', 'asd', '2020-07-20 19:52:19'),
(380, 'ahmet', 'ihlasUser', 'kon', '2020-07-20 19:52:22'),
(381, 'ihlasUser', 'ahmet', 'ss', '2020-07-20 19:52:31'),
(382, 'ahmet', 'ihlasUser', 'jkj', '2020-07-20 19:52:37'),
(383, 'Mathias', 'benim adim berkcan', 'cCc', '2020-07-20 20:00:46'),
(384, 'Mathias', 'benim adim berkcan', 'asd', '2020-07-20 20:00:54'),
(385, 'benim adim berkcan', 'Mathias', 'fjkdsa', '2020-07-20 20:00:56'),
(386, 'benim adim berkcan', 'Mathias', 'jflksa', '2020-07-20 20:01:03'),
(387, 'ITC ENVER', 'Mathias', 'asd', '2020-07-20 20:02:27'),
(388, 'ITC ENVER', 'Mathias', 'asd', '2020-07-20 20:02:34'),
(389, 'ITC ENVER', 'ahmet', 'asd', '2020-07-20 20:02:43'),
(390, 'benim adim berkcan', 'ITC ENVER', 'hjhjk', '2020-07-20 20:06:56'),
(391, 'ITC ENVER', 'benim adim berkcan', 'asd', '2020-07-20 20:06:57'),
(392, 'ITC ENVER', 'benim adim berkcan', 'ss', '2020-07-20 20:07:07'),
(393, 'benim adim berkcan', 'Mathias', 'kjh', '2020-07-20 20:07:07'),
(394, 'ITC ENVER', 'benim adim berkcan', 's', '2020-07-20 20:07:08'),
(395, 'ITC ENVER', 'benim adim berkcan', 'ss', '2020-07-20 20:07:09'),
(396, 'ITC ENVER', 'benim adim berkcan', 'ss', '2020-07-20 20:07:11'),
(397, 'ITC ENVER', 'benim adim berkcan', 's', '2020-07-20 20:09:03'),
(398, 'ITC ENVER', 'ahmet', 'ssd', '2020-07-20 20:17:59'),
(399, 'ITC ENVER', 'ahmet', 'ay ti ci enver', '2020-07-20 20:23:14'),
(400, 'ITC ENVER', 'ahmet', 'I                T                     C ', '2020-07-20 20:23:27'),
(401, 'ITC ENVER', 'ahmet', 'enver', '2020-07-20 20:23:29'),
(402, 'ITC ENVER', 'ahmet', 'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc', '2020-07-20 20:26:40'),
(403, 'ITC ENVER', 'ahmet', 'ccccccccccccccccccccccccc', '2020-07-20 20:26:42'),
(404, 'ITC ENVER', 'ahmet', 'ccccccc', '2020-07-20 20:26:44'),
(405, 'ITC ENVER', 'ahmet', 'ccc', '2020-07-20 20:26:44'),
(406, 'ITC ENVER', 'ahmet', 'ccc', '2020-07-20 20:26:45'),
(407, 'ITC ENVER', 'ahmet', 'ccc', '2020-07-20 20:26:46'),
(408, 'ITC ENVER', 'ahmet', 'ulkucuforum.ccc', '2020-07-20 20:26:53'),
(409, 'ahmet', 'Mathias', 'hey brotha', '2020-07-20 20:28:45'),
(410, 'ahmet', 'hakan', 'kfjka', '2020-07-20 20:29:36'),
(411, 'ahmet', 'Mathias', 'ADANALI MATÄ°AS', '2020-07-20 20:30:50'),
(412, 'ahmet', 'Mathias', 'SELAM', '2020-07-20 20:30:52'),
(413, 'ahmet', 'Mathias', 'AYTÄ°CÄ° ENVER', '2020-07-20 20:31:05'),
(414, 'ahmet', 'Mathias', 'lan', '2020-07-20 20:31:22'),
(415, 'ahmet', 'Mathias', 'GELMÄ°YO', '2020-07-20 20:31:29'),
(416, 'ihlasUser', 'ahmet', 'GOKPÄ°NAR', '2020-07-20 20:40:27'),
(417, 'ihlasUser', 'ahmet', 'GOKPÄ°NAR BEY', '2020-07-20 20:40:33'),
(418, 'ihlasUser', 'ahmet', 'GOKPÄ°NAR BE', '2020-07-20 20:40:36'),
(419, 'ihlasUser', 'ahmet', 'CEVAP YAZÄ°N', '2020-07-20 20:40:43'),
(420, 'ihlasUser', 'ahmet', 'HOCAM GOKPÄ°NAR', '2020-07-20 20:40:49'),
(421, 'ihlasUser', 'ahmet', 'GOKPÄ°NAR ACÄ°L', '2020-07-20 20:40:53'),
(422, 'ihlasUser', 'ahmet', 'gokPinar', '2020-07-20 20:41:00'),
(423, 'ahmet', 'ihlasUser', 'selamkekee', '2020-07-20 20:41:16'),
(424, 'ihlasUser', 'ahmet', 'hocam sa', '2020-07-20 20:41:26'),
(425, 'ihlasUser', 'ahmet', 'as', '2020-07-20 20:41:27'),
(426, 'ihlasUser', 'ahmet', 'es', '2020-07-20 20:41:28'),
(427, 'ahmet', 'ihlasUser', 'jfksadjflksdajfksad', '2020-07-20 20:41:34'),
(428, 'ihlasUser', 'ahmet', 'Ä°NSALLAH ALLAAAN Ä°ZNÄ° Ä°LE', '2020-07-20 20:41:39'),
(429, 'ahmet', 'ihlasUser', 'fdsafsa', '2020-07-20 20:41:50'),
(430, 'ihlasUser', 'ahmet', 'ASD', '2020-07-20 20:42:08'),
(431, 'ihlasUser', 'ahmet', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', '2020-07-20 20:42:20'),
(432, 'ahmet', 'ihlasUser', 'm', '2020-07-20 20:42:31'),
(433, 'ahmet', 'ihlasUser', 'koko', '2020-07-20 20:42:45'),
(434, 'ihlasUser', 'ahmet', 'NE DÄ°ON AMCUQ', '2020-07-20 20:46:17'),
(435, 'ihlasUser', 'ahmet', 'IHLAS USER LAN BENÃœ-', '2020-07-20 20:46:28'),
(436, 'ihlasUser', 'ahmet', 'cyber seccade', '2020-07-20 20:46:36'),
(437, 'ahmet', 'ihlasUser', 'muska kernel Ä±', '2020-07-20 20:49:50'),
(438, 'ITC ENVER', 'benim adim berkcan', 'ddad', '2020-07-20 20:53:08'),
(439, 'ahmet', 'altan', 'slm', '2020-07-20 21:12:48'),
(440, 'ahmet', 'altan', 'mrb', '2020-07-20 21:14:47'),
(441, 'ahmet', 'altan', 'mk', '2020-07-20 21:16:46'),
(442, 'ahmet', 'altan', 'as', '2020-07-20 21:51:10'),
(443, 'ahmet', 'hakan', 'sa', '2020-07-20 21:53:19'),
(444, 'ahmet', 'hakan', 'ok', '2020-07-20 21:53:29'),
(445, 'ahmet', 'hakan', 'ok', '2020-07-20 21:53:36'),
(446, 'ahmet', 'hakan', 'nb', '2020-07-20 21:53:46'),
(447, 'ahmet', 'omar', 'p', '2020-07-20 21:54:36'),
(448, 'ahmet', 'omar', 'k', '2020-07-20 21:54:43'),
(449, 'ahmet', 'omar', 'n', '2020-07-20 21:56:34'),
(450, 'ahmet', 'omar', 'b', '2020-07-20 21:57:41'),
(451, 'ahmet', 'omar', 'n', '2020-07-20 21:57:48'),
(452, 'ahmet', 'omar', 'v', '2020-07-20 21:58:01'),
(453, 'ahmet', 'omar', 'b', '2020-07-20 21:58:57'),
(454, 'ahmet', 'omar', 'l', '2020-07-20 21:59:04'),
(455, 'ahmet', 'omar', 'n', '2020-07-20 22:01:16'),
(456, 'ahmet', 'omar', 'o', '2020-07-20 22:01:21'),
(457, 'ahmet', 'omar', 'o', '2020-07-20 22:01:48'),
(458, 'ahmet', 'omar', 's', '2020-07-20 22:02:09'),
(459, 'ahmet', 'omar', 'c', '2020-07-20 22:02:19'),
(460, 'ahmet', 'omar', 'g', '2020-07-20 22:02:29'),
(461, 'ahmet', 'omar', 'u', '2020-07-20 22:04:03'),
(462, 'ahmet', 'omar', 'b', '2020-07-20 22:04:14'),
(463, 'ahmet', 'Mathias', 'o', '2020-07-20 22:04:24'),
(464, 'ahmet', 'ihlasUser', 'x', '2020-07-20 22:04:37'),
(465, 'ahmet', 'omar', 'q', '2020-07-20 22:06:59'),
(466, 'ahmet', 'omar', 'v', '2020-07-20 22:07:13'),
(467, 'ahmet', 'omar', 'z', '2020-07-20 22:07:26'),
(468, 'ahmet', 'omar', 'c', '2020-07-20 22:07:50'),
(469, 'ahmet', 'omar', 'x', '2020-07-20 22:07:57'),
(470, 'ahmet', 'ihlasUser', 'l', '2020-07-20 22:10:54'),
(471, 'ahmet', 'ihlasUser', 'v', '2020-07-20 22:11:47'),
(472, 'ahmet', 'ihlasUser', 'b', '2020-07-20 22:11:56');

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `notiftable`
--

CREATE TABLE `notiftable` (
  `id` int(11) NOT NULL,
  `sender` varchar(25) NOT NULL,
  `receiver` varchar(25) NOT NULL,
  `counts` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dataark for tabell `notiftable`
--

INSERT INTO `notiftable` (`id`, `sender`, `receiver`, `counts`) VALUES
(8, 'hakan', 'ahmet', 0),
(9, 'ahmet', 'hakan', 7),
(10, 'ahmet', 'omar', 26),
(11, 'ahmet', 'enes', 0),
(12, 'enes', 'ahmet', 0),
(13, 'ahmet', 'mathias', 7),
(14, 'altan', 'enes', 1),
(15, 'altan', 'hakan', 0),
(16, 'altan', 'ahmet', 0),
(17, 'ahmet', 'altan', 27),
(18, 'hakan', 'altan', 3),
(19, 'hakan', 'hakan', 0),
(20, 'hakan', '', 2),
(21, 'hakan', 'SYSADMIN', 3),
(22, 'ihlasUser', 'Error', 1),
(23, 'ihlasUser', 'ahmet', 0),
(24, 'ITC ENVER', 'Error', 3),
(25, 'ITC ENVER', 'ahmet', 0),
(26, 'ahmet', 'ihlasUser', 4),
(27, 'Mathias', 'benim adim berkcan', 0),
(28, 'benim adim berkcan', 'Mathias', 1),
(29, 'ITC ENVER', 'Mathias', 2),
(30, 'benim adim berkcan', 'ITC ENVER', 0),
(31, 'ITC ENVER', 'benim adim berkcan', 7);

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `requeststable`
--

CREATE TABLE `requeststable` (
  `id` int(11) NOT NULL,
  `sender` varchar(25) NOT NULL,
  `receiver` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dataark for tabell `requeststable`
--

INSERT INTO `requeststable` (`id`, `sender`, `receiver`) VALUES
(23, 'ahmet', 'kaan'),
(26, 'iver', 'Mathias'),
(30, 'hakan', 'omar'),
(31, 'hakan', 'kaan'),
(35, 'ihlasUser', 'hakan');

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `users`
--

CREATE TABLE `users` (
  `username` varchar(25) NOT NULL,
  `password` varchar(25) NOT NULL,
  `photo` longblob
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dataark for tabell `users`
--

INSERT INTO `users` (`username`, `password`, `photo`) VALUES
('ahmet', 'test', ''),
('altan', 'test', ''),
('benim adim berkcan', 'test', NULL),
('emre', 'test', ''),
('enes', 'test', ''),
('hakan', 'test', ''),
('ihlasUser', 'bismillah', NULL),
('ITC ENVER', 'itcitc', NULL),
('iver', '1234', NULL),
('jailor', 'bismillah', NULL),
('kaan', 'test', ''),
('Mathias', '1234', NULL),
('omar', 'test', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `blacklist`
--
ALTER TABLE `blacklist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `friends`
--
ALTER TABLE `friends`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `messagetable`
--
ALTER TABLE `messagetable`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notiftable`
--
ALTER TABLE `notiftable`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `requeststable`
--
ALTER TABLE `requeststable`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `blacklist`
--
ALTER TABLE `blacklist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `friends`
--
ALTER TABLE `friends`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `messagetable`
--
ALTER TABLE `messagetable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=473;

--
-- AUTO_INCREMENT for table `notiftable`
--
ALTER TABLE `notiftable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `requeststable`
--
ALTER TABLE `requeststable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;