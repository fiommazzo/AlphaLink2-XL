#generate crosslink file for AlphaLink2 prediction

library(tidyverse)

protein_complex_xls <- read.csv("XLs.csv")

## uncomment if you want to have only heterolinks. 
## Usually heterolink are enough to improve the prediction
#protein_complex_xls <- protein_complex_xls |> filter(Self == "false")

tab <- data.frame(
  "Protein1" = protein_complex_xls$Protein1,
  "residueFrom" = protein_complex_xls$SeqPos1,
  "Protein2" = protein_complex_xls$Protein2,
  "residueTo" = protein_complex_xls$SeqPos2,
  "FDR" = 0.05 # if residue pair fdr set to 0.05. Otherwise column FDR
)

# assign chains: A, B, C, ...
tab <- tab |>
  mutate(chain1 = case_when(Protein1 == "Q8IWI9" ~ "B",
                            Protein1 == "Q99NA9" ~ "A",
                            #Protein1 == "Q99496" ~ "C",
                            TRUE ~ "C"),
         chain2 = case_when(Protein2 == "Q8IWI9" ~ "B",
                            Protein2 == "Q99NA9" ~ "A",
                            #Protein2 == "Q99496" ~ "C",
                            TRUE ~ "C"))

tab <- tab |>
  dplyr::select(residueFrom,
                     chain1,
                     residueTo,
                     chain2,
                     FDR
                     ) 

## uncomment if your protein has TAGS or it has been CHOPED for prediction
## if protein has tag, the modified fasta was used for XL-MS. On the other
## hand, the prediction makes use of the original fasta. So you should remove
## additional residues from xl-ms file and to scale all the positions

# tab <- tab |>
#   mutate(residueFrom = if_else(chain1 == "B", residueFrom-40, residueFrom),
#          residueTo = if_else(chain2 == "B", residueTo-40, residueTo)) |>
#   filter(residueFrom > 0 & residueTo > 0)


# write table
tab |> write.table("dataset_links.csv", col.names = F, row.names = F, sep = " ", quote = F)

