SELECT 
    h.Brand,
    CASE WHEN t.IsHighSeason = 1 THEN 'High Season' ELSE 'Off Season' END AS Season,
    r.RoomType,
    SUM(rf.TotalRoomRevenue) AS RoomRevenue,
    SUM(rf.TotalAncillaryRevenue) AS AncillaryRevenue,
    SUM(rf.TotalRoomRevenue + rf.TotalAncillaryRevenue) AS TotalRevenue,
    COUNT(rf.ReservationKey) AS ReservationCount
FROM 
    ReservationFact rf
JOIN 
    HotelDim h ON rf.HotelKey = h.HotelKey
JOIN 
    TimeDim t ON rf.TimeKey = t.TimeKey
JOIN
    RoomDim r ON rf.RoomKey = r.RoomKey
GROUP BY 
    ROLLUP(h.Brand, CASE WHEN t.IsHighSeason = 1 THEN 'High Season' ELSE 'Off Season' END, r.RoomType)
ORDER BY 
    h.Brand, 
    Season, 
    TotalRevenue DESC;