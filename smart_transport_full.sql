-- ============================================
-- SMART TRANSPORT SYSTEM - SQLite Kurulumu
-- Tüm tablolar + tüm veriler
-- ============================================

-- 1. ÖNCE TABLOLARI OLUŞTUR

-- User_Types
CREATE TABLE IF NOT EXISTS user_types (
    user_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    type_name TEXT NOT NULL UNIQUE,
    discount_rate REAL DEFAULT 0.00
);

-- Days
CREATE TABLE IF NOT EXISTS days (
    day_id INTEGER PRIMARY KEY AUTOINCREMENT,
    day_name TEXT NOT NULL UNIQUE
);

-- Time_Slots
CREATE TABLE IF NOT EXISTS time_slots (
    time_slot_id INTEGER PRIMARY KEY AUTOINCREMENT,
    slot_name TEXT NOT NULL UNIQUE
);

-- Stations
CREATE TABLE IF NOT EXISTS stations (
    station_id INTEGER PRIMARY KEY AUTOINCREMENT,
    station_name TEXT NOT NULL,
    name_location TEXT,
    is_accessible INTEGER DEFAULT 0,
    amenities TEXT,
    latitude REAL,
    longitude REAL
);

-- Vehicles
CREATE TABLE IF NOT EXISTS vehicles (
    vehicle_id INTEGER PRIMARY KEY AUTOINCREMENT,
    license_plate TEXT UNIQUE NOT NULL,
    vehicle_type TEXT NOT NULL CHECK(vehicle_type IN ('bus', 'metro', 'tram')),
    capacity INTEGER NOT NULL,
    current_capacity INTEGER DEFAULT 0,
    is_accessible INTEGER DEFAULT 0,
    latitude REAL,
    longitude REAL
);

-- Routes
CREATE TABLE IF NOT EXISTS routes (
    route_id INTEGER PRIMARY KEY AUTOINCREMENT,
    route_name TEXT NOT NULL,
    start_point TEXT,
    end_point TEXT,
    estimated_duration INTEGER,
    total_distance REAL
);

-- Users
CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    firstname TEXT NOT NULL,
    lastname TEXT NOT NULL,
    user_type_id INTEGER,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    phone TEXT,
    address TEXT,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_type_id) REFERENCES user_types(user_type_id)
);

-- Pricing
CREATE TABLE IF NOT EXISTS pricing (
    pricing_id INTEGER PRIMARY KEY AUTOINCREMENT,
    route_id INTEGER NOT NULL,
    user_type_id INTEGER NOT NULL,
    price REAL NOT NULL,
    FOREIGN KEY (route_id) REFERENCES routes(route_id),
    FOREIGN KEY (user_type_id) REFERENCES user_types(user_type_id)
);

