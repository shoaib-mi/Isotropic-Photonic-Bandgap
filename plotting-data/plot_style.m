clc;
clearvars;
close all;

%% plot style
unit = "centimeters";
box_linewidth = 0.5;
curve_linewidth = 1.0;
title_fontsize = 7.0;
title_fontName = 'Times New Roman';
title_fontWeight = 'normal';
xlabel_fontsize = 8.0;
ylabel_fontsize = 8.0;
ylabel_fontWeight = 'bold';
legend_fontsize = 7.0;
tick_fontsize = 7.0;
marker_fontname = 'Times New Roman';
marker_fontsize = 10;
marker_fontweight = 'normal';
colors = {[1 0.3 0],[0 0.5 0],[0 0 0.8],[0 0 0]};
titles = {'Atom in Free Space', 'Atom in PBG'};
xlabels = {'$\gamma t$', '$\beta t$'};
ratio = 0.85;
gamma_labels = {'$\Omega=0.1\gamma$', '$\Omega=0.5\gamma$', '$\Omega=3\gamma$','$\Omega=5\gamma$'};
beta_labels = {'$\Omega=0.1\beta$', '$\Omega=0.5\beta$', '$\Omega=3\beta$', '$\Omega=5\beta$'};