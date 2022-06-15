#! /usr/bin/env python
import os
import sys
import numpy as np
import subprocess
from neksuite import *
import timing_utility as timing
import time
#----------------------------------------------------------------------------------------------------------------------------------
def readPipeVolumeFile(volfiledir,casename,filenum,nel_cs,n_cs):
    '''
        Read pipe volume file data (written using NEK5000) and store data on required slices.
        Stores a list of elements which lie on the slices for files without coordinate data.
        
        Inputs:
                 1) volfiledir  : string     : Directory where all volume files from NEK5000 are stored (including the trailing '/').
                 2) casename    : string     : Name of case run with NEK5000.
                 3) filenum     : Integer    : Volume file number to be read.
                 4) nel_cs      : Integer    : Number of elements in a cross-section.
                 5) n_cs        : Integer    : Total number of cross-sections.
        Outputs:
                 1) cs_flowdata : Real array : Array containing flow field data across n_cs cross-sections from the 
                                               the volume file.
                 2) lx1         : Integer    : Polynomial order of mesh in x-direction.
                 3) ly1         : Integer    : Polynomial order of mesh in y-direction.
                 4) cs_locations: Real array : Array containing streamwise locations of cross-sections to be output
    '''
    filename    = volfiledir+casename+'0.f'+str(filenum).zfill(5)
    
    pipeLength  = 12.5      #Length of pipr
    cs_location = np.linspace(0,pipeLength,n_cs+1)[0:n_cs] #Streamwise locations of cross-sections (or start of elements)

    if (filenum == 1):    
        zref = cs_location[0]
        print('---Reading coordinates for cross-sections from first volume file.')
        coord_read_start = time.time()
        nel,lx1,ly1,lz1,cs_coords = readCoordinatesFromVolumeFile(filename,nel_cs,zref)
        coord_read_end = time.time()
        coord_read_time = coord_read_end - coord_read_start
        timing.convertTime2hhmmss(coord_read_time,"---Coordinates for cross-sections read in")
        
    print('---Extracting cross-sections')
    cs_extract_start = time.time()
    cs_flowdata = readSlicesFromVolumeFile(filename,lx1,ly1,nel,nel_cs,n_cs,cs_location,cs_coords)
    cs_extract_end = time.time()
    cs_extract_time = cs_extract_end - cs_extract_start
    timing.convertTime2hhmmss(cs_extract_time,"---Cross-sections extracted in")
              
    return cs_flowdata, lx1, ly1, cs_location
#----------------------------------------------------------------------------------------------------------------------------------
def readCoordinatesFromVolumeFile(filename,nel_cs,zref):
    '''
        1. Reads the first volume file (written using NEK500) and stores the coordinates of the xy-plane
           to a data array.
        2. Assumes that the sequence of elements on a cross-section doesn't change. If it does, the script
           will have to change (not implemented) and the xy-coordinates of each of the cross-sections will need to be extracted
           individually instead of just using the first cross-section, i.e., z = 0.
        Inputs: 
                1) filename  : string     : Name of the file containing NEK5000 volume data (including mesh coordinates).
                2) nel_cs    : Integer    : Number of elements in a cross-section.
                3) z_ref     : Real       : Location of slice where coordinates are being extracted, i.e., z = 0.
        Outputs:
                1) nel       : Integer    : Total number of elements in the 3D domain.
                2) lx1       : Integer    : Polynomial order of mesh in x-direction.
                3) ly1       : Integer    : Polynomial order of mesh in y-direction.
                4) lz1       : Integer    : Polynomial order of mesh in z-direction.
                5) cs_coords : Real array : Array containing the XY coordiantes of the points in a cross-section.
    '''

    data = readnek(filename)
    nel  = data.nel
    ndim = data.ndim
    var  = data.var
    lr1  = data.lr1
    lx1  = lr1[0]
    ly1  = lr1[1]
    lz1  = lr1[2]

    numpts_cs = nel_cs*lx1*ly1
    cs_coords = np.ones((numpts_cs,2))

    counter = 0
    
    for iel in range(nel_cs):
        for ix in range(lx1):
            for iy in range(ly1):
                z = data.elem[iel].pos[2,0,iy,ix]
                if (abs(z - zref) >= 1.0e-8):
                    print('[E] Streamwise location of cross-section for output of xy-coordinates: %6.3f'%(z))
                    print('[E] Streamwise reference location of first cross-section: %6.3f'%(zref))
                    print('[E] Location mismatch. Code exitting.')
                    sys.exit(8)
                x = data.elem[iel].pos[0,0,iy,ix]
                y = data.elem[iel].pos[1,0,iy,ix]
                
                cs_coords[counter,0:2] = [x,y]
                counter += 1
                
    return nel,lx1,ly1,lz1,cs_coords
