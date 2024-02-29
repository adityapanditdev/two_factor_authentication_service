# Two-Factor Authentication Service

## Description

The Two-Factor Authentication (2FA) Service is a web application built using the Sinatra framework in Ruby. It provides users with an added layer of security by implementing two-factor authentication. The application allows users to register, log in, and manage their account settings.

## Key Features

- **User Registration:** Users can register for an account by providing their email and password.
- **User Authentication:** Registered users can log in to their account using their email and password.
- **Two-Factor Authentication (2FA):** Users have the option to enable two-factor authentication for their account, adding an extra layer of security.
- **QR Code Integration:** Users are provided with a secret key (or QR code) to set up their authenticator app (e.g., Google Authenticator).
- **Account Settings:** Users can manage their account settings, including updating their password and enabling/disabling 2FA.

## Technologies Used

- **Ruby:** Programming language used for backend development.
- **Sinatra:** Lightweight web framework used for building web applications.
- **BCrypt:** Encryption library used for securely storing user passwords.
- **Pony:** Gem used for sending confirmation emails to users.
- **ROTP:** Library used for generating and verifying one-time codes for 2FA.
- **RQRCode:** Library used for generating QR codes.
- **RSpec:** Testing framework used for writing and executing tests.

## Prerequisites

Before you begin, ensure you have met the following requirements:
- Docker: [Install Docker](https://docs.docker.com/get-docker/)

## Installation and Setup

1. Clone the repository:

```bash
git clone <repository_url>
cd two_factor_authentication_service
```

2. Install Docker:

```bash
Install docker and docker-compose
```

3. Build the Docker containers:

```bash
docker compose build
```

## Usage

To start the application, run:

```bash
docker compose up
```

After start docker hit the url:- http://localhost:3000/

## Accessing Bash Shell

To access the bash shell of the backend container, run:

```bash
docker exec -it < container-name >
```

you can check contains using:

```bash
docker ps
```

## Accessing Sidekiq/backend Logs

To access the logs of the Sidekiq container, you can use the `docker attach` command. Run the following command:

```bash
docker attach two_factor_authentication_service-backend-1
docker attach two_factor_authentication_service-sidekiq-1
```
This will attach your terminal to the logs of the Sidekiq/backend container, allowing you to view real-time logs and debug any issues.


## Running Tests

To run tests, execute the following command:

1. Open the backend container:
```bash
docker exec -it two_factor_authentication_service-backend-1
```
2. Run the migration command with test env:
```bash
rake db:migrate RACK_ENV=test
```

3. Run the rspec in the container:
```bash
bundle exec rspec
```
