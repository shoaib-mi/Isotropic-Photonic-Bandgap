// use this line to speed up running time -> g++ -I c:\c_libs -O3 -march=native -o PBG-R3-data-measurements PBG-R3-data-measurements.cpp
#include <iostream> // needed for read/write in cmd
#include <fstream> // needed for read/write files 
#include <iomanip> //needed for setprecision
#include <Eigen/Dense> // needed for doing matrix manipulations
#include <cmath> // needed for arithmetic functions
#include <complex> // needed for doing calculations in complex numbers
#include <cstdlib> // for convert string to number
#include <ctime> // for measuring time
#include <filesystem> // required for creating folders and check for their existence

using namespace std; // needed for removing (std::) from function usages
using namespace Eigen; 
using cd = complex<double>; // used for simplifying the code syntax

// Define global necessary variables
double phase_step = 1e-4;
double omega_21 = 1.0;
double eps = 1e-8;
double delta_10 = -2.0;
double delta_20 = -1.0;
double t, eval1, eval2, eval3, f_phi_phi, f_theta_theta, f_phi_theta, sigma, isigma, coherency;
cd h1, h2;
Vector3cd evec1, evec2, evec3; // 3*1 complex column vectors
Matrix3cd ket1_rho, ket2_rho, ket3_rho, ket1_eigen_rho, ket2_eigen_rho, ket3_eigen_rho; // 3*3 complex matrices

double fisher(Matrix3cd drho_a,Matrix3cd drho_b){
    cd tmp1=0.0, tmp2=0.0, tmp3=0.0, tmp4=0.0, tmp5=0.0, tmp6=0.0, tmp7=0.0, tmp8=0.0, tmp9=0.0;
    cd x1, x2;
    if(eval1>eps){
        x1 = evec1.adjoint() * drho_a * evec1;
        x2 = evec1.adjoint() * drho_b * evec1;
        tmp1 = x1 * x2 / (2.0*eval1);
    }
    if(eval2>eps){
        x1 = evec2.adjoint() * drho_a * evec2;
        x2 = evec2.adjoint() * drho_b * evec2;
        tmp2 = x1 * x2 / (2.0*eval2);
    }
    if(eval3>eps){
        x1 = evec3.adjoint() * drho_a * evec3;
        x2 = evec3.adjoint() * drho_b * evec3;
        tmp3 = x1 * x2 / (2.0*eval3);
    }
    if((eval1+eval2)>eps){
        x1 = evec1.adjoint() * drho_a * evec2;
        x2 = evec2.adjoint() * drho_b * evec1;
        tmp4 = x1 * x2 / (eval1 + eval2);
        x1 = evec2.adjoint() * drho_a * evec1;
        x2 = evec1.adjoint() * drho_b * evec2;
        tmp5 = x1 * x2 / (eval1 + eval2);
    }
    if((eval1+eval3)>eps){
        x1 = evec1.adjoint() * drho_a * evec3;
        x2 = evec3.adjoint() * drho_b * evec1;
        tmp6 = x1 * x2 / (eval1 + eval3);
        x1 = evec3.adjoint() * drho_a * evec1;
        x2 = evec1.adjoint() * drho_b * evec3;
        tmp7 = x1 * x2 / (eval1 + eval3);
    }
    if((eval3+eval2)>eps){
        x1 = evec3.adjoint() * drho_a * evec2;
        x2 = evec2.adjoint() * drho_b * evec3;
        tmp8 = x1 * x2 / (eval3 + eval2);
        x1 = evec2.adjoint() * drho_a * evec3;
        x2 = evec3.adjoint() * drho_b * evec2;
        tmp9 = x1 * x2 / (eval3 + eval2);
    }
    return 2.0 * real(tmp1 + tmp2 + tmp3 + tmp4 + tmp5 + tmp6 + tmp7 + tmp8 + tmp9);
}

