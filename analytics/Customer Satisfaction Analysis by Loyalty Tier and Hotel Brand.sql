SELECT 
    g.LoyaltyTier,
    h.Brand,
    AVG(rf.SatisfactionScore) AS AvgSatisfactionScore,
    COUNT(rf.ReservationKey) AS ReservationCount
FROM 
    ReservationFact rf
JOIN 
    GuestDim g ON rf.GuestKey = g.GuestKey
JOIN 
    HotelDim h ON rf.HotelKey = h.HotelKey
GROUP BY 
    ROLLUP(g.LoyaltyTier, h.Brand)
ORDER BY 
    GROUPING(g.LoyaltyTier), g.LoyaltyTier,
    GROUPING(h.Brand), h.Brand;