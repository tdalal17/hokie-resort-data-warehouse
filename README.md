# Hokie Resort Data Warehouse Project (ACIS 5504)

A comprehensive data warehouse implementation for a hotel resort chain, demonstrating dimensional modeling, ETL processes, and business analytics.

## 📋 Project Overview

This project implements a star schema data warehouse for Hokie Resort, a hotel chain that operates across multiple locations. The system integrates data from two different corporate databases (Corp1 and Corp2) and provides analytics for revenue optimization, customer satisfaction analysis, and cross-selling opportunities.

## 🏗️ Project Structure

### `/database/` - Database Schema & Design
- **`schema.sql`**: Complete DDL statements defining dimensional tables and fact table with star schema design

### `/etl/` - Extract, Transform, Load Procedures
- **`Load_GuestDim_From_Corp1.sql`**: Guest dimension ETL from Corporation 1 database
- **`Load_HotelDim_From_Corp2 Procedure.sql`**: Hotel dimension ETL from Corporation 2 database
- **`Load_ReservationFact_From_Corp1 Procedure.sql`**: Reservation fact table ETL from Corporation 1
- **`Load_ReservationFact_From_Corp2 Procedure.sql`**: Reservation fact table ETL from Corporation 2

### `/sample-data/` - Test Data & Sample Scripts
- **`Data for GuestDim.sql`**: Guest dimension sample data
- **`Data for HotelDim.sql`**: Hotel dimension sample data
- **`Data for RoomDim.sql`**: Room dimension sample data
- **`Data for EventDim.sql`**: Event dimension sample data
- **`Data for ReservationFact.sql`**: Fact table sample data

### `/analytics/` - Business Intelligence Queries
- **`Revenue Optimization by Hotel Brand, Season, and Room Type.sql`**: Revenue analysis with ROLLUP operations
- **`Cross-Selling Opportunities Analysis by Room Type and Booking Channel.sql`**: Ancillary revenue analysis with CUBE operations
- **`Customer Satisfaction Analysis by Loyalty Tier and Hotel Brand.sql`**: Customer satisfaction metrics with ROLLUP

### `/visualizations/` - Charts & Data Visualizations
- **`Revenue by Hotel Brand and Season.png`**: Revenue trends visualization
- **`Cross-Selling Opportunities Analysis by Room Type and Booking Channel.png`**: Cross-selling opportunities chart
- **`Customer Satisfaction Analysis by Loyalty Tier and Hotel Brand.png`**: Satisfaction metrics by segment
- **`Customer Satisfaction Analysis by Loyalty Tier.png`**: Loyalty tier satisfaction breakdown

### `/docs/` - Documentation & Architecture
- **`HokieResortDW_Star.png`**: Star schema diagram and data model
- **`Data Dictionary.docx`**: Comprehensive field definitions and business rules
- **`Data wearhouse mapping table.docx`**: Source-to-target mapping documentation
- **`Introducation of the hotal and question.docx`**: Project requirements and business context
- **`Reporting and Visualization.docx`**: Comprehensive reporting documentation

## 🗃️ Database Schema

### Dimension Tables
- **GuestDim**: Customer information including loyalty tier and demographics
- **HotelDim**: Hotel properties with brand, location, and rating details
- **RoomDim**: Room inventory with type, capacity, and pricing information
- **TimeDim**: Date dimension with seasonal indicators
- **EventDim**: Special events and conferences

### Fact Table
- **ReservationFact**: Central fact table containing reservation transactions with revenue metrics

## 🔄 ETL Process

The ETL system handles data integration from two corporate databases:
- **Corp1**: Primary booking system
- **Corp2**: Secondary property management system

Key features:
- Incremental loading with upsert logic
- Automatic dimension key generation
- Data quality validation
- Business rule enforcement

## 📊 Analytics Capabilities

### Revenue Optimization
- Analysis by hotel brand, season, and room type
- Revenue breakdown between room charges and ancillary services
- Seasonal pattern identification

### Cross-Selling Opportunities
- Ancillary revenue analysis by room type and booking channel
- Opportunity identification for additional service sales
- Channel performance comparison

### Customer Satisfaction
- Satisfaction scoring by loyalty tier and hotel brand
- Customer segmentation analysis
- Service quality benchmarking

## 🛠️ Technologies Used

- **Database**: Microsoft SQL Server
- **ETL**: SQL Server stored procedures with cursor-based processing
- **Analytics**: Advanced SQL with ROLLUP and CUBE operations
- **Visualization**: Business intelligence dashboards and charts

## 📈 Business Value

This data warehouse enables Hokie Resort to:
- Optimize pricing strategies based on demand patterns
- Identify cross-selling opportunities to increase revenue per guest
- Monitor and improve customer satisfaction across different segments
- Make data-driven decisions for hotel operations and marketing

## 🚀 Getting Started

1. **Database Setup**: Execute `database/schema.sql` to create the data warehouse schema
2. **Load Sample Data**: Run the scripts in `sample-data/` folder to populate test data
3. **Configure ETL**: Deploy the stored procedures from `etl/` folder for ongoing data integration
4. **Run Analytics**: Execute the business intelligence queries in `analytics/` folder
5. **View Results**: Check `visualizations/` folder for data insights and charts

## 📝 Notes

- The project demonstrates academic understanding of data warehousing concepts
- Sample data is provided for testing and demonstration purposes
- ETL procedures include error handling and data validation
- Queries utilize advanced SQL features for comprehensive analytics

---

**Course**: ACIS 5504 - Data Warehousing  
**Institution**: Virginia Tech  
**Project Type**: Academic Capstone Project
