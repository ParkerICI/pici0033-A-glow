# config for PICI0033A glow app


list(
  # The name of the dataset
  dataset.name = "porter",
  
  # Use this option to specify groups of cell populations that should be plotted together.
  # Must be a named list where the name of a list element is the name of the cell population group,
  # and the value is a vector of cell.population.name that belong to that group
  cell.population.groups = list(
    "X50" = list(
    # measurement set name
      "X50 T cells" = c(
        list(
          "CD4 T cells" = c("CD4 > CD45RA-CD27- > EM2", "CD4 > CD45RA-CD27- > EM3", "CD4 > CD45RA-CD27+ > CM", "CD4 > EMRA > EMRA CCR7-", "CD4 > EMRA > EMRA CCR7+", "CD4 > Naive",
                            "CD4 > Th2", "CD4 > Foxp3+ > Treg"),
          "CD8 T cells" = c("CD8 > CD45RA-CD27- > EM2", "CD8 > CD45RA-CD27- > EM3", "CD8 > CD45RA-CD27+ > CM", "CD8 > EMRA > EMRA CCR7-", "CD8 > EMRA > EMRA CCR7+", "CD8 > Naive")
        ),
        {
          # list dataset name, technology, then measurement set name
          pops <- wick::get_all_cell_populations("porter", "X50", "X50 T cells")
          ret <- list()
          markers <- c("CD127", "CD137", "CD152", "CD185", "CD223", "CD244", "CD25", "CD278", "CD279", "CD28", "CD366", "CD38", "CD39", 
                       "Eomes", "Ki67\\+$", "KLRG1", "PD1\\+CD39\\+", "Tbet\\+Eomes\\+", "Tbet(Hi|Int)", "TCF1", "TIGIT")
          for(pop in c("CD4\ ", "CD8\ ")) {
            for(m in markers) {
              v <- pops$cell.population.name
              pop.re <- pop
              if(pop.re == "CD4\ ")
                pop.re <- "CD4\ |Treg\ "
              ret <- c(ret, setNames(list(v[grepl(m, v) & grepl(pop.re, v)]), sprintf("%s (%s)", pop, gsub("\\\\|\\$", "", m))))
            }
          }
          ret
        }
      )
    )
  ),
  
  # Use this option to specify treatment regimens that should be grouped together.
  # Must be a named list where the name of a list element is the name of the treatment regimen group,
  # and the value is a vector of treatment.regimen.name that belong to that group
  #treatment.regimen.groups = list(
   # c("A" = "A",
    #  "B" = "B",
     # "C" = "C"),
  
  # Default selected timepoints
  default.timepoints = c("BL", "C1D1","C1D1", "C1D2", "C1D8", "C2D1",
                         "C3D1", "C4D1", "EOS"),
  
  # Default timepoint for normalization
  default.normalize.by.timepoint =  "C1D1",
  
  
  # Subject annotations. A data.frame with arbitrary columns corresponding to subject annotations
  # that can be used for grouping. Should either have a subject.id column, or row.names corresponding
  # to subject.id's
  subj.annots <- read.table(file.path("CONFIG.LOCATION", "ctc.response.csv"), 
                    header = T, sep = "\t", stringsAsFactors = FALSE),
 
  # Sample annotations. A data.frame with arbitrary columns corresponding to sample annotations
  # that can be used for grouping. Should either have a sample.id column, or row.names corresponding
  # to sample.id's
  # sample.annotations <- read.table(file.path("CONFIG.LOCATION", "samples_to_exclude.tsv"), 
  #                  header = T, sep = "\t", stringsAsFactors = FALSE),

  # Use this option to specify subject cohorts. Must be a named list with list names corresponding to the name
  # of the cohorts, and values consisting of vectors of subject.id's that comprise the corresponding cohort
  subject.cohorts = {
    tab <- wick::get_all_subjects("porter")
    arms <- unique(tab$treatment.regimen.name)
    setNames(lapply(arms, function(x) {tab[tab$treatment.regimen.name == x, "subject.id"]}), arms)
    
  }
)








