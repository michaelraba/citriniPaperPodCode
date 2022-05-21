
# Table of Contents

1.  [Proper Orthogonal Decompositon (Snapshot POD) Code](#org6e6ae36)
2.  [Description](#org38af305)
3.  [Part 1: Spectral Analysis Procedure](#org13dbb7c)
4.  [Part 2: Snapshot POD Procedure](#org4b89c3d)
5.  [Sources:](#org1aada2a)


<a id="org6e6ae36"></a>

# Proper Orthogonal Decompositon (Snapshot POD) Code


<a id="org38af305"></a>

# Description

Follows the paper by [Citrini and George 2000](https://www.cambridge.org/core/journals/journal-of-fluid-mechanics/article/abs/reconstruction-of-the-global-velocity-field-in-the-axisymmetric-mixing-layer-utilizing-the-proper-orthogonal-decomposition/68BAA266FC58F299B2D9DA612C8F4A6C) ,  which is used by

[Hellstrom and Smits 2017](https://royalsocietypublishing.org/doi/full/10.1098/rsta.2016.0086) and [Ganapathisubramani, Hellstrom, and Smits 2015](https://www.cambridge.org/core/journals/journal-of-fluid-mechanics/article/abs/evolution-of-largescale-motions-in-turbulent-pipe-flow/CB2FF14595A6E552DF8A554FE489CBE9).


<a id="org13dbb7c"></a>

# Part 1: Spectral Analysis Procedure

The process of taking azimuthal and streamwise FFT is described in this section. The motivation for taking in both directions is described in eg (source).


<a id="org4b89c3d"></a>

# Part 2: Snapshot POD Procedure

1.  According to source (cite), the POD equation in pipe coordinates may be written as,

$$\int_{r^{\prime}} \boldsymbol{S}\left(m ; r, r^{\prime}\right) \Phi_{n}\left(m ; r^{\prime}\right) \mathrm{d} r^{\prime}=\lambda_{n}(m) \Phi_{n}(m ; r)$$

where $n$ represents the POD mode number, $\Phi_{n}$ are the eigenfunctions with the corresponding eigenvalues $\lambda_{n}$, and $m$ represents the azimuthally decomposed mode number. Here, $r$ from the polar integration is absorbed into the eigenfunctions and the cross-correlation tensor.

1.  Define the time-averaged cross-correlation tensor as

$$\mathbf{S}\left(m ; r, r^{\prime}\right)=\lim_{\tau \rightarrow \infty} \frac{1}{\tau} \int_{0}^{\tau} r^{1 / 2} \boldsymbol{u}(m ; r, t) \boldsymbol{u}^{*}\left(m ; r^{\prime}, t\right) r^{1 / 2} \mathrm{~d} t$$

1.  Next write the projection coefficient $\alpha$ for the radial geometry as,
    
    $$\alpha_{n}(m ; t)=\int_{r} \boldsymbol{u}(m ; r, t) r^{1 / 2} \Phi_{n}^{*}(m ; r) \mathrm{d} r$$

2.  Then, we may rewrite the eigenvalue problem, which we will implement in the code

$$\lim_{\tau \rightarrow \infty} \frac{1}{\tau} \int_{0}^{\tau} r^{1 / 2} \boldsymbol{u}(m ; r, t) \alpha_{n}^{*}(m ; t) \mathrm{d} t=\Phi_{n}(m ; r) \lambda^{n}(m)$$

1.  The resulting solution $\alpha_n$ for $n\in \{1,\ldots , N\}$ is found from the above. From that, we may directly find the eigenfunctions $\Phi_n$, which are given by,
    
    $$\lim _{\tau \rightarrow \infty} \frac{1}{\tau} \int_{0}^{\tau} r^{1 / 2} \boldsymbol{u}(m ; r, t) \alpha_{n}^{*}(m ; t) \mathrm{d} t=\Phi_{n}(m ; r) \lambda^{n}(m)$$


<a id="org1aada2a"></a>

# Sources:

1.  Duggleby and Paul
2.  Citrini and George
3.  Smits 2014

