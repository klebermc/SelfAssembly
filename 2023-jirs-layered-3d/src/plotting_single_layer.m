close all
figure
subplot(2,2,1)
c = polyfit(datatrW.tr(1:3),datatrW.nmov(1:3),1);
y_est = polyval(c,datatrW.tr(1:3));
hold on
plot(datatrW.tr(1:3),y_est,'b--','LineWidth',1)
plot(datatrW.tr(1:3),datatrW.nmov(1:3),'rx')
hold off
grid on
legend('Trend line', 'Computed data','Location', 'Southeast')
title('3 x 3 layer')
xlabel('trace(W_{H,T})')
ylabel('\bar{m}')
ax=gca;
ax.FontSize=12;

subplot(2,2,2)
c = polyfit(datatrW.tr(4:8),datatrW.nmov(4:8),1);
y_est = polyval(c,datatrW.tr(4:8));
hold on
plot(datatrW.tr(4:8),y_est,'b--','LineWidth',1)
plot(datatrW.tr(4:8),datatrW.nmov(4:8),'rx')
hold off
grid on
legend('Trend line', 'Computed data','Location', 'Southeast')
title('5 x 5 layer')
xlabel('trace(W_{H,T})')
ylabel('\bar{m}')
ax=gca;
ax.FontSize=12;

subplot(2,2,3)
c = polyfit(datatrW.tr(9:24),datatrW.nmov(9:24),1);
y_est = polyval(c,datatrW.tr(9:24));
hold on
plot(datatrW.tr(9:24),y_est,'b--','LineWidth',1)
plot(datatrW.tr(9:24),datatrW.nmov(9:24),'rx')
hold off
grid on
legend('Trend line', 'Computed data','Location', 'Southeast')
title('Fig. 7e bottom layer, l=1')
xlabel('trace(W_{H,T})')
ylabel('\bar{m}')
ax=gca;
ax.FontSize=12;

subplot(2,2,4)
c = polyfit(datatrW.tr(25:39),datatrW.nmov(25:39),1);
y_est = polyval(c,datatrW.tr(25:39));
hold on
plot(datatrW.tr(25:39),y_est,'b--','LineWidth',1)
plot(datatrW.tr(25:39),datatrW.nmov(25:39),'rx')
hold off
grid on
legend('Trend line', 'Computed data','Location', 'Southeast')
title('Fig. 7e second layer, l=2')
xlabel('trace(W_{H,T})')
ylabel('\bar{m}')
ax=gca;
ax.FontSize=12;
