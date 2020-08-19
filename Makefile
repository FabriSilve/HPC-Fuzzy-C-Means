CC    = icpc
MPICC = mpiicc

FZY = fuzzycm

RPT_FLAGS = -qopt-report=2 -qopt-report-phase=vec
DEV_FLAGS = -Wall -pedantic -ggdb -Werror
COM_FLAGS = -ansi -std=c++17 -DBIG
PAR_FLAGS = -lm -qopenmp

SEQ = sequential
PAR = parallel
MPI = mpi

ST = static
GU = guided
DY = dynamic

BIN_DIR = bin
COM_DIR = common
RES_DIR = results
MPI_DIR = OpenMPI
MP_DIR  = OpenMP
SEQ_DIR = sequential
RPT_DIR = $(RES_DIR)/report

SEQ_CMD = $(CC) $(COM_FLAGS) $(SEQ)/*.cpp $(COM_DIR)/common.cpp
PAR_CMD = $(CC) $(COM_FLAGS) $(MP_DIR)/*.cpp $(COM_DIR)/common.cpp $(PAR_FLAGS)
MPI_CMD = $(MPICC) $(COM_FLAGS) $(MPI_DIR)/*.cpp $(COM_DIR)/common.cpp

.PHONY: clean all sequential parallel mpi


all: clean report sequential parallel mpi


report: | $(RPT_DIR) $(COM_DIR)
	@rm -f $(RPT_DIR)/*.optrpt
	$(CC) $(COM_FLAGS) $(DEV_FLAGS) $(RPT_FLAGS) -O0 $(SEQ)/*.cpp $(COM_DIR)/common.cpp -o $(BIN_DIR)/tmp
	@mv $(BIN_DIR)/*.optrpt $(RPT_DIR) 
	@rm -f $(BIN_DIR)/tmp


# SEQUENTIAL COMMANDS
sequential: sequential0 sequential2 sequentialF sequentialX

sequential0: | $(BIN_DIR)/$(SEQ)
	$(SEQ_CMD) -O0 -o $(BIN_DIR)/$(SEQ)/$(FZY)_O0
sequential2: | $(BIN_DIR)/$(SEQ)
	$(SEQ_CMD) -O2 -o $(BIN_DIR)/$(SEQ)/$(FZY)_O2
sequentialF: | $(BIN_DIR)/$(SEQ)
	$(SEQ_CMD) -Ofast -o $(BIN_DIR)/$(SEQ)/$(FZY)_Ofast
sequentialX: | $(BIN_DIR)/$(SEQ)
	$(SEQ_CMD) -xHost -o $(BIN_DIR)/$(SEQ)/$(FZY)_xHost


# PARALLEL COMMANDS
parallel: parallel0 parallel2 parallelF parallelX

parallel0: | $(BIN_DIR)/$(PAR)
	$(PAR_CMD) -DSTATIC -O0 -o $(BIN_DIR)/$(PAR)/$(ST)/$(FZY)_$(ST)_O0
	$(PAR_CMD) -DDYNAMIC -O0 -o $(BIN_DIR)/$(PAR)/$(DY)/$(FZY)_$(DY)_O0
	$(PAR_CMD) -O0 -o $(BIN_DIR)/$(PAR)/$(GU)/$(FZY)_$(GU)_O0
parallel2: | $(BIN_DIR)/$(PAR)
	$(PAR_CMD) -DSTATIC -O2 -o $(BIN_DIR)/$(PAR)/$(ST)/$(FZY)_$(ST)_O2
	$(PAR_CMD) -DDYNAMIC -O2 -o $(BIN_DIR)/$(PAR)/$(DY)/$(FZY)_$(DY)_O2
	$(PAR_CMD) -O2 -o $(BIN_DIR)/$(PAR)/$(GU)/$(FZY)_$(GU)_O2
parallelF: | $(BIN_DIR)/$(PAR)
	$(PAR_CMD) -DSTATIC -Ofast -o $(BIN_DIR)/$(PAR)/$(ST)/$(FZY)_$(ST)_Ofast
	$(PAR_CMD) -DDYNAMIC -Ofast -o $(BIN_DIR)/$(PAR)/$(DY)/$(FZY)_$(DY)_Ofast
	$(PAR_CMD) -Ofast -o $(BIN_DIR)/$(PAR)/$(GU)/$(FZY)_$(GU)_Ofast
parallelX: | $(BIN_DIR)/$(PAR)
	$(PAR_CMD) -DSTATIC -xHost -o $(BIN_DIR)/$(PAR)/$(ST)/$(FZY)_$(ST)_xHost
	$(PAR_CMD) -DDYNAMIC -xHost -o $(BIN_DIR)/$(PAR)/$(DY)/$(FZY)_$(DY)_xHost
	$(PAR_CMD) -xHost -o $(BIN_DIR)/$(PAR)/$(GU)/$(FZY)_$(GU)_xHost


# MPI COMMANDS
mpi: mpi0 mpi2 mpiF mpiX

mpi0:
	$(MPI_CMD) -O0 -o $(BIN_DIR)/$(MPI)/$(FZY)_$(MPI)_O0
mpi2:
	$(MPI_CMD) -O2 -o $(BIN_DIR)/$(MPI)/$(FZY)_$(MPI)_O2
mpiF:
	$(MPI_CMD) -Ofast -o $(BIN_DIR)/$(MPI)/$(FZY)_$(MPI)_Ofast
mpiX:
	$(MPI_CMD) -xHost -o $(BIN_DIR)/$(MPI)/$(FZY)_$(MPI)_xHost


# MP-MPI COMMANDS

# UTILITIES
clean: clean_rpt clean_bin

clean_rpt:
	rm -f $(RPT_DIR)/*
clean_bin:
	rm -f $(BIN_DIR)/$(SEQ)/*
	rm -f $(BIN_DIR)/$(PAR)/$(ST)/*
	rm -f $(BIN_DIR)/$(PAR)/$(DY)/*
	rm -f $(BIN_DIR)/$(PAR)/$(GU)/*
	rm -f $(BIN_DIR)/$(MPI)/*