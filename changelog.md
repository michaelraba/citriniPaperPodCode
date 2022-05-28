
# Table of Contents

1.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-28 Sat&gt;</span></span>](#orgb2c5f18)
2.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-27 Fri&gt;</span></span>](#org8812a93)
3.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-26 Thu&gt;</span></span>](#orgeddbb57)
4.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-25 Wed&gt;</span></span>](#orgbf5ff9e)
5.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-24 Tue&gt;</span></span>](#orge88dd31)
6.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-22 Sun&gt;</span></span>](#org04cdb54)
7.  [Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-21 Sat&gt;</span></span>](#org5a0e034)
8.  [Changes  <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-20 Fri&gt;</span></span>](#org1c94a0a)



<a id="orgb2c5f18"></a>

# Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-28 Sat&gt;</span></span>

-   make correlation matrix option to:
    1.  use either direct multiplication,
    2.  xcorr (which is then formed into a symmetric matrix with 0 lag on the diagonal)
    3.  use corrcoef(y,ctranspose()). This gives 1 along the diagonal.


<a id="org8812a93"></a>

# Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-27 Fri&gt;</span></span>

1.  finish u save/import. ran pod.
    -   r is incorrect.  change to real radius $[0,R]= 0.5$ and $dr$ presumably $0.5/540$.


<a id="orgeddbb57"></a>

# Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-26 Thu&gt;</span></span>

1.  Almost done with POD. Refactored: so no moore xcorr with AzimuthalModes5.m
2.  started direct correlation hellstrom 2017. need to refactor the save/load of velocity signal in $t,m,k,r$. Really annoying part! because:
3.  Needed to refactor the velocity signal load/save mechanism. 
    1.  saving happens in timebloc, but also crosssection. But:
    2.  I need to then later load in crosssection and then time bloc, and then save that.
    3.  So that&rsquo;s juggling three competing tasks!

Note that (2) has mistakes, so needs fixing. 


<a id="orgbf5ff9e"></a>

# Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-25 Wed&gt;</span></span>

1.  finish most of pod, but has mistakes with using xcorr. Some nonsense with snapshot that didn&rsquo;t occur with classical pod.


<a id="orge88dd31"></a>

# Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-24 Tue&gt;</span></span>

1.  refactored lot of stuff, lot of reading done today (helped with eg Tuesday-Thursday work).


<a id="org04cdb54"></a>

# DONE Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-22 Sun&gt;</span></span>

-   1. adding snapshot pod.
-   2. change temporal dim from ntimesteps to 2\*ntimesteps -1, after xcorr application in time direction


<a id="org5a0e034"></a>

# Changes <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-21 Sat&gt;</span></span>

1.  spectral analysis following Smits2017. fft(x,theta) and correlate in time, then average radially (weighted).


<a id="org1c94a0a"></a>

# Changes  <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-05-20 Fri&gt;</span></span>

1.  start of branch using Citrini&rsquo;s paper for snapshot pod
2.  remove correlation step from fft procedure
3.  implement equations (3.4)-(3.5) from Citrini and George 2000.

