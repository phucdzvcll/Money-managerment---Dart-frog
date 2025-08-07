# Project Structure

The project follows a clean and modular architecture, organized into different directories and files based on their purpose. Below is a high-level overview of the structure:

---

## 📁 Root Directory (`lib/`)

The `lib/` directory is the main directory of the project and contains all the source code. It is organized into different subdirectories based on the feature or module.

---

## 📁 Feature Directories

Each feature is organized into its own directory under `lib/feature/`. For example, the `installments` feature has its own directory.

### `lib/feature/installments/`

This directory contains all the code related to the `installments` feature. It is further divided into subdirectories based on the layer or component.

---

## 📁 Subdirectories within `lib/feature/installments/`

### `entities/`

This subdirectory contains **domain models** (entities) for the `installments` feature. These represent the data in the domain layer and are used for business logic and data persistence.

- **`installments_entity.dart`**
  - Defines the `InstallmentsEntity` class, which represents an installment in the domain layer.
  - Uses the `freezed_annotation` package to generate immutable classes.
  - Implements `BaseEntity` (a likely base class for all entities in the app).

---

### `dto/`

This subdirectory contains **Data Transfer Objects (DTOs)**, which are used for transferring data between different layers (e.g., between the API and the application, or between the repository and the service layer).

- **`request/installments_request_dto.dart`**
  - Defines the `InstallmentsRequestDto` class, representing the data required for incoming requests (e.g., from the API).
  - Uses `freezed_annotation` to generate immutable classes.
  - Implements `BaseRequestDto` (a likely base class for all request DTOs in the app).

- **`response/installments_response_dto.dart`**
  - Defines the `InstallmentsResponseDto` class, representing the data returned as a response.
  - Uses `freezed_annotation` to generate immutable classes.
  - Implements `BaseResponseDto` (a likely base class for all response DTOs in the app).

- **`mapper.dart`**
  - Defines the `InstallmentsMapper` class, which extends `BaseMapper`.
  - Provides methods to convert between:
    - `InstallmentsRequestDto` and `InstallmentsEntity` (`fromRequestDto`).
    - `InstallmentsEntity` and `InstallmentsResponseDto` (`toResponseDto`).
  - This is essential for mapping data between layers (e.g., from the API to the domain model).

---

### `repository/`

This subdirectory contains the **repository layer**, which is responsible for data persistence (e.g., working with the database).

- **`installments_repository.dart`**
  - Defines the `InstallmentsRepository` interface, which extends `BaseRepository<InstallmentsEntity>`.
  - The `InstallmentsRepositoryImpl` class implements this interface.
  - It provides methods to interact with the database (e.g., via `postgres`).
  - Includes `fromJson` and `toJson` methods for converting between `InstallmentsEntity` and database rows.

---

### `service/`

This subdirectory contains the **service layer**, which contains business logic and coordinates between the repository and controller layers.

- **`installments_service.dart`**
  - Defines the `InstallmentsService` interface, which extends `BaseService<InstallmentsEntity, InstallmentsRequestDto, InstallmentsResponseDto, InstallmentsRepository, InstallmentsMapper>`.
  - The `InstallmentsServiceImpl` class implements this interface and is annotated with `@Injectable` for dependency injection.
  - This service handles high-level logic, such as creating, reading, updating, and deleting installment data.

---

### `controller.dart`

This file contains the **controller layer**, which handles incoming HTTP requests and routes them to the appropriate service methods.

- **`InstallmentsController`**
  - Extends `BaseController<InstallmentsEntity, InstallmentsRequestDto, InstallmentsResponseDto, InstallmentsMapper, InstallmentsRepository, InstallmentsService>`.
  - Implements methods like `executeCreate`, `executeFindAll`, `executeUpdate`, `executeFindById`, and `executeDeleteById`.
  - Uses annotations like `@OpenApi` to define API endpoints and their behaviors (e.g., `POST /installments/`, `GET /installments/{id}`).
  - Converts incoming request data (JSON) into `InstallmentsRequestDto` objects and passes them to the service layer for processing.

---

## 📦 Summary of the Structure

Here is a high-level summary of the structure of the project:

---

## ✅ Key Observations

- The project uses **clean architecture** principles, with separate layers for data (entities), transfer (DTOs), mapping, persistence (repository), business logic (service), and HTTP handling (controller).
- It uses the **`freezed`** package to create immutable models, which is a popular pattern in Flutter and Dart for managing state and data.
- **Dependency injection** is used via the `@Injectable` annotation, indicating that the app is using a DI container (likely `get_it` or `injectable`).
- **OpenAPI** annotations are used to define RESTful endpoints and their expected behavior, which is useful for generating API documentation.

---

## 📌 Notes

- This is just one feature (`installments`) in the project. Other features will likely have a similar structure under the `lib/feature/` directory.
- If you're looking for more information about the overall project, you might want to check the `README.md` file in the root directory or other top-level files like `pubspec.yaml`.

Let me know if you'd like a diagram or further explanation of any part of the structure!