-- GENERAL
-- transforms a datetime to null 
-- in case it does not contain any time (say 00:00:00)
drop function if exists to_datetime(timestamp without time zone);
create function to_datetime(datetime timestamp without time zone) returns timestamp without time zone as
$body$
begin
    if (datetime::date)::timestamp without time zone = datetime then
        return null::timestamp without time zone;
    end if;

    return datetime;
 end
$body$
language plpgsql;

-- CHARTEVENTS (minus labs)
-- calcul the mean from systole/diastole
DROP FUNCTION IF EXISTS map_bp_calc(text);
CREATE FUNCTION map_bp_calc(value text) RETURNS double precision AS
$BODY$
DECLARE
sp integer;
dp integer;
map double precision;
BEGIN
    sp := regexp_replace(value,'([0-9]+)/[0-9]+',E'\\1','g')::double precision;
    dp := regexp_replace(value,'[0-9]+/([0-9]+)',E'\\1','g')::double precision;
    map := dp + sp / 3 - dp/3;
    IF map IS NULL THEN
        RETURN null::double precision;
    END IF;

    RETURN map;
 END
$BODY$
LANGUAGE plpgsql;
