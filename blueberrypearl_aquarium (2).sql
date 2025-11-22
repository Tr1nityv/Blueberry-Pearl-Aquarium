-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 22, 2025 at 10:21 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `blueberrypearl_aquarium`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `animals_by_habitat` (IN `h_id` INT)   BEGIN
    DECLARE done INT DEFAULT FALSE;

    DECLARE v_animalID INT;
    DECLARE v_animalName VARCHAR(100);
    DECLARE v_species VARCHAR(100);
    DECLARE v_habitatID INT;
    DECLARE v_countryID VARCHAR(3);
    DECLARE v_dob DATE;
    DECLARE v_class VARCHAR(100);
    DECLARE v_gender VARCHAR(100);
    DECLARE v_dateAdmission DATE;

    DECLARE animal_cur CURSOR FOR
        SELECT AnimalID, AnimalName, Species, HabitatID, CountryID, DOB, Class, Gender, DateofAdmission
        FROM animal
        WHERE HabitatID = h_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN animal_cur;

    read_loop: LOOP
        FETCH animal_cur INTO 
            v_animalID, v_animalName, v_species, v_habitatID, 
            v_countryID, v_dob, v_class, v_gender, v_dateAdmission;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT CONCAT(
            'ID: ', v_animalID,
            ' | Name: ', v_animalName,
            ' | Species: ', v_species,
            ' | Habitat: ', v_habitatID,
            ' | Country: ', v_countryID,
            ' | DOB: ', v_dob,
            ' | Class: ', v_class,
            ' | Gender: ', v_gender,
            ' | Admission: ', v_dateAdmission
        ) AS Animal_Record;

    END LOOP;

    CLOSE animal_cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AssignMaintenanceTask` (`taskDescription` TEXT, `taskDate` DATETIME, `employeeID` INT, `habitatID` INT)   BEGIN
    INSERT INTO maintenance (TaskDescription, TaskDate, EmployeeID, HabitatID)
    VALUES (taskDescription, taskDate, employeeID, habitatID);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `FeedAnimal` (`animalID` INT, `employeeID` INT, `foodType` VARCHAR(100))   BEGIN
    INSERT INTO feeding (FeedingTime, FoodType, AnimalID, EmployeeID)
    VALUES (NOW(), foodType, animalID, employeeID);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `feeding_by_employee` (IN `emp_id` INT)   BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_feedingTime DATETIME;
    DECLARE v_foodType VARCHAR(100);
    DECLARE v_animalID INT;
    DECLARE v_employeeID INT;

    DECLARE feed_cursor CURSOR FOR
        SELECT FeedingTime, FoodType, AnimalID, EmployeeID
        FROM feeding
        WHERE EmployeeID = emp_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN feed_cursor;

    read_loop: LOOP
        FETCH feed_cursor INTO v_feedingTime, v_foodType, v_animalID, v_employeeID;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT 
            CONCAT(
                'Time: ', v_feedingTime,
                ' | Food: ', v_foodType,
                ' | Animal: ', v_animalID,
                ' | Employee: ', v_employeeID
            ) AS Feeding_Record;
    END LOOP;

    CLOSE feed_cursor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SignupVisitorToEvent` (`visitorID` INT, `eventID` INT, `signupDate` DATETIME)   BEGIN
    INSERT INTO signup (VisitorID, EventID, SignupDate)
    VALUES (visitorID, eventID, signupDate);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateTicketPriceByIDRange` (IN `startID` INT, IN `endID` INT)   BEGIN
    -- Variables to hold cursor data
    DECLARE v_VisitorID INT;
    DECLARE v_TicketType VARCHAR(20);
    DECLARE done INT DEFAULT 0;

    -- Declare cursor for VisitorID range
    DECLARE visitor_cursor CURSOR FOR
        SELECT VisitorID, TicketType
        FROM Visitor
        WHERE VisitorID BETWEEN startID AND endID;

    -- Handler for end of cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open the cursor
    OPEN visitor_cursor;

    -- Loop through all fetched rows
    read_loop: LOOP
        FETCH visitor_cursor INTO v_VisitorID, v_TicketType;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Update TicketPrice based on TicketType
        IF v_TicketType = 'Adult' THEN
            UPDATE Visitor SET TicketPrice = 20.00 WHERE VisitorID = v_VisitorID;
        ELSEIF v_TicketType = 'Child' THEN
            UPDATE Visitor SET TicketPrice = 10.00 WHERE VisitorID = v_VisitorID;
        ELSEIF v_TicketType = 'Student' THEN
            UPDATE Visitor SET TicketPrice = 15.00 WHERE VisitorID = v_VisitorID;
        ELSEIF v_TicketType = 'Senior' THEN
            UPDATE Visitor SET TicketPrice = 12.00 WHERE VisitorID = v_VisitorID;
        END IF;

    END LOOP;

    -- Close the cursor
    CLOSE visitor_cursor;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `animal`
--

CREATE TABLE `animal` (
  `AnimalID` int(11) NOT NULL,
  `AnimalName` varchar(100) NOT NULL,
  `Species` varchar(100) DEFAULT NULL,
  `HabitatID` int(11) DEFAULT NULL,
  `CountryID` varchar(3) NOT NULL,
  `DOB` date NOT NULL,
  `Class` varchar(100) NOT NULL,
  `Gender` varchar(100) NOT NULL,
  `DateofAdmission` date NOT NULL
) ;

--
-- Dumping data for table `animal`
--

INSERT INTO `animal` (`AnimalID`, `AnimalName`, `Species`, `HabitatID`, `CountryID`, `DOB`, `Class`, `Gender`, `DateofAdmission`) VALUES
(1, 'Nemo', 'Clownfish', 4, 'AUS', '2023-03-15', 'Fish', 'Male', '2024-01-10'),
(2, 'Bubbles', 'Yellow Tang', 4, 'USA', '2022-06-10', 'Fish', 'Female', '2024-02-05'),
(3, 'Coralina', 'Bubble Tip Anemone', 5, 'BRA', '2021-11-01', 'Invertebrate', 'Unknown', '2024-01-20'),
(4, 'Glimmer', 'Neon Tetra', 1, 'IND', '2023-05-22', 'Fish', 'Female', '2024-03-12'),
(5, 'Spike', 'Betta Fish', 1, 'BGD', '2023-08-14', 'Fish', 'Male', '2024-03-25'),
(6, 'Shadow', 'Black Molly', 3, 'MEX', '2023-02-01', 'Fish', 'Female', '2024-02-18'),
(7, 'Pebble', 'Goldfish', 2, 'CAN', '2022-09-19', 'Fish', 'Male', '2024-01-15'),
(8, 'Sandy', 'Hermit Crab', 4, 'ARG', '2021-07-10', 'Invertebrate', 'Unknown', '2024-04-01'),
(9, 'Luna', 'Axolotl', 1, 'DEU', '2022-12-05', 'Amphibian', 'Female', '2024-02-28'),
(10, 'Titan', 'Koi Carp', 10, 'FRA', '2020-04-30', 'Fish', 'Male', '2024-03-05'),
(11, 'Coral', 'Clownfish', 4, 'AUS', '2022-05-14', 'Fish', 'Female', '2023-02-10'),
(12, 'Jet', 'Blacktip Reef Shark', 6, 'AUS', '2017-08-02', 'Fish', 'Male', '2019-06-18'),
(13, 'Pearl', 'Moon Jellyfish', 4, 'JPN', '2023-03-20', 'Cnidarian', 'Female', '2023-10-01'),
(14, 'Otto', 'Sea Otter', 2, 'USA', '2020-11-11', 'Mammal', 'Male', '2021-12-05'),
(15, 'Spark', 'Electric Eel', 5, 'BRA', '2019-01-09', 'Fish', 'Female', '2020-04-12'),
(16, 'Marina', 'French Angelfish', 3, 'FRA', '2021-07-30', 'Fish', 'Female', '2022-08-20'),
(17, 'Sandy', 'Southern Stingray', 6, 'MEX', '2018-09-14', 'Fish', 'Female', '2019-11-03'),
(18, 'Nimbus', 'Beluga Whale', 1, 'CAN', '2015-02-27', 'Mammal', 'Male', '2016-05-21'),
(19, 'Inky', '', 4, 'USA', '2020-04-06', 'Cephalopod', 'Male', '2021-01-14'),
(20, 'Lotus', 'Bengal Snapper', 3, 'IND', '2022-12-12', 'Fish', 'Female', '2023-06-10'),
(21, 'Bubbles', 'Blue Tang', 3, 'AUS', '2021-06-18', 'Fish', 'Female', '2022-03-12'),
(22, 'Titan', 'Red-Bellied Piranha', 5, 'BRA', '2020-03-25', 'Fish', 'Male', '2021-01-19'),
(23, 'Frost', 'Arctic Char', 1, 'CAN', '2019-12-10', 'Fish', 'Male', '2020-09-05'),
(24, 'Shadow', 'Moray Eel', 3, 'MEX', '2018-04-02', 'Fish', 'Male', '2019-02-11'),
(25, 'Cleo', 'Sea Nettle Jellyfish', 4, 'USA', '2023-01-14', 'Cnidarian', 'Female', '2023-07-18'),
(26, 'Nori', 'Japanese Spider Crab', 7, 'JPN', '2020-09-08', 'Crustacean', 'Female', '2021-04-03'),
(27, 'Whisper', 'Axolotl', 1, 'MEX', '2022-10-22', 'Amphibian', 'Female', '2023-02-15'),
(28, 'Pebble', 'Sea Turtle', 2, 'IND', '2017-07-01', 'Reptile', 'Female', '2018-10-20'),
(29, 'Drift', 'Lionfish', 3, 'AUS', '2021-02-17', 'Fish', 'Male', '2021-12-05'),
(30, 'Coraline', 'Seahorse', 3, 'FRA', '2022-03-11', 'Fish', 'Female', '2022-11-02'),
(31, 'Riptide', 'Great Barracuda', 5, 'BRA', '2019-05-30', 'Fish', 'Male', '2020-03-21'),
(32, 'Sakura', 'Cherry Blossom Shrimp', 7, 'JPN', '2023-06-05', 'Crustacean', 'Female', '2023-10-09'),
(33, 'Mango', 'African Cichlid', 6, 'NGA', '2021-04-27', 'Fish', 'Male', '2022-02-01'),
(34, 'Glacier', 'King Crab', 7, 'DEU', '2018-11-19', 'Crustacean', 'Male', '2019-07-14'),
(35, 'Harbor', 'Harbor Seal', 2, 'CAN', '2016-08-22', 'Mammal', 'Female', '2017-05-16'),
(36, 'Faye', 'French Wrasse', 3, 'FRA', '2020-02-01', 'Fish', 'Female', '2021-01-08'),
(37, 'Azure', 'Bangladesh River Gourami', 5, 'BGD', '2021-10-12', 'Fish', 'Female', '2022-06-17'),
(38, 'Tempo', 'German Rainbow Trout', 1, 'DEU', '2020-04-28', 'Fish', 'Male', '2021-03-15'),
(39, 'Copper', 'Red-Clawed Crab', 7, 'AUS', '2023-02-08', 'Crustacean', 'Male', '2023-09-30'),
(40, 'Blossom', 'Koi Fish', 10, 'JPN', '2020-07-24', 'Fish', 'Female', '2021-04-26');

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE `country` (
  `CountryID` varchar(3) NOT NULL,
  `CountryName` varchar(100) NOT NULL,
  `Climate` varchar(100) DEFAULT NULL,
  `Continent` varchar(50) NOT NULL
) ;

--
-- Dumping data for table `country`
--

INSERT INTO `country` (`CountryID`, `CountryName`, `Climate`, `Continent`) VALUES
('ARG', 'Argentina', 'Temperate', 'South America'),
('AUS', 'Australia', 'Arid', 'Oceania'),
('BGD', 'Bangladesh', 'Monsoon', 'Asia'),
('BRA', 'Brazil', 'Tropical', 'South America'),
('CAN', 'Canada', 'Cold', 'North America'),
('DEU', 'Germany', 'Temperate', 'Europe'),
('FRA', 'France', 'Temperate', 'Europe'),
('IND', 'India', 'Tropical', 'Asia'),
('JPN', 'Japan', 'Temperate', 'Asia'),
('MEX', 'Mexico', 'Tropical', 'North America'),
('NGA', 'Nigeria', 'Tropical', 'Africa'),
('USA', 'United States', 'Temperate', 'North America');

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `EmployeeID` int(11) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Role` varchar(50) NOT NULL,
  `HireDate` date NOT NULL,
  `Hourly` decimal(5,2) NOT NULL
) ;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`EmployeeID`, `FirstName`, `LastName`, `Role`, `HireDate`, `Hourly`) VALUES
(1, 'Maria', 'Lopez', 'Aquarist', '2020-03-15', 22.50),
(2, 'James', 'Turner', 'Marine Biologist', '2019-07-01', 28.75),
(3, 'Aisha', 'Henderson', 'Event Coordinator', '2021-11-12', 20.00),
(4, 'Evan', 'Kim', 'Maintenance Technician', '2022-02-25', 18.50),
(5, 'Sofia', 'Martinez', 'Guest Services', '2023-05-10', 16.75),
(6, 'Liam', 'Reynolds', 'Animal Care Specialist', '2018-09-03', 25.00),
(7, 'Noah', 'Patel', 'Water Quality Technician', '2020-12-19', 21.40),
(8, 'Chloe', 'Wilson', 'Education Guide', '2021-06-07', 17.80),
(9, 'Daniel', 'Nguyen', 'Security', '2019-04-28', 19.60),
(10, 'Grace', 'Thompson', 'Feeding Supervisor', '2017-08-14', 27.30),
(11, 'Daniel', 'Harris', 'Aquarist', '2022-10-12', 21.75),
(12, 'Sofia', 'Martinez', 'Marine Biologist', '2021-03-05', 27.50),
(13, 'Omar', 'Hassan', 'Facility Technician', '2023-01-20', 19.80),
(14, 'Priya', 'Patel', 'Guest Services Associate', '2024-04-01', 16.25),
(15, 'Ethan', 'Brooks', 'Animal Care Specialist', '2020-09-17', 24.90),
(16, 'Hannah', 'Wells', 'Veterinary Assistant', '2021-07-28', 23.10),
(17, 'Leo', 'Nguyen', 'Operations Manager', '2019-11-04', 32.75),
(18, 'Chloe', 'Bennett', 'Conservation Educator', '2022-05-10', 26.40),
(19, 'Marcus', 'Fleming', 'Water Quality Technician', '2023-06-22', 20.60),
(20, 'Aaliyah', 'Simmons', 'Tour Guide', '2024-02-14', 18.90);

