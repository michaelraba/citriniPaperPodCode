
# Table of Contents

1.  [Part 1. Spectral Analysis](#orgf057cdf)
2.  [Part 2. Snapshot POD](#org9b2752c)



<a id="orgf057cdf"></a>

# Part 1. Spectral Analysis

-   take fft azimuthally
    -   use half of $\theta$ data to avoid aliasing
-   find correlation in $t,t'$ described in Smits2017.below.eq.2.4.
    
    $$\mathbf{R}\left(k ; m ; t, t^{\prime}\right)=\int_{r} \mathbf{u}(k ; m ; r, t) \mathbf{u}^{*}\left(k ; m ; r, t^{\prime}\right) r \mathrm{~d} r \hspace{1in} (1)$$
-   take fft in $x$ of the above correlation to get $k$ modes.


<a id="org9b2752c"></a>

# Part 2. Snapshot POD

-   the crossspectra for the kernal of the pod
    
    $$\lim_{\tau \rightarrow \infty} \frac{1}{\tau} \int_{0}^{\tau} \mathbf{R}\left(k ; m ; t, t^{\prime}\right) \alpha^{(n)}\left(k ; m ; t^{\prime}\right) \mathrm{d} t^{\prime}=\lambda^{(n)}(k ; m) \alpha^{(n)}(k ; m ; t)\hspace{1 in} (2)$$

-   Find the (sorted) eigenvalues $\alpha^{(n)}$ found in (2) to solve for $\Phi^{(n)}$,
    
    $$\lim _{\tau \rightarrow \infty} \frac{1}{\tau} \int_{0}^{\tau} \mathbf{u}_{\mathrm{T}}(k ; m ; r, t) \alpha^{(n)^{*}}(k ; m ; t) \mathrm{d} t=\Phi_{\mathrm{T}}^{(n)}(k ; m ; r) \lambda^{(n)}(k ; m)$$

