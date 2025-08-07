CREATE OR ALTER PROCEDURE Load_ReservationFact_From_Corp1
AS
BEGIN
    -- Declare variables
    DECLARE @reservation_id VARCHAR(20);
    DECLARE @guest_id VARCHAR(20);
    DECLARE @room_id VARCHAR(20);
    DECLARE @hotel_id VARCHAR(20);
    DECLARE @event_id VARCHAR(20);
    DECLARE @checkin_date DATE;
    DECLARE @checkout_date DATE;
    DECLARE @booking_date DATE;
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
    
    -- Declare cursor for Corp1 database
    DECLARE reservation_cursor CURSOR FOR 
        SELECT 
            b.BookingID AS ReservationID,
            b.GuestID,
            bd.RoomID,
            r.PropertyID AS HotelID,
            CASE WHEN e.EventID IS NOT NULL THEN e.EventID ELSE NULL END AS EventID,
            b.CheckInDate,
            b.CheckOutDate,
            b.BookingDate,
            SUM(bd.RoomCharge) AS TotalRoomRevenue,
            SUM(pt.Amount) AS TotalAncillaryRevenue,
            b.NumberOfGuests,
            b.BookingChannel,
            b.SatisfactionRating
        FROM 
            Corp1.dbo.Booking b
        JOIN 
            Corp1.dbo.BookingDetail bd ON b.BookingID = bd.BookingID
        JOIN 
            Corp1.dbo.Room r ON bd.RoomID = r.RoomID
        LEFT JOIN 
            Corp1.dbo.PaymentTransaction pt ON b.BookingID = pt.BookingID AND pt.Type = 'Ancillary'
        LEFT JOIN 
            Corp1.dbo.EventBooking eb ON b.BookingID = eb.BookingID
        LEFT JOIN 
            Corp1.dbo.Event e ON eb.EventID = e.EventID
        GROUP BY 
            b.BookingID, b.GuestID, bd.RoomID, r.PropertyID, e.EventID, 
            b.CheckInDate, b.CheckOutDate, b.BookingDate, b.NumberOfGuests, 
            b.BookingChannel, b.SatisfactionRating;
    
    -- Open cursor
    OPEN reservation_cursor;
    
    -- Fetch the first row
    FETCH NEXT FROM reservation_cursor INTO 
        @reservation_id, @guest_id, @room_id, @hotel_id, @event_id,
        @checkin_date, @checkout_date, @booking_date, @total_room_revenue, 
        @total_ancillary_revenue, @number_of_guests, @booking_channel, 
        @satisfaction_score;
    
    -- Loop through cursor
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get TimeKey from TimeDim
        SELECT @time_key = TimeKey
        FROM TimeDim
        WHERE FullDate = @booking_date;
        
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
                @booking_date,
                DATEPART(WEEKDAY, @booking_date),
                DATENAME(WEEKDAY, @booking_date),
                MONTH(@booking_date),
                DATENAME(MONTH, @booking_date),
                DATEPART(QUARTER, @booking_date),
                YEAR(@booking_date),
                CASE 
                    WHEN MONTH(@booking_date) BETWEEN 6 AND 9 THEN 1
                    WHEN MONTH(@booking_date) = 12 THEN 1
                    ELSE 0
                END
            );
        END
        
        -- Get GuestKey from GuestDim
        SELECT @guest_key = GuestKey
        FROM GuestDim
        WHERE GuestID = @guest_id;
        
        -- Get RoomKey from RoomDim
        SELECT @room_key = RoomKey
        FROM RoomDim
        WHERE RoomID = @room_id;
        
        -- Get HotelKey from HotelDim
        SELECT @hotel_key = HotelKey
        FROM HotelDim
        WHERE HotelID = @hotel_id;
        
        -- Get EventKey from EventDim if applicable
        IF @event_id IS NOT NULL
        BEGIN
            SELECT @event_key = EventKey
            FROM EventDim
            WHERE EventID = @event_id;
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
            @reservation_id, @guest_id, @room_id, @hotel_id, @event_id,
            @checkin_date, @checkout_date, @booking_date, @total_room_revenue, 
            @total_ancillary_revenue, @number_of_guests, @booking_channel, 
            @satisfaction_score;
    END
    
    -- Close and deallocate the cursor
    CLOSE reservation_cursor;
    DEALLOCATE reservation_cursor;
END
GO