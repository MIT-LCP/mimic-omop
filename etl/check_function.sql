
-- -----------------------------------------------------------------------------
-- File created - January-8-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;
SELECT plan ( 11 );

SELECT ok(
	looks_like_value('1')
	AND looks_like_value('.1209')
	AND looks_like_value(',192 ')
	AND looks_like_value('1.')
	AND looks_like_value('1,0')
      , 'simple value'
);

SELECT ok(
	looks_like_value('+1')
      , 'simple value'
);
SELECT ok(
	looks_like_value('-.1209')
      , 'simple value'
);
SELECT ok(
	looks_like_value('+ ,192')
      , 'simple value'
);
SELECT ok(
	looks_like_value(' +1,0')
      , 'simple value'
);
SELECT ok(
	looks_like_value(' > +1,0 ')
      , 'simple value'
);

SELECT ok(
	looks_like_value('=+1,0')
      , 'simple value operator and sign'
);
SELECT ok(
	looks_like_value('LESS THAN+1,0')
      , 'simple value operator and sign'
);
SELECT ok(
	looks_like_value('=+1,0meters')
      , 'simple value operator and sign and unit'
);
SELECT ok(
	looks_like_value('1m')
      , 'simple value operator and sign and unit'
);

SELECT ok(
	looks_like_value('1,000')
      , 'number with commas as thousandths separator, no period'
);
SELECT ok(
	looks_like_value('1,000.5')
      , 'number with commas as thousandths separator, period as decimal separator'
);
SELECT ok(
	looks_like_value('1,000,000,000')
      , 'number with commas as thousandths separator, multiple commas'
);
SELECT ok(
	looks_like_value('1.000')
      , 'number with period as thousandths separator, no comma'
);
SELECT ok(
	looks_like_value('1.000,5')
      , 'number with period as thousandths separator, comma as decimal separator'
);
SELECT ok(
	looks_like_value('1.000.000.000')
      , 'number with period as thousandths separator, multiple period'
);

-- tests which should not match
SELECT ok(
        NOT looks_like_value('a') AND NOT looks_like_value('a1')
      , 'should not match '
);

SELECT * FROM finish();
ROLLBACK;
