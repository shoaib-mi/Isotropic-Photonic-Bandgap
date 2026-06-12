
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
i = 2; % f_phi_phi is the second column of the data
j = 4; % f_theta_theta is the fourth column of the data
x_lim = [0 30];
y_lim = [0 1];
x_ticks = [0 15 30];
y_ticks = [0 0.5 1];
ylabels = {'$F_{\phi}$', '$F_{\theta}$'};

%% path for PBG and vacuum data
pbg_directory = 'C:\Users\Shoaib\Desktop\thesis\matlab paper2\sampled pbg data\PBG\data\';
region_1_path = strcat(pbg_directory, 'R1\omega-is-0.000000\phi-is-0\sampled_measurements.csv');
region_2_path = strcat(pbg_directory, 'R2\omega-is-0.000000\phi-is-0\sampled_measurements.csv');
region_3_path = strcat(pbg_directory, 'R3\omega-is-0.000000\phi-is-0\sampled_measurements.csv');

%% import pbg and vacuum data
region_1_data = readmatrix(region_1_path);
region_2_data = readmatrix(region_2_path);
region_3_data = readmatrix(region_3_path);
disp('Reading PBG data is finished');

%% ===================== 1) Vacuum - Sigma_min =====================
hold(ax1, "on");
box(ax1, "on");
set(ax1,'FontSize', tick_fontsize, 'LineWidth', box_linewidth)
xlim(ax1, x_lim); xticks(ax1, x_ticks);
ylim(ax1, y_lim); yticks(ax1, y_ticks);
xlabel(ax1, xlabels{2}, 'FontSize', xlabel_fontsize,'Interpreter','latex');
ylabel(ax1, ylabels{1}, 'FontSize', ylabel_fontsize,'FontWeight',ylabel_fontWeight,'Interpreter','latex');
p1 = plot(ax1, region_1_data(:,1), region_1_data(:,i), '-','LineWidth', curve_linewidth,'color',colors{1});
p2 = plot(ax1, region_2_data(:,1), region_2_data(:,i), '--','LineWidth', curve_linewidth,'Color',colors{2});
p3 = plot(ax1, region_3_data(:,1), region_3_data(:,i),'-.','LineWidth', curve_linewidth,'color',colors{3});

%% ===================== 1) Vacuum - Sigma_min =====================
hold(ax2, "on");
box(ax2, "on");
set(ax2,'FontSize', tick_fontsize, 'LineWidth', box_linewidth)
xlim(ax2, x_lim); xticks(ax2, x_ticks);
ylim(ax2, y_lim); yticks(ax2, y_ticks);
xlabel(ax2, xlabels{2}, 'FontSize', xlabel_fontsize,'Interpreter','latex');
ylabel(ax2, ylabels{2}, 'FontSize', ylabel_fontsize,'FontWeight',ylabel_fontWeight,'Interpreter','latex');
plot(ax2, region_1_data(:,1), region_1_data(:,j), '-','LineWidth', curve_linewidth,'color',colors{1});
plot(ax2, region_2_data(:,1), region_2_data(:,j), '--','LineWidth', curve_linewidth,'Color',colors{2});
plot(ax2, region_3_data(:,1), region_3_data(:,j),'-.','LineWidth', curve_linewidth,'color',colors{3});


%% add legend
lgd = legend(ax1, [p1, p2, p3],{'$\omega_{3c}=0.9\beta$', '$\omega_{3c}=0.2\beta$', '$\omega_{3c}=-1\beta$'}, FontSize=legend_fontsize*.9, Interpreter='latex', Box="off");
lgd.ItemTokenSize = [20 6];
lgd.Position = [0.21 0.45 0.2682 0.3039];%= [0.220 0.45570 0.192 0.30];

%% marking figures
text(ax1, 0.05, 0.13, '(a)', Units='normalized', FontSize=marker_fontsize, FontWeight=marker_fontweight, FontName=marker_fontname);
text(ax2, 0.05, 0.13, '(b)', Units='normalized', FontSize=marker_fontsize, FontWeight=marker_fontweight, FontName=marker_fontname);
% 0.82
%% Save and export figurs
if ~exist('ghafar_plots', 'dir')
    mkdir('ghafar_plots');
end
fname = 'ghafar_plots\Fig3';
print(h, strcat(fname, '.jpg'),'-djpeg', '-r300');
print(h, fname, '-depsc', '-r300');
%saveas(h, strcat(fname, '.eps'),'epsc');
%cmd = ['epstopdf ', fname,'.eps'];
%system(cmd);
close(h)