-- ================================================================================================
-- DATABASE SETUP
-- Create the project database and set it as the active database.
-- ================================================================================================

CREATE DATABASE EcommerceAnalysis;

USE EcommerceAnalysis;
GO

-- Verify the active database.

SELECT DB_NAME() AS CurrentDatabase;
