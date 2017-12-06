function test_err=svm_test(theta,X_test,y_test)
    [m,d]=size(X_test);
    dodajJedan=ones(m,1);
    X_test=[X_test,dodajJedan];
    d=d+1;
    classify=sign(X_test*theta);
    test_err=100*sum(classify~=y_test)/m;
end