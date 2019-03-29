# Meta-analysis of interaction

This repository contains the code and data used for a literature review on the use of factorial meta-analysis/meta-analysis of interaction in Ecology.

## Scripts:

`001deduplicating_references.R`: script to deduplicate references from three different search engines: Web of Science, PubMed and Scopus; and prepare the data to be imported into [Rayyan](https://rayyan.qcri.org) for Title+Abstract screening.

`002reorganizing_refs_after_screening.R`: script to subset those references included for full text screening.

`003summarizing_literature_factorial_ma.R`: script to provide with some summary statistics and plots on the number of studies using a factorial meta-analysis.

## Folders:

`equation_examples`: contains some screenshots from some of the included papers.

`literature_searches_results`: contains all the .bib and .nbib files extracted from Web of Science, PubMed and Scopus.

`output_cleaning_reference_list`: contains all the files created during the deduplication process.

`output_rayyan`: contains the files extracted from [Rayyan](https://rayyan.qcri.org) after Title+Abstract screening was finished.

`plots`: contains plots showing the number of papers using factorial meta-analysis over time.

`the_final_database`: contains the data on which of the full texts screened actually used a factorial meta-analysis.

### Notes:

The version of the R package '[revtools](https://revtools.net/)' used differs between scripts, which means that the code used in script "001deduplicating_references.R" would need adjusting from revtools v.0.2.0 to v.0.3.0.

Literature search conducted on the 15th of November, 2018. 

Titles and abstracts screening conducted using [Rayyan](https://rayyan.qcri.org). Addtional information regarding the literature review can be found in [here](https://docs.google.com/document/d/1mlEl7E_svDc9WiZDHy1V4DMDlvqfyKpjildiH2duL4I/edit?usp=sharing) or [here](https://docs.google.com/document/d/1mlEl7E_svDc9WiZDHy1V4DMDlvqfyKpjildiH2duL4I/edit?usp=sharing).

More informationa about this project available at the [OSF] (to be announced) or can be requested via email to: alfredo.tojar@gmail.com
