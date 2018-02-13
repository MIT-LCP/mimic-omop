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

-- test whether the string looks like a value
DROP FUNCTION IF EXISTS looks_like_value(text);
CREATE FUNCTION looks_like_value(value_text text) RETURNS boolean AS
$BODY$
DECLARE
operator text;
signe    text;
value    text;
unit     text;
pattern  text;
BEGIN
	operator := '(=|>=|=>|<=|>|<){0,1} ?';
	signe    := '[+-]{0,1} ?';
	value    := '([.,]{1}[0-9]+|[0-9]+([,.][0-9]+)*[,.]{0,1}[0-9]*) ?';
	unit     := '(ml\/hr|ml\/h|cc\/h|cc\/hr|\/h|mg\/h|mg\/hr|g\/h|g\/hr|mcg\/h|mcg\/hr|U\/hr|U\/h|lpm|g|gram|grams|gm|gms|grm|mg|meq|mcg|kg|liter|l|ppm|s|sec|min|min\.|minutes|minute|mins|hour|hr|hrs|in|inch|cm|mm|m|meters|ml|mmHg|cs|wks|weeks|week|French|fr|gauge|degrees|%|cc){0,1}';
	pattern  := '^' || operator || signe || value || unit || '$';

    value_text := trim(regexp_replace(regexp_replace(value_text, 'LE[SE]S TH[AE]N', '<'), 'GRE[EA]TER TH[AE]N', '>'));

    IF trim(value_text) ~* pattern THEN
        RETURN true;
    END IF;

    RETURN false;
 END
$BODY$
LANGUAGE plpgsql;

-- extract operator
-- when looks like a value
-- if no operator, then assume this is equals (=)
DROP FUNCTION IF EXISTS extract_operator(text);
CREATE FUNCTION extract_operator(value_text text) RETURNS text AS
$BODY$
DECLARE
operator text;
signe    text;
value    text;
unit     text;
pattern  text;
BEGIN
    value_text := trim(regexp_replace(regexp_replace(value_text, 'LE[SE]S TH[AE]N', '<'), 'GRE[EA]TER TH[AE]N', '>'));
    IF looks_like_value(value_text) THEN
        RETURN coalesce(substring(replace(value_text, '=>', '>=') from '^(<=|>=|<|>)'), '=');
    END IF;

    RETURN null::text ;
 END
$BODY$
LANGUAGE plpgsql;

-- extract unit
-- when looks like a value
DROP FUNCTION IF EXISTS extract_unit(text);
CREATE FUNCTION extract_unit(value_text text) RETURNS text AS
$BODY$
DECLARE
operator text;
signe    text;
value    text;
unit     text;
pattern  text;
BEGIN
    IF looks_like_value(value_text) THEN
	RETURN substring(value_text from '(ml\/hr|ml\/h|cc\/h|cc\/hr|\/h|mg\/h|mg\/hr|g\/h|g\/hr|mcg\/h|mcg\/hr|U\/hr|U\/h|lpm|g|gram|grams|gm|gms|grm|mg|meq|mcg|kg|liter|l|ppm|s|sec|min|min\.|minutes|minute|mins|hour|hr|hrs|in|inch|cm|mm|m|meters|ml|mmHg|cs|wks|weeks|week|French|fr|gauge|degrees|%|cc){0,1}$');
    END IF;

    RETURN null::text ;
 END
$BODY$
LANGUAGE plpgsql;

-- extract value
-- when looks like a value
-- **assumes European style numbers:
--    period is thousandths separator
--    comma is decimal separator
DROP FUNCTION IF EXISTS extract_value_comma_decimal(text);
CREATE FUNCTION extract_value_comma_decimal(value_text text) RETURNS double precision AS
$BODY$
BEGIN
    IF looks_like_value(value_text) THEN
        RETURN replace(substring( replace(replace(value_text,'.',''),' ','') from '[+-]{0,1}[0-9]*[,.]{0,1}[0-9]+'), ',', '.')::double precision;
    END IF;

    RETURN null::double precision;
 END
$BODY$
LANGUAGE plpgsql;

-- extract value - assumes a decimal is used as the separator
-- when looks like a value
-- **assumes non-European style numbers:
--    comma is thousandths separator
--    period is decimal separator
DROP FUNCTION IF EXISTS extract_value_period_decimal(text);
CREATE FUNCTION extract_value_period_decimal(value_text text) RETURNS double precision AS
$BODY$
BEGIN
    IF looks_like_value(value_text) THEN
        RETURN substring( replace(replace(value_text,',',''),' ','') from '[+-]{0,1}[0-9]*[.]{0,1}[0-9]+')::double precision;
    END IF;

    RETURN null::double precision;
 END
$BODY$
LANGUAGE plpgsql;

-- format wards
DROP FUNCTION IF EXISTS format_ward(text, integer);
CREATE FUNCTION format_ward(ward text, wardid integer) RETURNS text AS
$BODY$
BEGIN

    RETURN coalesce(ward,'UNKNOWN') || ' ward #' || coalesce(wardid::text, '?');
 END
$BODY$
LANGUAGE plpgsql;