-- --------------------------------------------------------

--
-- Table structure for table `event`
--

CREATE TABLE `event` (
  `EventID` int(11) NOT NULL,
  `EventName` varchar(100) NOT NULL,
  `EventDate` date NOT NULL,
  `StartTime` time DEFAULT NULL,
  `EndTime` time DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `HabitatID` int(11) DEFAULT NULL,
  `EmployeeID` int(11) NOT NULL
) ;

--
-- Dumping data for table `event`
--

INSERT INTO `event` (`EventID`, `EventName`, `EventDate`, `StartTime`, `EndTime`, `Description`, `HabitatID`, `EmployeeID`) VALUES
(101, 'Shark Feeding Frenzy', '2025-03-10', '10:00:00', '11:00:00', 'Watch our aquarists feed the sharks in the marine tank.', 4, 1),
(102, 'Coral Reef Conservation Talk', '2025-03-11', '13:00:00', '14:00:00', 'Learn about coral reef ecosystems and how to protect them.', 5, 2),
(103, 'Touch Tank Exploration', '2025-03-12', '09:30:00', '10:30:00', 'Hands-on session with starfish, sea cucumbers, and more.', 7, 3),
(104, 'Axolotl Encounter', '2025-03-13', '11:00:00', '12:00:00', 'Meet Luna the axolotl and learn about amphibians.', 1, 6),
(105, 'Goldfish Races', '2025-03-14', '14:00:00', '15:00:00', 'Cheer on your favorite goldfish in a fun race.', 2, 5),
(106, 'Jellyfish Light Show', '2025-03-15', '16:00:00', '17:00:00', 'A mesmerizing display of jellyfish and colored lights.', 5, 8),
(107, 'Feeding the Koi', '2025-03-16', '10:30:00', '11:30:00', 'Join us at the pond habitat to feed Titan and friends.', 10, 10),
(108, 'Invertebrate Spotlight', '2025-03-17', '12:00:00', '13:00:00', 'Discover the fascinating world of hermit crabs and anemones.', 4, 7),
(109, 'Water Chemistry 101', '2025-03-18', '15:00:00', '16:00:00', 'Learn how we monitor and balance aquarium water.', 3, 7),
(110, 'Behind the Scenes Tour', '2025-03-19', '09:00:00', '10:00:00', 'Explore the filtration systems and animal care areas.', 9, 4);

