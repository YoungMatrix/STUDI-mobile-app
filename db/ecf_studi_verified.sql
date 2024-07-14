-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : sam. 13 juil. 2024 à 13:30
-- Version du serveur : 10.4.28-MariaDB
-- Version de PHP : 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `ecf_studi_verified`
--

-- --------------------------------------------------------

--
-- Structure de la table `admin`
--

CREATE TABLE `admin` (
  `id_admin` int(11) NOT NULL,
  `id_role` int(11) NOT NULL,
  `last_name_admin` varchar(25) NOT NULL,
  `first_name_admin` varchar(25) NOT NULL,
  `email_admin` varchar(255) NOT NULL,
  `password_admin` text NOT NULL,
  `salt_admin` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `admin`
--

INSERT INTO `admin` (`id_admin`, `id_role`, `last_name_admin`, `first_name_admin`, `email_admin`, `password_admin`, `salt_admin`) VALUES
(1, 1, 'ADMIN', 'Admin', 'admin@admin.com', '69b6aac3c7fbd8be247252b97d457e8621e89bbb8e230ec7ad4d56e5c2e5738b926bc1f1815f9f6117aabe53db108ec4e3e4c4c015ef48b83940b59fba9c6de6b5d530e1193eceb5e124fc2cbe5cf30ea3918141b42a6b7e1f94f5b134722db9', '926bc1f1815f9f6117aabe53db108ec4e3e4c4c015ef48b83940b59fba9c6de6');

-- --------------------------------------------------------

--
-- Structure de la table `doctor`
--

CREATE TABLE `doctor` (
  `id_doctor` int(11) NOT NULL,
  `id_role` int(11) NOT NULL,
  `id_field` int(11) NOT NULL,
  `last_name_doctor` varchar(25) NOT NULL,
  `first_name_doctor` varchar(25) NOT NULL,
  `email_doctor` varchar(255) NOT NULL,
  `password_doctor` text NOT NULL,
  `salt_doctor` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `doctor`
--

INSERT INTO `doctor` (`id_doctor`, `id_role`, `id_field`, `last_name_doctor`, `first_name_doctor`, `email_doctor`, `password_doctor`, `salt_doctor`) VALUES
(1, 2, 5, 'GORGIO', 'Daniel', 'd.gorgio.1@soignemoi.com', '9053ba6881e66c98f23c8b1ff87811519dc66595f77d29d1adc9dc71024e9121967fcbd0ba5698da0966f2cbf7388487d86083c67a6cbd5a6e33209fa61df3e2b5d530e1193eceb5e124fc2cbe5cf30ea3918141b42a6b7e1f94f5b134722db9', '967fcbd0ba5698da0966f2cbf7388487d86083c67a6cbd5a6e33209fa61df3e2'),
(2, 2, 1, 'HUBERT', 'Jack', 'j.hubert.2@soignemoi.com', '41308778e6ada120ad82b082e46172c062ba9bbc47f1feefbf817cac977e7c8b9f089540c8643b2f5a786c3d64dc6011c8fb38b90ffdc929a851f5501e83a1e6b5d530e1193eceb5e124fc2cbe5cf30ea3918141b42a6b7e1f94f5b134722db9', '9f089540c8643b2f5a786c3d64dc6011c8fb38b90ffdc929a851f5501e83a1e6'),
(3, 2, 5, 'GREC', 'Ji', 'j.grec.3@soignemoi.com', '6f3c48c9884b86c064b61c310230264f6c8f5246cfdcceca45d595f708c1e6e8bfebd848e7f1dce7f256b63db75a2a361fa858af69c0631474c927b9d9bd15fab5d530e1193eceb5e124fc2cbe5cf30ea3918141b42a6b7e1f94f5b134722db9', 'bfebd848e7f1dce7f256b63db75a2a361fa858af69c0631474c927b9d9bd15fa'),
(4, 2, 6, 'MARC', 'Julien', 'j.marc.4@soignemoi.com', 'f8e85ce31b33e81144cc47f0f6166dcefe38f6a5c4b4b1002ece34024ec5254f324b887e1cd6aa38c7f76adbde28d18e5aeb80e51267a28ed31bdc069bb860fcb5d530e1193eceb5e124fc2cbe5cf30ea3918141b42a6b7e1f94f5b134722db9', '324b887e1cd6aa38c7f76adbde28d18e5aeb80e51267a28ed31bdc069bb860fc'),
(5, 2, 2, 'MARC', 'Julien', 'j.marc.5@soignemoi.com', '0dcbead57affe14bcb4cb95dfc2598e80ae6ef0350372832681bd78b4ded73a62b24dd0680a776c1503a706dcc5fde2c421a1bf4888ec16449c9b4c19ae26fc4b5d530e1193eceb5e124fc2cbe5cf30ea3918141b42a6b7e1f94f5b134722db9', '2b24dd0680a776c1503a706dcc5fde2c421a1bf4888ec16449c9b4c19ae26fc4');

-- --------------------------------------------------------

--
-- Structure de la table `dosage`
--

CREATE TABLE `dosage` (
  `id_dosage` int(11) NOT NULL,
  `quantity_dosage` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `dosage`
--

INSERT INTO `dosage` (`id_dosage`, `quantity_dosage`) VALUES
(1, '1* | 6 heures'),
(2, '1* | Matin'),
(3, '1* | Matin, midi et soir'),
(4, '1* | Midi'),
(5, '1* | Soir'),
(6, 'Si douleur');

-- --------------------------------------------------------

--
-- Structure de la table `drug`
--

CREATE TABLE `drug` (
  `id_drug` int(11) NOT NULL,
  `name_drug` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `drug`
--

INSERT INTO `drug` (`id_drug`, `name_drug`) VALUES
(1, 'Doliprane'),
(2, 'Sirop');

-- --------------------------------------------------------

--
-- Structure de la table `field`
--

CREATE TABLE `field` (
  `id_field` int(11) NOT NULL,
  `name_field` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `field`
--

INSERT INTO `field` (`id_field`, `name_field`) VALUES
(1, 'Chirurgie'),
(2, 'Dermatologie'),
(3, 'Gynécologie'),
(4, 'Médecine Dentaire'),
(5, 'Médecine Générale'),
(6, 'Ophtalmologie');

-- --------------------------------------------------------

--
-- Structure de la table `history`
--

CREATE TABLE `history` (
  `id_history` int(11) NOT NULL,
  `id_patient` int(11) NOT NULL,
  `id_pattern` int(11) NOT NULL,
  `id_field` int(11) NOT NULL,
  `id_doctor` int(11) NOT NULL,
  `date_entrance` date NOT NULL,
  `date_release` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `history`
--

INSERT INTO `history` (`id_history`, `id_patient`, `id_pattern`, `id_field`, `id_doctor`, `date_entrance`, `date_release`) VALUES
(1, 1, 1, 5, 1, '2024-06-16', '2024-07-16'),
(2, 2, 2, 5, 1, '2024-06-16', '2024-07-18'),
(3, 3, 3, 5, 3, '2024-06-16', '2024-08-31'),
(4, 4, 4, 5, 1, '2024-06-16', '2024-08-31'),
(5, 5, 3, 5, 1, '2024-06-16', '2024-08-31'),
(6, 6, 1, 5, 1, '2024-06-16', '2024-08-31');

-- --------------------------------------------------------

--
-- Structure de la table `label`
--

CREATE TABLE `label` (
  `id_label` int(11) NOT NULL,
  `title_label` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `label`
--

INSERT INTO `label` (`id_label`, `title_label`) VALUES
(1, 'Pas de soin'),
(2, 'Repos'),
(3, 'Soin');

-- --------------------------------------------------------

--
-- Structure de la table `medication`
--

CREATE TABLE `medication` (
  `id_medication` int(11) NOT NULL,
  `id_prescription` int(11) NOT NULL,
  `id_drug` int(11) NOT NULL,
  `id_dosage` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `medication`
--

INSERT INTO `medication` (`id_medication`, `id_prescription`, `id_drug`, `id_dosage`) VALUES
(1, 1, 1, 5),
(2, 2, 1, 3);

-- --------------------------------------------------------

--
-- Structure de la table `patient`
--

CREATE TABLE `patient` (
  `id_patient` int(11) NOT NULL,
  `id_role` int(11) NOT NULL,
  `last_name_patient` varchar(25) NOT NULL,
  `first_name_patient` varchar(25) NOT NULL,
  `address_patient` varchar(255) NOT NULL,
  `email_patient` varchar(255) NOT NULL,
  `password_patient` text NOT NULL,
  `salt_patient` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `patient`
--

INSERT INTO `patient` (`id_patient`, `id_role`, `last_name_patient`, `first_name_patient`, `address_patient`, `email_patient`, `password_patient`, `salt_patient`) VALUES
(1, 3, 'TEST', 'Test', '25bis rue de l&#039;église, 75017, paris', 'test@test.com', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08492d075dc82a7215a32619a6eb1949ad336c6842e426237d6a444e28584dc292b5d530e1193eceb5e124fc2cbe5cf30ea3918141b42a6b7e1f94f5b134722db9', '492d075dc82a7215a32619a6eb1949ad336c6842e426237d6a444e28584dc292'),
(2, 3, 'MILANE', 'Achille', '32 rue du rocher, 75016, Paris', 'm.achille@gmail.com', '5aae1e555a5ca4c0489be6a7ff3502208adeca5999d91e78b755b4dafd8ecffeac32178431da5647df10cb59ff4f040b03fe181e02e80ee9691cc3f0d281a39bb5d530e1193eceb5e124fc2cbe5cf30ea3918141b42a6b7e1f94f5b134722db9', 'ac32178431da5647df10cb59ff4f040b03fe181e02e80ee9691cc3f0d281a39b'),
(3, 3, 'ZYGMUNT', 'Vincent', '48 rue de la lance, 75013, paris', 'z.vincent@gmail.com', '8770721234605af7a31cb902253e7990c5d5a3adecfd04429df291a5206d277d1f57ff2786393b92a67a16e5f93b46b696bc87447a55a0041dab9257c276b383b5d530e1193eceb5e124fc2cbe5cf30ea3918141b42a6b7e1f94f5b134722db9', '1f57ff2786393b92a67a16e5f93b46b696bc87447a55a0041dab9257c276b383'),
(4, 3, 'KAOUTAR', 'Kamel', '2 rue de Paris, 75018, Paris', 'k.kamel@gmail.com', '8770721234605af7a31cb902253e7990c5d5a3adecfd04429df291a5206d277d1f57ff2786393b92a67a16e5f93b46b696bc87447a55a0041dab9257c276b383b5d530e1193eceb5e124fc2cbe5cf30ea3918141b42a6b7e1f94f5b134722db9', '1f57ff2786393b92a67a16e5f93b46b696bc87447a55a0041dab9257c276b383'),
(5, 3, 'MIA', 'Amel', '56 rue de Villeneuve, 92300, Levallois', 'm.amel@gmail.com', '8770721234605af7a31cb902253e7990c5d5a3adecfd04429df291a5206d277d1f57ff2786393b92a67a16e5f93b46b696bc87447a55a0041dab9257c276b383b5d530e1193eceb5e124fc2cbe5cf30ea3918141b42a6b7e1f94f5b134722db9', '1f57ff2786393b92a67a16e5f93b46b696bc87447a55a0041dab9257c276b383'),
(6, 3, 'KHEIDAR', 'Prune', '4 rue de Londres, 75009, Paris', 'k.prune@gmail.com', '8770721234605af7a31cb902253e7990c5d5a3adecfd04429df291a5206d277d1f57ff2786393b92a67a16e5f93b46b696bc87447a55a0041dab9257c276b383b5d530e1193eceb5e124fc2cbe5cf30ea3918141b42a6b7e1f94f5b134722db9', '1f57ff2786393b92a67a16e5f93b46b696bc87447a55a0041dab9257c276b383');

-- --------------------------------------------------------

--
-- Structure de la table `pattern`
--

CREATE TABLE `pattern` (
  `id_pattern` int(11) NOT NULL,
  `name_pattern` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `pattern`
--

INSERT INTO `pattern` (`id_pattern`, `name_pattern`) VALUES
(1, 'Consultation'),
(2, 'Douleur'),
(3, 'Fatigue'),
(4, 'Suivi');

-- --------------------------------------------------------

--
-- Structure de la table `planning`
--

CREATE TABLE `planning` (
  `id_planning` int(11) NOT NULL,
  `id_history` int(11) NOT NULL,
  `id_confirmed_doctor` int(11) NOT NULL,
  `id_prescription` int(11) DEFAULT NULL,
  `date_planning` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `planning`
--

INSERT INTO `planning` (`id_planning`, `id_history`, `id_confirmed_doctor`, `id_prescription`, `date_planning`) VALUES
(155, 3, 3, NULL, '2024-06-16'),
(156, 3, 3, NULL, '2024-06-17'),
(157, 3, 3, NULL, '2024-06-18'),
(158, 3, 3, NULL, '2024-06-19'),
(159, 3, 3, NULL, '2024-06-20'),
(160, 3, 3, NULL, '2024-06-21'),
(161, 3, 3, NULL, '2024-06-22'),
(162, 3, 3, NULL, '2024-06-23'),
(163, 3, 3, NULL, '2024-06-24'),
(164, 3, 3, NULL, '2024-06-25'),
(165, 3, 3, NULL, '2024-06-26'),
(166, 3, 3, NULL, '2024-06-27'),
(167, 3, 3, NULL, '2024-06-28'),
(168, 3, 3, NULL, '2024-06-29'),
(169, 3, 3, NULL, '2024-06-30'),
(170, 3, 3, NULL, '2024-07-01'),
(171, 3, 3, NULL, '2024-07-02'),
(172, 3, 3, NULL, '2024-07-03'),
(173, 3, 3, NULL, '2024-07-04'),
(174, 3, 3, NULL, '2024-07-05'),
(175, 3, 3, NULL, '2024-07-06'),
(176, 3, 3, NULL, '2024-07-07'),
(177, 3, 3, NULL, '2024-07-08'),
(178, 3, 3, NULL, '2024-07-09'),
(179, 3, 3, NULL, '2024-07-10'),
(180, 3, 3, NULL, '2024-07-11'),
(181, 3, 3, NULL, '2024-07-12'),
(182, 3, 3, NULL, '2024-07-13'),
(183, 3, 3, NULL, '2024-07-14'),
(184, 3, 3, NULL, '2024-07-15'),
(185, 3, 3, NULL, '2024-07-16'),
(186, 3, 3, NULL, '2024-07-17'),
(187, 3, 3, NULL, '2024-07-18'),
(188, 3, 3, NULL, '2024-07-19'),
(189, 3, 3, NULL, '2024-07-20'),
(190, 3, 3, NULL, '2024-07-21'),
(191, 3, 3, NULL, '2024-07-22'),
(192, 3, 3, NULL, '2024-07-23'),
(193, 3, 3, NULL, '2024-07-24'),
(194, 3, 3, NULL, '2024-07-25'),
(195, 3, 3, NULL, '2024-07-26'),
(196, 3, 3, NULL, '2024-07-27'),
(197, 3, 3, NULL, '2024-07-28'),
(198, 3, 3, NULL, '2024-07-29'),
(199, 3, 3, NULL, '2024-07-30'),
(200, 3, 3, NULL, '2024-07-31'),
(201, 3, 3, NULL, '2024-08-01'),
(202, 3, 3, NULL, '2024-08-02'),
(203, 3, 3, NULL, '2024-08-03'),
(204, 3, 3, NULL, '2024-08-04'),
(205, 3, 3, NULL, '2024-08-05'),
(206, 3, 3, NULL, '2024-08-06'),
(207, 3, 3, NULL, '2024-08-07'),
(208, 3, 3, NULL, '2024-08-08'),
(209, 3, 3, NULL, '2024-08-09'),
(210, 3, 3, NULL, '2024-08-10'),
(211, 3, 3, NULL, '2024-08-11'),
(212, 3, 3, NULL, '2024-08-12'),
(213, 3, 3, NULL, '2024-08-13'),
(214, 3, 3, NULL, '2024-08-14'),
(215, 3, 3, NULL, '2024-08-15'),
(216, 3, 3, NULL, '2024-08-16'),
(217, 3, 3, NULL, '2024-08-17'),
(218, 3, 3, NULL, '2024-08-18'),
(219, 3, 3, NULL, '2024-08-19'),
(220, 3, 3, NULL, '2024-08-20'),
(221, 3, 3, NULL, '2024-08-21'),
(222, 3, 3, NULL, '2024-08-22'),
(223, 3, 3, NULL, '2024-08-23'),
(224, 3, 3, NULL, '2024-08-24'),
(225, 3, 3, NULL, '2024-08-25'),
(226, 3, 3, NULL, '2024-08-26'),
(227, 3, 3, NULL, '2024-08-27'),
(228, 3, 3, NULL, '2024-08-28'),
(229, 3, 3, NULL, '2024-08-29'),
(230, 3, 3, NULL, '2024-08-30'),
(231, 3, 3, NULL, '2024-08-31'),
(232, 4, 1, NULL, '2024-06-16'),
(233, 4, 1, NULL, '2024-06-17'),
(234, 4, 1, NULL, '2024-06-18'),
(235, 4, 1, NULL, '2024-06-19'),
(236, 4, 1, NULL, '2024-06-20'),
(237, 4, 1, NULL, '2024-06-21'),
(238, 4, 1, NULL, '2024-06-22'),
(239, 4, 1, NULL, '2024-06-23'),
(240, 4, 1, NULL, '2024-06-24'),
(241, 4, 1, NULL, '2024-06-25'),
(242, 4, 1, NULL, '2024-06-26'),
(243, 4, 1, NULL, '2024-06-27'),
(244, 4, 1, NULL, '2024-06-28'),
(245, 4, 1, NULL, '2024-06-29'),
(246, 4, 1, NULL, '2024-06-30'),
(247, 4, 1, NULL, '2024-07-01'),
(248, 4, 1, NULL, '2024-07-02'),
(249, 4, 1, NULL, '2024-07-03'),
(250, 4, 1, NULL, '2024-07-04'),
(251, 4, 1, NULL, '2024-07-05'),
(252, 4, 1, NULL, '2024-07-06'),
(253, 4, 1, NULL, '2024-07-07'),
(254, 4, 1, NULL, '2024-07-08'),
(255, 4, 1, NULL, '2024-07-09'),
(256, 4, 1, NULL, '2024-07-10'),
(257, 4, 1, NULL, '2024-07-11'),
(258, 4, 1, NULL, '2024-07-12'),
(259, 4, 1, NULL, '2024-07-13'),
(260, 4, 1, NULL, '2024-07-14'),
(261, 4, 1, NULL, '2024-07-15'),
(262, 4, 1, NULL, '2024-07-16'),
(263, 4, 1, NULL, '2024-07-17'),
(264, 4, 1, NULL, '2024-07-18'),
(265, 4, 1, NULL, '2024-07-19'),
(266, 4, 1, NULL, '2024-07-20'),
(267, 4, 1, NULL, '2024-07-21'),
(268, 4, 1, NULL, '2024-07-22'),
(269, 4, 1, NULL, '2024-07-23'),
(270, 4, 1, NULL, '2024-07-24'),
(271, 4, 1, NULL, '2024-07-25'),
(272, 4, 1, NULL, '2024-07-26'),
(273, 4, 1, NULL, '2024-07-27'),
(274, 4, 1, NULL, '2024-07-28'),
(275, 4, 1, NULL, '2024-07-29'),
(276, 4, 1, NULL, '2024-07-30'),
(277, 4, 1, NULL, '2024-07-31'),
(278, 4, 1, NULL, '2024-08-01'),
(279, 4, 1, NULL, '2024-08-02'),
(280, 4, 1, NULL, '2024-08-03'),
(281, 4, 1, NULL, '2024-08-04'),
(282, 4, 1, NULL, '2024-08-05'),
(283, 4, 1, NULL, '2024-08-06'),
(284, 4, 1, NULL, '2024-08-07'),
(285, 4, 1, NULL, '2024-08-08'),
(286, 4, 1, NULL, '2024-08-09'),
(287, 4, 1, NULL, '2024-08-10'),
(288, 4, 1, NULL, '2024-08-11'),
(289, 4, 1, NULL, '2024-08-12'),
(290, 4, 1, NULL, '2024-08-13'),
(291, 4, 1, NULL, '2024-08-14'),
(292, 4, 1, NULL, '2024-08-15'),
(293, 4, 1, NULL, '2024-08-16'),
(294, 4, 1, NULL, '2024-08-17'),
(295, 4, 1, NULL, '2024-08-18'),
(296, 4, 1, NULL, '2024-08-19'),
(297, 4, 1, NULL, '2024-08-20'),
(298, 4, 1, NULL, '2024-08-21'),
(299, 4, 1, NULL, '2024-08-22'),
(300, 4, 1, NULL, '2024-08-23'),
(301, 4, 1, NULL, '2024-08-24'),
(302, 4, 1, NULL, '2024-08-25'),
(303, 4, 1, NULL, '2024-08-26'),
(304, 4, 1, NULL, '2024-08-27'),
(305, 4, 1, NULL, '2024-08-28'),
(306, 4, 1, NULL, '2024-08-29'),
(307, 4, 1, NULL, '2024-08-30'),
(308, 4, 1, NULL, '2024-08-31'),
(309, 5, 1, NULL, '2024-06-16'),
(310, 5, 1, NULL, '2024-06-17'),
(311, 5, 1, NULL, '2024-06-18'),
(312, 5, 1, NULL, '2024-06-19'),
(313, 5, 1, NULL, '2024-06-20'),
(314, 5, 1, NULL, '2024-06-21'),
(315, 5, 1, NULL, '2024-06-22'),
(316, 5, 1, NULL, '2024-06-23'),
(317, 5, 1, NULL, '2024-06-24'),
(318, 5, 1, NULL, '2024-06-25'),
(319, 5, 1, NULL, '2024-06-26'),
(320, 5, 1, NULL, '2024-06-27'),
(321, 5, 1, NULL, '2024-06-28'),
(322, 5, 1, NULL, '2024-06-29'),
(323, 5, 1, NULL, '2024-06-30'),
(324, 5, 1, NULL, '2024-07-01'),
(325, 5, 1, NULL, '2024-07-02'),
(326, 5, 1, NULL, '2024-07-03'),
(327, 5, 1, NULL, '2024-07-04'),
(328, 5, 1, NULL, '2024-07-05'),
(329, 5, 1, NULL, '2024-07-06'),
(330, 5, 1, NULL, '2024-07-07'),
(331, 5, 1, NULL, '2024-07-08'),
(332, 5, 1, NULL, '2024-07-09'),
(333, 5, 1, NULL, '2024-07-10'),
(334, 5, 1, NULL, '2024-07-11'),
(335, 5, 1, NULL, '2024-07-12'),
(336, 5, 1, NULL, '2024-07-13'),
(337, 5, 1, NULL, '2024-07-14'),
(338, 5, 1, NULL, '2024-07-15'),
(339, 5, 1, NULL, '2024-07-16'),
(340, 5, 1, NULL, '2024-07-17'),
(341, 5, 1, NULL, '2024-07-18'),
(342, 5, 1, NULL, '2024-07-19'),
(343, 5, 1, NULL, '2024-07-20'),
(344, 5, 1, NULL, '2024-07-21'),
(345, 5, 1, NULL, '2024-07-22'),
(346, 5, 1, NULL, '2024-07-23'),
(347, 5, 1, NULL, '2024-07-24'),
(348, 5, 1, NULL, '2024-07-25'),
(349, 5, 1, NULL, '2024-07-26'),
(350, 5, 1, NULL, '2024-07-27'),
(351, 5, 1, NULL, '2024-07-28'),
(352, 5, 1, NULL, '2024-07-29'),
(353, 5, 1, NULL, '2024-07-30'),
(354, 5, 1, NULL, '2024-07-31'),
(355, 5, 1, NULL, '2024-08-01'),
(356, 5, 1, NULL, '2024-08-02'),
(357, 5, 1, NULL, '2024-08-03'),
(358, 5, 1, NULL, '2024-08-04'),
(359, 5, 1, NULL, '2024-08-05'),
(360, 5, 1, NULL, '2024-08-06'),
(361, 5, 1, NULL, '2024-08-07'),
(362, 5, 1, NULL, '2024-08-08'),
(363, 5, 1, NULL, '2024-08-09'),
(364, 5, 1, NULL, '2024-08-10'),
(365, 5, 1, NULL, '2024-08-11'),
(366, 5, 1, NULL, '2024-08-12'),
(367, 5, 1, NULL, '2024-08-13'),
(368, 5, 1, NULL, '2024-08-14'),
(369, 5, 1, NULL, '2024-08-15'),
(370, 5, 1, NULL, '2024-08-16'),
(371, 5, 1, NULL, '2024-08-17'),
(372, 5, 1, NULL, '2024-08-18'),
(373, 5, 1, NULL, '2024-08-19'),
(374, 5, 1, NULL, '2024-08-20'),
(375, 5, 1, NULL, '2024-08-21'),
(376, 5, 1, NULL, '2024-08-22'),
(377, 5, 1, NULL, '2024-08-23'),
(378, 5, 1, NULL, '2024-08-24'),
(379, 5, 1, NULL, '2024-08-25'),
(380, 5, 1, NULL, '2024-08-26'),
(381, 5, 1, NULL, '2024-08-27'),
(382, 5, 1, NULL, '2024-08-28'),
(383, 5, 1, NULL, '2024-08-29'),
(384, 5, 1, NULL, '2024-08-30'),
(385, 5, 1, NULL, '2024-08-31'),
(386, 6, 1, NULL, '2024-06-16'),
(387, 6, 1, NULL, '2024-06-17'),
(388, 6, 1, NULL, '2024-06-18'),
(389, 6, 1, NULL, '2024-06-19'),
(390, 6, 1, NULL, '2024-06-20'),
(391, 6, 1, NULL, '2024-06-21'),
(392, 6, 1, NULL, '2024-06-22'),
(393, 6, 1, NULL, '2024-06-23'),
(394, 6, 1, NULL, '2024-06-24'),
(395, 6, 1, NULL, '2024-06-25'),
(396, 6, 1, NULL, '2024-06-26'),
(397, 6, 1, NULL, '2024-06-27'),
(398, 6, 1, NULL, '2024-06-28'),
(399, 6, 1, NULL, '2024-06-29'),
(400, 6, 1, NULL, '2024-06-30'),
(401, 6, 1, NULL, '2024-07-01'),
(402, 6, 1, NULL, '2024-07-02'),
(403, 6, 1, NULL, '2024-07-03'),
(404, 6, 1, NULL, '2024-07-04'),
(405, 6, 1, NULL, '2024-07-05'),
(406, 6, 1, NULL, '2024-07-06'),
(407, 6, 1, NULL, '2024-07-07'),
(408, 6, 1, NULL, '2024-07-08'),
(409, 6, 1, NULL, '2024-07-09'),
(410, 6, 1, NULL, '2024-07-10'),
(411, 6, 1, NULL, '2024-07-11'),
(412, 6, 1, NULL, '2024-07-12'),
(413, 6, 1, NULL, '2024-07-13'),
(414, 6, 1, NULL, '2024-07-14'),
(415, 6, 1, NULL, '2024-07-15'),
(416, 6, 1, NULL, '2024-07-16'),
(417, 6, 1, NULL, '2024-07-17'),
(418, 6, 1, NULL, '2024-07-18'),
(419, 6, 1, NULL, '2024-07-19'),
(420, 6, 1, NULL, '2024-07-20'),
(421, 6, 1, NULL, '2024-07-21'),
(422, 6, 1, NULL, '2024-07-22'),
(423, 6, 1, NULL, '2024-07-23'),
(424, 6, 1, NULL, '2024-07-24'),
(425, 6, 1, NULL, '2024-07-25'),
(426, 6, 1, NULL, '2024-07-26'),
(427, 6, 1, NULL, '2024-07-27'),
(428, 6, 1, NULL, '2024-07-28'),
(429, 6, 1, NULL, '2024-07-29'),
(430, 6, 1, NULL, '2024-07-30'),
(431, 6, 1, NULL, '2024-07-31'),
(432, 6, 1, NULL, '2024-08-01'),
(433, 6, 1, NULL, '2024-08-02'),
(434, 6, 1, NULL, '2024-08-03'),
(435, 6, 1, NULL, '2024-08-04'),
(436, 6, 1, NULL, '2024-08-05'),
(437, 6, 1, NULL, '2024-08-06'),
(438, 6, 1, NULL, '2024-08-07'),
(439, 6, 1, NULL, '2024-08-08'),
(440, 6, 1, NULL, '2024-08-09'),
(441, 6, 1, NULL, '2024-08-10'),
(442, 6, 1, NULL, '2024-08-11'),
(443, 6, 1, NULL, '2024-08-12'),
(444, 6, 1, NULL, '2024-08-13'),
(445, 6, 1, NULL, '2024-08-14'),
(446, 6, 1, NULL, '2024-08-15'),
(447, 6, 1, NULL, '2024-08-16'),
(448, 6, 1, NULL, '2024-08-17'),
(449, 6, 1, NULL, '2024-08-18'),
(450, 6, 1, NULL, '2024-08-19'),
(451, 6, 1, NULL, '2024-08-20'),
(452, 6, 1, NULL, '2024-08-21'),
(453, 6, 1, NULL, '2024-08-22'),
(454, 6, 1, NULL, '2024-08-23'),
(455, 6, 1, NULL, '2024-08-24'),
(456, 6, 1, NULL, '2024-08-25'),
(457, 6, 1, NULL, '2024-08-26'),
(458, 6, 1, NULL, '2024-08-27'),
(459, 6, 1, NULL, '2024-08-28'),
(460, 6, 1, NULL, '2024-08-29'),
(461, 6, 1, NULL, '2024-08-30'),
(462, 6, 1, NULL, '2024-08-31'),
(463, 1, 1, 1, '2024-06-16'),
(464, 1, 1, 1, '2024-06-17'),
(465, 1, 1, 1, '2024-06-18'),
(466, 1, 1, 1, '2024-06-19'),
(467, 1, 1, 1, '2024-06-20'),
(468, 1, 1, 1, '2024-06-21'),
(469, 1, 1, 1, '2024-06-22'),
(470, 1, 1, 1, '2024-06-23'),
(471, 1, 1, 1, '2024-06-24'),
(472, 1, 1, 1, '2024-06-25'),
(473, 1, 1, 1, '2024-06-26'),
(474, 1, 1, 1, '2024-06-27'),
(475, 1, 1, 1, '2024-06-28'),
(476, 1, 1, 1, '2024-06-29'),
(477, 1, 1, 1, '2024-06-30'),
(478, 1, 1, 1, '2024-07-01'),
(479, 1, 1, 1, '2024-07-02'),
(480, 1, 1, 1, '2024-07-03'),
(481, 1, 1, 1, '2024-07-04'),
(482, 1, 1, 1, '2024-07-05'),
(483, 1, 1, 1, '2024-07-06'),
(484, 1, 1, 1, '2024-07-07'),
(485, 1, 1, 1, '2024-07-08'),
(486, 1, 1, 1, '2024-07-09'),
(487, 1, 1, 1, '2024-07-10'),
(488, 1, 1, 1, '2024-07-11'),
(489, 1, 1, 1, '2024-07-12'),
(490, 1, 1, 1, '2024-07-13'),
(491, 1, 1, 1, '2024-07-14'),
(492, 1, 1, 1, '2024-07-15'),
(493, 1, 1, 1, '2024-07-16'),
(494, 2, 1, 2, '2024-06-16'),
(495, 2, 1, 2, '2024-06-17'),
(496, 2, 1, 2, '2024-06-18'),
(497, 2, 1, 2, '2024-06-19'),
(498, 2, 1, 2, '2024-06-20'),
(499, 2, 1, 2, '2024-06-21'),
(500, 2, 1, 2, '2024-06-22'),
(501, 2, 1, 2, '2024-06-23'),
(502, 2, 1, 2, '2024-06-24'),
(503, 2, 1, 2, '2024-06-25'),
(504, 2, 1, 2, '2024-06-26'),
(505, 2, 1, 2, '2024-06-27'),
(506, 2, 1, 2, '2024-06-28'),
(507, 2, 1, 2, '2024-06-29'),
(508, 2, 1, 2, '2024-06-30'),
(509, 2, 1, 2, '2024-07-01'),
(510, 2, 1, 2, '2024-07-02'),
(511, 2, 1, 2, '2024-07-03'),
(512, 2, 1, 2, '2024-07-04'),
(513, 2, 1, 2, '2024-07-05'),
(514, 2, 1, 2, '2024-07-06'),
(515, 2, 1, 2, '2024-07-07'),
(516, 2, 1, 2, '2024-07-08'),
(517, 2, 1, 2, '2024-07-09'),
(518, 2, 1, 2, '2024-07-10'),
(519, 2, 1, 2, '2024-07-11'),
(520, 2, 1, 2, '2024-07-12'),
(521, 2, 1, 2, '2024-07-13'),
(522, 2, 1, 2, '2024-07-14'),
(523, 2, 1, 2, '2024-07-15'),
(524, 2, 1, 2, '2024-07-16'),
(525, 2, 1, 2, '2024-07-17'),
(526, 2, 1, 2, '2024-07-18');

-- --------------------------------------------------------

--
-- Structure de la table `prescription`
--

CREATE TABLE `prescription` (
  `id_prescription` int(11) NOT NULL,
  `id_label` int(11) NOT NULL,
  `date_prescription` date NOT NULL,
  `date_start_prescription` date NOT NULL,
  `date_end_prescription` date NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `prescription`
--

INSERT INTO `prescription` (`id_prescription`, `id_label`, `date_prescription`, `date_start_prescription`, `date_end_prescription`, `description`) VALUES
(1, 3, '2024-07-13', '2024-07-13', '2024-07-16', 'test22'),
(2, 1, '2024-07-13', '2024-07-14', '2024-07-18', 'ok');

-- --------------------------------------------------------

--
-- Structure de la table `role`
--

CREATE TABLE `role` (
  `id_role` int(11) NOT NULL,
  `name_role` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `role`
--

INSERT INTO `role` (`id_role`, `name_role`) VALUES
(1, 'admin'),
(2, 'docteur'),
(3, 'patient'),
(4, 'secretary');

-- --------------------------------------------------------

--
-- Structure de la table `secretary`
--

CREATE TABLE `secretary` (
  `id_secretary` int(11) NOT NULL,
  `id_role` int(11) NOT NULL,
  `last_name_secretary` varchar(25) NOT NULL,
  `first_name_secretary` varchar(25) NOT NULL,
  `email_secretary` varchar(255) NOT NULL,
  `password_secretary` text NOT NULL,
  `salt_secretary` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `secretary`
--

INSERT INTO `secretary` (`id_secretary`, `id_role`, `last_name_secretary`, `first_name_secretary`, `email_secretary`, `password_secretary`, `salt_secretary`) VALUES
(1, 4, 'FARA', 'Milène', 'm.fara.1@soignemoi.com', '42d830cfac4d52a1546918e917d625db6b1c037f24b62195d03bc310efa64c6df6141924800b7bd32402eea315e26d0c469fd9c98940ab9199f4f9f02f7f4c11b5d530e1193eceb5e124fc2cbe5cf30ea3918141b42a6b7e1f94f5b134722db9', 'f6141924800b7bd32402eea315e26d0c469fd9c98940ab9199f4f9f02f7f4c11');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id_admin`),
  ADD UNIQUE KEY `email_admin` (`email_admin`),
  ADD KEY `id_role` (`id_role`);

--
-- Index pour la table `doctor`
--
ALTER TABLE `doctor`
  ADD PRIMARY KEY (`id_doctor`),
  ADD UNIQUE KEY `email_doctor` (`email_doctor`),
  ADD KEY `id_role` (`id_role`),
  ADD KEY `id_field` (`id_field`);

--
-- Index pour la table `dosage`
--
ALTER TABLE `dosage`
  ADD PRIMARY KEY (`id_dosage`),
  ADD UNIQUE KEY `quantity_dosage` (`quantity_dosage`);

--
-- Index pour la table `drug`
--
ALTER TABLE `drug`
  ADD PRIMARY KEY (`id_drug`),
  ADD UNIQUE KEY `name_drug` (`name_drug`);

--
-- Index pour la table `field`
--
ALTER TABLE `field`
  ADD PRIMARY KEY (`id_field`),
  ADD UNIQUE KEY `name_field` (`name_field`);

--
-- Index pour la table `history`
--
ALTER TABLE `history`
  ADD PRIMARY KEY (`id_history`),
  ADD KEY `id_patient` (`id_patient`),
  ADD KEY `id_pattern` (`id_pattern`),
  ADD KEY `id_field` (`id_field`),
  ADD KEY `id_doctor` (`id_doctor`);

--
-- Index pour la table `label`
--
ALTER TABLE `label`
  ADD PRIMARY KEY (`id_label`),
  ADD UNIQUE KEY `title_label` (`title_label`);

--
-- Index pour la table `medication`
--
ALTER TABLE `medication`
  ADD PRIMARY KEY (`id_medication`),
  ADD KEY `id_prescription` (`id_prescription`),
  ADD KEY `id_drug` (`id_drug`),
  ADD KEY `id_dosage` (`id_dosage`);

--
-- Index pour la table `patient`
--
ALTER TABLE `patient`
  ADD PRIMARY KEY (`id_patient`),
  ADD UNIQUE KEY `email_user` (`email_patient`),
  ADD KEY `id_role` (`id_role`);

--
-- Index pour la table `pattern`
--
ALTER TABLE `pattern`
  ADD PRIMARY KEY (`id_pattern`),
  ADD UNIQUE KEY `name_pattern` (`name_pattern`);

--
-- Index pour la table `planning`
--
ALTER TABLE `planning`
  ADD PRIMARY KEY (`id_planning`),
  ADD KEY `id_history` (`id_history`),
  ADD KEY `id_confirmed_doctor` (`id_confirmed_doctor`),
  ADD KEY `id_prescription` (`id_prescription`);

--
-- Index pour la table `prescription`
--
ALTER TABLE `prescription`
  ADD PRIMARY KEY (`id_prescription`),
  ADD KEY `id_label` (`id_label`);

--
-- Index pour la table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`id_role`),
  ADD UNIQUE KEY `name_role` (`name_role`);

--
-- Index pour la table `secretary`
--
ALTER TABLE `secretary`
  ADD PRIMARY KEY (`id_secretary`),
  ADD UNIQUE KEY `email_secretary` (`email_secretary`),
  ADD KEY `id_role` (`id_role`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `admin`
--
ALTER TABLE `admin`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `doctor`
--
ALTER TABLE `doctor`
  MODIFY `id_doctor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `dosage`
--
ALTER TABLE `dosage`
  MODIFY `id_dosage` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `drug`
--
ALTER TABLE `drug`
  MODIFY `id_drug` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `field`
--
ALTER TABLE `field`
  MODIFY `id_field` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `history`
--
ALTER TABLE `history`
  MODIFY `id_history` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `label`
--
ALTER TABLE `label`
  MODIFY `id_label` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `medication`
--
ALTER TABLE `medication`
  MODIFY `id_medication` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `patient`
--
ALTER TABLE `patient`
  MODIFY `id_patient` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `pattern`
--
ALTER TABLE `pattern`
  MODIFY `id_pattern` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `planning`
--
ALTER TABLE `planning`
  MODIFY `id_planning` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=527;

--
-- AUTO_INCREMENT pour la table `prescription`
--
ALTER TABLE `prescription`
  MODIFY `id_prescription` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `role`
--
ALTER TABLE `role`
  MODIFY `id_role` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `secretary`
--
ALTER TABLE `secretary`
  MODIFY `id_secretary` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `history`
--
ALTER TABLE `history`
  ADD CONSTRAINT `history_ibfk_1` FOREIGN KEY (`id_pattern`) REFERENCES `pattern` (`id_pattern`),
  ADD CONSTRAINT `history_ibfk_2` FOREIGN KEY (`id_patient`) REFERENCES `patient` (`id_patient`),
  ADD CONSTRAINT `history_ibfk_3` FOREIGN KEY (`id_field`) REFERENCES `field` (`id_field`),
  ADD CONSTRAINT `history_ibfk_4` FOREIGN KEY (`id_doctor`) REFERENCES `doctor` (`id_doctor`);

--
-- Contraintes pour la table `patient`
--
ALTER TABLE `patient`
  ADD CONSTRAINT `patient_ibfk_1` FOREIGN KEY (`id_role`) REFERENCES `role` (`id_role`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
