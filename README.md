# Gopher Tortoise Burrow Associates: Camera Trap Study Analysis
This repository contains the statistical analysis and R code I contributed to Huffman et al. 2025.

## Paper Information

**Citation:**
Huffman, J., J. Aquino-Thomas, L. De Souza, J. Unger, and E. Frazier. 2025. Vertebrate fauna associated with Gopher Tortoise burrows in southeastern Florida. *Southeastern Naturalist* 24(2):200–222.

**DOI:** https://doi.org/10.1656/058.024.0212

**Journal:** Southeastern Naturalist  
**Volume:** 24, Issue 2  
**Pages:** 200–222  
**Year:** 2025

## Study Overview

This study used motion-triggered cameras to document vertebrate species using Gopher Tortoise (*Gopherus polyphemus*) burrows across southeastern Florida. Camera traps were deployed at active adult burrows for 18 months across 4 sampling units representing 3 habitat types at 3 sites (Florida Atlantic University Preserve, Jonathan Dickinson State Park, and Pine Jog Preserve):

- **FAU/Grass** - Florida Atlantic University Preserve (5 cameras)
- **FAU/Scrub** - Florida Atlantic University Preserve (5 cameras)  
- **JDSP/Scrub** - Jonathan Dickinson State Park (9 cameras)
- **PJP/Pine** - Pine Jog Preserve (5 cameras)

### Key Findings
- **44 vertebrate species** observed at burrows (excluding Gopher Tortoises)
- **42 species** identified to species level
- **9,084 total observations** (5,890 Gopher Tortoise, 3,194 other vertebrates)
- Vertebrate community composition **varied significantly among study locations**
- **Species accumulation curves** indicated adequate sampling effort
- **Beta diversity analysis** revealed turnover vs. nestedness patterns between sites

![Vertebrate species overlap across four southeast Florida study sites, including Gopher Tortoise observations](venn_diagram.png)
*Venn diagram of vertebrate species recorded at Gopher Tortoise burrows across four study locations (FAU Grass, Jonathan Dickinson, Pine Jog, and FAU Scrub). Unlike Figure 3 in Huffman et al. 2025, this version includes Gopher Tortoise observations in the species counts. Produced in R.*

## Statistical Analyses

### Analytical Approach

1. **Species Richness and Diversity**
   - Alpha diversity by site using `specnumber()` (vegan)
   - Gamma diversity across all sites  
   - Chao index estimates using `BiodiversityR`
   - Shannon diversity indices with significance testing

2. **Species Accumulation Curves**
   - Generated using `accumcomp()` and `specaccum()` from vegan/BiodiversityR
   - Assessed sampling completeness across study locations

3. **Community Overlap Analysis**
   - Venn diagrams showing species overlap between sites
   - Separate analyses for all species and excluding Gopher Tortoises

4. **Beta Diversity Decomposition**
   - Total β-diversity using Sørensen dissimilarity (via adespatial package)
   - Partitioning into **turnover/replacement** and **nestedness/richness** 
   components
   - Local Contribution to Beta Diversity (**LCBD**) for each site
   - Species Contribution to Beta Diversity (**SCBD**)

5. **Statistical Software**
   - R statistical environment
   - Key packages: `vegan`, `BiodiversityR`, `adespatial`, `VennDiagram`, `tidyverse`

### Generated Figures
The Venn diagram of species overlap (venn_diagram.png) is included in this repository, reproduced with Gopher Tortoise observations added to the species counts.

The species accumulation curves and the β-diversity partitioning were also produced in this code. Those figures are published in Huffman et al. 2025 and are not reproduced here; please see the paper for the published versions.

## Repository Contents

- `camera_study_clean_v2.R` - Main analysis script (cleaned and organized)
- `README.md` - This file
- `venn_diagram.png` - Species overlap figure
- `CITATION.cff` - Citation metadata
- `LICENSE` - MIT License

## Software Requirements

### R Version
Tested with R 4.0+ 

### Required R Packages
```r
library(tidyverse)      # Data manipulation and visualization
library(vegan)          # Community ecology analysis
library(BiodiversityR)   # Biodiversity indices and accumulation curves
library(adespatial)     # Beta diversity analysis
library(VennDiagram)    # Species overlap visualization
library(ggthemes)       # Additional ggplot themes
library(scales)         # Plot scaling
library(zoo)           # Time series data
```

## Data Availability

**Important:** The raw camera trap data cannot be made publicly available by the analysis author due to data sharing restrictions and privacy considerations related to the study locations. 

For questions about data access, please contact the corresponding author through the journal or institutional affiliations listed in the publication.

## Paper Access

The published paper is **not open access**. To obtain a copy:

1. **ResearchGate:** Visit [Jessene Aquino-Thomas's ResearchGate profile](https://www.researchgate.net/profile/Jessene-Aquino-Thomas) to request a PDF
2. **Institutional Access:** Check if your institution has access to *Southeastern Naturalist*
3. **Journal Website:** [Southeastern Naturalist](https://www.bioone.org/loi/sena)


## Conservation Context

Gopher Tortoises are:
- **State threatened** in Florida
- **Keystone species** and ecosystem engineers
- Support communities of **360+ associated species** range-wide
- Declining due to habitat loss and fragmentation

This research provides baseline data for vertebrate communities associated with Gopher Tortoise burrows in southeastern Florida, contributing to conservation planning in this highly urbanized region.

## Contact

For questions about the statistical analysis or R code:
- **Jessene Aquino-Thomas**: [ResearchGate Profile](https://www.researchgate.net/profile/Jessene-Aquino-Thomas)

## How to Cite

If you use this code in your research, please cite both the code and the original paper:

### Code Citation:
```
Aquino-Thomas, J. (2025). Statistical Analysis Code: Gopher Tortoise Burrow Associates Camera Trap Study. 
GitHub repository: https://github.com/Jessene/gopher-tortoise-camera-analysis
```

### Paper Citation:
```
Huffman, J., J. Aquino-Thomas, L. De Souza, J. Unger, and E. Frazier. 2025. 
Vertebrate fauna associated with Gopher Tortoise burrows in southeastern Florida. 
Southeastern Naturalist 24(2):200–222. https://doi.org/10.1656/058.024.0212
```

## License

This code is released under the MIT License; see the LICENSE file for details. You are free to use, modify, and distribute it, including for commercial purposes, provided the copyright and license notices are preserved. If you use or adapt this analysis, please also cite the original publication (see How to Cite above).

## Acknowledgments

I would like to thank my co-authors, Dr. Evelyn Frazier, Jessica Huffman, Laura De Souza, and Jennifer Unger, for their collaboration on this research. Thanks also to all undergraduate and graduate students who assisted with data processing, Dr. Dale Gawlik and Dr. Jeanette Wyneken for species identification assistance, and Brian Randle for GIS support. Funding provided by FAU Technology Fee Grant and FAU Terrestrial Ecology Lab.

---

**Repository maintained by:** Jessene Aquino-Thomas  
**Last updated:** July 3, 2026  
**R Script version:** 2.0 (Cleaned and organized)
