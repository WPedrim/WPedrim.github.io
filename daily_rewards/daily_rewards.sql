CREATE TABLE IF NOT EXISTS `daily_rewards` (
  `identifier` varchar(60) NOT NULL,
  `current_day` int(11) NOT NULL DEFAULT 0,
  `last_claim` timestamp NULL DEFAULT NULL,
  `total_claims` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;