
%% in this file you can see style variables
plot_style;
number_of_plots = 2;
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
i = 5; % Sigma is the second column of the data
j = 5; % Sigma is the fourth column of the data
x_lim = [0 8];
y_lim = [0 10];
x_ticks = [0 4 8];
y_ticks = [0 5 10];
ylabels = {'$\Sigma_{min}$'};

%% path for PBG and vacuum data
pbg_directory = 'C:\Users\Shoaib\Desktop\thesis\matlab paper2\sampled pbg data\PBG\data\R3\';
vac_directory = 'C:\Users\Shoaib\Desktop\thesis\matlab paper2\sampled pbg data\Vacuum\data\';
pbg_phi_0_path = strcat(pbg_directory, 'omega-is-0.000000\phi-is-0\sampled_measurements.csv');
pbg_phi_pi_2_path = strcat(pbg_directory, 'omega-is-0.000000\phi-is-pi-over-2\sampled_measurements.csv');
pbg_phi_pi_path = strcat(pbg_directory, 'omega-is-0.000000\phi-is-pi\sampled_measurements.csv');
vac_phi_0_path = strcat(vac_directory, 'omega-is-0.000000\phi-is-0\sampled_measurements.csv');
vac_phi_pi_2_path = strcat(vac_directory, 'omega-is-0.000000\phi-is-pi-over-2\sampled_measurements.csv');
vac_phi_pi_path = strcat(vac_directory, 'omega-is-0.000000\phi-is-pi\sampled_measurements.csv');

%% import pbg and vacuum data
pbg_phi_0_data = readmatrix(pbg_phi_0_path);
pbg_phi_pi_2_data = readmatrix(pbg_phi_pi_2_path);
pbg_phi_pi_data = readmatrix(pbg_phi_pi_path);
disp('Reading PBG data is finished');
vac_phi_0_data = readmatrix(vac_phi_0_path);
vac_phi_pi_2_data = readmatrix(vac_phi_pi_2_path);
vac_phi_pi_data = readmatrix(vac_phi_pi_path);
disp('Reading Vacuum data is finished');

%% ===================== 1) Vacuum - Sigma_min =====================
hold(ax1, "on");
box(ax1, "on");
set(ax1,'FontSize', tick_fontsize, 'LineWidth', box_linewidth)
title(ax1, titles{1}, 'FontSize', title_fontsize,'FontWeight',title_fontWeight,'FontName',title_fontName);
xlim(ax1, x_lim); xticks(ax1, x_ticks);
ylim(ax1, y_lim); yticks(ax1, y_ticks);
xlabel(ax1, xlabels{1}, 'FontSize', xlabel_fontsize,'Interpreter','latex');
ylabel(ax1, ylabels{1}, 'FontSize', ylabel_fontsize,'FontWeight',ylabel_fontWeight,'Interpreter','latex');
p1 = plot(ax1, vac_phi_0_data(:,1), vac_phi_0_data(:,i), '-','LineWidth', curve_linewidth,'Color',colors{1});
p2 = plot(ax1, vac_phi_pi_2_data(:,1), vac_phi_pi_2_data(:,i),'--','LineWidth', curve_linewidth,'color',colors{2});
p3 = plot(ax1, vac_phi_pi_data(:,1), vac_phi_pi_data(:,i), '-.','LineWidth', curve_linewidth,'color',colors{3});

%% ===================== 2) PBG - Sigma_min =====================
hold(ax2, "on");
box(ax2, "on");
set(ax2,'FontSize', tick_fontsize, 'LineWidth', box_linewidth)
title(ax2, titles{2}, 'FontSize', title_fontsize,'FontWeight',title_fontWeight,'FontName',title_fontName);
xlim(ax2, x_lim); xticks(ax2, x_ticks);
ylim(ax2, y_lim); yticks(ax2, y_ticks);
xlabel(ax2, xlabels{2}, 'FontSize', xlabel_fontsize,'Interpreter','latex');
plot(ax2, pbg_phi_0_data(:,1), pbg_phi_0_data(:,i), '-','LineWidth', curve_linewidth,'Color',colors{1});
plot(ax2, pbg_phi_pi_2_data(:,1), pbg_phi_pi_2_data(:,i),'--','LineWidth', curve_linewidth,'color',colors{2});
plot(ax2, pbg_phi_pi_data(:,1), pbg_phi_pi_data(:,i), '-.','LineWidth', curve_linewidth,'color',colors{3});

%% add legend
lgd = legend([p1, p2, p3],{'$\phi=0$', '$\phi=\pi/2$', '$\phi=\pi$'}, FontSize=legend_fontsize, Interpreter='latex', Box='off');
lgd.ItemTokenSize = [20 6];
lgd.Position = [0.273 0.56 0.2363 0.3039];
%lgd.Position = [0.2732 0.5571 0.1735 0.29];

%% marking figures
text(ax1, 0.82, 0.13, '(a)', 'Units','normalized','FontSize',marker_fontsize,'FontWeight',marker_fontweight,'FontName',marker_fontname)
text(ax2, 0.82, 0.13, '(b)', 'Units','normalized','FontSize',marker_fontsize,'FontWeight',marker_fontweight,'FontName',marker_fontname)

%% Save and export figurs
if ~exist('ghafar_plots', 'dir')
    mkdir('ghafar_plots');
end
fname = 'ghafar_plots\Fig7';
print(h, strcat(fname, '.jpg'),'-djpeg', '-r300');
print(h, fname, '-depsc', '-r300');
%saveas(h, strcat(fname, '.eps'),'epsc');
%cmd = ['epstopdf ', fname,'.eps'];
%system(cmd);
close(h)