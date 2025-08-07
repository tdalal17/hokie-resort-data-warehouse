CREATE OR ALTER PROCEDURE Load_ReservationFact_From_Corp2
AS
BEGIN
    -- Declare variables
    DECLARE @reservation_id VARCHAR(20);
    DECLARE @customer_id VARCHAR(20);
    DECLARE @accommodation_id VARCHAR(20);
    DECLARE @hotel_id VARCHAR(20);
    DECLARE @function_id VARCHAR(20);
    DECLARE @checkin_date DATE;
    DECLARE @checkout_date DATE;
    DECLARE @reservation_date DATE;
    DECLARE @total_room_revenue DECIMAL(10,2);
    DECLARE @total_ancillary_revenue DECIMAL(10,2);
    DECLARE @number_of_guests INT;
    DECLARE @booking_channel VARCHAR(50);
    DECLARE @satisfaction_score INT;
    
    -- Variables for dimension keys
    DECLARE @time_key INT;
    DECLARE @guest_key INT;
    DECLARE @room_key INT;
    DECLARE @hotel_key INT;
    DECLARE @event_key INT;
    DECLARE @reservation_key INT;
    
    -- Declare cursor for Corp2 database
    DECLARE reservation_cursor CURSOR FOR 
        SELECT 
            r.ReservationID,
            r.CustomerID,
            sd.AccommodationID,
            a.HotelID,
            CASE WHEN fb.FunctionID IS NOT NULL THEN fb.FunctionID ELSE NULL END AS FunctionID,
            r.CheckInDate,
            r.CheckOutDate,
            r.ReservationDate,
            SUM(sd.RoomCharge) AS TotalRoomRevenue,
            SUM(sc.Amount) AS TotalAncillaryRevenue,
            r.GuestCount,
            r.BookingSource,
            r.SatisfactionRating
        FROM 
            Corp2.dbo.Reservation r
        JOIN 
            Corp2.dbo.StayDetail sd ON r.ReservationID = sd.ReservationID
        JOIN 
            Corp2.dbo.Accommodation a ON sd.AccommodationID = a.AccommodationID
        LEFT JOIN 
            Corp2.dbo.ServiceCharge sc ON r.ReservationID = sc.ReservationID
        LEFT JOIN 
            Corp2.dbo.FunctionBooking fb ON r.ReservationID = fb.ReservationID
        GROUP BY 
            r.ReservationID, r.CustomerID, sd.AccommodationID, a.HotelID, fb.FunctionID,
            r.CheckInDate, r.CheckOutDate, r.ReservationDate, r.GuestCount,
            r.BookingSource, r.SatisfactionRating;
    
    -- Open cursor
    OPEN reservation_cursor;
    
    -- Fetch the first row
    FETCH NEXT FROM reservation_cursor INTO 
        @reservation_id, @customer_id, @accommodation_id, @hotel_id, @function_id,
        @checkin_date, @checkout_date, @reservation_date, @total_room_revenue, 
        @total_ancillary_revenue, @number_of_guests, @booking_channel, 
        @satisfaction_score;
    
    -- Loop through cursor
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get TimeKey from TimeDim
        SELECT @time_key = TimeKey
        FROM TimeDim
        WHERE FullDate = @reservation_date;
        
        -- If date doesn't exist in TimeDim, insert it
        IF @time_key IS NULL
        BEGIN
            -- Generate a new TimeKey
            SELECT @time_key = ISNULL(MAX(TimeKey), 0) + 1 FROM TimeDim;
            
            -- Insert new date into TimeDim
            INSERT INTO TimeDim (
                TimeKey, FullDate, DayOfWeek, DayName, MonthNumber, 
                MonthName, Quarter, Year, IsHighSeason
            )
            VALUES (
                @time_key, 
                @reservation_date,
                DATEPART(WEEKDAY, @reservation_date),
                DATENAME(WEEKDAY, @reservation_date),
                MONTH(@reservation_date),
                DATENAME(MONTH, @reservation_date),
                DATEPART(QUARTER, @reservation_date),
                YEAR(@reservation_date),
                CASE 
                    WHEN MONTH(@reservation_date) BETWEEN 6 AND 9 THEN 1
                    WHEN MONTH(@reservation_date) = 12 THEN 1
                    ELSE 0
                END
            );
        END
        
        -- Get GuestKey from GuestDim (assuming CustomerID in Corp2 maps to GuestID in DW)
        SELECT @guest_key = GuestKey
        FROM GuestDim
        WHERE GuestID = @customer_id;
        
        -- Get RoomKey from RoomDim (assuming AccommodationID in Corp2 maps to RoomID in DW)
        SELECT @room_key = RoomKey
        FROM RoomDim
        WHERE RoomID = @accommodation_id;
        
        -- Get HotelKey from HotelDim
        SELECT @hotel_key = HotelKey
        FROM HotelDim
        WHERE HotelID = @hotel_id;
        
        -- Get EventKey from EventDim if applicable (assuming FunctionID in Corp2 maps to EventID in DW)
        IF @function_id IS NOT NULL
        BEGIN
            SELECT @event_key = EventKey
            FROM EventDim
            WHERE EventID = @function_id;
        END
        ELSE
        BEGIN
            SET @event_key = NULL;
        END
        
        -- Check if all required dimension keys exist
        IF @guest_key IS NOT NULL AND @room_key IS NOT NULL AND @hotel_key IS NOT NULL
        BEGIN
            -- Generate ReservationKey
            SELECT @reservation_key = ISNULL(MAX(ReservationKey), 0) + 1 FROM ReservationFact;
            
            -- Check if reservation already exists
            IF EXISTS (SELECT 1 FROM ReservationFact WHERE ReservationID = @reservation_id)
            BEGIN
                -- Update existing reservation
                UPDATE ReservationFact
                SET 
                    TimeKey = @time_key,
                    GuestKey = @guest_key,
                    RoomKey = @room_key,
                    HotelKey = @hotel_key,
                    EventKey = @event_key,
                    CheckInDate = @checkin_date,
                    CheckOutDate = @checkout_date,
                    TotalRoomRevenue = @total_room_revenue,
                    TotalAncillaryRevenue = @total_ancillary_revenue,
                    NumberOfGuests = @number_of_guests,
                    BookingChannel = @booking_channel,
                    SatisfactionScore = @satisfaction_score
                WHERE ReservationID = @reservation_id;
            END
            ELSE
            BEGIN
                -- Insert new reservation
                INSERT INTO ReservationFact (
                    ReservationKey, TimeKey, GuestKey, RoomKey, HotelKey, EventKey,
                    ReservationID, CheckInDate, CheckOutDate, TotalRoomRevenue,
                    TotalAncillaryRevenue, NumberOfGuests, BookingChannel, SatisfactionScore
                ) VALUES (
                    @reservation_key, @time_key, @guest_key, @room_key, @hotel_key, @event_key,
                    @reservation_id, @checkin_date, @checkout_date, @total_room_revenue,
                    @total_ancillary_revenue, @number_of_guests, @booking_channel, @satisfaction_score
                );
            END
        END
        
        -- Fetch the next row
        FETCH NEXT FROM reservation_cursor INTO 
            @reservation_id, @customer_id, @accommodation_id, @hotel_id, @function_id,
            @checkin_date, @checkout_date, @reservation_date, @total_room_revenue, 
            @total_ancillary_revenue, @number_of_guests, @booking_channel, 
            @satisfaction_score;
    END
    
    -- Close and deallocate the cursor
    CLOSE reservation_cursor;
    DEALLOCATE reservation_cursor;
END
GO