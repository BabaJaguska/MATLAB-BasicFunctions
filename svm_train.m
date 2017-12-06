function theta=svm_train(X,y)

    [n d]=size(X);
    dodajJedan=ones(n,1);
    X=[X,dodajJedan];
    
    d=d+1;
    %margin=0.5*norm(theta);
    %constraint: -y*theta*x<=-1
    
    theta=quadprog(eye(d),zeros(1,d),-diag(y)*X,-ones(1,n));
  
end