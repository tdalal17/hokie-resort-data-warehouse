CREATE OR ALTER PROCEDURE Load_HotelDim_From_Corp2
AS
BEGIN
    -- Declare variables
    DECLARE @hotel_id VARCHAR(20);
    DECLARE @hotel_name VARCHAR(100);
    DECLARE @brand VARCHAR(50);
    DECLARE @city VARCHAR(50);
    DECLARE @state VARCHAR(50);
    DECLARE @country VARCHAR(50);
    DECLARE @star_rating INT;
    DECLARE @total_rooms INT;
    DECLARE @hotel_key INT;
    
    -- Declare cursor for Corp2 database
    DECLARE hotel_cursor CURSOR FOR 
        SELECT 
            h.HotelID,
            h.HotelName,
            h.Brand,
            h.City,
            h.State,
            h.Country,
            hf.StarRating,
            COUNT(a.RoomID) AS TotalRooms
        FROM 
            Corp2.dbo.Hotel h
        LEFT JOIN 
            Corp2.dbo.HotelFacilities hf ON h.HotelID = hf.HotelID
        LEFT JOIN 
            Corp2.dbo.Accommodation a ON h.HotelID = a.HotelID
        GROUP BY 
            h.HotelID, h.HotelName, h.Brand, h.City, h.State, h.Country, hf.StarRating;
    
    -- Open cursor
    OPEN hotel_cursor;
    
    -- Fetch the first row
    FETCH NEXT FROM hotel_cursor INTO 
        @hotel_id, @hotel_name, @brand, @city, @state, 
        @country, @star_rating, @total_rooms;
    
    -- Loop through cursor
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Generate HotelKey
        SELECT @hotel_key = ISNULL(MAX(HotelKey), 0) + 1 FROM HotelDim;
        
        -- Insert into Data Warehouse
        -- Check if the record already exists
        IF EXISTS (SELECT 1 FROM HotelDim WHERE HotelID = @hotel_id)
        BEGIN
            -- Update existing record
            UPDATE HotelDim SET
                HotelName = @hotel_name,
                Brand = @brand,
                City = @city,
                State = @state,
                Country = @country,
                StarRating = @star_rating,
                TotalRooms = @total_rooms
            WHERE HotelID = @hotel_id;
        END
        ELSE
        BEGIN
            -- Insert new record
            INSERT INTO HotelDim (
                HotelKey, HotelID, HotelName, Brand, City, State, Country, 
                StarRating, TotalRooms
            ) VALUES (
                @hotel_key, @hotel_id, @hotel_name, @brand, @city, @state, 
                @country, @star_rating, @total_rooms
            );
        END
        
        -- Fetch the next row
        FETCH NEXT FROM hotel_cursor INTO 
            @hotel_id, @hotel_name, @brand, @city, @state, 
            @country, @star_rating, @total_rooms;
    END
    
    -- Close and deallocate the cursor
    CLOSE hotel_cursor;
    DEALLOCATE hotel_cursor;
END
GO