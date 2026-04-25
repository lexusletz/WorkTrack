# Project Specification: Income Tracker & Forecaster (macOS)

### Overview
An application designed for macOS to track daily earnings based on hours worked and provide a real-time financial forecast for the end of the month. The app focuses on local data persistence and dynamic recalculation.

### Core Objective
To bridge the gap between "scheduled income" and "actual income." The app must allow the user to define a standard work schedule while allowing daily overrides that immediately update the projected monthly total.

#### Functional Requirements
1. Configuration & Constants (User Settings)

   - Hourly Rate: The base currency value per hour.

   - Standard Schedule: A definition of "working days" (e.g., Mon-Fri) and "standard hours" (e.g., 8h/day).

   - Monthly Target: A calculation of potential income if all standard hours are met.

2. Daily Logging System

   - Calendar/List View: Interface to select a specific day.

   - Hour Input: Ability to input the actual hours worked on a specific date.

   - Status Indicators:

     - Pending: Future days or days not yet logged.

     - Completed: Days where hours have been confirmed.

     - Missed/Holiday: Days marked as zero hours.

3. Dynamic Calculation Engine
   The app must handle three primary variables to generate the forecast:

   1. Accumulated Income: (Total hours worked so far this month) * (Hourly Rate).

   2. Remaining Potential: (Standard hours in remaining workdays) * (Hourly Rate).

   3. Monthly Estimate: Accumulated Income + Remaining Potential.
 
### Data Schema (Local Persistence)
- **Storage**: Local-only (Hive or SQFlite).

- **WorkLog Model**:

  - `date`: DateTime (Primary Key).

  - `hoursWorked`: Double.

  - `isExtraDay`: Boolean (for weekends or overtime).

  - notes`: String (Optional).

### Technical Stack (Flutter/macOS)
- **Framework*: Flutter (Desktop).

- **Platform**: macOS.

- **State Management**: Any reactive approach (Provider/Riverpod) to ensure that changing a single day's hours updates the "Monthly Estimate" header instantly.

- **Persistence**: path_provider (to access macOS application documents) and a lightweight database.

### User Flow
1. **Setup**: User enters their hourly rate and typical weekly schedule.

2. **Dashboard**: Shows the Current Total and the Updated Forecast.

3. **Daily Entry**: User clicks on "Today" (or any past date), enters hours, and saves.

4. **Instant Update**: The Forecast recalculates, showing the impact of that specific day on the final monthly paycheck.
