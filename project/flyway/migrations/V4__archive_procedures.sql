CREATE SCHEMA IF NOT EXISTS archive;

CREATE TABLE IF NOT EXISTS archive.purchase (
    LIKE business.purchase INCLUDING CONSTRAINTS INCLUDING INDEXES
);

CREATE TABLE IF NOT EXISTS archive.purchase_item (
    LIKE business.purchase_item INCLUDING CONSTRAINTS INCLUDING INDEXES
);

CREATE OR REPLACE FUNCTION business.transliterate(input_text TEXT) RETURNS TEXT AS $$
DECLARE
    output_text TEXT := '';
    char TEXT;
BEGIN
    FOR char IN
        SELECT unnest(string_to_array(input_text, NULL)) -- изменено на NULL
    LOOP
        output_text := output_text ||
            CASE char
                WHEN 'А' THEN 'A' WHEN 'Б' THEN 'B' WHEN 'В' THEN 'V' WHEN 'Г' THEN 'G' WHEN 'Д' THEN 'D'
                WHEN 'Е' THEN 'E' WHEN 'Ё' THEN 'E' WHEN 'Ж' THEN 'ZH' WHEN 'З' THEN 'Z' WHEN 'И' THEN 'I'
                WHEN 'Й' THEN 'Y' WHEN 'К' THEN 'K' WHEN 'Л' THEN 'L' WHEN 'М' THEN 'M' WHEN 'Н' THEN 'N'
                WHEN 'О' THEN 'O' WHEN 'П' THEN 'P' WHEN 'Р' THEN 'R' WHEN 'С' THEN 'S' WHEN 'Т' THEN 'T'
                WHEN 'У' THEN 'U' WHEN 'Ф' THEN 'F' WHEN 'Х' THEN 'KH' WHEN 'Ц' THEN 'TS' WHEN 'Ч' THEN 'CH'
                WHEN 'Ш' THEN 'SH' WHEN 'Щ' THEN 'SCH' WHEN 'Ъ' THEN '' WHEN 'Ы' THEN 'Y' WHEN 'Ь' THEN ''
                WHEN 'Э' THEN 'E' WHEN 'Ю' THEN 'YU' WHEN 'Я' THEN 'YA'
                WHEN 'а' THEN 'a' WHEN 'б' THEN 'b' WHEN 'в' THEN 'v' WHEN 'г' THEN 'g' WHEN 'д' THEN 'd'
                WHEN 'е' THEN 'e' WHEN 'ё' THEN 'e' WHEN 'ж' THEN 'zh' WHEN 'з' THEN 'z' WHEN 'и' THEN 'i'
                WHEN 'й' THEN 'y' WHEN 'к' THEN 'k' WHEN 'л' THEN 'l' WHEN 'м' THEN 'm' WHEN 'н' THEN 'n'
                WHEN 'о' THEN 'o' WHEN 'п' THEN 'p' WHEN 'р' THEN 'r' WHEN 'с' THEN 's' WHEN 'т' THEN 't'
                WHEN 'у' THEN 'u' WHEN 'ф' THEN 'f' WHEN 'х' THEN 'kh' WHEN 'ц' THEN 'ts' WHEN 'ч' THEN 'ch'
                WHEN 'ш' THEN 'sh' WHEN 'щ' THEN 'sch' WHEN 'ъ' THEN '' WHEN 'ы' THEN 'y' WHEN 'ь' THEN ''
                WHEN 'э' THEN 'e' WHEN 'ю' THEN 'yu' WHEN 'я' THEN 'ya'
                ELSE char
            END;
    END LOOP;
    RETURN output_text;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE PROCEDURE business.archive_old_purchases()
LANGUAGE plpgsql
AS $$
DECLARE
    batch_size INT := 1000;
    rows_moved INT;
BEGIN
    CREATE TEMP TABLE temp_purchase_batch (id INT) ON COMMIT DROP;

    LOOP
        -- Очищаем временную таблицу перед использованием
        TRUNCATE TABLE temp_purchase_batch;

        -- Выбираем ID покупок для архивации и сохраняем их во временную таблицу
        INSERT INTO temp_purchase_batch (id)
        SELECT id FROM business.purchase
        WHERE purchase_date < NOW() - INTERVAL '14 days'
        LIMIT batch_size
        FOR UPDATE SKIP LOCKED;

        -- Если нет данных для переноса, выходим из цикла
        IF NOT FOUND THEN
            EXIT;
        END IF;

        -- Сначала архивируем связанные purchase_item
        INSERT INTO archive.purchase_item
        SELECT pi.* FROM business.purchase_item pi
        JOIN temp_purchase_batch pb ON pi.purchase_id = pb.id;

        -- Теперь архивируем purchase
        INSERT INTO archive.purchase
        SELECT * FROM business.purchase
        WHERE id IN (SELECT id FROM temp_purchase_batch)
        RETURNING 1 INTO rows_moved;

        -- Если ничего не перенеслось — выходим из цикла
        EXIT WHEN rows_moved IS NULL;

        -- Теперь можно удалять данные из business.purchase_item
        DELETE FROM business.purchase_item WHERE purchase_id IN (SELECT id FROM temp_purchase_batch);

        -- Теперь можно удалять из business.purchase
        DELETE FROM business.purchase WHERE id IN (SELECT id FROM temp_purchase_batch);

        -- Делаем небольшую паузу для снижения нагрузки
        PERFORM pg_sleep(0.1);
    END LOOP;
END;
$$;

SELECT cron.schedule('0 4 * * *', $$CALL business.archive_old_purchases();$$);
