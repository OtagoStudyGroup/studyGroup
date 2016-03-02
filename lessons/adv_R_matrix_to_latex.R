load("R_to_LaTeX_demo.RData")
library("xtable")

#Export one data matrix to a .tex table
head(data.frame(signif_df(function13(SL_Table_TCGA_BRCA_Cut_Voom), digits = 3)), 20)
xtable(data.frame(signif_df(function13(SL_Table_TCGA_BRCA_Cut_Voom), digits = 3))[1:25, c(3, 4, 13, 15, 17 )])
print(xtable(data.frame(signif_df(function13(SL_Table_TCGA_BRCA_Cut_Voom), digits = 3))[1:25, c(3, 4, 13, 15, 17 )]), type="latex", file="output.tex")
export_SL_latex <- function(x) print(xtable(data.frame(signif_df(function13(x), digits = 3))[1:25, c(3, 4, 13, 15, 17 )]), type="latex", file="output.tex")
export_SL_latex
as.character(get(SL_Table_TCGA_BRCA_Cut_Voom))
paste0(deparse(substitute(x)), ".tex")
export_SL_latex <- function(x) print(xtable(data.frame(signif_df(function13(x), digits = 3))[1:25, c(3, 4, 13, 15, 17 )]), type="latex", file=paste0(deparse(substitute(x)), ".tex"))
export_SL_latex
export_SL_latex(SL_Table_TCGA_BRCA_Cut_Voom)
#what have we done to get the tex file the same name as the data matrix?
?deparse
?substitute
substitute(SL_Table_TCGA_BRCA_Cut_Voom)
name <- function(x) paste0(deparse(substitute(x)), ".tex")
name(SL_Table_TCGA_BRCA_Cut_Voom)

#Export several matrices
grep("SL_Table", ls())
ls()[grep("SL_Table", ls())]
for(file in ls()[grep("SL_Table", ls())]){
export_SL_latex(get(file))
print(file)
}
#now all of the matrixes are called "file"
#unless we loop over commands not files
paste0('export_SL_latex(', ls()[grep("SL_Table", ls())], ")")
for(command in paste0('export_SL_latex(', ls()[grep("SL_Table", ls())], ")")){
  eval(parse(text=command))
  print(command)
}
