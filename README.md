# tewke_test

Tewke mobile development assignment

## Carbon Intensity App

This app displays the current carbon intensity and also presents a graph of the actual and forecasted carbon intensity over 24hr periods.

### OS
- Run app on android emulator or device

### Features

- Display current carbon intensity - refreshed every 5 minutes
- Display graph of actual and forecasted carbon intensity over 24hr periods
- Allows user to step forward and backward in time to view the carbon intensity on different days
- Allows user to tap on graph and see summary or actual and forecasted carbon intensity at that time
- If there is an error fetching data, the app will present a simple error message

### Architecture

- The app logic has been separated into UI, Controller, Domain and Repository Layers
- The current and historic data are handled independently each with its own controller
- Riverpod has been used for state management

### Assumptions

- The carbon intensity api is assumed to be available at all times
- For each data period returned by the api forecast data is assumed to be non-null
- The app doesn't do much explanation of what carbon intensity is, it is assumed this would be improved in a real app
- The bands for low medium and high carbon intensity colors are somewhat arbitrary



