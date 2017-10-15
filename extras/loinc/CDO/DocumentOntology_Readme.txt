The LOINC Document Ontology file is provided in a .zip format that contains a single comma separated flat file as well as Release Notes, Readme and LOINC license files in plain text format.

Version history:
 - 6/2017: LOINC_2.61_DocumentOntology.zip

Directory listing:
 - DocumentOntology.csv
 - DocumentOntology_ReleaseNotes.txt
 - DocumentOntology_Readme.txt
 - License.txt

The first row in the comma separated file contains column headings and all other rows contain data. Details about the file contents are provided below.

Overview:
This file contains an export of the LOINC terms in the Document Ontology class (DOC.ONTOLOGY) and their values from each axis of the Document Ontology. The axis values are identified by LOINC Part Numbers and classified according their type (Setting, Type of Service, etc). Some LOINC terms contain combinations of Document Ontology values from within the same axis, and the PartSequenceOrder value indicates the proper order of each one within that axis. 

For more information on the LOINC Document Ontology, see the LOINC Users' Guide.

The Document Ontology file contains the following columns:
 - LoincNumber - the LOINC term identifier, which is a unique numeric identifier with a check digit
 - PartNumber - the LOINC Part Number, which is a unique identifier that starts with the prefix "LP"
 - PartTypeName - the type of Part. Examples: Document.TypeOfService, Document.Setting
 - PartSequenceOrder - indicates the proper order of Parts within the axis
 - PartName - the name of the Part. Examples: Note, Consultation, Physician

Sort order:
This file is sorted by LoincNumber followed by PartTypeName and then PartSequenceOrder. The PartTypeName is sorted in the following order: Document.Kind --> Document.TypeOfService --> Document.Setting --> Document.SubjectMatterDomain --> Document.Role.

Note:
This file does not contain any deprecated LOINC terms.