--
-- Triggers `event`
--
DELIMITER $$
CREATE TRIGGER `EndTimeBeforeStartTime` BEFORE INSERT ON `event` FOR EACH ROW IF NEW.EndTime <= NEW.StartTime THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'End time must be after start time';
END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `feeding`
--

CREATE TABLE `feeding` (
  `FeedingTime` datetime NOT NULL,
  `FoodType` varchar(100) DEFAULT NULL,
  `AnimalID` int(11) NOT NULL,
  `EmployeeID` int(11) DEFAULT NULL
) ;

--
-- Dumping data for table `feeding`
--

INSERT INTO `feeding` (`FeedingTime`, `FoodType`, `AnimalID`, `EmployeeID`) VALUES
('2024-05-01 09:00:00', 'Brine Shrimp', 1, 10),
('2024-05-01 09:30:00', 'Marine Pellets', 2, 1),
('2024-05-01 10:00:00', 'Plankton', 3, 6),
('2024-05-01 10:30:00', 'Micro Pellets', 4, 5),
('2024-05-01 11:00:00', 'Bloodworms', 5, 10),
('2024-05-01 11:30:00', 'Algae Wafers', 6, 1),
('2024-05-01 12:00:00', 'Goldfish Flakes', 7, 3),
('2024-05-01 12:30:00', 'Seaweed Sheets', 8, 7),
('2024-05-01 13:00:00', 'Earthworms', 9, 6),
('2024-05-01 13:30:00', 'Koi Pellets', 10, 10),
('2024-10-01 12:00:00', 'Fish Pellets', 11, 6),
('2024-10-01 12:15:00', 'Small Crabs', 12, 1),
('2024-10-01 12:30:00', 'Krill', 13, 6),
('2024-10-01 12:45:00', 'Live Fish', 14, 10),
('2024-10-01 13:00:00', 'Vegetation Mix', 15, 6),
('2024-10-01 13:15:00', 'Seaweed Mix', 16, 18),
('2024-10-01 13:30:00', 'Invertebrate Mix', 17, 7),
('2024-10-01 13:45:00', 'Squid', 18, 15),
('2024-10-01 14:00:00', 'Krill Mix', 19, 10),
('2024-10-01 14:15:00', 'Fish Pellets', 20, 6),
('2024-10-01 14:30:00', 'Plankton', 21, 1),
('2024-10-01 14:45:00', 'Meat Chunks', 22, 6),
('2024-10-01 15:00:00', 'Cold-Water Pellets', 23, 19),
('2024-10-01 15:15:00', 'Small Fish', 24, 10),
('2024-10-01 15:30:00', 'Jellyfish Diet', 25, 8),
('2024-10-01 15:45:00', 'Shellfish', 26, 1),
('2024-10-01 16:00:00', 'Worms', 27, 6),
('2024-10-01 16:15:00', 'Vegetation Mix', 28, 15),
('2024-10-01 16:30:00', 'Crustaceans', 29, 10),
('2024-10-01 16:45:00', 'Brine Shrimp', 30, 18),
('2024-10-01 17:00:00', 'Live Fish', 31, 6),
('2024-10-01 17:15:00', 'Pellets', 32, 1),
('2024-10-01 17:30:00', 'Insect Larvae', 33, 11),
('2024-10-01 17:45:00', 'Small Fish', 34, 6),
('2024-10-01 18:00:00', 'Fish Pellets', 35, 15),
('2024-10-01 18:15:00', 'Coral Diet', 36, 18),
('2024-10-01 18:30:00', 'River Vegetation', 37, 12),
('2024-10-01 18:45:00', 'Cold-Water Feed', 38, 19),
('2024-10-01 19:00:00', 'Crustaceans', 39, 1),
('2024-10-01 19:15:00', 'Pond Pellets', 40, 10);

