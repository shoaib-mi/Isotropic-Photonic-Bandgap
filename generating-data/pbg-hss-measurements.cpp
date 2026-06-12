// use this line to speed up running time -> g++ -I C:\c_libs -O3 -march=native -o hss-measurements hss-measurements.cpp
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

double phase_step = 1e-4;
double omega_21 = 1.0;

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

void parseLine(const string& line, double& t, cd& h1, cd& h2) {
    int index = line.find(':');
    string edited_line;
    if(index != -1){
        //cout << "old format file" << endl;
        string tmp = line.substr(0,line.size()-1);
        edited_line = tmp.substr(0, index) + ",";
        tmp = tmp.substr(index+2, tmp.size());
        index = tmp.find(')');
        edited_line = edited_line + tmp.substr(0, index) + "," + tmp.substr(index+3);
    }
    else{
        edited_line = line;
    }
    vector<string> parts = split(edited_line, ',');
    t = stod(parts[0]);
    h1 = cd(stod(parts[1]), stod(parts[2]));
    h2 = cd(stod(parts[3]), stod(parts[4]));
}

Matrix3cd density_matrix(cd h1, cd h2, cd h0){
    cd rho_11 = h1 * conj(h1);
    cd rho_22 = h2 * conj(h2);
    cd rho_33 = 1.0 - rho_11 - rho_22;
    cd rho_12 = h1 * conj(h2);
    cd rho_13 = h1 * conj(h0);
    cd rho_23 = h2 * conj(h0);

    Matrix3cd rho;
    rho << rho_22, conj(rho_12), rho_23,
           rho_12, rho_11, rho_13,
           conj(rho_23), conj(rho_13), rho_33;
    return rho;
}

int main(int argc, char* argv[]){
    ios_base::sync_with_stdio(false);
    ostringstream path;
    path << ".\\";
    vector<string> ket1_lines = readLines(path.str() + "ket1.csv");
    vector<string> ket2_lines = readLines(path.str() + "ket2.csv");
    
    double t, HSS, drho_dphi_2_trace;
    cd h1, h2, h0;
    Matrix3cd ket1_rho, ket2_rho, drho_dphi, drho_dphi_2;

    ofstream output(path.str() + "measurements.csv");
    
    if (!output.is_open()) {
        cerr << "Error opening file for writing" << endl;
        return(1);
    }

    output << "t,HSS" << endl;
    h0 = cd(1.0 / sqrt(3.0), 0.0);
    for (size_t j=1;j<ket1_lines.size();j++) {
        parseLine(ket1_lines[j], t, h1, h2);
        ket1_rho = density_matrix(h1, h2, h0);

        parseLine(ket2_lines[j], t, h1, h2);
        ket2_rho = density_matrix(h1, h2, h0);

        drho_dphi = (ket2_rho - ket1_rho) / phase_step;
        drho_dphi_2 = drho_dphi * drho_dphi;
        drho_dphi_2_trace = drho_dphi_2.trace().real();
        HSS = sqrt( drho_dphi_2_trace / 2.0);

        output << fixed << setprecision(16) << t << "," << HSS << endl;
    }
    output.close();
    cout << "measurement is done for path " << argv[1] << ". you can now access measurements.csv in order to plot figures." << endl;
    return(0);
}