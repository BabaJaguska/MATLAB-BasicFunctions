 function podeli(node)
          niz=node.root;
          L=length(niz);
              if L>=2 %neki uslov vec
                  splitData1=niz(1:floor(L/2));
                  splitData2=niz(floor(L/2)+1:end);
                  node.left=Node(splitData1);
                  node.right=Node(splitData2);
                  podeli(node.left);
                  podeli(node.right);
              end
end