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

1.  **Clone the repository**
    go into desired directory:
    cd desired_directory

    in your terminal run: 
git clone https://github.com/MuhammadZameer786/US_Technical
    
    followed by:
cd US_Technical
    


2. Run Setup File. 

    2.1. in your terminal run:
bin/setup
    
    ***Should the setup fail, follow steps 2.2 to 2.4
    otherwise continue to step 3***
    
    **Potential error: the setup may fail due to an 
    incomplete migration. If so, please run the following in your terminal:
     rails db:migrate

    and retry step 2.1
------------------------------------------------------------------------------------
    

    2.2.  **Install Dependencies**
        In your terminal run:

bundle install
        

    2.3.  **Database Setup**
        This command will create the database, run migrations, and 
        populate the seed data. 
        
        
rails db:setup
rails db:migrate
        
        
    2.4. **Database Seed**
    
        
        rails db:seed

3.  **Start the Server**
    rails s
    
    Visit `http://localhost:3000` in your browser.

    * On the latest versions of windows 11, local host doesn't work.  
      replace localhost with your ipv4 address which can be found running:

       ipconfig
    
       in cmd and locating it near the bottom 
       of all the results. should loo jsomething like:
       IpV4 ................................: 192.168.1.7
       In this case, the url to enter into your browser would be https://192.168.1.7:3000 


## 🔑 Login Credentials (Seed Data)

The `db:seed` file populates the database with the following accounts for testing:

| Role | Email | Password |
| :--- | :--- | :--- |
| **Admin** | `admin@unionswiss.com` | `password` |
| **Distributor** | `user@distributor.com` | `password` |



## Extra Details

## 🚀 Additional Features Implemented
* **Soft Deletes:** Products are archived rather than deleted to preserve historical order integrity.
* **Advanced Filtering:** Admin dashboard includes Ransack search and Pagy pagination.
* **Unit Testing:** Core business logic (pricing, status transitions) is verified with RSpec.


## ✅ Running Tests

This project uses **RSpec** for testing. To run the full test suite and verify the business logic:

```bash
bundle exec rspec
