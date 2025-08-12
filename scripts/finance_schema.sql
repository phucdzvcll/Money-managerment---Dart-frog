-- =========================================================
-- Finance App – Full Schema (No FOREIGN KEYs)
-- All tables include created_at, updated_at, and an updated_at trigger
-- =========================================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Trigger function to auto-update updated_at
CREATE OR REPLACE FUNCTION set_updated_at()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =========================
-- 1) Core: users
-- =========================
CREATE TABLE IF NOT EXISTS users
(
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username      VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT               NOT NULL,
    full_name     VARCHAR(100),
    created_at    TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP        DEFAULT CURRENT_TIMESTAMP
);
CREATE OR REPLACE TRIGGER trg_users_updated_at
    BEFORE UPDATE
    ON users
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- =========================
-- 2) RBAC (dynamic; no FKs)
-- =========================
CREATE TABLE IF NOT EXISTS roles
(
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        TEXT NOT NULL, -- owner/admin/member/viewer...
    description TEXT,
    scope_type  TEXT NOT NULL CHECK (scope_type IN ('global', 'group')),
    created_at  TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (name, scope_type)
);
CREATE OR REPLACE TRIGGER trg_roles_updated_at
    BEFORE UPDATE
    ON roles
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TABLE IF NOT EXISTS permissions
(
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key         TEXT UNIQUE NOT NULL, -- accounts.read, transactions.write, ...
    description TEXT,
    created_at  TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP        DEFAULT CURRENT_TIMESTAMP
);
CREATE OR REPLACE TRIGGER trg_permissions_updated_at
    BEFORE UPDATE
    ON permissions
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TABLE IF NOT EXISTS role_permissions
(
    role_id       UUID NOT NULL,
    permission_id UUID NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (role_id, permission_id)
);
CREATE OR REPLACE TRIGGER trg_role_permissions_updated_at
    BEFORE UPDATE
    ON role_permissions
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TABLE IF NOT EXISTS user_roles
(
    user_id    UUID NOT NULL, -- users.id
    role_id    UUID NOT NULL, -- roles.id
    scope_type TEXT NOT NULL CHECK (scope_type IN ('global', 'group')),
    scope_id   UUID,          -- NULL if global; group id if scope=group (no FK)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id, scope_type, scope_id)
);
CREATE OR REPLACE TRIGGER trg_user_roles_updated_at
    BEFORE UPDATE
    ON user_roles
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- =========================
-- 3) groups & membership (no FKs)
-- =========================
CREATE TABLE IF NOT EXISTS groups
(
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name       TEXT NOT NULL,
    owner_id   UUID NOT NULL, -- users.id
    created_at TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);
CREATE OR REPLACE TRIGGER trg_groups_updated_at
    BEFORE UPDATE
    ON groups
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TABLE IF NOT EXISTS group_members
(
    group_id   UUID NOT NULL, -- groups.id
    user_id    UUID NOT NULL, -- users.id
    joined_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (group_id, user_id)
);
CREATE OR REPLACE TRIGGER trg_group_members_updated_at
    BEFORE UPDATE
    ON group_members
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- =========================
-- 4) accounts & credit cycle (no FKs)
-- =========================
CREATE TABLE IF NOT EXISTS accounts
(
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL, -- users.id
    type        TEXT NOT NULL CHECK (type IN ('credit', 'debit', 'e_wallet')),
    name        TEXT NOT NULL,
    issuer      TEXT,
    note        TEXT,
    is_archived BOOLEAN          DEFAULT FALSE,
    deleted_at  TIMESTAMP,
    created_at  TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP        DEFAULT CURRENT_TIMESTAMP
);
CREATE OR REPLACE TRIGGER trg_accounts_updated_at
    BEFORE UPDATE
    ON accounts
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_accounts_user ON accounts (user_id);
CREATE INDEX IF NOT EXISTS idx_accounts_user_type ON accounts (user_id, type);
CREATE INDEX IF NOT EXISTS idx_accounts_archived ON accounts (is_archived);

CREATE TABLE IF NOT EXISTS account_credit_cycle
(
    account_id  UUID PRIMARY KEY, -- accounts.id
    closing_day INT NOT NULL CHECK (closing_day BETWEEN 1 AND 28),
    payment_day INT NOT NULL CHECK (payment_day BETWEEN 1 AND 28),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE OR REPLACE TRIGGER trg_account_credit_cycle_updated_at
    BEFORE UPDATE
    ON account_credit_cycle
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- =========================
-- 5) categories (no FKs)
-- =========================
CREATE TABLE IF NOT EXISTS categories
(
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id    UUID NOT NULL, -- users.id
    name       TEXT NOT NULL,
    kind       TEXT NOT NULL CHECK (kind IN ('expense', 'income')),
    parent_id  UUID,          -- categories.id
    created_at TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);
CREATE OR REPLACE TRIGGER trg_categories_updated_at
    BEFORE UPDATE
    ON categories
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE UNIQUE INDEX IF NOT EXISTS uq_categories_user_name_kind_parent
    ON categories (user_id, name, kind, COALESCE(parent_id, '00000000-0000-0000-0000-000000000000'::uuid));

