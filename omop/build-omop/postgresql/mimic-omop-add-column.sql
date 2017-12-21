--ALTER TABLE omop.death ADD COLUMN visit_detail_id BIGINT;
COMMENT ON COLUMN omop.death.visit_detail_id             IS 'A foreign key to the visit in the VISIT_DETAIL table during where the death occured';

