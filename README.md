# Dart Frog Clean Project

A clean, maintainable Dart Frog backend project template for authentication and user management.

## Project Structure

```
lib/
  constants/           # Error codes and constants
  di/                  # Dependency injection setup
  models/              # Data models (DTOs)
  repositories/        # Database access logic
  services/            # Business logic (auth, db connection)
  utils/               # Utilities (JWT, password, API response, etc.)
routes/
  _middleware.dart     # Global middleware
  index.dart           # Root route
  auth/                # Auth feature routes and middleware
scripts/               # SQL and setup scripts
test/                  # Tests for routes and lib
```

## Setup

1. **Install dependencies:**
   ```sh
   dart pub get
   ```

2. **Configure environment variables:**
   - Copy `.env.example` to `.env` and fill in your secrets.

3. **Run the server:**
   ```sh
   dart_frog dev
   ```

4. **Run tests:**
   ```sh
   dart test
   ```

## Environment Variables

See `.env.example` for required variables.

## Common Commands

- `dart format .`   # Format code
- `dart analyze`    # Lint code
- `dart test`       # Run tests

## Docker

If using Docker, see `docker-compose.yml` and update as needed.

## Contributing

- Follow the project structure.
- Write tests for new features.
- Use environment variables for secrets.

---

**Enjoy building with Dart Frog!**

