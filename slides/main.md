---
title: 'DAPHNE'
short_title: 'DAPHNE'
subtitle: ''
date: 29/08/2023
affiliations:
    - name: UGA, INRIA
      mark: ''
      signature: 'Univ. Grenoble Alpes, INRIA, CNRS, LIG'
      email: 'firstname.lastname@inria.fr'
      authors:
        - firstname: Quentin
          lastname: Guilloteau
          is_presenter: true
header-includes:
    - \usepackage{tikz}
    - \usepackage{hyperref}
    - \usepackage{animate}
    - \usetikzlibrary{decorations.pathreplacing}
    - \usepackage{subcaption}
    - \usepackage{MnSymbol,wasysym}
    - \usepackage{listings}
    - \definecolor{qpurple}{rgb}{0.363, 0.226, 0.605}
    - \definecolor{qorange}{rgb}{0.898, 0.379, 0.0}
bibliography: references.bib
lang: en
---

# Context

- Integrated Data Analysis (IDA) pipelines

- e.g., HPC simulation $\rightsquigarrow$ Big Data processing $\rightsquigarrow$ ML training

- would require different tools, methods, expertises, platforms, etc.

\begin{center}
$\hookrightarrow$ \textbf{Daphne wants to be an infra to develop \& deploy IDA pipelines}
\end{center}

\begin{columns}
    \begin{column}{0.65\textwidth}
        \begin{figure}
            \centering
            \includegraphics[width=\textwidth]{./figs/daphne.pdf}
            \caption{Daphne infrastructure \cite{damme2022daphne}}
        \end{figure}
    \end{column}
    \begin{column}{0.35\textwidth}
        \begin{itemize}
            \item DaphneDSL $\simeq$ Python, Julia, R
            \item reuse Python code w/ DaphneDSL
            \item MLIR $\rightsquigarrow$ allows to use existing kernels
            \item wants to be extensible
            \item \emph{Scheduling opportunities}
        \end{itemize}
    \end{column}
\end{columns}



# The Scheduling Challenges (1/2)

\begin{center}
    \textbf{How to efficiently schedule IDA pipelines?}
\end{center}

\begin{itemize}
    \item Execution ordering: generated by compiler, FCFS
    \item Execution timing: start task immediatedly, $\rightsquigarrow$ defer
    \item having a master thread partition and assign work to workers \\$\implies$ waiting and idleness
\end{itemize}

\begin{center}
$\hookrightarrow$ \textbf{instead}: the workers partition and self-assign the work
\end{center}


## Local scheduler \cite{daphne-report52, daphne-report51}

\begin{itemize}
    \item Self-Scheduling: State-of-Practice + State-of-the-Art
    \item Work-queues: centralized, decentralized (per core, per CPU)
    \item Work-Stealing: seq, random, + same but with NUMA priority
    \item \cite{eleliemy2023daphnesched} evaluation of \emph{DaphneSched}
    \item extensible!
\end{itemize}

# The Scheduling Challenges (2/2)

\begin{center}
\textbf{But what about several nodes?}
\end{center}

\begin{itemize}
    \item need to consider locality, cost of data transfers, etc.
    \item interaction between IDA pipelines
    \item coarser grain idleness
    \item $\nearrow$ heterogeneous
\end{itemize}

## Global Scheduler \cite{eleliemy2021resourceful}

\begin{itemize}
    \item interaction with the batch-scheduler
    \item opportunity for collocation, relinquish resources, monitoring, etc.
    \item communications between the global and local scheds
    \item $\rightsquigarrow$ not done yet in Daphne?
\end{itemize}

# Questions

- when decentralized work queue, workers *pull* from the "main" queue. Can the main queue *push* to the workers, and then let them steal work?

- at the cluster level, when running 2 IDA pipelines, how many instances of Daphne?

    - if 1, Daphne runtime is a wrapper around batch sched?

    - if 2, how to communicate between the instances?

# Technical task

`src/runtime/local/vectorized/LoadPartitioning.h`

```
+ cstChunk = 0;
+ if (schedulingMethod == CST){
+     if (const char* env_cst_size =\
            std::getenv("DAPHNE_CST_TASK_SIZE")){
+         cstChunk = std::stoi(env_cst_size);
+     }
+     else{
+         schedulingMethod = STATIC;
+     }
+ }
// ...
+ case CST:{
+     chunkSize=cstChunk;
+     break;
+ }
```

# Demo

\begin{center}
Demo!
\end{center}

(see a GIF of the demo [here](https://github.com/GuilloteauQ/daphne-toy-sched#the-toy-scheduler))


# A word on reproducibility

- in Grenoble ([DATAMOVE team](https://team.inria.fr/datamove/)), we are very interested in reproductibility of experiments

- in CS this notably goes through reproducibility of software (and others)

- was annoying to build (MLIR \& ANTLR)

- use tools such as [Nix](https://nixos.org)/[Guix](https://guix.gnu.org) (see issue [#580](https://github.com/daphne-eu/daphne/issues/580))

- packaged (rougthly) Daphne in Nix: see [daphne-nix](https://github.com/GuilloteauQ/daphne-nix)

- created a binary cache ([cachix](https://cachix.org)): [daphne-nix.cachix](https://daphne-nix.cachix.org)

- allows for reproducible, sharable, precisely customizable softwares

- (see [those slides](https://guilloteauq.github.io/downloads/slides/tuto_nix_compas22.pdf) for more)
