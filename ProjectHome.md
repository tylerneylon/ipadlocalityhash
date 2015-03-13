This app gives an interactive look at a new locality-sensitive hashing algorithm.

Locality-sensitive hashing is a technique used to perform very fast lookups for data points near a given query point among a large set of pre-processed numerical data.  For example, it could quickly retrieve all videos in a large database which are similar to a new video.  The word "similar" here means close as a numerical vector (in the usual Euclidean distance) - the algorithm assumes all data is represented as set of floating-point numbers, each data having the same parameters (i.e. each point is a vector of the same number of dimensions).

The original paper for this algorithm can be found here:

https://www.siam.org/proceedings/soda/2010/SODA10_094_neylont.pdf