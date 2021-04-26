-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 21, 2021 at 07:12 AM
-- Server version: 10.4.18-MariaDB
-- PHP Version: 8.0.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gestioncompetitions`
--

-- --------------------------------------------------------

--
-- Table structure for table `administrateurprofile`
--

CREATE TABLE `administrateurprofile` (
  `adminid` int(11) NOT NULL,
  `motdepasse` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `competiteur`
--

CREATE TABLE `competiteur` (
  `competiteurid` int(11) NOT NULL,
  `competiteurcin` int(11) NOT NULL,
  `competiteurprenom` varchar(30) NOT NULL,
  `competiteurnom` varchar(30) NOT NULL,
  `datenaissance` date NOT NULL,
  `sportid` int(11) NOT NULL,
  `lieuid` int(11) NOT NULL,
  `grade` varchar(30) NOT NULL,
  `equipeid` int(11) NOT NULL,
  `participations` int(11) NOT NULL DEFAULT 0,
  `gagnes` int(11) NOT NULL DEFAULT 0,
  `pertes` int(11) NOT NULL DEFAULT 0,
  `matchnuls` int(11) NOT NULL DEFAULT 0,
  `competiteurimage` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `competition`
--

CREATE TABLE `competition` (
  `competitionid` int(11) NOT NULL,
  `competitionnom` varchar(30) NOT NULL,
  `sportid` int(11) NOT NULL,
  `terrainid` int(11) NOT NULL,
  `datecompetition` date NOT NULL,
  `heure` int(11) NOT NULL,
  `duree` int(11) NOT NULL,
  `prix` int(11) NOT NULL,
  `competitionimage` blob NOT NULL,
  `termine` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `equipe`
--

CREATE TABLE `equipe` (
  `equipeid` int(11) NOT NULL,
  `equipenom` varchar(30) NOT NULL,
  `sportid` int(11) NOT NULL,
  `participations` int(11) NOT NULL DEFAULT 0,
  `egagnes` int(11) NOT NULL DEFAULT 0,
  `epertes` int(11) NOT NULL DEFAULT 0,
  `ematchnuls` int(11) NOT NULL DEFAULT 0,
  `equipeimage` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `lieu`
--

CREATE TABLE `lieu` (
  `lieuid` int(11) NOT NULL,
  `ville` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `participation`
--

CREATE TABLE `participation` (
  `competitionid` int(11) NOT NULL,
  `competiteurid` int(11) NOT NULL,
  `equipeid` int(11) NOT NULL,
  `resultat` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `participation`
--
DELIMITER $$
CREATE TRIGGER `competiteurparticipationajouter` AFTER INSERT ON `participation` FOR EACH ROW UPDATE competiteur
SET participations = (select count(*) from participation where participation.competiteurid = inserted.competiteurid)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `competiteurparticipationmodifiera` AFTER UPDATE ON `participation` FOR EACH ROW UPDATE competiteur
SET participations = (select count(*) from participation where participation.competiteurid = updated.competiteurid)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `competiteurparticipationmodifierb` BEFORE UPDATE ON `participation` FOR EACH ROW UPDATE competiteur
SET participations = (select count(*) from participation where participation.competiteurid = updated.competiteurid)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `competiteurparticipationresultatg` AFTER UPDATE ON `participation` FOR EACH ROW UPDATE competiteur
SET gagnes = (select count(*) from participation where participation.competiteurid = updated.competiteurid and participation.resultat = 1)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `competiteurparticipationresultatm` AFTER UPDATE ON `participation` FOR EACH ROW UPDATE competiteur
SET matchnuls = (select count(*) from participation where participation.competiteurid = updated.competiteurid and participation.resultat = 3)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `competiteurparticipationresultatp` BEFORE INSERT ON `participation` FOR EACH ROW UPDATE competiteur
SET pertes = (select count(*) from participation where participation.competiteurid = updated.competiteurid and participation.resultat = 2)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `competiteurparticipationsupprimer` AFTER DELETE ON `participation` FOR EACH ROW UPDATE competiteur
SET participations = (select count(*) from participation where participation.competiteurid = deleted.competiteurid)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `equipeparticipationajouter` AFTER INSERT ON `participation` FOR EACH ROW UPDATE equipe
SET participations = (select count(*) from participation where participation.equipeid = inserted.equipeid )
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `equipeparticipationmodifiera` AFTER UPDATE ON `participation` FOR EACH ROW UPDATE equipe
SET participations = (select count(*) from participation where participation.equipeid = updated.equipeid)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `equipeparticipationmodifierb` BEFORE UPDATE ON `participation` FOR EACH ROW UPDATE equipe
SET participations = (select count(*) from participation where participation.equipeid = updated.equipeid)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `equipeparticipationresultatg` AFTER UPDATE ON `participation` FOR EACH ROW UPDATE equipe
SET egagnes = (select count(*) from participation where participation.equipeid = updated.equipeid and participation.resultat = 1)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `equipeparticipationresultatm` AFTER UPDATE ON `participation` FOR EACH ROW UPDATE equipe
SET ematchnuls = (select count(*) from participation where participation.equipeid = updated.equipeid and participation.resultat = 3)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `equipeparticipationresultatp` AFTER UPDATE ON `participation` FOR EACH ROW UPDATE equipe
SET epertes = (select count(*) from participation where participation.equipeid = updated.equipeid and participation.resultat = 2)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `equipeparticipationsupprimer` AFTER DELETE ON `participation` FOR EACH ROW UPDATE equipe
SET participations = (select count(*) from participation where participation.equipeid = deleted.equipeid)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sport`
--

