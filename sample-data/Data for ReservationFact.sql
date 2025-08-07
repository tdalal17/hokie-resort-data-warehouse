-- Sample data for ReservationFact
INSERT INTO ReservationFact (ReservationKey, TimeKey, GuestKey, RoomKey, HotelKey, EventKey, ReservationID, CheckInDate, CheckOutDate, TotalRoomRevenue, TotalAncillaryRevenue, NumberOfGuests, BookingChannel, SatisfactionScore)
VALUES
-- Question 1: Revenue optimization - High season luxury booking
(1, 11, 1, 1, 1, NULL, 'RES001', '2024-06-01', '2024-06-05', 750.00, 350.00, 2, 'Website', 9),
(2, 11, 2, 2, 1, NULL, 'RES002', '2024-06-01', '2024-06-04', 800.00, 420.00, 2, 'Mobile App', 8),

-- Question 1: Revenue optimization - Off-season budget booking
(3, 3, 3, 7, 3, NULL, 'RES003', '2024-02-01', '2024-02-03', 550.00, 125.00, 2, 'OTA', 7),
(4, 4, 4, 8, 3, NULL, 'RES004', '2024-02-14', '2024-02-16', 850.00, 175.00, 1, 'Corporate', 6),

-- Question 2: Customer satisfaction - Event bookings with different satisfaction scores
(5, 5, 1, 3, 1, 1, 'RES005', '2024-03-14', '2024-03-18', 1400.00, 580.00, 3, 'Phone', 10),
(6, 5, 2, 4, 1, 1, 'RES006', '2024-03-14', '2024-03-18', 3000.00, 750.00, 2, 'Website', 8),
(7, 5, 3, 5, 2, 1, 'RES007', '2024-03-14', '2024-03-18', 900.00, 320.00, 2, 'OTA', 5),

-- Question 3: Cross-selling opportunities - Different ancillary spending patterns
(8, 7, 1, 6, 2, 3, 'RES008', '2024-04-04', '2024-04-09', 2375.00, 980.00, 4, 'Phone', 9),
(9, 7, 2, 7, 3, 3, 'RES009', '2024-04-04', '2024-04-09', 1375.00, 420.00, 2, 'Website', 7),
(10, 8, 3, 8, 3, 3, 'RES010', '2024-04-10', '2024-04-15', 2125.00, 150.00, 1, 'Corporate', 8);