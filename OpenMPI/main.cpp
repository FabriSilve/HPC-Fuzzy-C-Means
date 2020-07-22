#include "fuzzy_functions.h"

#ifdef MEDIUM
	#define DATASET_NAME "../common/dataset/medium.csv"
	#define RESULT "../common/python_plot/medium_out_MPI.csv"
#elif BIG
	#define DATASET_NAME "../common/dataset/big.csv"
	#define RESULT "../common/python_plot/big_out_MPI.csv"
#else
	#define DATASET_NAME "../common/dataset/small.csv"
	#define RESULT "../common/python_plot/small_out_MPI.csv"
#endif

int main(int argc, char **argv) {
	srand(time(nullptr));

	point *X = new point[SIZE];
	int *Y = new int[SIZE];

	FILE *dataset = fopen(DATASET_NAME, "r");
	for (int i=0; i<SIZE; i++) {
		for (int k=0; k<DIM; k++) {
			fscanf(dataset, "%lg ", &X[i].dims[k]);
		}
	}
	fclose(dataset);

	int P, myid;

	MPI_Init(nullptr, nullptr);
	MPI_Comm_size(MPI_COMM_WORLD, &P);
	MPI_Comm_rank(MPI_COMM_WORLD, &myid);

	fuzzyCMeans(X, Y, P, myid);

	MPI_Finalize();

	std::cout << "HERE I AM.... ROCK YOU LIKE A HURRICANE!!!!" << std::endl;
	printDataset(X, Y, RESULT, true);

	delete[] X;
	delete[] Y;

	return 0;
}
