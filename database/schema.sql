-- Create dimension tables
CREATE TABLE GuestDim (
    GuestKey INT PRIMARY KEY,
    GuestID VARCHAR(20) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    LoyaltyTier VARCHAR(20),
    Organization VARCHAR(100),
    TotalStays INT
);

CREATE TABLE HotelDim (
    HotelKey INT PRIMARY KEY,
    HotelID VARCHAR(20) NOT NULL,
    HotelName VARCHAR(100) NOT NULL,
    Brand VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    StarRating INT NOT NULL,
    TotalRooms INT NOT NULL
);

CREATE TABLE TimeDim (
    TimeKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    DayOfWeek INT NOT NULL,
    DayName VARCHAR(10) NOT NULL,
    MonthNumber INT NOT NULL,
    MonthName VARCHAR(10) NOT NULL,
    Quarter INT NOT NULL,
    Year INT NOT NULL,
    IsHighSeason BIT NOT NULL
);

CREATE TABLE RoomDim (
    RoomKey INT PRIMARY KEY,
    RoomID VARCHAR(20) NOT NULL,
    RoomNumber VARCHAR(10) NOT NULL,
    RoomType VARCHAR(50) NOT NULL,
    BedType VARCHAR(50) NOT NULL,
    MaxOccupancy INT NOT NULL,
    BaseRate DECIMAL(10,2) NOT NULL,
    IsNonSmoking BIT NOT NULL,
    HotelKey INT NOT NULL,
    CONSTRAINT FK_RoomDim_HotelDim FOREIGN KEY (HotelKey) REFERENCES HotelDim(HotelKey)
);

CREATE TABLE EventDim (
    EventKey INT PRIMARY KEY,
    EventID VARCHAR(20) NOT NULL,
    EventName VARCHAR(100) NOT NULL,
    EventType VARCHAR(50) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    EstimatedAttendees INT
);

-- Create fact table
CREATE TABLE ReservationFact (
    ReservationKey INT PRIMARY KEY,
    TimeKey INT NOT NULL,
    GuestKey INT NOT NULL,
    RoomKey INT NOT NULL,
    HotelKey INT NOT NULL,
    EventKey INT,
    ReservationID VARCHAR(20) NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    TotalRoomRevenue DECIMAL(10,2) NOT NULL,
    TotalAncillaryRevenue DECIMAL(10,2) NOT NULL,
    NumberOfGuests INT NOT NULL,
    BookingChannel VARCHAR(50) NOT NULL,
    SatisfactionScore INT,
    CONSTRAINT FK_ReservationFact_TimeDim FOREIGN KEY (TimeKey) REFERENCES TimeDim(TimeKey),
    CONSTRAINT FK_ReservationFact_GuestDim FOREIGN KEY (GuestKey) REFERENCES GuestDim(GuestKey),
    CONSTRAINT FK_ReservationFact_RoomDim FOREIGN KEY (RoomKey) REFERENCES RoomDim(RoomKey),
    CONSTRAINT FK_ReservationFact_HotelDim FOREIGN KEY (HotelKey) REFERENCES HotelDim(HotelKey),
    CONSTRAINT FK_ReservationFact_EventDim FOREIGN KEY (EventKey) REFERENCES EventDim(EventKey)
);