# Budget Scanner

A budget and expense tracking app built as part of the [CastroDev](https://castrodev.com) portfolio. Create custom budgets, track your spending, scan receipts with OCR, and get monthly analytics — with full dark mode support.

---

## 📱 Screenshots

<p align="center">
  <img src="screenshots/login_light.png" width="23%" />
  <img src="screenshots/boards_light.png" width="23%" />
  <img src="screenshots/transactions_light.png" width="23%" />
  <img src="screenshots/profile_dark.png" width="23%" />
</p>
<p align="center">
  <img src="screenshots/boards_dark.png" width="23%" />
  <img src="screenshots/analytics_dark.png" width="23%" />
</p>

---

## ✨ Features

- 💰 **Budgets** — Create budgets with custom colours, categories, limits and alert thresholds
- 📋 **Transactions** — Log expenses with categories, tags, notes and merchant info
- 📸 **Receipt scanning** — Extract amount, date and merchant automatically via OCR
- 📊 **Analytics** — Monthly summary, category breakdown and month-over-month comparison
- 🔔 **Alerts** — Get notified when a budget reaches your configured threshold
- 🔁 **Recurring budgets** — Automatically reset monthly budgets each month
- 🌙 **Dark mode** — Automatic dark/light mode based on system settings
- 👤 **Profile** — Edit name, manage notifications and appearance
- 🌍 **Multilingual** — English and Spanish support

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift 6 |
| UI Framework | SwiftUI |
| State Management | `@Observable` + `@State` |
| Authentication | Firebase Auth (Email + Google) |
| Backend | .NET 10 REST API (Clean Architecture) |
| Database | Cloud Firestore |
| OCR | Google Cloud Vision API |
| Infrastructure | Google Cloud Run |
| Dependency Management | Swift Package Manager |

---

## 🏗️ Architecture

The app follows **Clean Architecture** principles with strict layer separation:

```
BudgetScanner/
├── Core/
│   ├── Config/          # API config, colours, theme
│   ├── Errors/          # Failure types
│   └── Network/         # API client with Firebase auth
└── Features/
    ├── Auth/            # Login, register, Google Sign-In
    ├── Budgets/         # CRUD budgets, alerts, recurring
    ├── Transactions/    # CRUD transactions, receipt scanning
    ├── Analytics/       # Monthly summary, categories, comparison
    └── Profile/         # Settings, notifications, appearance
```

Each feature follows the pattern:

```
Feature/
├── Data/
│   ├── DataSources/     # Remote API calls
│   ├── Models/          # DTO models
│   └── Repositories/    # Repository implementations
├── Domain/
│   ├── Entities/        # Domain entities
│   ├── Repositories/    # Abstract repository interfaces
│   └── UseCases/        # Business logic use cases
└── Presentation/
    ├── Views/           # SwiftUI screens
    ├── ViewModels/      # @Observable ViewModels
    └── Components/      # Reusable UI components
```

---

## 🚀 Getting Started

### Prerequisites

- Xcode 16+
- iOS 17+ (simulator or device)
- Firebase project configured
- API running at `api.castrodev.com` or locally

### Installation

```bash
# Clone the repository
git clone https://github.com/castrodev/budget-scanner-ios.git

# Open in Xcode
open BudgetScanner.xcodeproj
```

Then:

1. Add your `GoogleService-Info.plist` to the main target in Xcode
2. Create a `Config.xcconfig` file in the project root:

```
API_BASE_URL = https://api.castrodev.com
```

3. Swift Package Manager dependencies resolve automatically on first open
4. Build and run with `⌘R`

### Running Tests

```bash
xcodebuild test \
  -scheme BudgetScanner \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

---

## 🔗 Related

- [CastroDev API](https://github.com/castrodev/castrodev-api) — Shared .NET 10 backend
- [Finance Tracker](https://github.com/castrodev/finance-tracker) — Personal finance app (Flutter)
- [Habit Tracker](https://github.com/castrodev/habit-tracker) — Daily habit tracking app (Flutter)
- [Task Manager](https://github.com/castrodev/task-manager-ios) — Board-based task management (iOS)
- [castrodev.com](https://castrodev.com) — Portfolio

---

## 📄 License

MIT © [Gabriel Castro](https://castrodev.com)

---

---

# Budget Scanner

App de seguimiento de presupuestos y gastos desarrollada como parte del portfolio de [CastroDev](https://castrodev.com). Crea presupuestos personalizados, registra tus gastos, escanea recibos con OCR y obtén análisis mensuales — con soporte completo de modo oscuro.

---

## ✨ Funcionalidades

- 💰 **Presupuestos** — Crea presupuestos con colores, categorías, límites y umbrales de alerta personalizados
- 📋 **Transacciones** — Registra gastos con categorías, etiquetas, notas e información del comercio
- 📸 **Escaneo de recibos** — Extrae importe, fecha y comercio automáticamente mediante OCR
- 📊 **Análisis** — Resumen mensual, desglose por categoría y comparativa mes a mes
- 🔔 **Alertas** — Recibe avisos cuando un presupuesto alcanza el umbral configurado
- 🔁 **Presupuestos recurrentes** — Reseteo automático mensual
- 🌙 **Modo oscuro** — Modo oscuro/claro automático según el sistema
- 👤 **Perfil** — Edita tu nombre, gestiona notificaciones y apariencia
- 🌍 **Multiidioma** — Soporte para español e inglés

---

## 🛠️ Stack Tecnológico

| Capa | Tecnología |
|---|---|
| Lenguaje | Swift 6 |
| UI Framework | SwiftUI |
| Estado | `@Observable` + `@State` |
| Autenticación | Firebase Auth (Email + Google) |
| Backend | API REST .NET 10 (Clean Architecture) |
| Base de datos | Cloud Firestore |
| OCR | Google Cloud Vision API |
| Infraestructura | Google Cloud Run |
| Gestión de dependencias | Swift Package Manager |

---

## 🚀 Instalación

### Requisitos previos

- Xcode 16+
- iOS 17+ (simulador o dispositivo)
- Proyecto Firebase configurado
- API disponible en `api.castrodev.com` o en local

### Pasos

```bash
# Clonar el repositorio
git clone https://github.com/castrodev/budget-scanner-ios.git

# Abrir en Xcode
open BudgetScanner.xcodeproj
```

A continuación:

1. Añade tu `GoogleService-Info.plist` al target principal en Xcode
2. Crea un fichero `Config.xcconfig` en la raíz del proyecto:

```
API_BASE_URL = https://api.castrodev.com
```

3. Las dependencias de Swift Package Manager se resuelven automáticamente al abrir el proyecto
4. Compila y ejecuta con `⌘R`

### Tests

```bash
xcodebuild test \
  -scheme BudgetScanner \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

---

## 🔗 Relacionado

- [CastroDev API](https://github.com/castrodev/castrodev-api) — Backend compartido en .NET 10
- [Finance Tracker](https://github.com/castrodev/finance-tracker) — App de finanzas personales (Flutter)
- [Habit Tracker](https://github.com/castrodev/habit-tracker) — App de seguimiento de hábitos (Flutter)
- [Task Manager](https://github.com/castrodev/task-manager-ios) — Gestión de tareas por tableros (iOS)
- [castrodev.com](https://castrodev.com) — Portfolio
