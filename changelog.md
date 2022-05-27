
# Table of Contents

1.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-26 Thu&gt;</span></span>](#orgbcbca2d)
2.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-25 Wed&gt;</span></span>](#org23e3bd3)
3.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-24 Tue&gt;</span></span>](#orgacac2a7)
4.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-22 Sun&gt;</span></span>](#org9305f1b)
5.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-21 Sat&gt;</span></span>](#org122d73a)
6.  [Changes  <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-20 Fri&gt;</span></span>](#org1c82484)



<a id="orgbcbca2d"></a>

# Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-26 Thu&gt;</span></span>

1.  Almost done with POD. Refactored: so no moore xcorr with AzimuthalModes5.m
2.  started direct correlation hellstrom 2017. need to refactor the save/load of velocity signal in $t,m,k,r$. Really annoying part! because:
3.  Needed to refactor the velocity signal load/save mechanism. 
    1.  saving happens in timebloc, but also crosssection. But:
    2.  I need to then later load in crosssection and then time bloc, and then save that.
    3.  So that&rsquo;s juggling three competing tasks!

Note that (2) has mistakes, so needs fixing. 


<a id="org23e3bd3"></a>

# Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-25 Wed&gt;</span></span>

1.  finish most of pod, but has mistakes with using xcorr. Some nonsense with

snapshot that didn&rsquo;t occur with classical pod. 


<a id="orgacac2a7"></a>

# Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-24 Tue&gt;</span></span>

1.  refactored lot of stuff.


<a id="org9305f1b"></a>

# DONE Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-22 Sun&gt;</span></span>

-   1. adding snapshot pod.
-   2. change temporal dim from ntimesteps to 2\*ntimesteps -1, after xcorr application in time direction


<a id="org122d73a"></a>

# Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-21 Sat&gt;</span></span>

1.  spectral analysis following Smits2017. fft(x,theta) and correlate in time, then average radially (weighted).


<a id="org1c82484"></a>

# Changes  <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-20 Fri&gt;</span></span>

1.  start of branch using Citrini&rsquo;s paper for snapshot pod
2.  remove correlation step from fft procedure
3.  implement equations (3.4)-(3.5) from Citrini and George 2000.

