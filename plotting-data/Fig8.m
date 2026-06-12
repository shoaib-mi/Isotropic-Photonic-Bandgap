
%% in this file you can see style variables
plot_style_2;
number_of_plots = 1;
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
i = 5; % f_phi_phi is the second column of the data
j = 5; % f_theta_theta is the fourth column of the data
x_lim = [0 15];
y_lim = [0 10];
x_ticks = [0 7.5 15];
y_ticks = [0 5 10];
ylabels = {'$\Sigma_{min}$'};

%% path for PBG and vacuum data
pbg_directory = 'C:\Users\Shoaib\Desktop\thesis\Paper II - MATLAB, data and everything\sampled pbg data\PBG\data\';
region_2_path = strcat(pbg_directory, 'R2\omega-is-0.000000\phi-is-0\sampled_measurements.csv');
region_3_path = strcat(pbg_directory, 'R3\omega-is-0.000000\phi-is-0\sampled_measurements.csv');
region_1_path = strcat(pbg_directory, 'R1\omega-is-0.000000\phi-is-0\sampled_measurements.csv');

%% import pbg and vacuum data
region_2_data = readmatrix(region_2_path);
region_3_data = readmatrix(region_3_path);
region_1_data = readmatrix(region_1_path);
disp('Reading PBG data is finished');

%% ===================== 1) Vacuum - Sigma_min =====================
hold(ax1, "on");
box(ax1, "on");
set(ax1, FontSize=tick_fontsize*.95, LineWidth=box_linewidth)
xlim(ax1, x_lim); xticks(ax1, x_ticks);
ylim(ax1, y_lim); yticks(ax1, y_ticks);
xlabel(ax1, xlabels{2}, FontSize=xlabel_fontsize*.9, Interpreter='latex');
ylabel(ax1, ylabels{1}, FontSize=ylabel_fontsize*.9, FontWeight=ylabel_fontWeight, Interpreter='latex');
p1 = plot(ax1, region_1_data(:,1), region_1_data(:,j), '-','LineWidth', curve_linewidth,'color',colors{1});
p2 = plot(ax1, region_2_data(:,1), region_2_data(:,i), '--','LineWidth', curve_linewidth,'Color',colors{2});
p3 = plot(ax1, region_3_data(:,1), region_3_data(:,i),'-.','LineWidth', curve_linewidth,'color',colors{3});

%% add legend
lgd = legend(ax1, [p1, p2, p3],{'$\omega_{3c}=0.9\beta$', '$\omega_{3c}=0.2\beta$', '$\omega_{3c}=-1\beta$'}, FontSize=legend_fontsize*.9, Interpreter='latex', Box='off');
lgd.ItemTokenSize = [20 6];
lgd.Position = [0.20 0.65 0.3532 0.2500];%[0.15 0.705 0.25 0.2];%[0.64 0.5 0.25 0.2];

%% Save and export figurs
if ~exist('ghafar_plots', 'dir')
    mkdir('ghafar_plots');
end
fname = 'ghafar_plots\Fig8';
print(h, strcat(fname, '.jpg'),'-djpeg', '-r300');
print(h, fname, '-depsc', '-r300');
%saveas(h, strcat(fname, '.eps'),'epsc');
%cmd = ['epstopdf ', fname,'.eps'];
%system(cmd);
close(h)