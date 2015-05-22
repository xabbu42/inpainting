---
title:  Assignment 2
author:
    - Nathan Gass
    - 02-124-337
header-includes:
    - \usepackage{caption,subcaption}
    - \usepackage{mathtools}
    - \usepackage{placeins}
    - \DeclarePairedDelimiter{\norm}{\lVert}{\rVert}
    - \DeclareMathOperator*{\argmin}{arg\,min}
    - \DeclareMathOperator*{\argmax}{arg\,max}
	- \everymath{\displaystyle}
...

\newcommand{\half}{\frac{1}{2}}
\newcommand{\qnorm}[1]{\norm{#1}_2^2}

Inpainting
==========

Primal Dual Formulation of the Problem
--------------------------------------

As in the first part, we do inpainting by minimizing the
following cost function:

\begin{equation*}
E(u) = \frac{\lambda}{2} \norm{u - g}^2_\Omega + \norm{\nabla u}_2
\end{equation*}

This cost function can be brought in the standard form for problems
solvable with the primal dual algorithms:

\begin{equation*}
E(u) = G(u) + F(Ku)
\end{equation*}

using the following definitions:

\begin{equation*}
\begin{split}
F(Ku) & \doteq \norm{u}_2 \\
G(u)  & \doteq \frac{\lambda}{2} \norm{u - g}^2_\Omega \\
K     & \doteq \nabla
\end{split}
\end{equation*}

In the primal dual algorithm, instead of solving this problem
directly, we solve the following equivalent problem:

\begin{equation*}
\min_{u} \max_{p} <p, \nabla u> - F^*(p) + G(u)
\end{equation*}

where $F^*$ is the convex conjugate of $F$ as defined above.

This problem is solved, iterating the following steps:

\begin{equation*}
\begin{split}
p^+ & = prox_{\sigma F*}(p + \sigma K \bar{u}) \\
u^+ & = prox_{\tau G}(u - \tau K^* p) \\
\bar{u}^+ & = u^{+} + \theta(u^{+} - x)
\end{split}
\end{equation*}


Explicit solution of the dual step
----------------------------------

The dual step of the primal dual algorithm consists in solving the following problem:

\begin{equation*}
\begin{split}
p^+ & = prox_{\sigma F*}(p + \sigma K \bar{u}) \\
    & = \argmin_z \half \qnorm{p + \sigma K \bar{u} - z} + \sigma F^*(z) \\
    & = \argmin_z <p - z, \sigma K \bar{u}> + \half \qnorm{p - z} + \half \qnorm{\sigma K \bar{u}} + \sigma F^*(z) \\
    & = \argmin_z - <z, \sigma K \bar{u}> + \half \qnorm{p - z} + \sigma F^*(z) \\
    & = \argmax_z <K \bar{u}, z> - F^*(z) - \frac{1}{2 \sigma} \qnorm{p - z}
\end{split}
\end{equation*}

As seen in the lecture, the convex conjugate of the norm $\norm{}$ is

\begin{equation*}
(\norm{\cdot}_2)^*(y) =
\begin{cases}
0 & \mathrm{if} \norm{y} \leq 1 \\
\infty & \mathrm{otherwise}
\end{cases}
\end{equation*}

and this gives us the following solution for the above problem:

\begin{equation*}
p^+ = \frac{p + \sigma K_x \bar{u}}{\max{\{1, \norm{p + \sigma \nabla  \bar{x}}\}}}
\end{equation*}


Explicit solution of the primal step
------------------------------------

The primal step of the primal dual algorithm consists in solving the following problem:


\begin{equation*}
\begin{split}
u^+ & = prox_{\tau G}(u - \tau K^* p) \\
    & = \argmin_z \half \qnorm{x - \tau K^* p^+ - z} + \tau G(z) \\
	& = \argmin_z <z - x, K^* p^+> + \half \qnorm{x - z} + \half \qnorm{\tau K^* p^+} + \tau G(z) \\
	& = \argmin_z <z, K^* p^+> + G(z) + \frac{1}{2 \tau} \qnorm{x - z}
\end{split}
\end{equation*}

Setting the gradient of this expression to zero gives the explicit solution:

\begin{align*}
0 & = K^* p^+ + \nabla_z G(z) + \frac{1}{\tau}(z - x) \\
0 & = \tau K^* p^+ + \tau \nabla_z G(z) + (z - x) \\
0 & = \tau K^* p^+ + \tau \lambda \Omega \odot (z - g) + (z - x) \\
z + \lambda \tau \Omega \odot z & = x + \lambda \tau \Omega \odot g - \tau K^* p^+ \\
z \odot (1 + \lambda \tau \Omega) & = x + \lambda \tau \Omega \odot g - \tau K^* p^+ \\
z & = (x + \lambda \tau \Omega \odot g  - \tau K^* p^+) \oslash (1 + \lambda \tau \Omega) \\
z & = (x + \tau \nabla \cdot p^+ + \lambda \tau \Omega \odot g) \oslash (1 + \lambda \tau \Omega)
\end{align*}

where $\odot$ and $\oslash$ stand for element-wise multiplication and division of matrices.

\newpage

Test Image
----------

\begin{figure}[h!]
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{original.png}
\caption{Original Image}
\label{original}
\end{subfigure}
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{input.png}
\caption{Input Image}
\label{input}
\end{subfigure}
\end{figure}

\newpage


Progress of the Primal Dual Method
----------------------------------

\begin{figure}[h!]
\setcounter{subfigure}{0}
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{primaldual-early.png}
\caption{After 10 iterations}
\label{original}
\end{subfigure}
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{primaldual-mid.png}
\caption{After 100 iterations}
\label{input}
\end{subfigure}
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{primaldual-late.png}
\caption{After 250 iterations}
\label{input}
\end{subfigure}
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{primaldual-final.png}
\caption{After 600 iterations}
\label{input}
\end{subfigure}
\end{figure}

\newpage



Difference to the original image (2)
------------------------------------

We repeat the same experiment we did with the gradient descent method
for the primal dual method. The following figure shows the sum of
squared distances (SSD) between the result of the primal dual
algorithm and the original image, depending on the $\lambda$
parameter:

\begin{figure}[h!]
\centering
\includegraphics[width=0.8\textwidth]{primaldual-plot.png}
\label{plot}
\end{figure}

The primal dual algorithm quickly reaches a lower SSD to the original
image than the gradient descent method did. The SSD further improves
slowely with larger values for lambda. So the closest result in this
series was achieved at the border with a $\lambda$ of 500 and a SSD to
the original of 14.0293:

\FloatBarrier

\begin{figure}[h!]
\centering
\includegraphics[width=0.45\textwidth]{primaldual-best.png}
\label{best}
\end{figure}

\newpage

The primal dual algorithm converges nearly 2 orders of magnitude
faster than the gradient descent method and still produces better
results:

\FloatBarrier

  Iterations  Total Time  SSD    Lambda
  ----------  ----------  ---    ------
  600		  2.3s        14.03  500
  5000		  80s		  15.34  306

\FloatBarrier