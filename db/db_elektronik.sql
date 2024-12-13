-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 13, 2024 at 06:09 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_elektronik`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `idcart` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `idproduct` varchar(10) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jual`
--

CREATE TABLE `jual` (
  `idjual` varchar(11) NOT NULL,
  `tgljual` date DEFAULT NULL,
  `idproduct` varchar(10) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jual`
--

INSERT INTO `jual` (`idjual`, `tgljual`, `idproduct`, `price`, `quantity`) VALUES
('', '2024-12-13', 'P202409001', 13999000, 1),
('J001', '2024-12-13', 'P202409002', 379000, 1),
('J002', '2024-12-13', 'P202409002', 379000, 1),
('J003', '2024-12-13', 'P202409002', 379000, 1),
('J004', '2024-12-13', 'P202409001', 3588899, 1),
('J005', '2024-12-13', 'P202409001', 3588899, 10),
('J006', '2024-12-13', 'P202409001', 3588899, 2),
('J007', '2024-12-13', 'P202409001', 3588899, 2),
('J008', '2024-12-13', 'P202409002', 379000, 3),
('J010', '2024-12-14', 'P202409004', 30990000, 5),
('J011', '2024-12-14', 'P202409005', 29999000, 5);

-- --------------------------------------------------------

--
-- Table structure for table `namaproduct`
--

CREATE TABLE `namaproduct` (
  `idproduct` varchar(10) NOT NULL,
  `product` varchar(100) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `namaproduct`
--

INSERT INTO `namaproduct` (`idproduct`, `product`, `price`, `image`, `description`) VALUES
('P202409001', 'Laptop Axioo Pongo 725', 13999000, 'https://images.tokopedia.net/img/cache/900/VqbcmM/2023/12/9/9a87d55b-7c24-4f0a-9b9a-76bf12498c26.png', 'Laptop Axioo Pongo 725 hadir dengan performa tinggi berkat prosesor Intel Core i7-12650H, RAM 16GB, dan SSD 512GB untuk kecepatan multitasking dan penyimpanan. Didukung GPU NVIDIA GeForce RTX 2050 4GB, laptop ini menawarkan grafis memukau untuk gaming dan desain. Dengan layar Full HD 15,6 inci, desain modern, serta sistem operasi Windows 11, Axioo Pongo 725 cocok untuk kebutuhan profesional, kreatif, dan hiburan, menjadikannya pilihan andal untuk segala aktivitas.\r\n'),
('P202409002', 'Asus ROG Zephyrus G14\r\n', 38999000, 'https://images.tokopedia.net/img/cache/900/VqbcmM/2024/12/2/597a71ee-a825-4203-a931-142a1d5fd00b.jpg', 'ASUS ROG Zephyrus G14 GA403UV adalah laptop gaming premium dengan prosesor AMD Ryzen 9 8945HS dan NVIDIA GeForce RTX 4060. Dilengkapi dengan 32GB RAM dan 1TB SSD, serta layar 3K OLED untuk visual tajam, laptop ini ideal untuk multitasking dan gaming. Dengan Windows 11 dan One-Handed Keyboard (OHS), G14 menawarkan kenyamanan dan performa tinggi dalam desain kompak dan elegan.'),
('P202409003', 'ACER SWIFT 3 INFINITY 4 ', 12899000, 'https://images.tokopedia.net/img/cache/900/VqbcmM/2022/1/29/cf9ad817-f878-4c62-96a0-e696febc5238.png', 'Acer Swift 3 Infinity 4 SF314 adalah laptop tipis dengan Intel Core i7-1165G7 dan Intel Iris Xe untuk performa cepat. Dilengkapi dengan 16GB RAM dan 512GB SSD, serta Windows 11 dan One-Handed Keyboard (OHS), laptop ini ideal untuk multitasking dan produktivitas. Desain elegan dan portabilitas tinggi membuatnya sempurna untuk profesional dan pelajar.'),
('P202409004', 'iPhone 15 Pro Max 1TB\r\n', 30990000, 'https://www.bhinneka.com/blog/wp-content/uploads/2023/02/Hp-termahal-iPhone-15-Pro-Max-terbaru-2023-404x500.jpg', 'iPhone 15 Pro Max 1TB hadir dengan chip A17 Pro untuk performa cepat dan efisien. Dengan 1TB penyimpanan, layar Super Retina XDR OLED 6,7 inci yang tajam, dan kamera utama 48MP, ponsel ini ideal untuk foto, video, dan gaming. Didukung oleh iOS 17, baterai tahan lama, dan konektivitas 5G, iPhone 15 Pro Max menawarkan pengalaman premium dengan desain elegan.'),
('P202409005', 'Samsung Galaxy Z Fold 5 1TB\r\n', 29999000, 'https://www.bhinneka.com/blog/wp-content/uploads/2023/08/Hp-Samsung-Terbaru-Galaxy-Z-Fold-5-2023-492x500.jpg', 'Samsung Galaxy Z Fold 5 1TB adalah smartphone lipat premium dengan layar utama 7,6 inci Dynamic AMOLED 2X dan layar luar 6,2 inci. Ditenagai oleh Snapdragon 8 Gen 2, ponsel ini menawarkan performa cepat untuk gaming dan produktivitas. Dengan 1TB penyimpanan dan kamera 50MP, Z Fold 5 memberikan pengalaman fotografi dan hiburan profesional. Desain elegan dan portabilitas tinggi menjadikannya pilihan sempurna bagi pengguna yang membutuhkan perangkat inovatif dan multifungsi.'),
('P202409006', 'ASUS ROG Phone 7 Ultimate', 18999000, 'https://www.bhinneka.com/blog/wp-content/uploads/2023/02/Hp-gaming-termahal-asus-rog-phone-7-ultimate-395x500.jpg', '**ASUS ROG Phone 7 Ultimate** adalah smartphone gaming dengan **Snapdragon 8 Gen 2**, **6,78 inci AMOLED 165Hz**, dan **16GB RAM**. Dilengkapi dengan **512GB penyimpanan**, sistem pendingin canggih, dan baterai besar, ponsel ini ideal untuk gaming intensif. Kamera **50MP** dan desain futuristik menambah kesan premium pada perangkat ini.');

-- --------------------------------------------------------

--
-- Table structure for table `riwayat_belanja`
--

CREATE TABLE `riwayat_belanja` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` varchar(10) NOT NULL,
  `purchase_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` text DEFAULT NULL,
  `password` text DEFAULT NULL,
  `nama` text DEFAULT NULL,
  `alamat` varchar(100) DEFAULT NULL,
  `telepon` varchar(15) DEFAULT NULL,
  `foto` text DEFAULT NULL,
  `createdDate` datetime DEFAULT current_timestamp(),
  `verification_code` int(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `nama`, `alamat`, `telepon`, `foto`, `createdDate`, `verification_code`) VALUES
(1935, 'herywijaya2709@gmail.com', '$2y$10$sYJhvNVqxp1XPkXH2lC6auzDhIgHwbtSzZQX8kbKsSSfDXArK8YZS', 'hery', 'a', '1', 'uploads/675c68e5415f4_1000068951.jpg', '2024-12-14 00:03:33', 152992),
(2919, 'o', '$2y$10$1k/HU.ZjYI0X.phpAaAXAuksNz/p/wjwSiHExn6/b5f849Y9DcxPG', 'o', 'l', '99', 'uploads/675c37ee69028_1000068951.jpg', '2024-12-13 20:34:38', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`idcart`),
  ADD KEY `idproduct` (`idproduct`);

--
-- Indexes for table `jual`
--
ALTER TABLE `jual`
  ADD PRIMARY KEY (`idjual`),
  ADD KEY `idproduct` (`idproduct`);

--
-- Indexes for table `namaproduct`
--
ALTER TABLE `namaproduct`
  ADD PRIMARY KEY (`idproduct`);

--
-- Indexes for table `riwayat_belanja`
--
ALTER TABLE `riwayat_belanja`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`) USING HASH;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `idcart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `riwayat_belanja`
--
ALTER TABLE `riwayat_belanja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`idproduct`) REFERENCES `namaproduct` (`idproduct`);

--
-- Constraints for table `jual`
--
ALTER TABLE `jual`
  ADD CONSTRAINT `jual_ibfk_1` FOREIGN KEY (`idproduct`) REFERENCES `namaproduct` (`idproduct`);

--
-- Constraints for table `riwayat_belanja`
--
ALTER TABLE `riwayat_belanja`
  ADD CONSTRAINT `riwayat_belanja_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `namaproduct` (`idproduct`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
