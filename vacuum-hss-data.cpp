// use this line to speed up running time -> g++ -I c:\c_libs -O3 -march=native -o main main.cpp
#include <iostream> // required for read/write in cmd
#include <fstream> // required for read/write files 
#include <Eigen/Dense> // required for doing matrix calculations
#include <iomanip> //required for setprecision
#include <cmath> // required for arithmetic functions
#include <complex> // required for doing calculations in complex numbers
#include <cstdlib> // for convert string to number
#include <ctime> // for measuring time
#include <filesystem>

using namespace std; // required for removing (std::) from function usages
using namespace Eigen; 
using cd = complex<double>;

// Define constant and global values
const double pi = 3.141592653589793, t_min = 0.0, t_max = 20.0, eta = 1.0, omega_21 = 1.0, gamma_10 = 0.5, gamma_20 = 1.0;
const double gamma_bar = sqrt( gamma_10 * gamma_20 );
const double time_step = 1e-4;
const double phase_step = 1e-4;
const int length = (t_max - t_min)/time_step + 1;
const int buffer_size = 1000;
double phi_c = 0.0;
double phi_p;

// change these sets based on needs
double omega_set[] = {0.0, 0.1, 0.5, 1, 2, 3, 5, 7};
double phi_set[] = {0.0, pi/2, pi, 3*pi/2};
string phi_name_set[] = {"0", "pi-over-2", "pi", "3pi-over-2"};

// this function produce and save the data into output file
int produce_data(string fname, double omega, double phi){
	clock_t inner_start = clock();
	ofstream output_file(fname);

	VectorXd t(length);
	VectorXcd c1(length), c2(length);

	if(output_file.is_open()){
		t[0] = t_min;
		c1[0] = exp(cd(0.0, phi)) / sqrt(3.0);
    	c2[0] = cd( 1.0 / sqrt(3.0), 0.0);
		
		output_file << "t:c1:c2" << endl;

		for(int j=0;j<length-1;j++){
	        //calculate next element of the arrays
	        t[j+1] = t[j] + time_step;
	        
	        c1[j+1] = c1[j] + time_step * ( - gamma_10 * c1[j] + ( omega * exp(cd(0.0, phi_c)) - eta * gamma_bar * exp(-cd(0.0, omega_21 * t[j])) ) * c2[j] );

			c2[j+1] = c2[j] + time_step * ( - gamma_20 * c2[j] - ( omega * exp(-cd(0.0, phi_c)) + eta * gamma_bar * exp(cd(0.0, omega_21 * t[j])) ) * c1[j] );

	    	output_file << fixed << setprecision(16) << t[j] << ":" << c1[j] << ":" << c2[j] << endl;
		}
		cout << "Calculating and Saving Density Matrix into " << fname << " is finished" << endl;
	}
	output_file.close();
	return(1);
}

int main(int argc, char* argv[]){
	//ofstream::sync_with_stdio(false);
	int omega_set_size = sizeof(omega_set) / sizeof(omega_set[0]);
	if (argc != 3){
		cout << "Use this convention: main.exe omega phi" << endl;
		cout << "this is what you used: ";
		for(int j=0;j<argc;j++){
			cout << argv[j] << " ";
		}
		cout << endl;
		return(0);
	}
	
	double omega = omega_set[atoi(argv[1])];
	phi_p = phi_set[atoi(argv[2])];

	string path = 
        "omega-is-" + to_string(omega) + "\\" +
        "phi-is-" + phi_name_set[atoi(argv[2])] + "\\";
    cout << path << endl;
    cout << "Phi_p = " << phi_p << endl;
	if(!filesystem::exists(path)) {
        	if(filesystem::create_directories(path)){
        		cout << "path created successfully" << endl;
        	}
        }
    
    clock_t start = clock(); // start time
	int result;
	result = produce_data(path + "ket1.csv", omega, phi_p);
	result = produce_data(path + "ket2.csv", omega, phi_p + phase_step);

	clock_t end = clock(); // end time
    double duration = double(end - start) / CLOCKS_PER_SEC;
    cout << "Producing data for ket1 took " << duration << " seconds" << endl;
	return(0);
}