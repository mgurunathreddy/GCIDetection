A Robust Non-Parametric and Filtering Based Approach for Glottal Closure Instant Detection

Authors : Pradeep Rengaswamy, Gurunath Reddy M, K. Sreenivasa Rao, Pallab Das Gupta

Speech is filtered using Raised Cosine Filter (RCF). The RCF is a pulse shaping low-pass filter widely used in digital communication for minimizing the inter symbol interference. Initially, the RCF filtered speech signal is thresholded to detect the voiced/unvoiced regions. In each identified voiced regions, the peaks corresponding to the GCIs are emphasised by non-linear filtering. Followed by a novel average epoch interval detection method based on the histogram and GCI detection based on peak picking approach is proposed. 

Usage: 

Through Matlab command prompt call the GCI detection method with any speech wave file as  

GCILoc= GCIDetection(filename)

ex: GCILoc= GCIDetection(arctic_a0007_speech.wav)

    Where arctic_a0007_speech.wav is the speech wave file, GCILoc is the vectore of GCI locations in seconds.
    

The file arctic_a0007_GCI.txt is the ground truth GCI of arctic_a0007_speech.wav

Manually annotated GCI dataset for CMU-ARCTIC dataset [1] is available at
http://www.sit.iitkgp.ernet.in/ksrao/gci-goi/egg-gci-goi.html

Source code is tested in Windows Environment in Matlab 2015A.

[1] J. Kominek and A. W. Black, “The CMU Arctic Speech Databases,” in Fifth ISCA Workshop on Speech Synthesis, 2004.