-- Schedule
CREATE TABLE IF NOT EXISTS schedule (
    schedule_id INTEGER PRIMARY KEY AUTOINCREMENT,
    vehicle_id INTEGER NOT NULL,
    route_id INTEGER NOT NULL,
    departure_time TEXT NOT NULL,
    arrival_time TEXT NOT NULL,
    day_type TEXT CHECK(day_type IN ('weekday', 'weekend', 'holiday')),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

-- Notifications
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    message_type TEXT NOT NULL,
    message_content TEXT NOT NULL,
    sent_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read INTEGER DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Emergency
CREATE TABLE IF NOT EXISTS emergency (
    emergency_id INTEGER PRIMARY KEY AUTOINCREMENT,
    route_id INTEGER NOT NULL,
    emergency_type TEXT NOT NULL,
    description TEXT,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estimated_end_time TIMESTAMP,
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

-- Trips
CREATE TABLE IF NOT EXISTS trips (
    trip_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    vehicle_id INTEGER NOT NULL,
    route_id INTEGER NOT NULL,
    start_station_id INTEGER NOT NULL,
    end_station_id INTEGER NOT NULL,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP,
    crowd_level REAL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id),
    FOREIGN KEY (start_station_id) REFERENCES stations(station_id),
    FOREIGN KEY (end_station_id) REFERENCES stations(station_id)
);

-- Crowd_Analytics
CREATE TABLE IF NOT EXISTS crowd_analytics (
    analytics_id INTEGER PRIMARY KEY AUTOINCREMENT,
    route_id INTEGER NOT NULL,
    time_slot_id INTEGER NOT NULL,
    day_id INTEGER NOT NULL,
    average_crowd_level REAL,
    recording_date TEXT NOT NULL,
    FOREIGN KEY (route_id) REFERENCES routes(route_id),
    FOREIGN KEY (time_slot_id) REFERENCES time_slots(time_slot_id),
    FOREIGN KEY (day_id) REFERENCES days(day_id)
);

-- Emergency_Vehicles (Junction Table)
CREATE TABLE IF NOT EXISTS emergency_vehicles (
    emergency_id INTEGER NOT NULL,
    vehicle_id INTEGER NOT NULL,
    PRIMARY KEY (emergency_id, vehicle_id),
    FOREIGN KEY (emergency_id) REFERENCES emergency(emergency_id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

-- Route_Time_Slots (Junction Table)
CREATE TABLE IF NOT EXISTS route_time_slots (
    route_id INTEGER NOT NULL,
    time_slot_id INTEGER NOT NULL,
    average_crowd_level REAL,
    PRIMARY KEY (route_id, time_slot_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id),
    FOREIGN KEY (time_slot_id) REFERENCES time_slots(time_slot_id)
);

-- ============================================
-- 2. SONRA VERİLERİ EKLE
-- ============================================

-- 1. User_Types
INSERT INTO user_types (type_name, discount_rate) VALUES 
('Student', 0.50),
('Elderly', 0.00),
('Disabled', 0.00),
('Regular', 1.00),
('Tourist', 0.80);

-- 2. Days
INSERT INTO days (day_name) VALUES 
('Monday'),
('Tuesday'),
('Wednesday'),
('Thursday'),
('Friday'),
('Saturday'),
('Sunday');

-- 3. Time_Slots
INSERT INTO time_slots (slot_name) VALUES 
('Morning Peak (06:00-09:00)'),
('Midday (09:00-16:00)'),
('Evening Peak (16:00-20:00)'),
('Night (20:00-06:00)');

-- 4. Stations
INSERT INTO stations (station_name, name_location, is_accessible, amenities, latitude, longitude) VALUES 
('Central Station', 'Main Square', 1, 'Wi-Fi, Cafe, Toilet, ATM', 41.0082, 28.9784),
('University Campus', 'Campus Entrance', 1, 'Wi-Fi, Library, Cafe', 41.0864, 29.0432),
('City Hospital', 'Hospital Entrance', 1, 'Pharmacy, Toilet', 41.0235, 28.9356),
('Old Town Square', 'Historic Square', 0, 'Tourist Info, Cafe', 41.0123, 28.9754),
('Shopping Mall', 'Mall Entrance', 1, 'Wi-Fi, Charging Stations, Restaurants', 41.0567, 29.0123);

-- 5. Vehicles
INSERT INTO vehicles (license_plate, vehicle_type, capacity, current_capacity, is_accessible, latitude, longitude) VALUES 
('34ABC123', 'bus', 50, 25, 1, 41.0152, 28.9797),
('34DEF456', 'metro', 200, 150, 1, 41.0256, 28.9741),
('34GHI789', 'tram', 80, 60, 0, 41.0351, 28.9823),
('34JKL012', 'bus', 45, 40, 1, 41.0458, 28.9765),
('34MNO345', 'metro', 180, 120, 1, 41.0553, 28.9689);

-- 6. Routes
INSERT INTO routes (route_name, start_point, end_point, estimated_duration, total_distance) VALUES 
('Blue Line', 'Central Station', 'University Campus', 45, 12.5),
('Red Line', 'City Hospital', 'Shopping Mall', 30, 8.2),
('Green Line', 'Old Town Square', 'Central Station', 20, 5.7),
('Express Route', 'Central Station', 'Shopping Mall', 15, 6.3),
('Night Line', 'University Campus', 'City Hospital', 35, 10.1);

-- 7. Users
INSERT INTO users (firstname, lastname, user_type_id, email, password, phone, address) VALUES 
('Ahmet', 'Yılmaz', 1, 'ahmet@gmail.com', 'SecurePass123!', '5551112233', '123 Main St, Istanbul'),
('Ayşe', 'Kaya', 2, 'ayse@hotmail.com', 'AysePass456!', '5552223344', '456 Park Ave, Istanbul'),
('Mehmet', 'Demir', 3, 'mehmet@outlook.com', 'Mehmet789!', '5553334455', '789 Oak Rd, Istanbul'),
('Zeynep', 'Çelik', 4, 'zeynep@gmail.com', 'ZeynepPass012!', '5554445566', '101 Pine St, Istanbul'),
('John', 'Smith', 5, 'john@gmail.com', 'TouristPass345!', '5555556677', 'Tourist Hotel, Istanbul');

-- 8. Pricing
INSERT INTO pricing (route_id, user_type_id, price) VALUES 
(1, 1, 5.00),
(1, 4, 10.00),
(2, 2, 0.00),
(2, 4, 8.00),
(3, 1, 3.50),
(3, 4, 7.00),
(4, 5, 12.00),
(5, 4, 15.00);

-- 9. Schedule
INSERT INTO schedule (vehicle_id, route_id, departure_time, arrival_time, day_type) VALUES 
(1, 1, '08:00:00', '08:45:00', 'weekday'),
(2, 2, '09:30:00', '10:00:00', 'weekday'),
(3, 3, '14:15:00', '14:35:00', 'weekend'),
(4, 4, '17:45:00', '18:00:00', 'weekday'),
(5, 5, '22:00:00', '22:35:00', 'weekend');

-- 10. Notifications
INSERT INTO notifications (user_id, message_type, message_content, is_read) VALUES 
(1, 'delay', 'Blue Line is delayed by 10 minutes due to traffic.', 0),
(2, 'emergency', 'Red Line temporarily suspended due to technical issues.', 1),
(3, 'congestion', 'Green Line currently experiencing high passenger volume.', 0),
(4, 'cancellation', 'Express Route cancelled for today. Alternative routes available.', 1);

-- 11. Emergency
INSERT INTO emergency (route_id, emergency_type, description, estimated_end_time) VALUES 
(2, 'breakdown', 'Vehicle mechanical failure', '2024-05-15 12:00:00'),
(4, 'accident', 'Minor collision at Central Station', '2024-05-15 16:30:00'),
(1, 'traffic', 'Heavy traffic due to construction', '2024-05-15 19:00:00');

-- 12. Trips
INSERT INTO trips (user_id, vehicle_id, route_id, start_station_id, end_station_id, end_time, crowd_level) VALUES 
(1, 1, 1, 1, 2, '2024-05-15 08:45:00', 50.00),
(2, 2, 2, 3, 5, '2024-05-15 10:00:00', 75.00),
(3, 3, 3, 4, 1, '2024-05-14 14:35:00', 60.00),
(4, 4, 4, 1, 5, '2024-05-13 18:00:00', 89.00),
(5, 5, 5, 2, 3, '2024-05-12 22:35:00', 67.00);

-- 13. Crowd_Analytics
INSERT INTO crowd_analytics (route_id, time_slot_id, day_id, average_crowd_level, recording_date) VALUES 
(1, 1, 1, 85.5, '2024-05-13'),
(2, 2, 2, 70.2, '2024-05-14'),
(3, 3, 3, 65.8, '2024-05-15'),
(4, 4, 4, 45.3, '2024-05-16'),
(5, 1, 5, 90.1, '2024-05-17');

-- 14. Route_Time_Slots
INSERT INTO route_time_slots (route_id, time_slot_id, average_crowd_level) VALUES 
(1, 1, 85.5),
(1, 3, 75.2),
(2, 2, 70.2),
(3, 3, 65.8),
(4, 4, 45.3),
(5, 1, 90.1);

-- 15. Emergency_Vehicles
INSERT INTO emergency_vehicles (emergency_id, vehicle_id) VALUES 
(1, 2),
(2, 4),
(3, 1);

-- ============================================
-- 3. KONTROL SORGULARI
-- ============================================

-- Tablo listesini göster
SELECT 'Tablolar:' AS Bilgi;
SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;

-- Kayıt sayılarını göster
SELECT 'Kayıt Sayıları:' AS Bilgi;
SELECT 'user_types' AS Tablo, COUNT(*) AS Kayıt FROM user_types
UNION ALL SELECT 'days', COUNT(*) FROM days
UNION ALL SELECT 'time_slots', COUNT(*) FROM time_slots
UNION ALL SELECT 'stations', COUNT(*) FROM stations
UNION ALL SELECT 'vehicles', COUNT(*) FROM vehicles
UNION ALL SELECT 'routes', COUNT(*) FROM routes
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'pricing', COUNT(*) FROM pricing
UNION ALL SELECT 'schedule', COUNT(*) FROM schedule
UNION ALL SELECT 'notifications', COUNT(*) FROM notifications
UNION ALL SELECT 'emergency', COUNT(*) FROM emergency
UNION ALL SELECT 'trips', COUNT(*) FROM trips
UNION ALL SELECT 'crowd_analytics', COUNT(*) FROM crowd_analytics
UNION ALL SELECT 'route_time_slots', COUNT(*) FROM route_time_slots
UNION ALL SELECT 'emergency_vehicles', COUNT(*) FROM emergency_vehicles
ORDER BY Tablo;

-- Örnek sorgu: Engelli erişimi olan araçlar
SELECT 'Engelli Erişimli Araçlar:' AS Bilgi;
SELECT vehicle_id, license_plate, vehicle_type, capacity, current_capacity 
FROM vehicles WHERE is_accessible = 1;

-- Örnek sorgu: Öğrenci kullanıcılar
SELECT 'Öğrenci Kullanıcılar:' AS Bilgi;
SELECT u.user_id, u.firstname, u.lastname, u.email, ut.type_name
FROM users u
JOIN user_types ut ON u.user_type_id = ut.user_type_id
WHERE ut.type_name = 'Student';