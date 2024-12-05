#all:
#	ifort -g -o *.out *.f
#	ifort -c *.f
#	ifort *.o -o matrix.exe

#all:
#	ifort -g -o *.out *.f
#	ifort -c *.f
#	ifort *.o -o main.exe


fortran_compiler = ifort #Intel Fortran compiler
lib_dir = /home/jairo/Downloads/libfortran/libNAG.a #PATH_LIB path to the Library
SRCDIR =  /home/jairo/Documents/fortran_codes/matrix_test_4

# Name of the file to exclude (without path)
EXCLUDE = main.f

# Find all .f files in the source directory
src_files = $(wildcard $(SRCDIR)/*.f)

# Exclude the specified file
src_files := $(filter-out $(SRCDIR)/$(EXCLUDE), $(src_files))


obj_files := $(src_files:.f=.o)

main: $(obj_files)
	 $(fortran_compiler) -o ./main.exe ./main.f $(obj_files) $(lib_dir)
	 rm ./*.o

%.o: %.f
	 $(fortran_compiler) -c ./$(<F) -o ./$(<F:.f=.o)

clean:
	 rm ./*.o ./main.exe






################ Code for the whole files inside the simulator #########################
#src_files := acoustic.f apply_voltage.f check_boundary.f \
ckeck_source_drain.f coulomb_scattering.f count_electrons_used.f \
delete_particles.f device_structure.f displacement_current.f drift.f \
electric_field_update.f electrons_initialization.f free_flight_scatter.f \
heat_source.f init_kspace.f init_realspace.f intervalley_first_order.f \
intervalley.f mat_par_initialization.f NEC_scheme.f poisson_SOR.f \
renormalize_table.f scatter_carrier.f scattering_table.f thermal_acoust_SOR.f \
velocity_energy_cumulative.f write_electron_distribution.f write_monte_carlo_averages.f \