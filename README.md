# Ab_CDR_Script
Perl - Recombinant Antibody Analysis. Calculates Wagner Fischer Score for clone CDRs(1-3) compared to reference CDRs(1-3).

This program requires two input .txt files (tab-seperated) - a clone input file and a reference input file, and generates
a tab-seperated .xls file (for viewing in excel). 

The Wagner–Fischer algorithm "computes edit distance based on the observation that if we reserve a matrix to hold the edit
distances between all prefixes of the first string and all prefixes of the second, then we can compute the values in the 
matrix by flood filling the matrix, and thus find the distance between the two full strings as the last value 
computed. " (Wikipedia). This algorithm was implemented to quickly screen recombinant Antibody clone variable regions to
putative targets.

There are weighted and unweighted versions. The weighted version selects for Clones with better CDR3 matches, as CDR3
is the most variable and is expected to be most important for antigen binding. The unweighted version assigns CDR1, CDR2
and CDR3 mismatch penalties equally.

Antibody Annotation is accomplished through IMGT: http://www.imgt.org/IMGT_vquest/share/textes/

The clone file expects the following format:

Sequence ID   Functionality   CDR1-IMGT   CDR2-IMGT   CDR3-IMGT   Sequence

The reference file expects the following format:

Sequence ID   CDR1-IMGT   CDR2-IMGT   CDR3-IMGT

The output file generated will be in the following format:

Functionality   CLONE_ID   REF_ID   CLONE_cdr1   REF_cdr1   CLONE_cdr2   REF_cdr2   CLONE_cdr3   REF_cdr3   WagnerFischerScore   Sequence

