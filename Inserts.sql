USE smart_transport_assistant;

-- 1. User_Types
INSERT INTO User_Types (type_name, discount_rate) VALUES 
('Student', 0.50),
('Elderly', 0.00),
('Disabled', 0.00),
('Regular', 1.00),
('Tourist', 0.80);

-- 2. Days
INSERT INTO Days (day_name) VALUES 
('Monday'), ('Tuesday'), ('Wednesday'), ('Thursday'), 
('Friday'), ('Saturday'), ('Sunday');

-- 3. Time_Slots
INSERT INTO Time_Slots (slot_name) VALUES 
('Morning Peak (06:00-09:00)'), 
('Midday (09:00-16:00)'), 
('Evening Peak (16:00-20:00)'), 
('Night (20:00-06:00)');

-- 4. Stations
INSERT INTO Stations (station_name, name_location, is_accessible, amenities) VALUES 
('Central Station', 'POINT(41.0082 28.9784)', TRUE, 'Wi-Fi, Cafe, Toilet, ATM'),
('University Campus', 'POINT(41.0864 29.0432)', TRUE, 'Wi-Fi, Library, Cafe'),
('City Hospital', 'POINT(41.0235 28.9356)', TRUE, 'Pharmacy, Toilet'),
('Old Town Square', 'POINT(41.0123 28.9754)', FALSE, 'Tourist Info, Cafe'),
('Shopping Mall', 'POINT(41.0567 29.0123)', TRUE, 'Wi-Fi, Charging Stations, Restaurants');

-- 5. Vehicles
INSERT INTO Vehicles (license_plate, vehicle_type, capacity, current_capacity, is_accessible, real_time_location) VALUES 
('34ABC123', 'bus', 50, 25, TRUE, POINT(41.0152, 28.9797)),
('34DEF456', 'metro', 200, 150, TRUE, POINT(41.0256, 28.9741)),
('34GHI789', 'tram', 80, 60, FALSE, POINT(41.0351, 28.9823)),
('34JKL012', 'bus', 45, 40, TRUE, POINT(41.0458, 28.9765)),
('34MNO345', 'metro', 180, 120, TRUE, POINT(41.0553, 28.9689));

-- 6. Routes
INSERT INTO Routes (route_name, start_point, end_point, estimated_duration, total_distance) VALUES 
('Blue Line', 'Central Station', 'University Campus', 45, 12.5),
('Red Line', 'City Hospital', 'Shopping Mall', 30, 8.2),
('Green Line', 'Old Town Square', 'Central Station', 20, 5.7),
('Express Route', 'Central Station', 'Shopping Mall', 15, 6.3),
('Night Line', 'University Campus', 'City Hospital', 35, 10.1);

-- 7. Users
INSERT INTO Users (firstname, lastname, user_type_id, email, password, phone, address) VALUES 
('Ahmet', 'Yılmaz', 1, 'ahmet@gmail.com', 'SecurePass123!', '5551112233', '123 Main St, Istanbul'),
('Ayşe', 'Kaya', 2, 'ayse@hotmail.com', 'AysePass456!', '5552223344', '456 Park Ave, Istanbul'),
('Mehmet', 'Demir', 3, 'mehmet@outlook.com', 'Mehmet789!', '5553334455', '789 Oak Rd, Istanbul'),
('Zeynep', 'Çelik', 4, 'zeynep@gmail.com', 'ZeynepPass012!', '5554445566', '101 Pine St, Istanbul'),
('John', 'Smith', 5, 'john@gmail.com', 'TouristPass345!', '5555556677', 'Tourist Hotel, Istanbul');

-- 8. Pricing
INSERT INTO Pricing (route_id, user_type_id, price) VALUES 
(1, 1, 5.00), (1, 4, 10.00), (2, 2, 0.00), (2, 4, 8.00),
(3, 1, 3.50), (3, 4, 7.00), (4, 5, 12.00), (5, 4, 15.00);

-- 9. Schedule
INSERT INTO Schedule (vehicle_id, route_id, departure_time, arrival_time, day_type) VALUES 
(1, 1, '08:00:00', '08:45:00', 'weekday'),
(2, 2, '09:30:00', '10:00:00', 'weekday'),
(3, 3, '14:15:00', '14:35:00', 'weekend'),
(4, 4, '17:45:00', '18:00:00', 'weekday'),
(5, 5, '22:00:00', '22:35:00', 'weekend');

