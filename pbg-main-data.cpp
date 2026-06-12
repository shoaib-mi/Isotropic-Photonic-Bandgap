// use this line to speed up running time -> g++ -I C:\c_libs -O3 -march=native -o wdata-main data-main.cpp
#include <iostream> // required for read/write in cmd
#include <fstream> // required for read/write files 
#include <iomanip> //required for setprecision
#include <Eigen/Dense> // required for doing matrix calculations
#include <cmath> // required for arithmetic functions
#include <complex> // required for doing calculations in complex numbers
#include <cstdlib> // for convert string to number
#include <ctime> // for measuring time
#include <filesystem>

using namespace std; // required for removing (std::) from function usages
using namespace Eigen; 

// Define constant and global values
const double pi = 3.141592653589793, t_min = 0.0, t_max = 30.0, eta = 1.0, omega_21 = 1.0;
const complex<double> i(0, 1);
const complex<double> alpha = exp(-i*pi/4.0)/sqrt(pi);
const double time_step = 1e-4;
const double phase_step = 1e-4;
const int length = (t_max - t_min)/time_step + 1;
const int buffer_size = 1000;
double theta = pi/2;
// change these sets based on needs
double omega_set[] = {0.0, 0.01, 0.1, 1, 2, 3, 4, 5, 7, 10};
double phi_set[] = {0.0, pi/2, pi, 3*pi/2};
string phi_name_set[] = {"0", "pi-over-2", "pi", "3pi-over-2"};

// this function produce and save the data into output file
int produce_data(string fname, int region, double omega, double theta, double phi){
	clock_t inner_start = clock();
	ofstream output_file(fname);

	// define variables
	double delta_10, delta_20, eigenvalue;
	VectorXd t(length);
	VectorXcd h1(length), h2(length); 
	
	if(region == 1){
		delta_10 = -0.1;
        delta_20 = 0.9;
	}
    else if(region == 2){
    	delta_10 = -0.8;
        delta_20 = 0.2;
    }
    else if(region == 3){
    	delta_10 = -2.0;
        delta_20 = -1.0;
    }
    else{
    	cout << "value entered for region is incorrect" << endl;
    	return(0);
    }

	if(output_file.is_open()){
		t[0] = t_min;
		h1[0] = sin(theta/2) * exp(i * phi);
    	h2[0] = cos(theta/2) + 0.0*i;
		
		stringstream buffer; // Store data in memory first
		output_file << "t,h1r,h1i,h2r,h2i" << endl;

		for(int j=0;j<length-1;j++){
	        //calculate next element of the arrays
	        t[j+1] = t[j] + time_step;
	        complex<double> sum_1 = 0.0, sum_2 = 0.0;
        	for(int k=0;k<j;k++){
	        	sum_1 += sqrt(t[j] - t[k]) * (h1[k+1] - h1[k] + eta * h2[k+1] - eta * h2[k]);
        		sum_2 += sqrt(t[j] - t[k]) * (h2[k+1] - h2[k] + eta * h1[k+1] - eta * h1[k]);
	        }

	        h1[j+1] = h1[j] + time_step * ( - i * delta_10 * h1[j] + omega * exp( i * omega_21 * t[j] ) * h2[j] - 2.0 * alpha * sqrt(t[j]) * (h1[0] + eta * h2[0]) - 2.0 * alpha * sum_1 );

	        h2[j+1] = h2[j] + time_step * ( - i * delta_20 * h2[j] - omega * exp( - i * omega_21 * t[j] ) * h1[j] - 2.0 * alpha * sqrt(t[j]) * (h2[0] + eta * h1[0]) - 2.0 * alpha * sum_2 );

	    	buffer << fixed << setprecision(16) << t[j] << "," << real(h1[j]) << "," << imag(h1[j]) << "," << real(h2[j]) << "," << imag(h2[j]) << endl;

	    	if (j % (length / 10) == 0 || j % 500 == 0) {
                output_file << buffer.str();
                buffer.str("");
            }
		}
		output_file << buffer.str();
		cout << "Calculating and Saving Density Matrix into " << fname << " is finished" << endl;
	}
	output_file.close();
	return(1);
}


int main(int argc, char* argv[]){
	//ofstream::sync_with_stdio(false);
	int omega_set_size = sizeof(omega_set) / sizeof(omega_set[0]);
	if (argc != 4){
		cout << "Use this convention: run.exe region omega phi" << endl;
		cout << "region: 1..4" << endl;
		cout << "omega: 0..9  <==>  " ;
		//cout << omega_set.repr() << endl;
		//cout << "phi = 0..3   <==>  " << to_string_array(phi_name_set) << endl;
		cout << "this is what you used: ";
		for(int j=0;j<argc;j++){
			cout << argv[j] << " ";
		}
		cout << endl;
		return(0);
	}
	
	int region = atoi(argv[1]); //for converting string to int use atoi, to double use atof
	double omega = omega_set[atoi(argv[2])];
	double phi = phi_set[atoi(argv[3])];
	string path = 
        "omega-is-" + to_string(omega) + "/" +
        "region-is-" + to_string(region) + "/" +
        "phi-is-" + phi_name_set[atoi(argv[3])] + "/";

    #ifdef _WIN32
        replace(path.begin(), path.end(), '/', '\\');
	#elif __linux__
	    replace(path.begin(), path.end(), '\\', '/');
	#elif __APPLE__
	    replace(path.begin(), path.end(), '\\', '/');
	#else
	    cout << "Unknown Operating System" << std::endl;
	#endif
	if(!filesystem::exists(path)) {
        	if(filesystem::create_directories(path)){
        		cout << "path created successfully" << endl;
        	}
        }
    
    clock_t start = clock(); // start time
	int result;
	result = produce_data(path + "ket1.csv", region, omega, theta, phi);
	result = produce_data(path + "ket2.csv", region, omega, theta, phi + phase_step);
	result = produce_data(path + "ket3.csv", region, omega, theta + phase_step, phi);

	clock_t end = clock(); // end time
    double duration = double(end - start) / CLOCKS_PER_SEC;
    cout << "Producing data for ket1 took " << duration << " seconds" << endl;
	return(0);
}