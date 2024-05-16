# Preprocessing


Preprocessing of the MRI was applied to the DWI and T1-w images using TractoFlow. Overall, DWI preprocessing is aimed at preparing the images for the application of local reconstruction models. It mainly consists of the following elements: denoising, artifact correction (eddy current/Foucault currents, motion, susceptibility Topup, truncation/Gibbs ringing), brain extraction, N4 bias correction, cropping, normalization, and resampling. On the other hand, preprocessing of the T1-w images is aimed at calculating tissue maps, seeding masks, and brain parcellations. Its main steps include denoising, brain extraction, N4 bias correction, cropping, and resampling.


