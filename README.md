#  Smart Public Transport and Transportation Assistant Database

A comprehensive SQL database system designed to solve real-world urban transportation challenges through intelligent data management.

##  Project Overview

The **Smart Transportation Assistant** is a database system that addresses common public transportation problems like real-time vehicle tracking, crowd management, personalized routing, and accessibility features. The system implements a fully normalized database with 15 interrelated tables.


### Database Schema
![ER Diagram](docs/Normalized_ERD.png)

### 1. Database Setup
```sql
-- Run the complete setup
sqlite3 transport.db < database/smart_transport_full.sql