-- =========================
-- 6) transactions (no FKs)
-- =========================
CREATE TABLE IF NOT EXISTS transactions
(
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID           NOT NULL, -- users.id
    account_id        UUID           NOT NULL, -- accounts.id
    type              TEXT           NOT NULL CHECK (type IN ('expense', 'income', 'transfer')),
    amount            NUMERIC(18, 2) NOT NULL CHECK (amount > 0),
    category_id       UUID,                    -- categories.id
    occurred_at       TIMESTAMP      NOT NULL,
    note              TEXT,
    attachment_url    TEXT,
    recurrence_id     UUID,                    -- future: recurrences.id
    client_request_id TEXT UNIQUE,
    created_at        TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    deleted_at        TIMESTAMP
);
CREATE OR REPLACE TRIGGER trg_transactions_updated_at
    BEFORE UPDATE
    ON transactions
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_txn_user_time ON transactions (user_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_txn_account_time ON transactions (account_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_txn_user_type_time ON transactions (user_id, type, occurred_at);
CREATE INDEX IF NOT EXISTS idx_txn_category ON transactions (category_id);

-- =========================
-- 7) budgets (no FKs)
-- =========================
CREATE TABLE IF NOT EXISTS budgets
(
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID           NOT NULL, -- users.id
    month        DATE           NOT NULL,
    category_id  UUID           NOT NULL, -- categories.id
    amount_limit NUMERIC(18, 2) NOT NULL,
    created_at   TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP        DEFAULT CURRENT_TIMESTAMP
);
CREATE OR REPLACE TRIGGER trg_budgets_updated_at
    BEFORE UPDATE
    ON budgets
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE UNIQUE INDEX IF NOT EXISTS uq_budgets_user_month_category
    ON budgets (user_id, month, category_id);

-- =========================
-- 8) loans & schedules (no FKs)
-- =========================
CREATE TABLE IF NOT EXISTS loans
(
    id                UUID PRIMARY KEY        DEFAULT gen_random_uuid(),
    user_id           UUID           NOT NULL, -- users.id
    type              TEXT           NOT NULL CHECK (type IN ('loan', 'installment', 'debt')),
    principal         NUMERIC(18, 2) NOT NULL,
    interest_rate     NUMERIC(7, 4),
    term_months       INT,
    start_date        DATE           NOT NULL,
    schedule_method   TEXT           NOT NULL CHECK (schedule_method IN ('declining_balance', 'fixed_payment', 'manual')),
    remaining_balance NUMERIC(18, 2) NOT NULL DEFAULT 0,
    note              TEXT,
    created_at        TIMESTAMP               DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP               DEFAULT CURRENT_TIMESTAMP,
    deleted_at        TIMESTAMP
);
CREATE OR REPLACE TRIGGER trg_loans_updated_at
    BEFORE UPDATE
    ON loans
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_loans_user ON loans (user_id);

CREATE TABLE IF NOT EXISTS loan_schedules
(
    id            UUID PRIMARY KEY        DEFAULT gen_random_uuid(),
    loan_id       UUID           NOT NULL, -- loans.id
    due_date      DATE           NOT NULL,
    principal_due NUMERIC(18, 2) NOT NULL,
    interest_due  NUMERIC(18, 2) NOT NULL,
    fee_due       NUMERIC(18, 2) NOT NULL DEFAULT 0,
    paid_amount   NUMERIC(18, 2) NOT NULL DEFAULT 0,
    paid_at       TIMESTAMP,
    status        TEXT           NOT NULL CHECK (status IN ('due', 'partial', 'paid', 'late')),
    created_at    TIMESTAMP               DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP               DEFAULT CURRENT_TIMESTAMP
);
CREATE OR REPLACE TRIGGER trg_loan_schedules_updated_at
    BEFORE UPDATE
    ON loan_schedules
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_loan_schedules_due ON loan_schedules (loan_id, due_date);

-- =========================
-- 9) shares (no FKs)
-- =========================
CREATE TABLE IF NOT EXISTS shares
(
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id      UUID NOT NULL, -- groups.id
    owner_user_id UUID NOT NULL, -- users.id
    scope_type    TEXT NOT NULL CHECK (scope_type IN ('account', 'category', 'summary')),
    scope_ids     UUID[],        -- null if summary
    permission    TEXT NOT NULL CHECK (permission IN ('view', 'edit')),
    created_at    TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP        DEFAULT CURRENT_TIMESTAMP
);
CREATE OR REPLACE TRIGGER trg_shares_updated_at
    BEFORE UPDATE
    ON shares
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_shares_group ON shares (group_id);

-- =========================
-- 10) audit_logs (no FKs)
-- =========================
CREATE TABLE IF NOT EXISTS audit_logs
(
    id         BIGSERIAL PRIMARY KEY,
    user_id    UUID,
    action     TEXT NOT NULL, -- e.g. 'transaction.create'
    entity     TEXT NOT NULL, -- e.g. 'transactions'
    entity_id  UUID,
    metadata   JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE OR REPLACE TRIGGER trg_audit_logs_updated_at
    BEFORE UPDATE
    ON audit_logs
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();