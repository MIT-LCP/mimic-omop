-- This inserts emergency information as real stay
-- this is related to #16
-- apparently, when emergency, urgent, and all kind of admissions having a edregtime should be considered as a emergency
-- the datetime can be sometimes contain error or gaps 
-- this is due to different systems
DELETE FROM transfers WHERE row_id < 0;
INSERT INTO transfers (row_id, hadm_id, subject_id, curr_careunit, intime, outtime)
SELECT
DISTINCT ON (hadm_id)
     -1 * admissions.row_id -- demoniac trick to moove forward
     , admissions.hadm_id
     , admissions.subject_id
     , 'EMERGENCY' as curr_careunit
     , edregtime as intime
     , min(intime) OVER(PARTITION BY hadm_id) as dischtime 
-- the end of the emergency is considered the begin of the the admission 
-- the admittime is sometime after the first transfer
 FROM admissions
 LEFT JOIN transfers USING (hadm_id)
 WHERE edregtime IS NOT NULL; 