vector<string> readLines(const string& filePath) {
    vector<string> lines;
    ifstream file(filePath);

    if (!file) {
        cerr << "Unable to open file: " << filePath << endl;
        return(lines);
    }

    string line;
    while (getline(file, line)) {
        lines.push_back(line);
    }

    file.close();
    return(lines);
}

vector<string> split(const string& str, char delimiter) {
    vector<string> tokens;
    string token;
    istringstream tokenStream(str);
    while (getline(tokenStream, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}

void parseLine(const string& line, double& t, cd& h1, cd& h2){
    vector<string> parts = split(line, ',');
    t = stod(parts[0]);
    h1 = cd(stod(parts[1]), stod(parts[2]));
    h2 = cd(stod(parts[3]), stod(parts[4]));
}

Matrix3cd density_matrix(double t, cd h1, cd h2){
    Matrix3cd result;
    result << norm(h1), h1 * conj(h2) * exp(-cd(0.0, omega_21*t)), cd(0.0, 0.0),
              h2 * conj(h1) * exp(cd(0.0, omega_21*t)), norm(h2), cd(0.0, 0.0),
              cd(0.0, 0.0), cd(0.0, 0.0), 1.0 - norm(h1) - norm(h2);
    return result;
}

void eigensystem(double t, cd h1, cd h2, double& e_value_1, double& e_value_2, double& e_value_3, Vector3cd& e_vector_1, Vector3cd& e_vector_2, Vector3cd& e_vector_3){
    /*Matrix3cd rho = density_matrix(t,h1,h2);
    SelfAdjointEigenSolver<Matrix3cd> es(rho);
    Vector3d evals = es.eigenvalues();  // real eigenvalues
    Matrix3cd evecs = es.eigenvectors(); // columns = eigenvectors
    cout << evals << endl;
    cout << evecs << endl;
    e_value_1 = evals[0];
    e_value_2 = evals[1];
    e_vector_1 = evecs[0];
    e_vector_2 = evecs[1];*/
    if((norm(h1)<eps) and norm(h2)<eps){
        e_value_1 = 1.0;
        e_value_2 = 0.0;
        e_value_3 = 0.0;
        e_vector_1 << 0.0,0.0,1.0;
        e_vector_2 << 0.0,1.0,0.0;
        e_vector_3 << 1.0,0.0,0.0;
    }
    else if((norm(h1)<eps) and (norm(h2)>eps)){
        e_value_1 = 0.0;
        e_value_2 = norm(h2);
        e_value_3 = 1.0 - norm(h2);
        e_vector_1 << 1.0,0.0,0.0;
        e_vector_2 << 0.0,1.0,0.0;
        e_vector_2 << 0.0,0.0,1.0;
    }
    else if((norm(h1)>eps) and (norm(h2)<eps)){
        e_value_1 = norm(h1);
        e_value_2 = 0.0;
        e_value_3 = 1.0 - norm(h1);
        e_vector_1 << 1.0,0.0,0.0;
        e_vector_2 << 0.0,1.0,0.0;
        e_vector_2 << 0.0,0.0,1.0;
    }
    else{
        e_value_1 = norm(h1) + norm(h2);
        e_value_2 = 0.0;
        e_value_3 = 1.0 - norm(h1) - norm(h2);
        e_vector_1 << h1*exp(cd(0.0,delta_10*t)) / sqrt(e_value_1), h2*exp(cd(0.0,delta_20*t)) / sqrt(e_value_1), 0.0;
        if(e_value_1 == 1){
            e_vector_2 << 0.0, 0.0, 1.0;
            e_vector_3 << -conj(h2)*exp(-cd(0.0,delta_20*t)), conj(h1)*exp(-cd(0.0,delta_10*t)), 0.0;
        }
        else{
            e_vector_2 << -conj(h2)*exp(-cd(0.0,delta_20*t)) / sqrt(e_value_1), conj(h1)*exp(-cd(0.0,delta_10*t)) / sqrt(e_value_1), 0.0;
            e_vector_3 << 0.0,0.0,1.0;
        }
    }
}


Matrix3cd eigen_density_matrix(double t, cd h1, cd h2, bool main_ket=false){
    Matrix3cd result;
    double e_value_1, e_value_2, e_value_3;
    Vector3cd e_vector_1, e_vector_2, e_vector_3;
    eigensystem(t, h1, h2, e_value_1, e_value_2, e_value_3, e_vector_1, e_vector_2, e_vector_3);
    if(main_ket==true){
        eval1 = e_value_1;
        eval2 = e_value_2;
        eval3 = e_value_3;
        evec1 = e_vector_1;
        evec2 = e_vector_2;
        evec3 = e_vector_3;
    }
    Matrix3cd tmp1 = e_vector_1 * e_vector_1.adjoint();
    Matrix3cd tmp2 = e_vector_2 * e_vector_2.adjoint();
    Matrix3cd tmp3 = e_vector_3 * e_vector_3.adjoint();
    result = e_value_1 * tmp1 + e_value_2 * tmp2 + e_value_3 * tmp3;
    return result;
}

int main(int argc, char* argv[]){
    cout << "This file is to measure parameters from data with this structure >> t,h1r, h1i, h2r, h2i" << endl;
    //ios_base::sync_with_stdio(false);
    string path = ".\\";
    //ofstream::sync_with_stdio(false);
    vector<string> ket1_lines = readLines(path + "ket1.csv");
    vector<string> ket2_lines = readLines(path + "ket2.csv");
    vector<string> ket3_lines = readLines(path + "ket3.csv");
    Matrix3cd drho_phi, drho_theta;
    ofstream output(path + "measurements.csv");
    
    if (!output.is_open()) {
        cerr << "Error opening file for writing" << endl;
        return(1);
    }
    
    output << "t,f_phi_phi,f_phi_theta,f_theta_theta,Sigma,Coherency,rho_22,rho_33,rho_11" << endl;
    for (size_t j=1;j<ket1_lines.size();j++) {
        parseLine(ket1_lines[j], t, h1, h2);
        ket1_rho = density_matrix(t,h1,h2);
        ket1_eigen_rho = eigen_density_matrix(t,h1,h2, true);

        parseLine(ket2_lines[j], t, h1, h2);
        ket2_rho = density_matrix(t,h1,h2);
        ket2_eigen_rho = eigen_density_matrix(t,h1,h2);

        parseLine(ket3_lines[j], t, h1, h2);
        ket3_rho = density_matrix(t,h1,h2);
        ket3_eigen_rho = eigen_density_matrix(t,h1,h2);

        drho_phi = (ket2_rho - ket1_rho) / phase_step;
        drho_theta = (ket3_rho - ket1_rho) / phase_step;

        f_phi_phi = fisher(drho_phi, drho_phi);
        f_phi_theta = fisher(drho_phi, drho_theta);
        f_theta_theta = fisher(drho_theta, drho_theta);

        sigma = (f_phi_phi + f_theta_theta) / (f_phi_phi * f_theta_theta - pow(f_phi_theta, 2));
        coherency = abs(ket1_rho(0, 1)) + abs(ket1_rho(0, 2)) + abs(ket1_rho(1, 0)) + abs(ket1_rho(1, 2)) + abs(ket1_rho(2, 0)) + abs(ket1_rho(2, 1));

        output << fixed << setprecision(16) << t << "," << f_phi_phi << "," << f_phi_theta << "," << f_theta_theta << "," << sigma << "," << coherency << "," << ket1_rho(0, 0).real() << "," << ket1_rho(1, 1).real() << "," << ket1_rho(2, 2).real() << endl;
    }
    output.close();
    cout << "measurement is done for path " << argv[1] << ". you can now access measurements.csv in order to plot figures." << endl;
    return(0);
}