-- --------------------------------------------------------

--
-- Table structure for table `habitat`
--

CREATE TABLE `habitat` (
  `HabitatID` int(11) NOT NULL,
  `HabitatName` varchar(100) NOT NULL,
  `Description` text DEFAULT NULL
) ;

--
-- Dumping data for table `habitat`
--

INSERT INTO `habitat` (`HabitatID`, `HabitatName`, `Description`) VALUES
(1, 'Freshwater Tropical', 'Warm freshwater environment with stable temperatures between 24–28°C, suitable for tetras, guppies, angelfish, and live plants.'),
(2, 'Freshwater Coldwater', 'Cooler freshwater habitat ideal for goldfish and koi, typically 15–22°C.'),
(3, 'Brackish Water', 'Mix of fresh and saltwater with variable salinity levels, suitable for mollies, mudskippers, and certain puffers.'),
(4, 'Saltwater Marine', 'Full ocean-salinity habitat for marine fish like clownfish, tangs, and wrasses.'),
(5, 'Coral Reef', 'Highly biodiverse saltwater environment with corals, anemones, and reef-safe fish species.'),
(6, 'Planted Aquarium', 'Freshwater environment rich in nutrients, CO₂, and lighting for aquatic plants and peaceful fish.'),
(7, 'Nano Tank', 'Small-capacity habitat designed for small fish, shrimp, and low-bioload species.'),
(8, 'Breeding Tank', 'Controlled habitat for breeding fish, featuring gentle filtration and isolated space.'),
(9, 'Quarantine Tank', 'Temporary tank for monitoring and treating sick or new fish before adding them to the main aquarium.'),
(10, 'Pond Habitat', 'Outdoor freshwater ecosystem for koi, goldfish, and aquatic plants with natural sunlight.');

