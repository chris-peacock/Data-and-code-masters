function hiprint(path,name,res)
    [path,name,'.fig']
    uiopen([path,name,'.fig'],1)
    si = [4000 3000];
    set(gcf,'paperunits','inches','paperposition',[0 0 si/res]);
    print([name,'.png'],'-dpng',['-r' num2str(res)]);
    movefile([name,'.png'],path);
end