# Union Swiss Technical Assessment - Order Management System

A Rails-based Order Management System allowing Distributors to place bulk orders and Admins to manage products and view analytics.

## 🛠 Tech Stack

* **Ruby:** 3.3.6
* **Rails:** 8.1.3
* **Database:** SQLite
* **Testing:** RSpec
* **Frontend:** Bootstrap 5

## ⚙️ Setup Instructions

Assuming you have Ruby and Rails installed, follow these steps to get the app running:

### 1. Clone the Repository

Navigate to your desired directory:
```bash
cd desired_directory
```

Clone the repository:
```bash
git clone https://github.com/MuhammadZameer786/US_Technical
cd US_Technical
```

### 2. Run Setup File

Run the automated setup:
```bash
bin/setup
```

**If the setup succeeds, skip to step 3.**

#### Troubleshooting Setup Failures

**Potential error:** The setup may fail due to an incomplete migration. If so, run:
```bash
rails db:migrate
```

Then retry `bin/setup`.

**If setup continues to fail, follow manual setup steps 2.1-2.3:**

#### 2.1. Install Dependencies
```bash
bundle install
```

#### 2.2. Database Setup

Create the database, run migrations, and populate seed data:
```bash
rails db:setup
rails db:migrate
```

#### 2.3. Database Seed
```bash
rails db:seed
```

### 3. Start the Server
```bash
rails s
```

Visit `http://localhost:3000` in your browser.

**Note for Windows 11 users:** If localhost doesn't work, use your IPv4 address instead. Find it by running:
```bash
ipconfig
```

Look for a line like:
```
IPv4 Address........................: 192.168.1.7
```

Then visit `http://192.168.1.7:3000` in your browser (note: use `http://`, not `https://`).

## 🔑 Login Credentials (Seed Data)

The `db:seed` file populates the database with the following test accounts:

| Role | Email | Password |
|:-----|:------|:---------|
| **Admin** | `admin@unionswiss.com` | `password` |
| **Distributor** | `user@distributor.com` | `password` |

## 🚀 Additional Features Implemented

* **Soft Deletes:** Products are archived rather than deleted to preserve historical order integrity
* **Advanced Filtering:** Admin dashboard includes Ransack search and Pagy pagination
* **Unit Testing:** Core business logic (pricing, status transitions) is verified with RSpec

## ✅ Running Tests

This project uses **RSpec** for testing. To run the full test suite:
```bash
bundle exec rspec
```