-- --------------------------------------------------------

--
-- Table structure for table `maintenance`
--

CREATE TABLE `maintenance` (
  `MaintenanceID` int(11) NOT NULL,
  `TaskDescription` text NOT NULL,
  `TaskDate` datetime NOT NULL,
  `EmployeeID` int(11) DEFAULT NULL,
  `HabitatID` int(11) NOT NULL
) ;

--
-- Dumping data for table `maintenance`
--

INSERT INTO `maintenance` (`MaintenanceID`, `TaskDescription`, `TaskDate`, `EmployeeID`, `HabitatID`) VALUES
(1, 'Clean viewing windows and remove algae buildup.', '2024-11-05 09:30:00', 4, 5),
(2, 'Check water filters and replace worn filter pads.', '2024-11-06 10:00:00', 7, 9),
(3, 'Inspect and repair lighting system in coral reef habitat.', '2024-11-07 14:15:00', 4, 5),
(4, 'Deep clean touch tank and sanitize guest areas.', '2024-11-08 08:45:00', 1, 7),
(5, 'Test salinity and pH levels and adjust accordingly.', '2024-11-09 11:20:00', 7, 1),
(6, 'Perform routine pump maintenance and lubrication.', '2024-11-10 13:00:00', 4, 10),
(7, 'Inspect habitat barriers and guest safety features.', '2024-11-11 16:10:00', 9, 2),
(8, 'Replace UV sterilizer bulbs in jellyfish habitat.', '2024-11-12 09:00:00', 7, 5),
(9, 'Clean sand substrate and remove debris.', '2024-11-13 15:30:00', 1, 6),
(10, 'Check backup generator powering life-support systems.', '2024-11-14 12:00:00', 4, 9);

-- --------------------------------------------------------

--
-- Table structure for table `plant`
--

