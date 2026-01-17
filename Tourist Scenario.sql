USE smart_transport_assistant;

-- Yeni turist kullanıcı ekle
INSERT INTO Users (firstname, lastname, user_type_id, email, password, phone, address, registration_date) 
VALUES ('David', 'Miller', 5, 'david.miller@mail.com', 'TouristPass1!', '+123456789', 'Hotel Istanbul', NOW());

-- Turist için uygun araçlar 
SELECT vehicle_id, license_plate, vehicle_type, capacity, current_capacity, is_accessible 
FROM Vehicles 
WHERE current_capacity < capacity * 0.7;

-- Turist rotası
INSERT INTO Trips (user_id, vehicle_id, route_id, start_station_id, end_station_id, start_time, end_time, crowd_level) 
VALUES (7, 4, 4, 1, 5, NOW(), DATE_ADD(NOW(), INTERVAL 15 MINUTE), 45.00);

-- Araç kapasitesi artır
UPDATE Vehicles 
SET current_capacity = current_capacity + 1 
WHERE vehicle_id = 4;

-- Turist için İngilizce bildirim
INSERT INTO Notifications (user_id, message_type, message_content, sent_time, is_read) 
VALUES (7, 'info', 'Welcome to Istanbul Public Transport', NOW(), FALSE);

--  Turist fiyat bilgisi
SELECT p.price, r.route_name, ut.type_name, ut.discount_rate 
FROM Pricing p 
JOIN Routes r ON p.route_id = r.route_id 
JOIN User_Types ut ON p.user_type_id = ut.user_type_id 
WHERE p.route_id = 4 AND p.user_type_id = 5;

-- Turistik duraklar
SELECT station_id, station_name, is_accessible, amenities 
FROM Stations 
WHERE station_id = 1 OR station_id = 4 OR station_id = 5;

-- Seferleri yoğunluğa göre sırala
SELECT trip_id, crowd_level, start_time 
FROM Trips 
ORDER BY crowd_level ASC;

--  Ortalama yoğunluktan az olan seferler
SELECT trip_id, crowd_level 
FROM Trips 
WHERE crowd_level < (SELECT AVG(crowd_level) FROM Trips);

-- Turistin telefon numarası
UPDATE Users 
SET phone = '+123456780' 
WHERE user_id = 7;

-- Metro olmayan ve boş araçlar
SELECT vehicle_id, license_plate, vehicle_type, current_capacity 
FROM Vehicles 
WHERE vehicle_type <> 'metro' 
AND current_capacity < 20;

-- Turist için acil durum 
INSERT INTO Emergency (route_id, emergency_type, description, start_time, estimated_end_time) 
VALUES (4, 'traffic', 'Heavy tourist traffic', NOW(), DATE_ADD(NOW(), INTERVAL 30 MINUTE));

-- Turist yoğunluğu analitiği
INSERT INTO Crowd_Analytics (route_id, time_slot_id, day_id, average_crowd_level, recording_date) 
VALUES (4, 2, 6, 55.00, CURDATE());

-- Turistin test bildirimini sil
DELETE FROM Notifications 
WHERE user_id = 7 AND message_type = 'info';