CREATE TABLE `sport` (
  `sportid` int(11) NOT NULL,
  `sportnom` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `terrain`
--

CREATE TABLE `terrain` (
  `terrainid` int(11) NOT NULL,
  `terrainnom` varchar(30) NOT NULL,
  `sportid` int(11) NOT NULL,
  `lieuid` int(11) NOT NULL,
  `longeur` int(11) NOT NULL,
  `largeur` int(11) NOT NULL,
  `capacite` int(11) NOT NULL,
  `terrainimage` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `administrateurprofile`
--
ALTER TABLE `administrateurprofile`
  ADD PRIMARY KEY (`adminid`);

--
-- Indexes for table `competiteur`
--
ALTER TABLE `competiteur`
  ADD PRIMARY KEY (`competiteurid`),
  ADD KEY `lieuid` (`lieuid`),
  ADD KEY `sportid` (`sportid`),
  ADD KEY `equipeid` (`equipeid`);

--
-- Indexes for table `competition`
--
ALTER TABLE `competition`
  ADD PRIMARY KEY (`competitionid`),
  ADD KEY `sportid` (`sportid`),
  ADD KEY `terrainid` (`terrainid`);

--
-- Indexes for table `equipe`
--
ALTER TABLE `equipe`
  ADD PRIMARY KEY (`equipeid`),
  ADD KEY `sportid` (`sportid`);

--
-- Indexes for table `lieu`
--
ALTER TABLE `lieu`
  ADD PRIMARY KEY (`lieuid`);

--
-- Indexes for table `participation`
--
ALTER TABLE `participation`
  ADD KEY `competitionid` (`competitionid`),
  ADD KEY `competiteurid` (`competiteurid`),
  ADD KEY `equipeid` (`equipeid`);

--
-- Indexes for table `sport`
--
ALTER TABLE `sport`
  ADD PRIMARY KEY (`sportid`);

--
-- Indexes for table `terrain`
--
ALTER TABLE `terrain`
  ADD PRIMARY KEY (`terrainid`),
  ADD KEY `sportid` (`sportid`),
  ADD KEY `lieuid` (`lieuid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `competiteur`
--
ALTER TABLE `competiteur`
  MODIFY `competiteurid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `competition`
--
ALTER TABLE `competition`
  MODIFY `competitionid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `equipe`
--
ALTER TABLE `equipe`
  MODIFY `equipeid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lieu`
--
ALTER TABLE `lieu`
  MODIFY `lieuid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sport`
--
ALTER TABLE `sport`
  MODIFY `sportid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `terrain`
--
ALTER TABLE `terrain`
  MODIFY `terrainid` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `competiteur`
--
ALTER TABLE `competiteur`
  ADD CONSTRAINT `competiteur_ibfk_1` FOREIGN KEY (`lieuid`) REFERENCES `lieu` (`lieuid`),
  ADD CONSTRAINT `competiteur_ibfk_2` FOREIGN KEY (`sportid`) REFERENCES `sport` (`sportid`),
  ADD CONSTRAINT `competiteur_ibfk_3` FOREIGN KEY (`equipeid`) REFERENCES `equipe` (`equipeid`);

--
-- Constraints for table `competition`
--
ALTER TABLE `competition`
  ADD CONSTRAINT `competition_ibfk_1` FOREIGN KEY (`sportid`) REFERENCES `sport` (`sportid`),
  ADD CONSTRAINT `competition_ibfk_2` FOREIGN KEY (`terrainid`) REFERENCES `terrain` (`terrainid`);

--
-- Constraints for table `equipe`
--
ALTER TABLE `equipe`
  ADD CONSTRAINT `equipe_ibfk_1` FOREIGN KEY (`sportid`) REFERENCES `sport` (`sportid`);

--
-- Constraints for table `participation`
--
ALTER TABLE `participation`
  ADD CONSTRAINT `participation_ibfk_1` FOREIGN KEY (`competitionid`) REFERENCES `competition` (`competitionid`),
  ADD CONSTRAINT `participation_ibfk_2` FOREIGN KEY (`competiteurid`) REFERENCES `competiteur` (`competiteurid`),
  ADD CONSTRAINT `participation_ibfk_3` FOREIGN KEY (`equipeid`) REFERENCES `equipe` (`equipeid`);

--
-- Constraints for table `terrain`
--
ALTER TABLE `terrain`
  ADD CONSTRAINT `terrain_ibfk_1` FOREIGN KEY (`sportid`) REFERENCES `sport` (`sportid`),
  ADD CONSTRAINT `terrain_ibfk_2` FOREIGN KEY (`lieuid`) REFERENCES `lieu` (`lieuid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
