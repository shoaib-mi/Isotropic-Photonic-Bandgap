
%% in this file you can see style variables
plot_style;
number_of_plots = 4;
if(number_of_plots == 4)
    fig_width = 7.9;
    fig_height = fig_width*ratio;
    h = figure(Units=unit, Position=[0, 0, fig_width, fig_height]);
    t = tiledlayout(2, 2, TileSpacing='compact', Padding='none');
    ax1 = nexttile;
    ax2 = nexttile;
    ax3 = nexttile;
    ax4 = nexttile;
elseif(number_of_plots == 2)
    fig_width = 7.9;
    fig_height = fig_width*ratio/2;
    h = figure(Units=unit, Position=[0, 0, fig_width, fig_height]);
    t = tiledlayout(1, 2, TileSpacing='compact', Padding='none');
    ax1 = nexttile;
    ax2 = nexttile;
else
    fig_width = 6;
    fig_height = fig_width*ratio;
    h = figure(Units=unit, Position=[0, 0, fig_width, fig_height]);
    t = tiledlayout(1, 1, TileSpacing='compact', Padding='none');
    ax1 = nexttile;
end

%% plot style
% data columns  are {'t','f_phi_phi','f_phi_theta','f_theta_theta','Sigma','Coherence','rho_22','rho_33','rho_11'};
i = 2; % F_phi_phi is the second column of the data
j = 4; % F_theta_theta is the fourth column of the data
x_lim = [0 20];
x_ticks = [0 10 20];
y_lim = [0 1];
y_ticks = [0 0.5 1];
ylabels = {'$F_\theta$', '$F_\phi$'};

%% path for PBG and vacuum data
pbg_directory = 'C:\Users\Shoaib\Desktop\thesis\matlab paper2\sampled pbg data\PBG\data\R2\';
vac_directory = 'C:\Users\Shoaib\Desktop\thesis\matlab paper2\sampled pbg data\Vacuum\data\';
pbg_omega_0_10_path = strcat(pbg_directory, 'omega-is-0.100000\phi-is-0\sampled_measurements.csv');
pbg_omega_0_50_path = strcat(pbg_directory, 'omega-is-0.500000\phi-is-0\sampled_measurements.csv');
pbg_omega_3_00_path = strcat(pbg_directory, 'omega-is-3.000000\phi-is-0\sampled_measurements.csv');
pbg_omega_5_00_path = strcat(pbg_directory, 'omega-is-5.000000\phi-is-0\sampled_measurements.csv');
vac_omega_0_10_path = strcat(vac_directory, 'omega-is-0.100000\phi-is-0\sampled_measurements.csv');
vac_omega_0_50_path = strcat(vac_directory, 'omega-is-0.500000\phi-is-0\sampled_measurements.csv');
vac_omega_3_00_path = strcat(vac_directory, 'omega-is-3.000000\phi-is-0\sampled_measurements.csv');
vac_omega_5_00_path = strcat(vac_directory, 'omega-is-5.000000\phi-is-0\sampled_measurements.csv');

%% import pbg and vacuum data
pbg_omega_0_10_data = readmatrix(pbg_omega_0_10_path);
pbg_omega_0_50_data = readmatrix(pbg_omega_0_50_path);
pbg_omega_3_00_data = readmatrix(pbg_omega_3_00_path);
pbg_omega_5_00_data = readmatrix(pbg_omega_5_00_path);
disp('Reading PBG data is finished');
vac_omega_0_10_data = readmatrix(vac_omega_0_10_path);
vac_omega_0_50_data = readmatrix(vac_omega_0_50_path);
vac_omega_3_00_data = readmatrix(vac_omega_3_00_path);
vac_omega_5_00_data = readmatrix(vac_omega_5_00_path);
disp('Reading Vacuum data is finished');

%% ===================== 1) Vacuum - F_phi =====================
hold(ax1, "on");
box(ax1, "on");
set(ax1,'FontSize', tick_fontsize, 'LineWidth', box_linewidth)
title(ax1, titles{1}, FontSize=title_fontsize, FontWeight='normal', FontName=title_fontName);
xlim(ax1, x_lim); xticks(ax1, x_ticks);
ylim(ax1, y_lim); yticks(ax1, y_ticks);
xlabel(ax1, xlabels{1}, FontSize=xlabel_fontsize, Interpreter='latex');
ylabel(ax1, ylabels{2}, FontSize=ylabel_fontsize, FontWeight=ylabel_fontWeight, Interpreter='latex');
p1 = plot(ax1, vac_omega_0_10_data(:,1), vac_omega_0_10_data(:,i), '-', LineWidth=curve_linewidth, Color=colors{1});
p2 = plot(ax1, vac_omega_0_50_data(:,1), vac_omega_0_50_data(:,i),'--', LineWidth=curve_linewidth, Color=colors{2});
p3 = plot(ax1, vac_omega_3_00_data(:,1), vac_omega_3_00_data(:,i), '-.', LineWidth=curve_linewidth, Color=colors{3});
p4 = plot(ax1, vac_omega_5_00_data(:,1), vac_omega_5_00_data(:,i), ':', LineWidth=curve_linewidth, Color=colors{4});

