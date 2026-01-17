USE smart_transport_assistant;

-- SELECT + WHERE ---------------------------------------------

-- Engelli erişimi olan araçlar
SELECT * FROM Vehicles WHERE is_accessible = TRUE;

-- Öğrenci kullanıcılar
SELECT * FROM Users WHERE user_type_id = 1;

-- Yoğunluğu %70'ten fazla olan seferler
SELECT * FROM Trips WHERE crowd_level > 70.00;

-- Hafta içi seferler
SELECT * FROM Schedule WHERE day_type = 'weekday';

-- Ücretsiz olan fiyatlandırmalar
SELECT * FROM Pricing WHERE price = 0.00;

-- Kapasitesi 100 kişiden fazla olan tüm araçlar
SELECT * FROM Vehicles WHERE capacity > 100;

-- Hafta içi VE sabah seferleri
SELECT * FROM Schedule 
WHERE day_type = 'weekday' 
AND departure_time < '12:00:00';

-- Her rotadaki ortalama yoğunluğu hesaplar ve ortalama yoğunluğu %50'den fazla olan rotaları gösterir
SELECT route_id, AVG(crowd_level) as avg_crowd
FROM Trips 
GROUP BY route_id 
HAVING AVG(crowd_level) > 50.00;


-- UPDATE ---------------------------------------------------------

-- Bir aracın konumunu güncelle
UPDATE Vehicles 
SET real_time_location = POINT(41.0200, 28.9800)
WHERE vehicle_id = 1;

-- Kullanıcı telefon numarası güncelle
UPDATE Users 
SET phone = '5559998877'
WHERE user_id = 1;

-- Seferin yoğunluğunu güncelle
UPDATE Trips 
SET crowd_level = 65.50
WHERE trip_id = 1;


-- ORDER BY --------------------------------------------------------------

-- Kullanıcıları kayıt tarihine göre sırala 
SELECT * FROM Users ORDER BY registration_date DESC;

-- Seferleri yoğunluğa göre sırala (en yoğundan en boşa)
SELECT * FROM Trips ORDER BY crowd_level DESC;

-- Fiyatları ucuzdan pahalıya sırala
SELECT * FROM Pricing ORDER BY price ASC;

-- Durakları isme göre alfabetik sırala
SELECT * FROM Stations ORDER BY station_name;


-- SUBQUERYS ----------------------------------------------------------------

-- İndirimli kullanıcı tiplerine sahip kullanıcılar
SELECT * FROM Users 
WHERE user_type_id IN (
    SELECT user_type_id FROM User_Types WHERE discount_rate < 1.00
);

-- En uzun rotaya sahip seferler
SELECT * FROM Trips 
WHERE route_id = (
    SELECT route_id FROM Routes ORDER BY total_distance DESC LIMIT 1
);

-- Öğrencilerin kullandığı araçlar
SELECT * FROM Vehicles 
WHERE vehicle_id IN (
    SELECT DISTINCT t.vehicle_id 
    FROM Trips t
    JOIN Users u ON t.user_id = u.user_id
    WHERE u.user_type_id = 1
);

-- Her kullanıcının detaylı bilgisi
SELECT 
    firstname,
    lastname,
    email,
    (SELECT type_name FROM User_Types ut WHERE ut.user_type_id = u.user_type_id) as user_type,
    (SELECT COUNT(*) FROM Trips t WHERE t.user_id = u.user_id) as total_trips,
    (SELECT MAX(start_time) FROM Trips t WHERE t.user_id = u.user_id) as last_trip_date
FROM Users u;

-- DELETE -----------------------------------------------------------------------

-- Önce test verisi ekle
INSERT INTO Notifications (user_id, message_type, message_content)
VALUES (1, 'test', 'Test message to be deleted');
-- Sonra sil
DELETE FROM Notifications WHERE notification_id = 5;

-- ID ile kullanıcı silme
DELETE FROM Users WHERE user_id = 5;

-- İptal edilen seferleri silme
DELETE FROM Schedule WHERE day_type = 'holiday' AND departure_time IS NULL;


-- Comparison operators ----------------------------------------------------------------

-- Tüm otobüs araçlarını getir
SELECT * FROM Vehicles WHERE vehicle_type = 'bus';

-- Fiyatı 10 TL'den fazla olan tüm tarifeleri getir
SELECT * FROM Pricing WHERE price > 10.00;

-- Yoğunluğu %60 veya daha az olan seferleri getir
SELECT * FROM Trips WHERE crowd_level <= 60.00;


-- Logical operators-------------------------------------------------------------------

-- Engelli erişimi olan ve metro OLMAYAN araçları getir
SELECT * FROM Vehicles WHERE is_accessible = TRUE AND vehicle_type <> 'metro';

-- Öğrenci VEYA yaşlı kullanıcıları getir
SELECT * FROM Users WHERE user_type_id = 1 OR user_type_id = 2;

-- Okunmamış bildirimleri getir
SELECT * FROM Notifications WHERE NOT is_read;

