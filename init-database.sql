-- ========== CBMS DATABASE SCHEMA ==========
-- This file creates all tables for the Construction Building Management System

-- Connect to database
\c cbms_db;

-- Drop existing tables if they exist (for clean setup)
DROP TABLE IF EXISTS resource_allocations;
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS activity_logs;

-- ========== USERS TABLE ==========
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'client',
    avatar VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========== PROJECTS TABLE ==========
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    location VARCHAR(200),
    status VARCHAR(50) DEFAULT 'Planning',
    progress INTEGER DEFAULT 0,
    budget DECIMAL(15,2) DEFAULT 0,
    spent DECIMAL(15,2) DEFAULT 0,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========== TASKS TABLE ==========
CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    assigned_to VARCHAR(100),
    status VARCHAR(50) DEFAULT 'pending',
    priority VARCHAR(20) DEFAULT 'medium',
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========== RESOURCE ALLOCATIONS TABLE ==========
CREATE TABLE resource_allocations (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    allocated INTEGER DEFAULT 0,
    used INTEGER DEFAULT 0,
    unit VARCHAR(50),
    cost_per_unit DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========== ACTIVITY LOGS TABLE (DevOps) ==========
CREATE TABLE activity_logs (
    id SERIAL PRIMARY KEY,
    user_name VARCHAR(100),
    action VARCHAR(100),
    details TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========== INSERT SAMPLE DATA ==========

-- Insert sample users
INSERT INTO users (name, email, password, role, avatar) VALUES
('Admin User', 'admin@cbms.com', 'hashed_password_123', 'Admin', '👑'),
('John Manager', 'manager@cbms.com', 'hashed_password_123', 'Project Manager', '👨‍💼'),
('Lisa Engineer', 'engineer@cbms.com', 'hashed_password_123', 'Site Engineer', '👩‍🔧'),
('DevOps Engineer', 'devops@cbms.com', 'hashed_password_123', 'DevOps', '🔧'),
('Client Rep', 'client@cbms.com', 'hashed_password_123', 'Client', '🤝');

-- Insert sample projects
INSERT INTO projects (name, location, status, progress, budget, spent, start_date, end_date) VALUES
('Green Tower HQ', 'Addis Ababa', 'In Progress', 64, 1250000, 789000, '2025-01-10', '2025-09-15'),
('Sunset Residences', 'Mekelle', 'Planning', 12, 870000, 95000, '2025-03-01', '2026-02-28'),
('Riverside Bridge', 'Bahir Dar', 'Design', 25, 2300000, 450000, '2025-02-15', '2026-05-30');

-- Insert sample tasks
INSERT INTO tasks (project_id, title, assigned_to, status, priority, due_date) VALUES
(1, 'Foundation excavation', 'Site Engineer', 'progress', 'high', '2025-06-10'),
(1, 'Steel framework', 'Contractor', 'pending', 'medium', '2025-07-20'),
(2, 'Permit acquisition', 'Project Manager', 'done', 'high', '2025-04-30'),
(3, 'Environmental study', 'Engineer', 'progress', 'high', '2025-06-25'),
(1, 'Electrical wiring', 'Electrician', 'pending', 'medium', '2025-08-15'),
(2, 'Site clearing', 'Contractor', 'pending', 'low', '2025-05-30');

-- Insert sample resources
INSERT INTO resource_allocations (project_id, type, name, allocated, used, unit, cost_per_unit) VALUES
(1, 'material', 'Cement', 450, 210, 'tons', 120),
(1, 'labor', 'Skilled Workers', 35, 28, 'workers', 150),
(2, 'equipment', 'Excavators', 4, 3, 'units', 50000),
(3, 'material', 'Steel beams', 120, 45, 'tons', 850),
(1, 'equipment', 'Crane', 2, 1, 'units', 75000);

-- Insert sample activity logs
INSERT INTO activity_logs (user_name, action, details, ip_address) VALUES
('System', 'DATABASE_INIT', 'Database initialized with sample data', '127.0.0.1'),
('Admin User', 'SCHEMA_CREATE', 'Created all tables', '127.0.0.1');

-- Display confirmation
SELECT '✅ Database initialized successfully!' as status;
SELECT COUNT(*) || ' projects loaded' as info FROM projects;
SELECT COUNT(*) || ' tasks loaded' as info FROM tasks;
SELECT COUNT(*) || ' resources loaded' as info FROM resource_allocations;

\q
