-- Sample data for GuestDim
INSERT INTO GuestDim (GuestKey, GuestID, FirstName, LastName, Email, Phone, Address, City, State, Country, LoyaltyTier, Organization, TotalStays)
VALUES
(1, 'G001', 'John', 'Smith', 'john.smith@email.com', '555-123-4567', '123 Main St', 'Boston', 'Massachusetts', 'USA', 'Platinum', 'ABC Corp', 25),
(2, 'G002', 'Emily', 'Johnson', 'emily.j@email.com', '555-234-5678', '456 Oak Ave', 'Seattle', 'Washington', 'USA', 'Gold', 'XYZ Inc', 18),
(3, 'G003', 'Michael', 'Brown', 'michael.b@email.com', '555-345-6789', '789 Pine Blvd', 'Austin', 'Texas', 'USA', 'Silver', 'Tech Solutions', 12),
(4, 'G004', 'Sarah', 'Davis', 'sarah.d@email.com', '555-456-7890', '101 Elm St', 'San Francisco', 'California', 'USA', 'Gold', NULL, 15);