#----------------------------------------------------------------------------------------------------------------------------------
def readSlicesFromVolumeFile(filename,lx1,ly1,nel,nel_cs,n_cs,cs_location,cs_coords):
    '''
        1. Reads in cross-sections containing the velocity and pressure data and stores them as arrays.
        2. The cross-sections being extracted are at the first z-collocation point of the corresponding element.
        3. It is assumed that all elements on a given cross-section being output are written out 
           sequentially by NEK.
        Inputs: 
                1) filename     : string     : Name of the file containing NEK5000 volume data (including mesh coordinates).
                2) lx1, ly1     : Integer    : Polynomial order in x and y
                3) nel          : Integer    : Total number of elements in domain
                4) nel_cs       : integer    : Number of elements in a cross-section.
                5) cs_locations : Real array : Array containing streamwise locations of cross-sections to be output
                6) cs_coords    : Real array : Array containing the XY coordiantes of the points in a cross-section.
        Outputs:
                1) cs_flowdata  : Real array : Array containing flow field data across n_cs cross-sections from the 
                                               volume file. [x,y,u,v,w,p]
    '''

    numpts_cs   = nel_cs*lx1*ly1
    cs_flowdata = np.ones((n_cs,numpts_cs,6))

    counter    = 0
    i_cs_reset = 0 

    data = readnek(filename)
    
    for iel in range(nel):
        i_cs = iel//nel_cs
        if (i_cs != i_cs_reset):
            if (counter != numpts_cs):
                print('[E] Not all points on cross-section were identified.')
                print('----Cross-section            : %8d'%(i_cs))
                print('----Cross-section location, z: %6.3f'%(cs_location[i_cs]))
                print('----Number of points found   : %8d'%(counter))
                print('----Number of points expected: %8d'%(numpts_cs))
                print('[E] Code exitting.')
                sys.exit(9)
            counter    = 0      #Reset counter when the reader moves on to the next cs
            i_cs_reset = i_cs   #Update value of i_cs_reset for new cs location
        for ix in range(lx1):
            for iy in range(ly1):
                x = cs_coords[counter,0]
                y = cs_coords[counter,1]
                u = data.elem[iel].vel [0,0,iy,ix]
                v = data.elem[iel].vel [1,0,iy,ix]
                w = data.elem[iel].vel [2,0,iy,ix]
                p = data.elem[iel].pres[0,0,iy,ix]
                
                cs_flowdata[i_cs,counter,0:6] = [x,y,u,v,w,p]
                counter += 1

                
    return cs_flowdata
#----------------------------------------------------------------------------------------------------------------------------------
def writeVolumeData2File(filenum,outputdir,lx1,ly1,nel_cs,n_cs,cs_flowdata,cs_location):
    '''
       Write cross-section data from NEK5000 volume file into individual files each containing data for
       for one slice at a given timestep.
        Inputs: 
                1) filenum      : Integer    : Volume file number to be read.
                2) outputdir    : string     : Directory where cross-section outputs for the given slice will be saved.
                3) lx1, ly1     : Integer    : Polynomial order in x and y
                4) nel_cs       : integer    : Number of elements in a cross-section.
                5) n_cs         : Integer    : Total number of cross-sections being output.
                6) cs_flowdata  : Real array : Array containing flow field data across n_cs cross-sections from the 
                                               volume file. [x,y,u,v,w,p]
                7) cs_locations : Real array : Array containing streamwise locations of cross-sections to be output
    '''

    for i_cs in range(n_cs):
        zcoord  = cs_location[i_cs]
        filename = outputdir+'vol_'+str(filenum).zfill(5)+'_cs_'+str(i_cs+1).zfill(5)+'.dat'
        headerLine1 = 'VARIABLES = "x" "y" "u" "v" "w" "p"'+'\n'
        headerLine2 = 'ZONE T =  "Vol = %5.5d, Cross-Section = %5.5d, z = %6.3f"'%(filenum,i_cs+1,zcoord)
        headerLine = headerLine1 + headerLine2
        np.savetxt(filename,cs_flowdata[i_cs,:,:],fmt="%17.9e",header=headerLine)

    return 0
#----------------------------------------------------------------------------------------------------------------------------------
def main():


    volfiledir = 'pipeVolumeData/'
    casename   = 'pipe'

    #Crearte directory to store output cross-sections for different timesteps
    outputdir = 'output_cross_sections/'
    outputdir_cmd = 'mkdir -p '+outputdir
    os.popen(outputdir_cmd)

    nel_cs = 341
    n_cs   = 100
    n_time = 1
    
    for t in range(n_time):
        file_start = time.time()
        filenum = t+1
        print('[I] Processing volume file %d/%d.'%(filenum,n_time))
        #
        timestep_start = time.time()
        timedir = outputdir+'nt_'+str(filenum).zfill(4)+'/'
        timedir_cmd = 'mkdir -p '+timedir
        os.popen(timedir_cmd)
        #
        cs_flowdata,lx1,ly1,cs_location  = readPipeVolumeFile(volfiledir,casename,filenum,nel_cs,n_cs)
        #
        write_start = time.time()
        print('---Writing cross-sections to files.')
        writeVolumeData2File(filenum,timedir,lx1,ly1,nel_cs,n_cs,cs_flowdata,cs_location)
        write_end = time.time()
        write_time = write_end - write_start
        timing.convertTime2hhmmss(write_time,"---Cross-sections written to files in")
        #
        file_end = time.time()
        file_time = file_end - file_start
        file_string = '[I] Completed extraction of cross-sections for file %d/%d.'%(filenum,n_time)
        timing.convertTime2hhmmss(file_time,file_string)
        print('---------------------------------------------------------------------------------------------------')
        
    return 0

main()
        
