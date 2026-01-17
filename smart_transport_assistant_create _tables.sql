
CREATE DATABASE IF NOT EXISTS smart_transport_assistant;
USE smart_transport_assistant;


CREATE TABLE IF NOT EXISTS User_Types (
    user_type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    discount_rate DECIMAL(5,2) DEFAULT 0.00
);


CREATE TABLE IF NOT EXISTS Days (
    day_id INT PRIMARY KEY AUTO_INCREMENT,
    day_name VARCHAR(20) NOT NULL UNIQUE
);


CREATE TABLE IF NOT EXISTS Time_Slots (
    time_slot_id INT PRIMARY KEY AUTO_INCREMENT,
    slot_name VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE IF NOT EXISTS Stations (
    station_id INT PRIMARY KEY AUTO_INCREMENT,
    station_name VARCHAR(100) NOT NULL,
    name_location VARCHAR(255),
    is_accessible BOOLEAN DEFAULT FALSE,
    amenities TEXT
);


CREATE TABLE IF NOT EXISTS Vehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    vehicle_type ENUM('bus', 'metro', 'tram') NOT NULL,
    capacity INT NOT NULL,
    current_capacity INT DEFAULT 0,
    is_accessible BOOLEAN DEFAULT FALSE,
    real_time_location POINT
);


CREATE TABLE IF NOT EXISTS Routes (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    route_name VARCHAR(100) NOT NULL,
    start_point VARCHAR(255),
    end_point VARCHAR(255),
    estimated_duration INT,
    total_distance DECIMAL(10,2)
);


CREATE TABLE IF NOT EXISTS Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    user_type_id INT,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_type_id) REFERENCES User_Types(user_type_id)
);


CREATE TABLE IF NOT EXISTS Pricing (
    pricing_id INT PRIMARY KEY AUTO_INCREMENT,
    route_id INT NOT NULL,
    user_type_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (route_id) REFERENCES Routes(route_id),
    FOREIGN KEY (user_type_id) REFERENCES User_Types(user_type_id)
);


CREATE TABLE IF NOT EXISTS Schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id INT NOT NULL,
    route_id INT NOT NULL,
    departure_time TIME NOT NULL,
    arrival_time TIME NOT NULL,
    day_type ENUM('weekday', 'weekend', 'holiday'),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);


CREATE TABLE IF NOT EXISTS Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    message_type VARCHAR(50) NOT NULL,
    message_content TEXT NOT NULL,
    sent_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


CREATE TABLE IF NOT EXISTS Emergency (
    emergency_id INT PRIMARY KEY AUTO_INCREMENT,
    route_id INT NOT NULL,
    emergency_type VARCHAR(50) NOT NULL,
    description TEXT,
    start_time DATETIME NOT NULL,
    estimated_end_time DATETIME,
    FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);


CREATE TABLE IF NOT EXISTS Trips (
    trip_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    route_id INT NOT NULL,
    start_station_id INT NOT NULL,
    end_station_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    crowd_level DECIMAL(5,2),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id),
    FOREIGN KEY (start_station_id) REFERENCES Stations(station_id),
    FOREIGN KEY (end_station_id) REFERENCES Stations(station_id)
);


CREATE TABLE IF NOT EXISTS Crowd_Analytics (
    analytics_id INT PRIMARY KEY AUTO_INCREMENT,
    route_id INT NOT NULL,
    time_slot_id INT NOT NULL,
    day_id INT NOT NULL,
    average_crowd_level DECIMAL(5,2),
    recording_date DATE NOT NULL,
    FOREIGN KEY (route_id) REFERENCES Routes(route_id),
    FOREIGN KEY (time_slot_id) REFERENCES Time_Slots(time_slot_id),
    FOREIGN KEY (day_id) REFERENCES Days(day_id)
);


CREATE TABLE IF NOT EXISTS Emergency_Vehicles (
    emergency_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    PRIMARY KEY (emergency_id, vehicle_id),
    FOREIGN KEY (emergency_id) REFERENCES Emergency(emergency_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);


CREATE TABLE IF NOT EXISTS Route_Time_Slots (
    route_id INT NOT NULL,
    time_slot_id INT NOT NULL,
    average_crowd_level DECIMAL(5,2),
    PRIMARY KEY (route_id, time_slot_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id),
    FOREIGN KEY (time_slot_id) REFERENCES Time_Slots(time_slot_id)
);


SHOW TABLES;