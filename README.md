# MCInsertionPackage_2020
This is a new algorithm to insert microcalcification clusters into Digital Mammograms.The details are described in the article:

[IWBI2020] Lucas R. Borges, Renato F. Caron, Paulo M. Azevedo-Marques, and Marcelo A. C. Vieira "Effect of denoising on the localization of microcalcification clusters in digital mammography", Proc. SPIE 11513, 15th International Workshop on Breast Imaging (IWBI2020), 115130K (22 May 2020); https://doi.org/10.1117/12.2564316

Disclosure: This package used The Laboratory for Individualized Breast Radiodensity Assessment (LIBRA), a software package developed by the University of Pennsylvania. Therefore, in addition to the above paper, you must cite the following papers:

[MedPhys2012] Keller, B.M., Nathan, D.L., Wang, Y., Zheng, Y., Gee, J.C., Conant, E.F., and Kontos, D., "Estimation of breast percent density in raw and processed full field digital mammography images via adaptive fuzzy c-means clustering and support vector machine segmentation," Medical physics 39 (8), 4903-4917

[BCR2015] B.M. Keller, J. Chen, D. Daye, E.F. Conant, and D. Kontos. "Preliminary evaluation of the publicly available Laboratory for Breast Radiodensity Assessment (LIBRA) software tool: comparison of fully automated area and volumetric density measures in a case-control study with digital mammography.," Breast Cancer Research 17(1), 1-17

This package needs the Matlab Runtime 8.1.

Disclaimer: For education purposes only.


---
## Instructions Linux (Ubuntu)

1. Download [Libra](https://www.nitrc.org/projects/cbica_libra/);
2. Run `InsertLesions.m`;
3. If you have a bug on `svmclassify` and `svmdecision`, modify these functions to `mod_svmclassify` and `mod_svmdecision`;
