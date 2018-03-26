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
(         0
        , 'No particular cohort'
        , null
        , 0
        , null
        , 0
        , now()
)
,
(         1
        , 'angus severe'
        , 'jerome description'
        , 0
        , ''
   --     , 'visit_occurrence'
        , 8
        , now()
)
,
(         2
        , 'angus shock'
        , 'jerome description'
        , 0
        , ''
     --   , 'visit_occurrence'
        , 8
        , now()
)
,
(         3
        , 'accp severe'
        , 'jerome description'
        , 0
        , ''
        --, 'visit_occurrence'
        , 8
        , now()
)
,
(         4
        , 'accp shock'
        , 'jerome description'
        , 0
        , ''
    --    , 'visit_occurrence'
        , 8
        , now()
)
,
(         5
        , 'sepsis3 severe'
        , 'jerome description'
        , 0
        , ''
     --   , 'visit_occurrence'
        , 8
        , now()
)
,
(         6
        , 'sepsis3 shock'
        , 'jerome description'
        , 0
        , ''
     --   , 'visit_occurrence'
        , 8
        , now()
);
