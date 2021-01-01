co2 = Solution('liquidvapor.cti', 'carbondioxide');
[V, T, P] = pvt(co2);
surf(V, T, P);
Surface = surf(V, T, P);
surf2solid(V, T, P);
stlwrite('PVT.stl', surf2solid(V, T/100, P));

function [logv,t,logp] = pvt(sub)

    tmin = minTemp(sub) + 0.01;
    tmax = maxTemp(sub) - 0.01;
    set(sub,'T', tmin, 'Liquid', 1.0);
    % The factor of 0.5 and 10 are used to better scale the plot
    vmin = 0.5/density(sub);
    set(sub, 'T', tmin, 'Vapor', 1.0);
    vmax = 10/density(sub);
    nt = 100;
    dt = (tmax-tmin)/nt;
    nv = 100;
    dlogv =log10(vmax/vmin)/nv;
    logvmin = log10(vmin);
    v = zeros(nv,1);
    t = zeros(nt,1);
    p = zeros(nt,nv);
    for n=1:nv
        logv(n) = logvmin + (n-1)*dlogv;
        v = 10.0^logv(n);
        for m = 1:nt
            t(m) = tmin + (m-1)*dt;
            set(sub, 'T', t(m), 'V', v);
            logp(m,n) = log10(pressure(sub));
        end
    end
end