# MoneyFlow

MoneyFlow is a personal expense tracker built with Flutter using a feature-based layered architecture.  
It helps users record income and expenses, review spending trends, secure the app with a PIN, and export data to CSV or PDF.

## Features

- Track income and expense transactions
- Create and manage categories
- Dashboard with total balance, income, expense, weekly chart, and recent transactions
- Detailed weekly, monthly, and yearly reports
- Category expense breakdown
- Global currency display based on app settings
- PIN lock with app gate and secure local storage
- Export transactions to CSV
- Export current month report to PDF
- Demo seed data for first launch

## Tech Stack

- Flutter
- `flutter_bloc` for state management
- `go_router` for navigation
- `get_it` for dependency injection
- `isar` for local database
- `flutter_secure_storage` for PIN credentials
- `syncfusion_flutter_charts` for charts
- `csv` and `pdf` for export

## Architecture

The project follows a feature-based layered structure:

- `presentation`: pages, widgets, blocs, cubits
- `domain`: entities, repositories, use cases
- `data`: models, mappers, datasources, repository implementations
- `core`: shared utilities, theme, DI, seed, constants

Each feature is isolated and keeps its own presentation, domain, and data layers.

## Main Modules

- `transactions`: transaction CRUD and history
- `categories`: category management
- `reports`: summary and detailed analytics
- `settings`: app preferences and export entry point
- `app_lock`: PIN lock, secure verification, and app gate
- `export`: CSV and PDF generation

## Local Data

- Transactions, categories, and settings are stored locally with Isar
- PIN credentials are stored securely with `flutter_secure_storage`
- The app seeds initial demo data on first launch

## Getting Started

```bash
flutter pub get
flutter run
```

## Development Notes

- State is managed with Cubits and Blocs depending on the feature
- App-wide settings and app lock are provided from the root
- Money values are stored in base data and formatted in UI based on current settings

## Status

This project is actively being built and refactored to improve architecture, UX, and export/security flows.
