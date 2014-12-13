function plot_points( dt, k )
%Plot points

hold on;
% plot(dt.Points(:,1),dt.Points(:,2), '.', 'markersize',10); hold on;
plot(dt.Points(k,1),dt.Points(k,2), 'w'); 

hold off;

end