CREATE TABLE `plant` (
  `PlantID` int(11) NOT NULL,
  `PlantName` varchar(100) NOT NULL,
  `Species` varchar(100) DEFAULT NULL,
  `HabitatID` int(11) DEFAULT NULL,
  `CountryID` varchar(3) NOT NULL
) ;

--
-- Dumping data for table `plant`
--

INSERT INTO `plant` (`PlantID`, `PlantName`, `Species`, `HabitatID`, `CountryID`) VALUES
(1, 'Amazon Sword', 'Echinodorus amazonicus', 1, 'BRA'),
(2, 'Java Fern', 'Microsorum pteropus', 6, 'IND'),
(3, 'Anubias Nana', 'Anubias barteri', 6, 'NGA'),
(4, 'Hornwort', 'Ceratophyllum demersum', 2, 'CAN'),
(5, 'Duckweed', 'Lemna minor', 10, 'USA'),
(6, 'Red Ludwigia', 'Ludwigia repens', 1, 'MEX'),
(7, 'Water Wisteria', 'Hygrophila difformis', 6, 'BGD'),
(8, 'Marimo Moss Ball', 'Aegagropila linnaei', 7, 'JPN'),
(9, 'Cryptocoryne', 'Cryptocoryne wendtii', 1, 'IND'),
(10, 'Dwarf Hairgrass', 'Eleocharis parvula', 6, 'AUS');

-- --------------------------------------------------------

--
-- Table structure for table `signup`
--

