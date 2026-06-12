clc;
clearvars;
close all;

%% plot style
unit = "centimeters";
box_linewidth = 0.1;
title_fontsize = 12.0;
title_fontName = 'Times New Roman';
title_fontWeight = 'normal';
xlabel_fontsize = 12.0;
ylabel_fontsize = 12.0;
ylabel_fontWeight = 'bold';
legend_fontsize = 12.0;
tick_fontsize = 10.0;

%% in this file you can see style variables
fig_width = 7.9;
fig_height = fig_width*0.85/2;
h = figure(Units=unit);
t = tiledlayout(1, 2, TileSpacing='loose', Padding='tight');
ax1 = nexttile;
ax2 = nexttile;

%% tick labels (به صورت cell تعریف شوند نه char array)
x_ticks = {'0', '\pi/2', '\pi', '3\pi/2', '2\pi'};
y_ticks = {'2\pi', '3\pi/2', '\pi', '\pi/2', '0'};
titles = {'$F_\phi$', '$F_\theta$'};

%% ===================== 1) left picture =====================
img1 = imread('Fig4-1.jpg');
imshow(img1,'Parent',ax1);
ax1_xlim = xlim(ax1);
ax1_xlim_min = ax1_xlim(1);
ax1_xlim_max = ax1_xlim(2);
ax1_xlim_step = (ax1_xlim_max - ax1_xlim_min)/4;
ax1.XTick = [ax1_xlim_min ax1_xlim_min+ax1_xlim_step ax1_xlim_min+2*ax1_xlim_step ax1_xlim_min+3*ax1_xlim_step ax1_xlim_max];
ax1_ylim = ylim(ax1);
ax1_ylim_min = ax1_ylim(1);
ax1_ylim_max = ax1_ylim(2);
ax1_ylim_step = (ax1_ylim_max - ax1_ylim_min)/4;
ax1.YTick = [ax1_ylim_min ax1_ylim_min+ax1_ylim_step ax1_ylim_min+2*ax1_ylim_step ax1_ylim_min+3*ax1_ylim_step ax1_ylim_max];

hold(ax1,"on");
box(ax1,"off");
axis(ax1,'on');
set(ax1,XTickLabel=x_ticks,YTickLabel=y_ticks,FontSize=tick_fontsize,TickDir='in',LineWidth=0.1,TickLength=[0 0]);
title(ax1,titles{1},FontSize=title_fontsize,FontWeight=title_fontWeight,Interpreter='latex');
xlabel(ax1,'$\phi$','FontSize',xlabel_fontsize,'Interpreter','latex');
yl1 = ylabel(ax1,'$\theta$',FontSize=ylabel_fontsize,FontWeight=ylabel_fontWeight,Interpreter='latex');
xt = ax1.XTick;
yt = ax1.YTick;
len = numel(xt);
for k = 2:numel(xt)-1
    line(ax1, [xt(1) xt(1)+20], [yt(k) yt(k)]+1,'Color', 'k', 'LineWidth', 0.5);
    line(ax1, [xt(k) xt(k)]-0.5*k, [yt(len) yt(len)-20],'Color', 'k', 'LineWidth', 0.5);
end

%% ===================== 2) right picture =====================
img2 = imread('Fig4-2.jpg');
imshow(img2,'Parent',ax2);
ax2_xlim = xlim(ax2);
ax2_xlim_min = ax2_xlim(1);
ax2_xlim_max = ax2_xlim(2);
ax2_xlim_step = (ax2_xlim_max - ax1_xlim_min)/4;
ax2.XTick = [ax2_xlim_min ax2_xlim_min+ax2_xlim_step ax2_xlim_min+2*ax2_xlim_step ax2_xlim_min+3*ax2_xlim_step ax2_xlim_max];
ax2_ylim = ylim(ax2);
ax2_ylim_min = ax2_ylim(1);
ax2_ylim_max = ax2_ylim(2);
ax2_ylim_step = (ax2_ylim_max - ax2_ylim_min)/4;
ax2.YTick = [ax2_ylim_min ax2_ylim_min+ax2_ylim_step ax2_ylim_min+2*ax2_ylim_step ax2_ylim_min+3*ax2_ylim_step ax2_ylim_max];

hold(ax2,"on");
box(ax2,"off");
axis(ax2,'on');
set(ax2,XTickLabel=x_ticks,YTickLabel=y_ticks,FontSize=tick_fontsize,LineWidth=0.1,TickLength=[0 0]);
ax2.LineWidth = 0.01;
title(ax2,titles{2},FontSize=title_fontsize,FontWeight=title_fontWeight,Interpreter='latex');
xlabel(ax2,'$\phi$','FontSize',xlabel_fontsize,'Interpreter','latex');
yl2 = ylabel(ax2,'$\theta$','FontSize',ylabel_fontsize,'FontWeight',ylabel_fontWeight,'Interpreter','latex');
yl2.Position(1) = yl2.Position(1);
xt = ax2.XTick;
yt = ax2.YTick;
len = numel(xt);
for k = 2:numel(xt)-1
    line(ax2, [xt(1) xt(1)+20], [yt(k) yt(k)]+1,'Color', 'k', 'LineWidth', 0.5);
    line(ax2, [xt(k) xt(k)]-0.5*k, [yt(len) yt(len)-20],'Color', 'k', 'LineWidth', 0.5);
end

%% adding a colorbar
cb = colorbar;
cb.Box='off';
cb.LineWidth=0.3;

%% Save and export figurs
if ~exist('ghafar_plots', 'dir')
    mkdir('ghafar_plots');
end
fname = 'ghafar_plots\Fig4';
print(h, strcat(fname, '.jpg'),'-djpeg', '-r300');
print(h, fname, '-depsc', '-r300');
%saveas(h, strcat(fname, '.eps'),'epsc');
%cmd = ['epstopdf ', fname,'.eps'];
%system(cmd);
close(h)