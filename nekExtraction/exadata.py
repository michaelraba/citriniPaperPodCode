#=============================================================================#
# exadata                                                                     #
#                                                                             #
#                                                                             #
#                                                                             #
# Authors: Jacopo Canton, Nicolo' Fabbiane                                    #
# Contacts: jcanton(at)mech.kth.se, nicolo(at)mech.kth.se                     #
# Last edit: 2016-01-28                                                       #
#=============================================================================#
import numpy as np

#==============================================================================
class datalims:
	"""
	    datalims
	    A class containing the extrema of all quantities stored in the mesh
	"""
	def __init__(self, var):
		#                    x,y,z   min,max
		self.pos  = np.zeros((3     , 2))
		#                    u,v,w   min,max
		self.vel  = np.zeros((3     , 2))
		#                    p       min,max
		self.pres = np.zeros((var[2], 2))
		#                    T       min,max
		self.temp = np.zeros((var[3], 2))
		#                    s_i     min,max
		self.scal = np.zeros((var[4], 2))

#==============================================================================
class elem:
	"""
	    elem
	    A class containing one nek element/SIMSON flow field
	"""
	def __init__(self, var, lr1):
		#                    x,y,z   lz      ly      lx
		self.pos  = np.zeros((3     , lr1[2], lr1[1], lr1[0]))
		#                    one per edge
		self.curv = np.zeros((12, 1))
		#                    u,v,w   lz      ly      lx
		self.vel  = np.zeros((3     , lr1[2], lr1[1], lr1[0]))
      #                    p       lz      ly      lx     
		self.pres = np.zeros((var[2], lr1[2], lr1[1], lr1[0]))
      #                    T       lz      ly      lx     
		self.temp = np.zeros((var[3], lr1[2], lr1[1], lr1[0]))
      #                    s_i     lz      ly      lx     
		self.scal = np.zeros((var[4], lr1[2], lr1[1], lr1[0]))
		#                    list of 8 parameters, one per face
		self.bcs  = np.zeros((6), dtype='a1, i4, i4, f8, f8, f8, f8, f8')

#==============================================================================
class exadata:
	"""
	    data
	    A class containing data for reading/writing binary simulation files
	"""
# ndim - number of dimensions (2-3)
# nel  - number of elements
# lr1  - polynomial order in each dimension
# var  - vector of variables ex: (3,3,1,1,0) for x,y,z-u,v,w-P-T-S
# lims - array for each variable type containing min and max values
# wdsz - word size  = 'f' or 'd' for 4 or 8

	def __init__(self, ndim, nel, lr1, var):
		self.ndim   = ndim
		self.nel    = nel
		self.ncurv  = []
		self.var    = var
		self.lr1    = lr1
		self.time   = []
		self.istep  = []
		self.wdsz   = []
		self.endian = []
		self.lims   = datalims(var)
		self.elem   = [elem(var, lr1) for i in range(nel)]
