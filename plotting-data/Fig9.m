
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
i = 5; % Sigma is the fifth column of the data
j = 5; % Sigma is the fifth column of the data
x_lim = [0 8];
y_lim = [0 10];
x_ticks = [0 4 8];
y_ticks = [0 5 10];
ylabels = {'$\Sigma_{min}$'};

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
title(ax1, titles{1}, 'FontSize', title_fontsize,'FontWeight','normal','FontName',title_fontName);
xlim(ax1, x_lim); xticks(ax1, x_ticks);
ylim(ax1, y_lim); yticks(ax1, y_ticks);
xlabel(ax1, xlabels{1}, 'FontSize', xlabel_fontsize,'Interpreter','latex');
ylabel(ax1, ylabels{1}, 'FontSize', ylabel_fontsize,'FontWeight',ylabel_fontWeight,'Interpreter','latex');
p1 = plot(ax1, vac_omega_0_10_data(:,1), vac_omega_0_10_data(:,i), '-','LineWidth', curve_linewidth,'Color',colors{1});
p2 = plot(ax1, vac_omega_0_50_data(:,1), vac_omega_0_50_data(:,i),'--','LineWidth', curve_linewidth,'color',colors{2});
p3 = plot(ax1, vac_omega_3_00_data(:,1), vac_omega_3_00_data(:,i), '-.','LineWidth', curve_linewidth,'color',colors{3});
p4 = plot(ax1, vac_omega_5_00_data(:,1), vac_omega_5_00_data(:,i), ':','LineWidth', curve_linewidth,'color',colors{4});

%% ===================== 2) PBG - F_phi =====================
hold(ax2, "on");
box(ax2, "on");
set(ax2,'FontSize', tick_fontsize, 'LineWidth', box_linewidth)
title(ax2, titles{2}, 'FontSize', title_fontsize,'FontWeight',title_fontWeight,'FontName',title_fontName);
xlim(ax2, x_lim); xticks(ax2, x_ticks);
ylim(ax2, y_lim); yticks(ax2, y_ticks);
xlabel(ax2, xlabels{2}, 'FontSize', xlabel_fontsize,'Interpreter','latex');
p5 = plot(ax2, pbg_omega_0_10_data(:,1), pbg_omega_0_10_data(:,i), '-','LineWidth', curve_linewidth,'Color',colors{1});
p6 = plot(ax2, pbg_omega_0_50_data(:,1), pbg_omega_0_50_data(:,i),'--','LineWidth', curve_linewidth,'color',colors{2});
p7 = plot(ax2, pbg_omega_3_00_data(:,1), pbg_omega_3_00_data(:,i), '-.','LineWidth', curve_linewidth,'color',colors{3});
p8 = plot(ax2, pbg_omega_5_00_data(:,1), pbg_omega_5_00_data(:,i), ':','LineWidth',curve_linewidth,'color',colors{4});

%% add legend
lgd1 = legend(ax1, [p1, p2, p3, p4],{'$\Omega=0.1\gamma$', '$\Omega=0.5\gamma$', '$\Omega=3\gamma$','$\Omega=5\gamma$'}, FontSize=legend_fontsize*.9, Interpreter='latex', Box="off");
lgd1.ItemTokenSize = [20 6];
lgd1.Position = [0.27 0.47 0.2479 0.3961];%[0.27 0.45 0.19 0.3961];
lgd2 = legend(ax2, [p5, p6],{'$\Omega=0.1\beta$', '$\Omega=0.5\beta$'}, FontSize=legend_fontsize*.9, Interpreter='latex', Box="off");
lgd2.ItemTokenSize = [20 6];
lgd2.Position = [0.755 0.6 0.2493 0.3961/2];%= [0.759 0.45 0.18 0.39];
% create a fake ax2_overlay
ax2_overlay = axes(Parent=h, Position=ax2.Position, Color='none', XColor='none', YColor='none', Box='off', HitTest='off');                  % کلیک‌ها به ax2 زیرین برسند
hold(ax2_overlay, 'on');
lgd3 = legend(ax2_overlay, [p7, p8],{'$\Omega=3\beta$','$\Omega=5\beta$'}, FontSize=legend_fontsize*.9, Interpreter='latex', Box="off");
lgd3.ItemTokenSize = [20 6];
lgd3.Position = [0.762 0.19 0.2493 0.3961/2];%= [0.759 0.45 0.18 0.39];

%% marking figures
text(ax1, 0.82, 0.13, '(a)', 'Units','normalized','FontSize',marker_fontsize,'FontWeight',marker_fontweight,'FontName',marker_fontname)
text(ax2, 0.05, 0.13, '(b)', 'Units','normalized','FontSize',marker_fontsize,'FontWeight',marker_fontweight,'FontName',marker_fontname)

%% Save and export figurs
if ~exist('ghafar_plots', 'dir')
    mkdir('ghafar_plots');
end
fname = 'ghafar_plots\Fig9';
print(h, strcat(fname, '.jpg'),'-djpeg', '-r300');
print(h, fname, '-depsc', '-r300');
%saveas(h, strcat(fname, '.eps'),'epsc');
%cmd = ['epstopdf ', fname,'.eps'];
%system(cmd);
%exportgraphics(h,'Fig9.pdf','ContentType','vector')
close(h)