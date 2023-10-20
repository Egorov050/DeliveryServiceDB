
CREATE OR REPLACE FUNCTION take_order(i_delivery_id INT, i_courier_id INT) RETURNS VOID AS $$
BEGIN 
    IF EXISTS (SELECT delivery_id FROM delivery WHERE delivery_id = i_delivery_id) THEN 
        INSERT INTO delivery (delivery_id, courier_id) VALUES (i_delivery_id, i_courier_id)
        ON CONFLICT (delivery_id) DO UPDATE SET courier_id = EXCLUDED.courier_id;
    ELSE 
        RAISE EXCEPTION 'Invalid id provided';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION start_delivery (i_delivery_id INT, i_courier_id INT) RETURNS VOID AS $$
BEGIN 
    IF EXISTS (SELECT delivery_id FROM delivery WHERE delivery_id = i_delivery_id) THEN 
        INSERT INTO delivery (delivery_id, courier_id, delivery_start) VALUES (i_delivery_id, i_courier_id, NOW())
       	ON CONFLICT (delivery_id) DO UPDATE SET courier_id = EXCLUDED.courier_id, delivery_start = now();
    ELSE 
        RAISE EXCEPTION 'Invalid id provided';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION end_delivery (i_delivery_id INT, i_courier_id INT) RETURNS VOID AS $$
DECLARE
timedelivery INT;
start_delivery timestamp;
end_delivery timestamp;
BEGIN
SELECT delivery_start INTO start_delivery FROM delivery WHERE delivery_id = i_delivery_id;
end_delivery := NOW();
timedelivery := extract(epoch from (end_delivery - start_delivery)/60);
IF EXISTS (SELECT delivery_id FROM delivery WHERE delivery_id = i_delivery_id) THEN
INSERT INTO delivery (delivery_id, courier_id, delivery_end)
VALUES (i_delivery_id, i_courier_id, end_delivery)
ON CONFLICT (delivery_id) DO UPDATE SET courier_id = EXCLUDED.courier_id, delivery_end = EXCLUDED.delivery_end, delivery_time =timedelivery;
ELSE
RAISE EXCEPTION 'Invalid id provided';
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_delivery_time(i_courier_id INT) RETURNS VOID AS $$
DECLARE
    timedelivery BIGINT;
BEGIN
    SELECT EXTRACT(EPOCH FROM (SUM(delivery_end - delivery_start))) / 60 INTO timedelivery
    FROM delivery
    WHERE courier_id = i_courier_id;

    UPDATE courier SET courier_num_of_orders = timedelivery * 5 WHERE courier_id = i_courier_id;
    IF NOT EXISTS (SELECT * FROM delivery WHERE courier_id = i_courier_id) OR
        (SELECT COUNT(*) FROM courier WHERE courier_num_of_orders > 0) = 0 THEN
        RAISE EXCEPTION 'Invalid id provided';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_courier_delivery_time() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.delivery_time IS NOT NULL THEN
        PERFORM update_delivery_time(NEW.courier_id);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