-- 10. Notifications
INSERT INTO Notifications (user_id, message_type, message_content, is_read) VALUES 
(1, 'delay', 'Blue Line is delayed by 10 minutes due to traffic.', FALSE),
(2, 'emergency', 'Red Line temporarily suspended due to technical issues.', TRUE),
(3, 'congestion', 'Green Line currently experiencing high passenger volume.', FALSE),
(4, 'cancellation', 'Express Route cancelled for today. Alternative routes available.', TRUE);

-- 11. Emergency
INSERT INTO Emergency (route_id, emergency_type, description, start_time, estimated_end_time) VALUES 
(2, 'breakdown', 'Vehicle mechanical failure', '2024-05-15 09:30:00', '2024-05-15 12:00:00'),
(4, 'accident', 'Minor collision at Central Station', '2024-05-15 14:15:00', '2024-05-15 16:30:00'),
(1, 'traffic', 'Heavy traffic due to construction', '2024-05-15 17:45:00', '2024-05-15 19:00:00');

-- 12. Trips
INSERT INTO Trips (user_id, vehicle_id, route_id, start_station_id, end_station_id, start_time, end_time, crowd_level) VALUES 
(1, 1, 1, 1, 2, '2024-05-15 08:00:00', '2024-05-15 08:45:00', 50.00),
(2, 2, 2, 3, 5, '2024-05-15 09:30:00', '2024-05-15 10:00:00', 75.00),
(3, 3, 3, 4, 1, '2024-05-14 14:15:00', '2024-05-14 14:35:00', 60.00),
(4, 4, 4, 1, 5, '2024-05-13 17:45:00', '2024-05-13 18:00:00', 89.00),
(5, 5, 5, 2, 3, '2024-05-12 22:00:00', '2024-05-12 22:35:00', 67.00);

-- 13. Crowd_Analytics
INSERT INTO Crowd_Analytics (route_id, time_slot_id, day_id, average_crowd_level, recording_date) VALUES 
(1, 1, 1, 85.5, '2024-05-13'),
(2, 2, 2, 70.2, '2024-05-14'),
(3, 3, 3, 65.8, '2024-05-15'),
(4, 4, 4, 45.3, '2024-05-16'),
(5, 1, 5, 90.1, '2024-05-17');

-- 14. Route_Time_Slots
INSERT INTO Route_Time_Slots (route_id, time_slot_id, average_crowd_level) VALUES 
(1, 1, 85.5), (1, 3, 75.2), (2, 2, 70.2), (3, 3, 65.8),
(4, 4, 45.3), (5, 1, 90.1);

-- 15. Emergency_Vehicles
INSERT INTO Emergency_Vehicles (emergency_id, vehicle_id) VALUES 
(1, 2), (2, 4), (3, 1);

-- Number of records in all tables:
SELECT 'User_Types' AS Table_, COUNT(*) AS Record FROM User_Types
UNION ALL SELECT 'Days', COUNT(*) FROM Days
UNION ALL SELECT 'Time_Slots', COUNT(*) FROM Time_Slots
UNION ALL SELECT 'Stations', COUNT(*) FROM Stations
UNION ALL SELECT 'Vehicles', COUNT(*) FROM Vehicles
UNION ALL SELECT 'Routes', COUNT(*) FROM Routes
UNION ALL SELECT 'Users', COUNT(*) FROM Users
UNION ALL SELECT 'Pricing', COUNT(*) FROM Pricing
UNION ALL SELECT 'Schedule', COUNT(*) FROM Schedule
UNION ALL SELECT 'Notifications', COUNT(*) FROM Notifications
UNION ALL SELECT 'Emergency', COUNT(*) FROM Emergency
UNION ALL SELECT 'Trips', COUNT(*) FROM Trips
UNION ALL SELECT 'Crowd_Analytics', COUNT(*) FROM Crowd_Analytics
UNION ALL SELECT 'Route_Time_Slots', COUNT(*) FROM Route_Time_Slots
UNION ALL SELECT 'Emergency_Vehicles', COUNT(*) FROM Emergency_Vehicles
ORDER BY Table_;



