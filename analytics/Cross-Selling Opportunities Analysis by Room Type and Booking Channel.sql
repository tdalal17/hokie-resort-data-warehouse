SELECT 
    r.RoomType,
    rf.BookingChannel,
    AVG(rf.TotalAncillaryRevenue) AS AvgAncillaryRevenue,
    SUM(rf.TotalAncillaryRevenue) / SUM(rf.TotalRoomRevenue) * 100 AS AncillaryPercentage,
    COUNT(rf.ReservationKey) AS ReservationCount
FROM 
    ReservationFact rf
JOIN 
    RoomDim r ON rf.RoomKey = r.RoomKey
GROUP BY 
    CUBE(r.RoomType, rf.BookingChannel)
ORDER BY 
    AvgAncillaryRevenue DESC;