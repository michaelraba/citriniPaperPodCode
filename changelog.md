
# Table of Contents

1.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-22 Sun&gt;</span></span>](#org61e4849)
2.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-21 Sat&gt;</span></span>](#org38acd1f)
3.  [Changes  <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-20 Fri&gt;</span></span>](#org90c9f82)



<a id="org61e4849"></a>

# DONE Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-22 Sun&gt;</span></span>

-   1. adding snapshot pod.
-   2. change temporal dim from ntimesteps to 2\*ntimesteps -1, after xcorr application in time direction


<a id="org38acd1f"></a>

# Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-21 Sat&gt;</span></span>

1.  spectral analysis following Smits2017. fft(x,theta) and correlate in time, then average radially (weighted).


<a id="org90c9f82"></a>

# Changes  <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-20 Fri&gt;</span></span>

1.  start of branch using Citrini&rsquo;s paper for snapshot pod
2.  remove correlation step from fft procedure
3.  implement equations (3.4)-(3.5) from Citrini and George 2000.

