## Chat App Backend

# ⚠️ ARCHIVED - Legacy PHP Backend

> **This repository is archived and maintained for historical reference only.**
> 
> **🚀 For the active, modernized version, see:** [Java-ChatApp](https://github.com/JakobGokpinar/Java-ChatApp)
> 
> This legacy PHP backend has been replaced with a modern Spring Boot REST API. The new version includes:
> - RESTful API architecture
> - Better code organization (MVC pattern)
> - Type safety with Java
> - Easy local development setup
> 

This is the PHP/MySQL backend for the Chat App messaging application. It provides REST-like endpoints for authentication, friend management, and messaging functionality.

## Quick Setup

### Prerequisites
- PHP 7.0+ with mysqli extension
- MySQL 8.0+
- Apache Web Server (MAMP/XAMPP recommended)

### Installation (Using MAMP)

1. **Install MAMP**
   - Download from [mamp.info](https://www.mamp.info/)
   - Start Apache and MySQL servers

2. **Create Database**
   - Open phpMyAdmin: `http://localhost:8888/phpMyAdmin/`
   - Create database: `goksoft_chat_app`
   - Import `sql.sql` and `SQLorders.sql`

3. **Configure Connection**
   
   Edit `connection.php`:
   ```php
   $connection = mysqli_connect('localhost', 'root', 'root', 'goksoft_chat_app', 8889);
   ```
   
   For XAMPP, use port `3306` and empty password: `''`

4. **Deploy Files**
   ```bash
   cp -r Chat-App-Backend /Applications/MAMP/htdocs/
   # For XAMPP: copy to C:\xampp\htdocs\
   ```

5. **Verify**
   - Open: `http://localhost:8888/Chat-App-Backend/`
   - Should see backend directory

### Frontend Setup

This backend requires the JavaFX frontend from:
👉 **[Chat-App-Frontend](https://github.com/JakobGokpinar/Chat-App-Frontend)**

Follow the setup instructions in that repository.

### API Endpoints

- `login.php` - User authentication
- `register.php` - New user registration  
- `getFriends.php` - Get user's friends list
- `getRequests.php` - Get friend requests
- `becomeFriend.php` - Accept friend request
- `rejectUser.php` - Reject friend request
- `sendMessage.php` - Send message
- `getMessage.php` - Get conversation
- `checkNotif.php` - Check notification count
- `getUsernames.php` - Search users
- `getProfilePhoto.php` - Get user photo
- `changePhoto.php` - Update profile photo

### Database Schema

Tables:
- `users` - User accounts (username, password, photo)
- `friends` - Friend relationships
- `requeststable` - Pending friend requests
- `messagetable` - Messages between users
- `notiftable` - Unread message counts
- `blacklist` - Rejected users

### Tech Stack

- **PHP 7.0+** - Server-side logic
- **MySQL 8.0** - Database with stored procedures
- **Apache** - Web server
- **SendGrid** - Email functionality (optional)


### Original README (PHP Backend - 2020)
This repository contains the backend code for the Chat App messaging application built with PHP and MySQL. The backend code has the responsibility for handling user authentication, friend management, messaging, image handling, and more. It connects with the frontend via Ajax and supports email functionalities through SendGrid.

## Table of Contents
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Project Setup and Installation](#project-setup-and-installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Contact Information](#contact-information)

## Features
- User Authentication:
  - Logging in users and establishing sessions
  - Registering new users
- Friend Management:
  - Getting friend requests of a user
  - Accepting or denying friend requests
  - Fetching friends of a user
- Messaging:
  - Handling message sending between two users
  - Establishing connection with Ajax
- Image Handling:
  - Uploading, updating, and receiving images
- Email Functionality:
  - Sending emails with SendGrid

## Technologies Used
- PHP
- SQL (for database commands)
- Ajax (for establishing connections)
- SendGrid (for email functionalities)

## Project Setup and Installation

### Prerequisites
- PHP 7.0 or higher
- MySQL or any compatible SQL database
- Composer (for PHP dependencies)
- SendGrid API Key (for email functionalities)

### Installation Steps
1. Clone the repository:
    ```bash
    git clone https://github.com/JakobGokpinar/Chat-App-Backend.git
    ```
2. Navigate to the project directory:
    ```bash
    cd Chat-App-Backend
    ```
3. Install PHP dependencies using Composer:
    ```bash
    composer install
    ```
4. Set up the database:
    - Create a new database in your SQL server.
    - Import the provided SQL schema into your database.
    - Update the database configuration in the project.
5. Configure SendGrid:
    - Set up your SendGrid API key in the project configuration.

## Usage
1. Start the PHP server:
    ```bash
    php -S localhost:8000
    ```
2. Access the backend API endpoints through the frontend application.
3. Use Postman or any API client to test the backend functionalities.

## Contributing
Contributions are welcome! Please follow these steps to contribute:
1. Fork the repository.
2. Create a new branch: `git checkout -b feature/your-feature-name`.
3. Make your changes and commit them: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature/your-feature-name`.
5. Open a pull request.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact Information
For any questions or support, please send me an email.
