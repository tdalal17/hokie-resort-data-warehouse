CREATE OR ALTER PROCEDURE Load_GuestDim_From_Corp1
AS
BEGIN
    -- Declare variables
    DECLARE @guest_id VARCHAR(20)
    DECLARE @first_name VARCHAR(50)
    DECLARE @last_name VARCHAR(50)
    DECLARE @email VARCHAR(100)
    DECLARE @phone VARCHAR(20)
    DECLARE @address VARCHAR(100)
    DECLARE @city VARCHAR(50)
    DECLARE @state VARCHAR(50)
    DECLARE @country VARCHAR(50)
    DECLARE @loyalty_tier VARCHAR(20)
    DECLARE @organization VARCHAR(100)
    DECLARE @total_stays INT
    DECLARE @guest_key INT
    
    -- Declare cursor for Corp1 database
    DECLARE guest_cursor CURSOR FOR 
        SELECT 
            g.GuestID,
            g.FirstName,
            g.LastName,
            g.Email,
            g.Phone,
            g.Address,
            g.City,
            g.State,
            g.Country,
            gp.LoyaltyTier,
            g.Organization,
            COUNT(b.BookingID) AS TotalStays
        FROM 
            Corp1.dbo.Guest g
        LEFT JOIN 
            Corp1.dbo.GuestProfile gp ON g.GuestID = gp.GuestID
        LEFT JOIN 
            Corp1.dbo.Booking b ON g.GuestID = b.GuestID
        GROUP BY 
            g.GuestID, g.FirstName, g.LastName, g.Email, g.Phone, g.Address, 
            g.City, g.State, g.Country, gp.LoyaltyTier, g.Organization;
    
    -- Open cursor
    OPEN guest_cursor
    
    -- Fetch the first row
    FETCH NEXT FROM guest_cursor INTO 
        @guest_id, @first_name, @last_name, @email, @phone, 
        @address, @city, @state, @country, @loyalty_tier, 
        @organization, @total_stays
    
    -- Loop through cursor
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Generate GuestKey
        SELECT @guest_key = ISNULL(MAX(GuestKey), 0) + 1 FROM GuestDim
        
        -- Insert into Data Warehouse
        -- Check if the record already exists
        IF EXISTS (SELECT 1 FROM GuestDim WHERE GuestID = @guest_id)
        BEGIN
            -- Update existing record
            UPDATE GuestDim SET
                FirstName = @first_name,
                LastName = @last_name,
                Email = @email,
                Phone = @phone,
                Address = @address,
                City = @city,
                State = @state, 
                Country = @country,
                LoyaltyTier = @loyalty_tier,
                Organization = @organization,
                TotalStays = @total_stays
            WHERE GuestID = @guest_id
        END
        ELSE
        BEGIN
            -- Insert new record
            INSERT INTO GuestDim (
                GuestKey, GuestID, FirstName, LastName, Email, Phone, Address,
                City, State, Country, LoyaltyTier, Organization, TotalStays
            ) VALUES (
                @guest_key, @guest_id, @first_name, @last_name, @email, @phone, 
                @address, @city, @state, @country, @loyalty_tier, 
                @organization, @total_stays
            )
        END
        
        -- Fetch the next row
        FETCH NEXT FROM guest_cursor INTO 
            @guest_id, @first_name, @last_name, @email, @phone, 
            @address, @city, @state, @country, @loyalty_tier, 
            @organization, @total_stays
    END
    
    -- Close and deallocate the cursor
    CLOSE guest_cursor
    DEALLOCATE guest_cursor
END
GO