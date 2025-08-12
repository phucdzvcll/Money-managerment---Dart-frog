
# Finance Management App – Implementation Plan (MVP 8 Weeks)

## 1. Mục tiêu & Phạm vi MVP
- **Mục tiêu**: phát hành MVP quản lý tài chính cá nhân + nhóm (Family) với ghi giao dịch, báo cáo tổng quan, chia sẻ theo phạm vi, chạy trên Flutter (mobile + web), backend Dart Frog, Postgres (schema không FK, RBAC động).
- **Phạm vi**  
  - Tài khoản/thẻ: CRUD + chu kỳ thẻ tín dụng (ngày chốt/ngày thanh toán).  
  - Danh mục: CRUD + phân cấp 1 mức.  
  - Giao dịch: expense/income/transfer, lọc & tổng hợp kỳ, đính kèm ảnh (URL).  
  - Báo cáo Overview: thu–chi, số dư theo tài khoản, dư nợ credit (theo chu kỳ), dư nợ vay.  
  - Nhóm & chia sẻ: tạo nhóm, mời thành viên, chia sẻ theo scope (account/category/summary).  
  - RBAC: roles/permissions theo scope (global/group).  
  - Hạ tầng: auth đã có, logging, audit, migration, CI build.

## 2. Persona chính
- **Owner**: người dùng cá nhân, có thể tạo nhóm Family.  
- **Member**: thành viên nhóm được chia sẻ dữ liệu trong scope.  
- **Viewer**: chỉ được xem trong scope.

## 3. Storyboard
### Onboarding & Home
- **SB-01**: Đăng nhập → chọn VND → Dashboard.
- **SB-02**: Dashboard: Thu, Chi, Net, danh sách tài khoản, dư nợ, nút “+ Giao dịch”.

### Accounts & Credit Cycle
- **SB-03**: Danh sách tài khoản (lọc, archived).  
- **SB-04**: Tạo/Sửa tài khoản.  
- **SB-05**: Cấu hình chu kỳ credit.  
- **SB-06**: Archive/Xóa mềm.

### Categories
- **SB-07**: Danh mục (expense/income).  
- **SB-08**: Tạo/Sửa/Xóa danh mục.

### Transactions
- **SB-09**: Ghi giao dịch.  
- **SB-10**: Lịch sử giao dịch + filter.  
- **SB-11**: Chi tiết giao dịch.

### Reports
- **SB-12**: Overview (thu–chi, số dư, dư nợ).  
- **SB-13**: Breakdown theo danh mục.

### Groups & Sharing
- **SB-14**: Nhóm: list, tạo, xem thành viên.  
- **SB-15**: Mời thành viên.  
- **SB-16**: Chia sẻ (scope + quyền).  
- **SB-17**: Xem quyền.

## 4. Lộ trình & Milestones (8 tuần)
### M0 – Khởi tạo & hạ tầng (Tuần 1)
- Backend: scaffold Dart Frog, middleware JWT, `/healthz`, Postgres, migration.
- Frontend: Flutter scaffold, theme, routing.
- DevOps: Docker compose, seed rbac.

### M1 – Accounts & Categories (Tuần 2)
- Backend: `/accounts` CRUD, `/categories` CRUD.
- Frontend: màn accounts, categories.

### M2 – Transactions (Tuần 3–4)
- Backend: `/transactions` CRUD + filter + totals.
- Frontend: form ghi, lịch sử, chi tiết giao dịch.

### M3 – Reports Overview (Tuần 5)
- Backend: `/reports/overview`, `/reports/categories`.
- Frontend: dashboard overview + breakdown.

### M4 – Groups & Sharing + RBAC (Tuần 6–7)
- Backend: `/groups`, `/shares`, RBAC guard.
- Frontend: nhóm, chia sẻ, hiển thị quyền.

### M5 – Hardening, UAT, Release (Tuần 8)
- Hardening, UAT, tài liệu, phát hành.

## 5. Deliverables theo Milestone
- **M0**: Repo, CI/CD, Docker, migration, seed RBAC, Postman collection.
- **M1**: API + UI Accounts/Categories, test.
- **M2**: API + UI Transactions, test.
- **M3**: API + UI Reports, test.
- **M4**: API + UI Groups/Shares/RBAC, test.
- **M5**: Build release (APK/IPA/Web), tài liệu.

## 6. Acceptance Criteria
- Dữ liệu: mọi bảng có `created_at/updated_at` + trigger.
- Bảo mật: API yêu cầu JWT, scoping đúng.
- Hiệu năng: overview < 1.5s với 1k giao dịch/kỳ.
- Tính đúng: totals khớp dữ liệu mẫu, idempotency hoạt động.
- Chia sẻ: quyền & scope chính xác.

## 7. Rủi ro & Giảm thiểu
- Không FK: kiểm tra rác ở service layer.
- Concurrent writes: idempotency key + transaction.
- Tải báo cáo lớn: index + view materialization.
- Quyền phức tạp: test guard, cache permissions.

## 8. Theo dõi & Analytics
- Sự kiện: tạo giao dịch, sửa, tạo tài khoản, xem báo cáo.
- KPI: DAU/MAU, số giao dịch/tuần, nhóm hoạt động, thời gian tải dashboard.
