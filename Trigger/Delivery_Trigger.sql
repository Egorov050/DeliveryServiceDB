CREATE TRIGGER delivery_time_trigger
AFTER UPDATE OF delivery_end ON delivery
FOR EACH ROW
WHEN (NEW.delivery_time IS NOT NULL)
EXECUTE FUNCTION update_courier_delivery_time();