%% ===================== 2) PBG - F_phi =====================
hold(ax2, "on");
box(ax2, "on");
set(ax2,'FontSize', tick_fontsize, 'LineWidth', box_linewidth)
title(ax2, titles{2}, 'FontSize', title_fontsize,'FontWeight',title_fontWeight,'FontName',title_fontName);
xlim(ax2, x_lim); xticks(ax2, x_ticks);
ylim(ax2, y_lim); yticks(ax2, y_ticks);
xlabel(ax2, xlabels{2}, 'FontSize', xlabel_fontsize,'Interpreter','latex');
plot(ax2, pbg_omega_0_10_data(:,1), pbg_omega_0_10_data(:,i), '-','LineWidth', curve_linewidth,'Color',colors{1});
plot(ax2, pbg_omega_0_50_data(:,1), pbg_omega_0_50_data(:,i),'--','LineWidth', curve_linewidth,'color',colors{2});
plot(ax2, pbg_omega_3_00_data(:,1), pbg_omega_3_00_data(:,i), '-.','LineWidth', curve_linewidth,'color',colors{3});
plot(ax2, pbg_omega_5_00_data(:,1), pbg_omega_5_00_data(:,i), ':','LineWidth',curve_linewidth,'color',colors{4});

%% ===================== 3) Vacuum - F_theta =====================
hold(ax3, "on");
box(ax3, "on");
set(ax3, FontSize=tick_fontsize, LineWidth=box_linewidth)
xlim(ax3, x_lim); xticks(ax3, x_ticks);
ylim(ax3, y_lim); yticks(ax3, y_ticks);
xlabel(ax3, xlabels{1}, 'FontSize', xlabel_fontsize,'Interpreter','latex');
ylabel(ax3, ylabels{1}, 'FontSize', ylabel_fontsize,'fontWeight',ylabel_fontWeight,'Interpreter','latex');
plot(ax3, vac_omega_0_10_data(:,1), vac_omega_0_10_data(:,j), '-','LineWidth', curve_linewidth,'Color',colors{1});
plot(ax3, vac_omega_0_50_data(:,1), vac_omega_0_50_data(:,j),'--','LineWidth', curve_linewidth,'color',colors{2});
plot(ax3, vac_omega_3_00_data(:,1), vac_omega_3_00_data(:,j), '-.','LineWidth', curve_linewidth,'color',colors{3});
plot(ax3, vac_omega_5_00_data(:,1), vac_omega_5_00_data(:,j), ':','LineWidth', curve_linewidth,'color',colors{4});

%% ===================== 4) PBG - F_theta =====================
hold(ax4, "on");
box(ax4, "on");
set(ax4,'FontSize', tick_fontsize, 'LineWidth', box_linewidth)
xlim(ax4, x_lim); xticks(ax4, x_ticks);
ylim(ax4, y_lim); yticks(ax4, y_ticks);
xlabel(ax4, xlabels{2}, 'FontSize', xlabel_fontsize,'Interpreter','latex');
p5 = plot(ax4, pbg_omega_0_10_data(:,1), pbg_omega_0_10_data(:,j), '-','LineWidth', curve_linewidth,'Color',colors{1});
p6 = plot(ax4, pbg_omega_0_50_data(:,1), pbg_omega_0_50_data(:,j),'--','LineWidth', curve_linewidth,'color',colors{2});
p7 = plot(ax4, pbg_omega_3_00_data(:,1), pbg_omega_3_00_data(:,j), '-.','LineWidth', curve_linewidth,'color',colors{3});
p8 = plot(ax4, pbg_omega_5_00_data(:,1), pbg_omega_5_00_data(:,j), ':','LineWidth', curve_linewidth,'color',colors{4});

%% add legends
lgd1 = legend(ax1, [p1, p2, p3, p4], gamma_labels, Location='NorthEast', Box = 'off', Interpreter='latex', FontSize=legend_fontsize*.9);
lgd2 = legend(ax2, [p5, p6],{'$\Omega=0.1\beta$', '$\Omega=0.5\beta$'}, FontSize=legend_fontsize*.9, Box='off', Interpreter = 'latex');
lgd3 = legend(ax4, [p7, p8],{'$\Omega=3\beta$', '$\Omega=5\beta$'}, FontSize=legend_fontsize*.9, Box='off', Interpreter = 'latex');
lgd1.ItemTokenSize = [20 6];
lgd2.ItemTokenSize = [20 6];
lgd3.ItemTokenSize = [20 6];
lgd1.Position = [0.25 0.7335 0.2479 0.1980];%[0.236 0.7335 0.20 0.1980];
lgd2.Position = [0.75 0.73 0.2493 0.1059];%= [0.75 0.73 0.2 0.10];
lgd3.Position = [0.58 0.6 0.2251 0.1059];%= [0.58 0.60 0.2 0.10];

%% marking figures
text(ax1, 0.82, 0.13, '(a)', 'Units','normalized','FontSize',marker_fontsize,'FontWeight',marker_fontweight,'FontName',marker_fontname)
text(ax2, 0.82, 0.13, '(b)', 'Units','normalized','FontSize',marker_fontsize,'FontWeight',marker_fontweight,'FontName',marker_fontname)
text(ax3, 0.82, 0.13, '(c)', 'Units','normalized','FontSize',marker_fontsize,'FontWeight',marker_fontweight,'FontName',marker_fontname)
text(ax4, 0.82, 0.13, '(d)', 'Units','normalized','FontSize',marker_fontsize,'FontWeight',marker_fontweight,'FontName',marker_fontname)

%% Save and export figurs
if ~exist('ghafar_plots', 'dir')
    mkdir('ghafar_plots');
end
fname = 'ghafar_plots\Fig5';
print(h, strcat(fname, '.jpg'),'-djpeg', '-r300');
print(h, fname, '-depsc', '-r300');
%saveas(h, strcat(fname, '.eps'),'epsc');
%cmd = ['epstopdf ', fname,'.eps'];
%system(cmd);
close(h)