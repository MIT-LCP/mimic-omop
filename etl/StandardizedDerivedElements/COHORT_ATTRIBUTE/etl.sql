DELETE FROM omop.cohort_definition;
INSERT INTO omop.cohort_definition
(
  cohort_definition_id
, cohort_definition_name
, cohort_definition_description
, definition_type_concept_id
, cohort_definition_syntax
, subject_concept_id
, cohort_initiation_date
 )
VALUES
(         1
        , 'angus severe'
        , 'jerome description'
        , 0
        , ''
   --     , 'visit_occurrence'
        , 0
        , now()
)
,
(         2
        , 'angus shock'
        , 'jerome description'
        , 0
        , ''
     --   , 'visit_occurrence'
        , 0
        , now()
)
,
(         3
        , 'accp simple'
        , 'jerome description'
        , 0
        , ''
       -- , 'visit_occurrence'
        , 0
        , now()
)
,
(         4
        , 'accp severe'
        , 'jerome description'
        , 0
        , ''
        --, 'visit_occurrence'
        , 0
        , now()
)
,
(         5
        , 'accp shock'
        , 'jerome description'
        , 0
        , ''
    --    , 'visit_occurrence'
        , 0
        , now()
)
,
(         6
        , 'sepsis3 severe'
        , 'jerome description'
        , 0
        , ''
     --   , 'visit_occurrence'
        , 0
        , now()
)
,
(         7
        , 'sepsis3 shock'
        , 'jerome description'
        , 0
        , ''
     --   , 'visit_occurrence'
        , 0
        , now()
)
