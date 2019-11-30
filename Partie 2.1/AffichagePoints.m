function AffichagePoints(sol,obj,box)


matrice = reshape(round(sol),15,15)';

figure
hold on
plot(box,zeros(1,15),'sr',obj(:,1),obj(:,2),'og')
labels = cellstr(num2str((1:15)'));
text(obj(:,1),obj(:,2),labels);
text(box(:,1),box(:,2),labels);
for i=1:15
    for j=1:15
        if matrice(i,j)==1
            plot([obj(j,1) box(i,1)],[obj(j,2) 0],'-b');
        end
    end
end