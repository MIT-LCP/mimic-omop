# Experimental

The OMOP schema is well suited for data standardisation. However, it is still
normalized and this is painfull and counterproductive for analysis.

Since OMOP datasets are mostly static datasets, a bit of denormalization is 
a good candidate to improve experience for data scientists.

This experimental set of views is an attempt to propose a simple transformation
of regular OMOP tables. The views might be exported to load an alternative and
denormalized OMOP dataset. The basic idea behind is "any transformation of a
standard still is a standard"

Let's see.
