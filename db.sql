-- Membuat Tabel `cart`
CREATE TABLE `cart` (
  `idcart` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `idproduct` VARCHAR(10) NOT NULL,
  `quantity` INT(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`idcart`),
  FOREIGN KEY (`idproduct`) REFERENCES `namaproduct` (`idproduct`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- Membuat Tabel `jual`
CREATE TABLE `jual` (
  `idjual` INT(11) NOT NULL AUTO_INCREMENT,
  `tgljual` DATE DEFAULT NULL,
  `idproduct` VARCHAR(10) DEFAULT NULL,
  `price` INT(11) DEFAULT NULL,
  `quantity` INT(11) DEFAULT NULL,
  PRIMARY KEY (`idjual`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data Mentahan untuk Tabel `jual`
INSERT INTO `jual` (`idjual`, `tgljual`, `idproduct`, `price`, `quantity`) VALUES
(1, '2024-12-11', 'P202409001', 3588899, 2),
(2, '2024-12-11', 'P202409005', 2000000, 1),
(3, '2024-12-11', 'P202409004', 700000, 1),
(4, '2024-12-11', 'P202409003', 900000, 1),
(5, '2024-12-11', 'P202409004', 700000, 4),
(6, '2024-12-11', 'P202409006', 500000, 6),
(7, '2024-12-11', 'P202409005', 2000000, 5),
(8, '2024-12-11', 'P202409001', 3588899, 4),
(9, '2024-12-11', 'P202409002', 379000, 3),
(10, '2024-12-11', 'P202409009', 2300000, 1),
(11, '2024-12-11', 'P202409001', 3588899, 1),
(12, '2024-12-11', 'P202409001', 3588899, 2);




-- Membuat Tabel `namaproduct`
CREATE TABLE `namaproduct` (
  `idproduct` VARCHAR(10) NOT NULL,
  `product` VARCHAR(100) DEFAULT NULL,
  `price` INT(11) DEFAULT NULL,
  `image` TEXT DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  PRIMARY KEY (`idproduct`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data Mentahan untuk Tabel `namaproduct`
INSERT INTO `namaproduct` (`idproduct`, `product`, `price`, `image`, `description`) VALUES
('P202409001', 'Tote Bag', 3588899, 'https://cdn.shopify.com/s/files/1/0366/9825/files/tas-tote-bag-charles-jenis.jpg?v=1490883290', 'Jika Anda kerap membawa banyak barang ketika bepergian, tote bag dapat menjadi pilihan yang tepat. Karena tas yang satu ini bisa memuat banyak barang dan bisa dijinjing dengan satu tangan. Aneka bahan populer untuk tote bag antara lain kulit, rajut, dan kanvas.'),
('P202409002', 'Handbag', 379000, 'https://rtwcreation.com/cdn/shop/files/maroon-classic-handbag-with-blooming-flower-quater.jpg?v=1695717449', 'Handbag selempang wanita ini adalah tas bahu yang trendi dengan desain modis dan fungsional. Terbuat dari bahan PU yang berkualitas.'),
('P202409003', 'Backpack', 900000, 'https://solo-ny.com/cdn/shop/files/UBN795-10_HO_c4f17d2f-425f-4fa9-98c1-dc3f06b1933a.jpg?v=1695141176&width=1080', 'Tas ransel backpack pria - Tas ransel cowok - koleksi import pilihan tas ransel, tas laptop, tas Anti Theft Anti Maling, dengan USB port dan multi fungsi.'),
('P202409004', 'Clutch', 700000, 'https://images.tokopedia.net/img/cache/500-square/VqbcmM/2021/4/24/8e948199-5ff4-4480-bf8d-fd4dfc000aa0.jpg', 'Tas Clutch Selempang Wanita Import ini adalah tas yang sangat mewah dan elegan, cocok untuk digunakan pada acara pesta. Terbuat dari bahan kain yang berkualitas tinggi.'),
('P202409005', 'Quilted Bag', 2000000, 'https://cdn.shopify.com/s/files/1/0366/9825/files/tas-quilted-bag-chanel.jpg?v=1490881665', 'Quilted bag merujuk pada model tas dengan bahan yang dijahit menyerupai selimut dari kain perca. Jadi semua jenis tas, baik berbahan kulit atau kain yang bermotif seperti ini bisa disebut quilted bag (seperti yang bisa kita lihat di gambar).'),
('P202409006', 'Shopper Bag', 500000, 'https://cdn.shopify.com/s/files/1/0366/9825/files/shopper-bag-tas-jenis.jpg?v=1490883508', 'Jika dilihat sekilas, shopper bag memang mirip tote bag dan banyak model tote bag yang bisa juga disebut shopper bag. Namun sering bagian talinya lebih besar dan bisa memuat banyak barang. Kaum wanita senior kerap menyukai jenis tas ini karena dianggap berkelas dan tak pernah ketinggalan zaman.'),
('P202409007', 'Hobo Bag', 650000, 'https://cdn.shopify.com/s/files/1/0366/9825/files/tas-hobo-bag.jpg?v=1490879252', 'Tak sekadar menarik dilihat, tas ini juga tergolong kuat karena beban barang bawaan tersebar merata pada badan dan tali tas.'),
('P202409008', 'Trapezoid Bag', 2500000, 'https://cdn.shopify.com/s/files/1/0366/9825/files/tas-trapezoid-jenis-tas.jpg?v=1490883802', 'Trapezoid adalah model tas yang pada bentuknya yang mirip dengan trapesium. Tas Trapezoid bisa memiliki sisi trapezium bagian atas yang lebih pendek ataupun yang lebih panjang seperti di foto.'),
('P202409009', 'Pouch Wallet', 2300000, 'https://cdn.shopify.com/s/files/1/0366/9825/files/pouch-wallet-jenis-tas_9d92f74d-0df0-48a8-b1fd-d45af25ffaf8.jpg?v=1490885420', 'Pouch wallet berukuran kecil cocok digunakan Anda acara santai dan hangout dengan teman. Ukurannya pas untuk memuat HP, kartu kredit dan item kecil lain seperti kunci dsb. Pouch wallet adalah item alternatifnya dompet formal terutama untuk suasana yang lebih casual.'),
('P202409010', 'Flight Bag', 3000000, 'https://cdn.shopify.com/s/files/1/0366/9825/files/tas-flight-bag-1.jpg?v=1490884737', 'Flight bag adalah istilah jenis tas yang dibawa ke dalam kabin pesawat saat berpergian. Tas flight bag beraneka ragam bentuk, design dan bahannya. Ada yang memiliki design formal ada juga yang casual seperti pada gambar (foto).'),
('P202409011', 'Swagger', 3200000, 'https://cdn.shopify.com/s/files/1/0366/9825/files/tas-swagger-bag-coach-jenis.jpg?v=1490880737', 'Swagger bag adalah signature style dari tas branded Coach. Tas ini memiliki keistimewaan berupa lempeng besi yang menjadi aksen pemanis. Variasi warna, ukuran, dan bahan swagger bag masih menjadi model klasik yang disukai banyak wanita.'),
('P202409012', 'Structured Bag', 2700000, 'https://cdn.shopify.com/s/files/1/0366/9825/files/tas-structured-bag-mk-jenis.jpg?v=1490884444', 'Structured bag adalah istilah untuk semua jenis tas tangan yang kalau tidak diisi barang pun tetap berbentuk atau tidak pipih.');


-- Membuat Tabel `riwayat_belanja`
CREATE TABLE `riwayat_belanja` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `product_id` VARCHAR(10) NOT NULL,
  `purchase_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`product_id`) REFERENCES `namaproduct` (`idproduct`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Membuat Tabel `users`
CREATE TABLE `users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `alamat` VARCHAR(100) DEFAULT NULL,
  `telepon` VARCHAR(15) DEFAULT NULL,
  `foto` TEXT DEFAULT NULL,
  `createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