CREATE TABLE `signup` (
  `SignupID` int(11) NOT NULL,
  `VisitorID` int(11) NOT NULL,
  `EventID` int(11) NOT NULL,
  `SignupDate` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `signup`
--

INSERT INTO `signup` (`SignupID`, `VisitorID`, `EventID`, `SignupDate`) VALUES
(1, 1, 101, '2025-03-01 09:00:00'),
(2, 2, 102, '2025-03-02 10:15:00'),
(3, 3, 103, '2025-03-03 11:30:00'),
(4, 4, 104, '2025-03-04 12:45:00'),
(5, 5, 105, '2025-03-05 14:00:00'),
(6, 6, 106, '2025-03-06 15:15:00'),
(7, 7, 107, '2025-03-07 16:30:00'),
(8, 8, 108, '2025-03-08 17:45:00'),
(9, 9, 109, '2025-03-09 09:30:00'),
(10, 10, 110, '2025-03-10 10:45:00'),
(21, 11, 101, '2024-08-15 00:00:00'),
(22, 12, 103, '2024-08-18 00:00:00'),
(23, 13, 106, '2024-08-19 00:00:00'),
(24, 14, 102, '2024-08-20 00:00:00'),
(25, 15, 109, '2024-08-21 00:00:00'),
(26, 16, 104, '2024-08-22 00:00:00'),
(27, 17, 108, '2024-08-25 00:00:00'),
(28, 18, 110, '2024-08-27 00:00:00'),
(29, 19, 105, '2024-08-29 00:00:00'),
(30, 20, 107, '2024-09-01 00:00:00'),
(31, 21, 103, '2024-09-02 00:00:00'),
(32, 22, 102, '2024-09-03 00:00:00'),
(33, 23, 101, '2024-09-05 00:00:00'),
(34, 24, 106, '2024-09-06 00:00:00'),
(35, 25, 109, '2024-09-07 00:00:00'),
(36, 26, 104, '2024-08-22 00:00:00'),
(37, 27, 107, '2024-08-23 00:00:00'),
(38, 28, 103, '2024-08-24 00:00:00'),
(39, 29, 110, '2024-08-25 00:00:00'),
(40, 30, 105, '2024-08-26 00:00:00'),
(41, 31, 101, '2024-08-27 00:00:00'),
(42, 32, 102, '2024-08-29 00:00:00'),
(43, 33, 109, '2024-08-30 00:00:00'),
(44, 34, 108, '2024-09-01 00:00:00'),
(45, 35, 106, '2024-09-02 00:00:00');

--
-- Triggers `signup`
--
DELIMITER $$
CREATE TRIGGER `SignUpDate` BEFORE INSERT ON `signup` FOR EACH ROW BEGIN
    DECLARE v_eventDate DATE;

    -- Look up the event date for the event being signed up for
    SELECT EventDate
    INTO v_eventDate
    FROM event
    WHERE EventID = NEW.EventID;

    -- If the event is in the past, block the insert
    IF v_eventDate < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot sign up for an event in the past';
    END IF;

    -- If SignupDate is not provided, default to now
    IF NEW.SignupDate IS NULL THEN
        SET NEW.SignupDate = NOW();
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `visitor`
--

CREATE TABLE `visitor` (
  `VisitorID` int(11) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `TicketType` enum('Adult','Child','Student','Senior') NOT NULL,
  `TicketPrice` decimal(5,2) NOT NULL,
  `DateofAdmission` date NOT NULL
) ;

--
-- Dumping data for table `visitor`
--

INSERT INTO `visitor` (`VisitorID`, `FirstName`, `LastName`, `Email`, `Phone`, `TicketType`, `TicketPrice`, `DateofAdmission`) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '555-100-2001', 'Adult', 25.00, '2025-02-20'),
(2, 'Sarah', 'Khan', 'sarah.khan@example.com', '555-100-2002', 'Student', 15.00, '2025-02-21'),
(3, 'Michael', 'Brown', 'michael.brown@example.com', '555-100-2003', 'Senior', 18.00, '2025-02-22'),
(4, 'Emily', 'Smith', 'emily.smith@example.com', '555-100-2004', 'Child', 10.00, '2025-02-23'),
(5, 'David', 'Lee', 'david.lee@example.com', '555-100-2005', 'Adult', 25.00, '2025-02-24'),
(6, 'Aisha', 'Rahman', 'aisha.rahman@example.com', '555-100-2006', 'Adult', 25.00, '2025-02-25'),
(7, 'Carlos', 'Martinez', 'carlos.martinez@example.com', '555-100-2007', 'Senior', 18.00, '2025-02-26'),
(8, 'Sophia', 'Wong', 'sophia.wong@example.com', '555-100-2008', 'Student', 15.00, '2025-02-27'),
(9, 'Noah', 'Patel', 'noah.patel@example.com', '555-100-2009', 'Child', 10.00, '2025-02-28'),
(10, 'Maya', 'Johnson', 'maya.johnson@example.com', '555-100-2010', 'Adult', 25.00, '2025-03-01'),
(11, 'Ariana', 'Lewis', 'ariana.lewis@example.com', '832-555-1033', 'Adult', 25.00, '2025-02-24'),
(12, 'Marcus', 'Reed', 'marcus.reed@example.com', '713-555-2290', 'Child', 10.00, '2025-02-24'),
(13, 'Selena', 'Rivera', 'selena.rivera@example.com', '346-555-7811', 'Senior', 18.00, '2025-02-24'),
(14, 'Jordan', 'Thompson', 'jordan.thompson@example.com', '832-555-4448', 'Student', 15.00, '2025-02-24'),
(15, 'Taylor', 'Nguyen', 'taylor.nguyen@example.com', '936-555-3029', 'Adult', 25.00, '2025-02-28'),
(16, 'Evan', 'Carter', 'evan.carter@example.com', '713-555-9094', 'Child', 10.00, '2025-02-28'),
(17, 'Isabella', 'Martinez', 'isabella.martinez@example.com', '281-555-5561', 'Senior', 18.00, '2025-03-24'),
(18, 'Gabriel', 'Price', 'gabriel.price@example.com', '832-555-7782', 'Student', 15.00, '2025-03-24'),
(19, 'Aaliyah', 'Brooks', 'aaliyah.brooks@example.com', '346-555-0042', 'Adult', 25.00, '2025-03-01'),
(20, 'Christopher', 'Hayes', 'chris.hayes@example.com', '713-555-1833', 'Child', 10.00, '2025-02-22'),
(21, 'Mia', 'Sullivan', 'mia.sullivan@example.com', '281-555-9941', 'Student', 15.00, '2025-02-22'),
(22, 'Dante', 'Williams', 'dante.williams@example.com', '832-555-3309', 'Senior', 18.00, '2025-02-22'),
(23, 'Riley', 'Henderson', 'riley.henderson@example.com', '713-555-7214', 'Adult', 25.00, '2025-02-21'),
(24, 'Vanessa', 'Kim', 'vanessa.kim@example.com', '832-555-5588', 'Child', 10.00, '2025-02-21'),
(25, 'Xavier', 'Patterson', 'xavier.patterson@example.com', '346-555-8822', 'Student', 0.00, '2025-03-04'),
(26, 'Jasmine', 'Clark', 'j.clark@example.com', '8325551020', 'Adult', 29.99, '2024-08-14'),
(27, 'Victor', 'Price', 'v.price@example.com', '3465558899', 'Child', 14.99, '2024-08-15'),
(28, 'Elena', 'Morales', 'e.morales@example.com', '7135557721', 'Adult', 29.99, '2024-08-16'),
(29, 'Trenton', 'Adams', 't.adams@example.com', '2815554432', 'Senior', 19.99, '2024-08-17'),
(30, 'Kayla', 'Robinson', 'k.robinson@example.com', '8325559822', 'Adult', 29.99, '2024-08-18'),
(31, 'Mason', 'Lee', 'm.lee@example.com', '7135552299', 'Adult', 29.99, '2024-08-19'),
(32, 'Arielle', 'Hunt', 'a.hunt@example.com', '3465553102', 'Child', 14.99, '2024-08-20'),
(33, 'Noah', 'Mitchell', 'n.mitchell@example.com', '7135559977', 'Adult', 29.99, '2024-08-21'),
(34, 'Riley', 'Sanders', 'r.sanders@example.com', '8325551178', 'Senior', 19.99, '2024-08-22'),
(35, 'Gianna', 'Torres', 'g.torres@example.com', '2815555588', 'Adult', 29.99, '2024-08-23');

