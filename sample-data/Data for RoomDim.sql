-- Sample data for RoomDim
INSERT INTO RoomDim (RoomKey, RoomID, RoomNumber, RoomType, BedType, MaxOccupancy, BaseRate, IsNonSmoking, HotelKey)
VALUES
(1, 'RM001', '101', 'Standard', 'Queen', 2, 150.00, 1, 1),
(2, 'RM002', '201', 'Deluxe', 'King', 2, 200.00, 1, 1),
(3, 'RM003', '301', 'Suite', 'King', 4, 350.00, 1, 1),
(4, 'RM004', '401', 'Presidential Suite', 'King', 4, 750.00, 1, 1),
(5, 'RM005', '102', 'Ocean View', 'Queen', 2, 225.00, 1, 2),
(6, 'RM006', '202', 'Ocean View Suite', 'King', 4, 475.00, 1, 2),
(7, 'RM007', '101', 'City View', 'Queen', 2, 275.00, 1, 3),
(8, 'RM008', '201', 'Executive Suite', 'King', 2, 425.00, 1, 3);