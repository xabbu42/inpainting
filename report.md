---
title:  Assignment 1
author: Nathan Gass
header-includes:
    - \usepackage{caption,subcaption}
    - \usepackage{mathtools}
    - \DeclarePairedDelimiter{\norm}{\lVert}{\rVert}
    - \DeclareMathOperator*{\argmin}{arg\,min}
	- \everymath{\displaystyle}
date: 10. April 2015
...

Problem
-------

Given a image $g$ with undefined or invalid pieces and a mask $\Omega$ identifing the valid parts of the image,
calculate a image with the missing parts filled in, depending on the surroundings in the image. 

Motivations
-----------

With this technique, one can restore damaged films and photographs.

Derivation
----------

The cost function used for inpainting is:

\begin{equation*}
E(u) = \frac{\lambda}{2} \norm{u - g}^2_\Omega + \norm{\nabla u}_2
\end{equation*}

We use the following descretized approximations:

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


Progress of Gradient Descent
----------------------------

\begin{figure}[h!]
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
\includegraphics[width=\textwidth]{final.png}
\caption{Final Image after 2500 iterations}
\label{input}
\end{subfigure}
\end{figure}

\newpage


Lambda parameter
----------------

\begin{figure}[h!]
\begin{subfigure}{0.5\textwidth}
\includegraphics[width=\textwidth]{low_lambda.png}
\caption{$\lambda = 1$}
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


Difference to original image
----------------------------

\begin{figure}[h!]
\includegraphics[width=\textwidth]{plot.png}
\label{plot}
\end{figure}

\begin{figure}[h!]
\includegraphics[width=0.5\textwidth]{best.png}
\label{best}
\end{figure}


