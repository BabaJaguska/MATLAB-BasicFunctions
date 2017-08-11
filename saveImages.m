function []=saveImages(folder)

h=findobj('type','figure') % find the handles of the opened figures
for k=1:numel(h)
  filename=sprintf('image%d.jpg',k)
  file=fullfile(folder,filename)
  saveas(h(k),file)
end
end
