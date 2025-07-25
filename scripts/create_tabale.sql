-- Bảng người dùng
CREATE TABLE users
(
    id            SERIAL PRIMARY KEY,
    username      VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT               NOT NULL,
    full_name     VARCHAR(100),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Bảng tín dụng (credit card)
CREATE TABLE credits
(
    id            SERIAL PRIMARY KEY,
    user_id       INT REFERENCES users (id) ON DELETE CASCADE,
    source        VARCHAR(100)   NOT NULL,
    limit_amount  DECIMAL(12, 2) NOT NULL,
    used_amount   DECIMAL(12, 2) DEFAULT 0,
    due_date      DATE,
    interest_rate DECIMAL(5, 2),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng giao dịch chi tiêu / thu nhập
CREATE TABLE transactions
(
    id          SERIAL PRIMARY KEY,
    user_id     INT REFERENCES users (id) ON DELETE CASCADE,
    amount      DECIMAL(12, 2)                                    NOT NULL,
    category    VARCHAR(100),
    type        VARCHAR(10) CHECK (type IN ('income', 'expense')) NOT NULL,
    description TEXT,
    date        DATE                                              NOT NULL,
    is_credit   BOOLEAN   DEFAULT FALSE,
    credit_id   INT REFERENCES credits (id),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (
        -- Nếu là giao dịch tín dụng thì phải có credit_id
        (is_credit = TRUE AND credit_id IS NOT NULL)
            OR
        (is_credit = FALSE)
        )
);

-- Bảng trả góp
CREATE TABLE installments
(
    id             SERIAL PRIMARY KEY,
    user_id        INT REFERENCES users (id) ON DELETE CASCADE,
    name           VARCHAR(100)   NOT NULL,
    total_amount   DECIMAL(12, 2) NOT NULL,
    monthly_amount DECIMAL(12, 2) NOT NULL,
    start_date     DATE           NOT NULL,
    months         INT            NOT NULL,
    is_completed   BOOLEAN DEFAULT FALSE,
    credit_id      INT REFERENCES credits (id), -- nullable nếu không dùng thẻ tín dụng
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng nợ
CREATE TABLE debts
(
    id       SERIAL PRIMARY KEY,
    user_id  INT REFERENCES users (id) ON DELETE CASCADE,
    person   VARCHAR(100)                                     NOT NULL,
    amount   DECIMAL(12, 2)                                   NOT NULL,
    type     VARCHAR(10) CHECK (type IN ('lent', 'borrowed')) NOT NULL,
    due_date DATE,
    is_paid  BOOLEAN DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
