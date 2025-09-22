-- 1. Таблица КЛИЕНТЫ
CREATE TABLE IF NOT EXISTS Клиенты (
    id_клиента SERIAL PRIMARY KEY,
    Фамилия VARCHAR(50) NOT NULL,
    Имя VARCHAR(50) NOT NULL,
    Отчество VARCHAR(50),
    Серия_паспорта VARCHAR(4) NOT NULL,
    Номер_паспорта VARCHAR(6) NOT NULL,
    CONSTRAINT уникальный_паспорт UNIQUE (Серия_паспорта, Номер_паспорта)
);

-- 2. Таблица АВТОМОБИЛИ
CREATE TABLE IF NOT EXISTS Автомобили (
    id_автомобиля SERIAL PRIMARY KEY,
    Модель VARCHAR(100) NOT NULL,
    Цвет VARCHAR(30) NOT NULL,
    Год_выпуска INT NOT NULL CHECK (Год_выпуска > 1900 AND Год_выпуска <= EXTRACT(YEAR FROM CURRENT_DATE)),
    Госномер VARCHAR(15) NOT NULL UNIQUE,
    Стоимость_проката_в_день MONEY NOT NULL CHECK (Стоимость_проката_в_день > 0::MONEY)
);


-- 3. Таблица СТРАХОВЫЕ_ПОЛИСЫ
CREATE TABLE IF NOT EXISTS Страховые_полисы (
    id_полиса SERIAL PRIMARY KEY,
    id_автомобиля INT NOT NULL REFERENCES Автомобили (id_автомобиля) ON DELETE CASCADE,
    Страховая_стоимость MONEY NOT NULL CHECK (Страховая_стоимость > 0::MONEY),
    Дата_начала_действия DATE NOT NULL,
    Дата_окончания_действия DATE NOT NULL,
    CONSTRAINT корректные_даты CHECK (Дата_начала_действия < Дата_окончания_действия)
);


-- 4. Таблица ПРОКАТЫ
CREATE TABLE IF NOT EXISTS Прокаты (
    id_проката SERIAL PRIMARY KEY,
    id_клиента INT NOT NULL REFERENCES Клиенты (id_клиента) ON DELETE CASCADE,
    id_автомобиля INT NOT NULL REFERENCES Автомобили (id_автомобиля) ON DELETE CASCADE,
    Дата_начала DATE NOT NULL,
    Количество_дней INT NOT NULL CHECK (Количество_дней > 0),
    Общая_стоимость MONEY NOT NULL CHECK (Общая_стоимость > 0::MONEY)
);

-- Создание индексов для улучшения производительности
CREATE INDEX IF NOT EXISTS idx_клиенты_паспорт ON Клиенты(Серия_паспорта, Номер_паспорта);
CREATE INDEX IF NOT EXISTS idx_автомобили_госномер ON Автомобили(Госномер);
CREATE INDEX IF NOT EXISTS idx_прокаты_даты ON Прокаты(Дата_начала);
CREATE INDEX IF NOT EXISTS idx_страховки_даты ON Страховые_полисы(Дата_начала_действия, Дата_окончания_действия);