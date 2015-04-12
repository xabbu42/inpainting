---
title:  Assignment 1
author: Nathan Gass
header-includes:
    - \usepackage{caption,subcaption}
    - \usepackage{mathtools}
    - \DeclarePairedDelimiter{\norm}{\lVert}{\rVert}
    - \DeclareMathOperator*{\argmin}{arg\,min}
	- \everymath{\displaystyle}
...


Problem
-------

The goal of inpainting algorithms is to recover missing or invalid
parts of an image. The inputs for inpainting are an image $g$ together
with a mask $\Omega$ identifing the valid parts of $g$.  The result is
a new image $\tilde{u}$ which should be close to the original image
$g$ where it is valid, and match the surroundings as closely as
possible in the invalid parts. In this particular inpainting
algorithm, this two factors are captured by the following minimization
problem:

\begin{equation*}
\tilde{u} = \argmin_u{\frac{\lambda}{2} \norm{u - g}^2_\Omega + \norm{\nabla u}}
\end{equation*}


Motivations
-----------

There are many possible sources for incomplete images:

* Damaged photographs and movie films.

* Partly overwritten images where the original is lost. For example
  the background image of an advertisement.

* Images with some objects removed by choice.

* Lost data during transmission without the time for retransmission
  (this requires fast algorithms for inpainting).

In all this cases, inpainting algorithms can be used to fill in the
holes of the incomplete image according to the surroundings to get a
complete image back.

\newpage

Derivation
----------

As seen in the problem description, we want to minimize the following
objective function:

\begin{equation*}
E(u) = \frac{\lambda}{2} \norm{u - g}^2_\Omega + \norm{\nabla u}_2
\end{equation*}

We use the following finite difference approximation of the objective
function $E$:

\begin{equation*}
\begin{split}
\norm{u - g}^2_\Omega & \simeq \sum_{x,y}{\Omega(x,y) \norm{u[x,y] - g[x,y]}^2} \\
    \norm{\nabla u}_2 & \simeq \sum_{i,j}\tau[i,j]
\end{split}
\end{equation*}

With $\tau[i,j]$ defined by:

\begin{equation*}
\begin{split}
forw_x[i,j] & \doteq u[i+1,j] - u[i,j] \\
forw_y[i,j] & \doteq u[i,j+1] - u[i,j] \\
\tau[i,j]   & \doteq \sqrt{forw_x[i,j]^2 + forw_y[i,j]^2 + \delta} = \sqrt{(u[i + 1,j] - u[i,j])^2 + (u[i, j+1] - u[i,j])^2 + \delta} \\
\end{split}
\end{equation*}

The gradient of our cost function $E(u)$ is:

\begin{equation*}
\begin{split}
\nabla_u E[i,j]
  & = \lambda \Omega[i,j] (u[i,j] - g[i,j]) + \frac{\delta\norm{\nabla u}_2}{\delta u[i,j]}\\
\\
\frac{\delta\norm{\nabla u}_2}{\delta u[i,j]}
  & = \sum_{x,y}{\frac{\delta \tau[x,y]}{\delta u[i,j]}} \\
  & = \frac{\delta \tau[i,j]}{\delta u[i,j]} + \frac{\delta \tau[i-1,j]}{\delta u[i,j]} + \frac{\delta \tau[i,j-1]}{\delta u[i,j]} \\
\\
\end{split}
\end{equation*}
\begin{equation*}
\begin{split}
\frac{\delta \tau[i,j]}{\delta u[i,j]}
  & = \frac{1}{2} \frac{1}{\tau[i,j]} \bigl(2 (u[i+1,j] - u[i,j]) (-1) + 2 (u[i,j+1] - u[i,j]) (-1)\bigr) \\
  & = \frac{1}{\tau[i,j]} (2u[i,j] - u[i+1,j] - u[i,j+1]) \\
  & = \frac{1}{\tau[i,j]} (-forw_x[i,j] - forw_y[i,j]) \\
\\
\frac{\delta \tau[i-1,j]}{\delta u[i,j]}
  & = \frac{1}{2} \frac{1}{\tau[i-1,j]} \bigl( 2 (u[i,j] - u[i-1,j]) + 2 (u[i-1,j+1] - u[i-1,j]) 0 \bigr)\\
  & = \frac{1}{\tau[i-1,j]} (u[i,j] - u[i-1,j]) \\
  & = \frac{1}{\tau[i-1,j]} forw_x[i-1,j] \\
\\
\frac{\delta \tau[i-1,j]}{\delta u[i,j]}
  & = \frac{1}{2} \frac{1}{\tau[i,j-1]} \bigl(2 (u[i+1,j-1] - u[i,j-1]) 0 + 2 (u[i,j] - u[i,j-1])\bigr) \\
  & = \frac{1}{\tau[i,j-1]} (u[i,j] - u[i,j - 1]) \\
  & = \frac{1}{\tau[i,j-1]} forw_y[i,j-1]
\end{split}
\end{equation*}


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


Progress of Gradient Descent
----------------------------

\begin{figure}[h!]
\setcounter{subfigure}{0}
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{early.png}
\caption{After 10 iterations}
\label{original}
\end{subfigure}
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{mid.png}
\caption{After 1000 iterations}
\label{input}
\end{subfigure}
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{late.png}
\caption{After 2500 iterations}
\label{input}
\end{subfigure}
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{final.png}
\caption{After 5000 iterations}
\label{input}
\end{subfigure}
\end{figure}

\newpage


Lambda parameter
----------------

The $\lambda$ parameter weights the two parts of the cost
function. Therefore we should expect to see results closer to the
original image for large values of $\lambda$, and results with a
stronger denoising effect for small values of $\lambda$. The following
pictures with 4 different values for $\lambda$ show this effect:

\begin{figure}[h!]
\setcounter{subfigure}{0}
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{vlow_lambda.png}
\caption{$\lambda = 10$}
\label{original}
\end{subfigure}
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{low_lambda.png}
\caption{$\lambda = 50$}
\label{original}
\end{subfigure}
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{final.png}
\caption{$\lambda = 100$}
\label{input}
\end{subfigure}
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{high_lambda.png}
\caption{$\lambda = 1000$}
\label{input}
\end{subfigure}
\end{figure}

\newpage


Difference to the original image
--------------------------------

As our input image was syntethicaly generated and we do have the
complete original image, we can compare the result of this algorithm
to the original image. The following figure shows the sum of squared
distances (SSD) between the result and the original image, depending
on the $\lambda$ parameter:

\begin{figure}[h!]
\centering
\includegraphics[width=0.7\textwidth]{plot.png}
\label{plot}
\end{figure}

The closest result was achieved with a $\lambda$ of 103 and had a SSD
to the original of 140:

\begin{figure}[h!]
\centering
\includegraphics[width=0.5\textwidth]{best.png}
\label{best}
\end{figure}


