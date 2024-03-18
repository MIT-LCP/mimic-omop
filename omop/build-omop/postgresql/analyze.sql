/*********************************************************************************
# Copyright 2014 Observational Health Data Sciences and Informatics
#
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,

# See the License for the specific language governing permissions and
# limitations under the License.
********************************************************************************/

/************************

 ####### #     # ####### ######      #####  ######  #     #           #######      #####     ###                                           
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #           #     #     #  #    # #####  ###### #    # ######  ####  
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #                 #     #  ##   # #    # #       #  #  #      #      
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######       #####      #  # #  # #    # #####    ##   #####   ####  
 #     # #     # #     # #          #       #     # #     #    #    #       # ### #           #  #  # # #    # #        ##   #           # 
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ### #           #  #   ## #    # #       #  #  #      #    # 
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ### #######    ### #    # #####  ###### #    # ######  ####  
                                                                              

script to create the required indexes within OMOP common data model, version 5.2 for PostgreSQL database

last revised: 14 July 2017

author:  Patrick Ryan

description:  These indices are considered a minimal requirement to ensure adequate performance of analyses.

*************************/


/************************

Standardized vocabulary

************************/

analyze :OMOP_SCHEMA.concept;
analyze :OMOP_SCHEMA.vocabulary;
analyze :OMOP_SCHEMA.domain;
analyze :OMOP_SCHEMA.concept_class;
analyze :OMOP_SCHEMA.concept_relationship;
analyze :OMOP_SCHEMA.relationship;
analyze :OMOP_SCHEMA.concept_synonym;
analyze :OMOP_SCHEMA.concept_ancestor;
analyze :OMOP_SCHEMA.source_to_concept_map;
analyze :OMOP_SCHEMA.drug_strength;
analyze :OMOP_SCHEMA.cohort_definition;
analyze :OMOP_SCHEMA.attribute_definition;