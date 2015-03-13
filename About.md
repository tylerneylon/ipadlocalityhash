# The Algorithm #

The locality hashing algorithm illustrated by this app works in any dimension, although this app only demonstrates the very simple 2d case.  Any LSH algorithm has the advantage of giving essentially constant-time lookups (constant with respect to number of pre-processed data points), at the cost of some accuracy.  In practice, the most popular LSH algorithms, including reductions via p-stable distributions, work very well.

This algorithm, among other LSH algorithms, has empirical evidence of being more accurate (see the paper mentioned below for more details).  It also has the advantage of being independent of dimension reduction, which allows it to be combined with other approaches (such as p-stable reductions) for even greater speed and lower memory requirements.

# Paper #

The algorithm was first presented at the SODA 2010 conference, and is published in the corresponding paper:

https://www.siam.org/proceedings/soda/2010/SODA10_094_neylont.pdf

# Slides and Talk #

The most recent was given at [this event](http://wiki.hackerdojo.com/amazonawsvisit) in Mountain View, CA.

The slides are available here:

http://wiki.hackerdojo.com/f/lsh_hacker_dojo_talk.pdf