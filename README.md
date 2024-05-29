# roc_flight

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application that follows the
[simple app state management
tutorial](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple).

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware).

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter
apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

## Post first flight : 
- Slow flight detection. Might need to add a button for faster sampling on demand
- Needs faster sampling in flight
- Sampling at 5 sec after apogee not landing
- Vertical velocity data is good but not transposed correctly
- Would need to save up data and send multiple packets to server
- Acceleration is a little weird as well.
- Save data in phone as csv
- Export flight as csv
- Distance in GPS mode weird
- phone going to sleep. Need to figure out how to run in background !!!!!!
- Velocity very weird