--
-- Triggers `visitor`
--
DELIMITER $$
CREATE TRIGGER `AutoVisitorAdmissionDate` BEFORE INSERT ON `visitor` FOR EACH ROW IF NEW.DateOfAdmission IS NULL THEN
    SET NEW.DateOfAdmission = CURDATE();
END IF
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `animal`
--
ALTER TABLE `animal`
  ADD PRIMARY KEY (`AnimalID`),
  ADD KEY `fk_animal_habitat` (`HabitatID`),
  ADD KEY `fk_animal_country` (`CountryID`);

--
-- Indexes for table `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`CountryID`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`EmployeeID`);

--
-- Indexes for table `event`
--
ALTER TABLE `event`
  ADD PRIMARY KEY (`EventID`),
  ADD KEY `fk_event_habitat` (`HabitatID`),
  ADD KEY `fk_event_employee` (`EmployeeID`);

--
-- Indexes for table `feeding`
--
ALTER TABLE `feeding`
  ADD PRIMARY KEY (`AnimalID`,`FeedingTime`),
  ADD KEY `fk_feeding_employee` (`EmployeeID`);

--
-- Indexes for table `habitat`
--
ALTER TABLE `habitat`
  ADD PRIMARY KEY (`HabitatID`);

--
-- Indexes for table `maintenance`
--
ALTER TABLE `maintenance`
  ADD PRIMARY KEY (`MaintenanceID`),
  ADD KEY `fk_maintenance_employee` (`EmployeeID`),
  ADD KEY `fk_maintenance_habitat` (`HabitatID`);

--
-- Indexes for table `plant`
--
ALTER TABLE `plant`
  ADD PRIMARY KEY (`PlantID`),
  ADD KEY `fk_plant_habitat` (`HabitatID`),
  ADD KEY `fk_plant_country` (`CountryID`);

--
-- Indexes for table `signup`
--
ALTER TABLE `signup`
  ADD PRIMARY KEY (`SignupID`),
  ADD UNIQUE KEY `uc_signup` (`VisitorID`,`EventID`),
  ADD KEY `fk_signup_event` (`EventID`);

--
-- Indexes for table `visitor`
--
ALTER TABLE `visitor`
  ADD PRIMARY KEY (`VisitorID`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `animal`
--
ALTER TABLE `animal`
  MODIFY `AnimalID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `event`
--
ALTER TABLE `event`
  MODIFY `EventID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `habitat`
--
ALTER TABLE `habitat`
  MODIFY `HabitatID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `maintenance`
--
ALTER TABLE `maintenance`
  MODIFY `MaintenanceID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `plant`
--
ALTER TABLE `plant`
  MODIFY `PlantID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `signup`
--
ALTER TABLE `signup`
  MODIFY `SignupID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `visitor`
--
ALTER TABLE `visitor`
  MODIFY `VisitorID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `animal`
--
ALTER TABLE `animal`
  ADD CONSTRAINT `fk_animal_country` FOREIGN KEY (`CountryID`) REFERENCES `country` (`CountryID`),
  ADD CONSTRAINT `fk_animal_habitat` FOREIGN KEY (`HabitatID`) REFERENCES `habitat` (`HabitatID`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `event`
--
ALTER TABLE `event`
  ADD CONSTRAINT `fk_event_employee` FOREIGN KEY (`EmployeeID`) REFERENCES `employee` (`EmployeeID`),
  ADD CONSTRAINT `fk_event_habitat` FOREIGN KEY (`HabitatID`) REFERENCES `habitat` (`HabitatID`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `feeding`
--
ALTER TABLE `feeding`
  ADD CONSTRAINT `fk_feeding_animal` FOREIGN KEY (`AnimalID`) REFERENCES `animal` (`AnimalID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_feeding_employee` FOREIGN KEY (`EmployeeID`) REFERENCES `employee` (`EmployeeID`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `maintenance`
--
ALTER TABLE `maintenance`
  ADD CONSTRAINT `fk_maintenance_employee` FOREIGN KEY (`EmployeeID`) REFERENCES `employee` (`EmployeeID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_maintenance_habitat` FOREIGN KEY (`HabitatID`) REFERENCES `habitat` (`HabitatID`) ON DELETE CASCADE;

--
-- Constraints for table `plant`
--
ALTER TABLE `plant`
  ADD CONSTRAINT `fk_plant_country` FOREIGN KEY (`CountryID`) REFERENCES `country` (`CountryID`),
  ADD CONSTRAINT `fk_plant_habitat` FOREIGN KEY (`HabitatID`) REFERENCES `habitat` (`HabitatID`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `signup`
--
ALTER TABLE `signup`
  ADD CONSTRAINT `fk_signup_event` FOREIGN KEY (`EventID`) REFERENCES `event` (`EventID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_signup_visitor` FOREIGN KEY (`VisitorID`) REFERENCES `visitor` (`VisitorID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
