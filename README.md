#### About

This project is for the simulation of random walks on different types of random graphs, including [ER network](https://en.wikipedia.org/wiki/Erd%C5%91s%E2%80%93R%C3%A9nyi_model), [WS network](https://en.wikipedia.org/wiki/Watts_and_Strogatz_model), scale free network such as [flower network](https://books.google.com.hk/books?id=dAS3CgAAQBAJ&pg=PA129&lpg=PA129&dq=flower+model+random+graph&source=bl&ots=6pgGP9vUmb&sig=ETDC_FZSYxWvvdXcHMbsw6_phXs&hl=en&sa=X&redir_esc=y#v=onepage&q=flower%20model%20random%20graph&f=false), [Sierpinski network](http://meep.cubing.net/html5/sierpinski.html), and real life network including [Facebook Ego network](https://snap.stanford.edu/data/egonets-Facebook.html) and a sub [Web graph](https://snap.stanford.edu/data/web-Stanford.html) (subsampling using [forestfire algorithm](https://github.com/snap-stanford/snap/tree/master/examples/forestfire)). The statistics we are interested is mean first passage time(MFPT). Full results (.mat with .fig) can be downloaded [here](www.google.com).

#### Folder Structure

+ AdjMat2D3Graph: visualization of graph using d3.js

+ Main: major simulation code in this folder
    * meanfstpsg.m: given a Markov chain simulation with (Transition Probability Matrix, Minimum Distance Matrix, Minimum number of times every node should be visited), return MFPT
    * mfpsimulatealpha/mu/alpha-multiworkers/mu-multiworkers.m: get relation of MFPT with mu and alpha through simulations
    * betamu/alpha.m: comparision of theoretical results with simulation results about relation MFPT(mu) and relation MFPT(alpha).
    * ffsampling.m: implementation of forest fire graph sampling algorithm
    * task.sh: make life easier

+ UVnetwork/UVnet.m: generator of flower graph model
+ batchtsks/simulate.batch: sbatch script
+ crawlernet/stanford/fbego/txt2mat.py: convert mfpsimulatemu-multiworkers.m results to mat
+ crawlernet, networkbase: store all type of networks' adjency matrix and MFPT simulation results


#### [Paper Link](tbp)