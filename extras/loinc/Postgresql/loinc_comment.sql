1. LOINC_NUM,Text,10 The unique LOINC Code is a string in the format of nnnnnnnn-n.
2. COMPONENT,Text,255 First major axis-component or analyte
3. PROPERTY,Text,"30 Second major axis-property observed (e.g., mass vs. substance)"
"Third major axis-timing of the measurement (e.g., point in time vs 24 4. TIME_ASPCT",Text,15
"",,hours)
5. SYSTEM,Text,"100 Fourth major axis-type of specimen or system (e.g., serum vs urine)"
"Fifth major axis-scale of measurement (e.g., qualitative vs. 6. SCALE_TYP",Text,30
"",,quantitative)
7. METHOD_TYP,Text,50 Sixth major axis-method of measurement
"",,An arbitrary classification of the terms for grouping related
"",,observations together.
"",,The current classifications are listed in Table 32. We present the
"",,database sorted by the class field within class type (see field 23).
"",,Users of the database should feel free to re-sort the database in any
8. CLASS,Text,20
"",,"way they find useful, and/or to add their own classifying fields to the"
"",,database.
"",,
"",,The content of the laboratory test subclasses should be obvious from
"",,the subclass name.
"",,The LOINC version number in which the record has last changed. For
9. VersionLastChanged,Text,"10 records that have never been updated after their release, this field will"
"",,contain the same value as the loinc.VersionFirstReleased field.
"",,Change Type Code
"",,
"",,DEL = delete (deprecate)
"",,
"",,ADD = add
"",,
10. CHNG_TYPE,Text,3 NAM = change to Analyte/Component (field #2);
"",,
"",,MAJ = change to name field other than #2 (#3 - #7);
"",,
"",,MIN = change to field other than name
"",,
"",,UND = undelete
"",,Narrative text that describes the LOINC term taken as a whole
"(i.e., taking all of the parts of the term together) or relays information 11. DefinitionDescription",Memo,-
"",,"specific to the term, such as the context in which the term was"
"",,requested or its clinical utility.
"",,,ACTIVE = Concept is active. Use at will.
"",,,
"",,,TRIAL = Concept is experimental in nature. Use with caution as the
"",,,concept and associated attributes may change.
"",,,
"",,,DISCOURAGED = Concept is not recommended for current use. New
"",,,mappings to this concept are discouraged;
"",,,although existing may mappings may continue to be valid in context.
12. STATUS,Text,11,"Wherever possible, the superseding concept is indicated in the MAP_"
"",,,TO field in the MAP_TO table
"",,,(see Table 31b) and should be used instead.
"",,,
"",,,"DEPRECATED = Concept is deprecated. Concept should not be used,"
"",,,"but it is retained in LOINC for historical purposes. Wherever possible,"
"",,,the superseding concept is
"",,,indicated in the MAP_TO field (see Table 31b) and should be used both
"",,,for new mappings and updating existing implementations.
"",,,An experimental (beta) consumer friendly name for this item. The
"",,,intent is to provide a test name that health care consumers will
"",,,recognize;
it will be similar to the names that might appear on a lab report and 13. CONSUMER_NAME,Text,255,
"",,,is not guaranteed to be unique because some elements of the LOINC
"",,,name are likely to be omitted.
"",,,"We will continue to modify these names in future release, so do not"
"",,,expect it to be stable (or perfect). Feedback is welcome.
"",,,1=Laboratory class; 2=Clinical class; 3=Claims attachments;
14. CLASSTYPE,Number,-,
"",,,4=Surveys
"",,,"Contains the formula in human readable form, for calculating the value"
"",,,of any measure that is based on an algebraic or other formula except
15. FORMULA,Memo,-,those for which
"",,,the component expresses the formula. So Sodium/creatinine does not
"",,,"need a formula, but Free T3 index does."
"",,,"Codes detailing which non-human species the term applies to. If blank,"
16. SPECIES,Text,20,
"",,,â€œhumanâ€ is assumed.
"For some tests and measurements, we have supplied examples of valid 17. EXMPL_ANSWERS",Memo,-,
"",,,"answers, such as â€œ1:64â€, â€œnegative @ 1:16â€, or â€œ55â€."
18. SURVEY_QUEST_TEXT,Memo,-,Verbatim question from the survey instrument
19. SURVEY_QUEST_SRC,Text,50,Exact name of the survey instrument and the item/question number
Y/N field that indicates that units are required when this LOINC is 20. UNITSREQUIRED,Text,1,
"",,,included as an OBX segment in a HIPAA attachment
21. SUBMITTED_UNITS,Text,30,Units as received from person who requested this LOINC term
"",,,This field was introduced in version 2.05. It contains synonyms for
22. RELATEDNAMES2,Memo,-,"each of the parts of the fully specified LOINC name (component,"
"",,,"property, time, system, scale, method)."
"",,,"Introduced in version 2.07, this field contains the short form of the"
23. SHORTNAME,Text,40,LOINC name and is created via a table-driven algorithmic process.
"",,,The short name often includes abbreviations and acronyms.
"",,,"Defines term as order only, observation only, or both. A fourth"
"",,,"category, Subset, is used for terms that are subsets of a panel but do"
"",,,not represent
a package that is known to be orderable. We have defined them only 24. ORDER_OBS,Text,15,
"",,,to make it easier to maintain panels or other sets within the LOINC
"",,,construct.
"",,,This field reflects our best approximation of the terms intended use; it
"",,,is not to be considered normative or a binding resolution.
"â€œYâ€ in this field means that the term is a part of subset of terms used by 25. CDISC_COMMON_TESTS",Text,1,
"",,,CDISC in clinical trials.
"",,,A value in this field means that the content should be delivered in the
"",,,named field/subfield of the HL7 message.
26. HL7_FIELD_SUBFIELD_ID,Text,50,"When NULL, the data for this data element should be sent in an OBX"
"",,,segment with this LOINC code stored in OBX-3 and with the value in
"",,,the OBX-5.
27. EXTERNAL_COPYRIGHT_,,,
"",Memo,-,External copyright holders copyright notice for this LOINC code
NOTICE,,,
"",,,This field is populated with a combination of submitters units and units
"that people have sent us. Its purpose is to show users representative,  28. EXAMPLE_UNITS",Text,255,
"",,,"but not necessarily recommended, units in which data could be sent"
"",,,for this term.
"",,,This field contains the LOINC name in a more readable format than the
"",,,fully specified name.
The long common names have been created via a table-driven 29. LONG_COMMON_NAME,Text,255,
"",,,algorithmic process.
"",,,Most abbreviations and acronyms that are used in the LOINC database
"",,,have been fully spelled out in English.
"",,,Units of measure (expressed using UCUM units) and normal ranges for
"",,,physical quantities and survey scores.
"",,,Intended as tailorable starter sets for applications that use LOINC
"",,,forms as a way to capture data.
"",,,Units are separated from normal ranges by a colon (:) and sets of
"",,,unit:normal range pairs are separated by a semi-colon (;).
30. UnitsAndRange,Memo,-,
"",,,"Syntax for the normal range includes square brackets, which mean that"
"",,,"the number adjacent to the bracket is included, and parentheses,"
"",,,which means that the number itself is not included.
"",,,"For example, [2,4] means â€œtwo to fourâ€, while [2,4) means â€œtwo to less"
"",,,"than fourâ€ and (2,4) means â€œbetween two and four but does not include"
"",,,two and fourâ€.
"",,,"Classification of whether this LOINC code can be used a full document,"
"",,,"a section of a document, or both."
31. DOCUMENT_SECTION,Text,255,"This field was created in the context of HL7 CDA messaging, and"
"",,,populated in collaboration with the HL7 Structured Documents Work
"",,,Group.
"",,,The Unified Code for Units of Measure (UCUM) is a code system
"",,,intended to include all units of measures being contemporarily
"used in international science, engineering, and business. (www.32. EXAMPLE_UCUM_UNITS",Text,255,
"",,,unitsofmeasure.org)
"",,,This field contains example units of measures for this term expressed
"",,,as UCUM units.
"",,,The Unified Code for Units of Measure (UCUM) is a code system
"",,,intended to include all units of measures being contemporarily
"used in international science, engineering, and business. (www.33. EXAMPLE_SI_UCUM_UNITS",Text,255,
"",,,unitsofmeasure.org)
"",,,This field contains example units of measures for this term expressed
"",,,as SI UCUM units.
"",,,Classification of the reason for concept status.
"",,,"This field will be Null for ACTIVE concepts, and optionally populated"
34. STATUS_REASON,Text,9,for terms in other status where the reason is clear.
"",,,DEPRECATED or DISCOURAGED terms may take values of:
"",,,"AMBIGUOUS, DUPLICATE, or ERRONEOUS."
"",,,Explanation of concept status in narrative text.
35. STATUS_TEXT,Memo,-,"This field will be Null for ACTIVE concepts, and optionally populated"
"",,,for terms in other status.
36. CHANGE_REASON_PUBLIC,Memo,-,Detailed explanation about special changes to the term over time.
Ranking of approximately 2000 common tests performed by 37. COMMON_TEST_RANK,Number,-,
"",,,laboratories in USA.
38. COMMON_ORDER_RANK,Number,-,"Ranking of approximately 300 common orders performed by
39. COMMON_SI_TEST_RANK,Number,-,"Corresponding SI terms for 2000 common tests performed by
STRUCTURE",Text,15,"This field will be populated in collaboration with the HL7 Attachments
2.58, the text will either be â€œIG existsâ€ (previously STRUCTURED)
41. EXTERNAL_COPYRIGHT_LINK,Text,255,"For terms that have a third party copyright, this field is populated with
42. PanelType,Text,50,"Describes a panel as a â€œConvenience groupâ€, â€œOrganizerâ€, or â€œPanelâ€.
common purpose, but not typically orderable as a single unit.
An â€œOrganizerâ€ is a subpanel (i.e., a child) within another panel that is
only used to group together a set of terms, but is not an independently
They often represent a header in a form, or serve as a navigation
43. AskAtOrderEntry,Text,255,"A multi-valued, semicolon delimited list of LOINC codes that represent
44. AssociatedObservations,Text,255,"A multi-valued, semicolon delimited list of LOINC codes that represent
45. VersionFirstReleased,Text,10,"The LOINC version number in which the record was first released. For
oldest records where the version released number is known, this field
46. ValidHL7AttachmentRequest,Text,50,"A value of â€˜Yâ€™ in this field indicates that this LOINC code can be
Table 31b: MAP_TO Table Structure,,,
