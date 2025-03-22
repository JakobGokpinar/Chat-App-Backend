# Chat App Backend

This repository contains the backend code for the Chat App messaging application built with PHP and MySQL. The backend is responsible for handling user authentication, friend management, messaging, image handling, and more. It connects with the frontend via Ajax and supports email functionalities through SendGrid.

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
