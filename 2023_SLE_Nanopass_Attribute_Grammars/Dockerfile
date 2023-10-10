FROM ghcr.io/siftech/nix-base-image:2023-10-09
RUN nix profile install nixpkgs#caddy
ADD Caddyfile /root/Caddyfile
ADD nanopass-ag /www/src
RUN cd /www/src \
 && rm -r .git \
 && nix build -L \
 && mkdir -p /www/nag \
 && cp -r /www/src/result/* /www/nag \
 && cd /www \
 &&  tar czf src.tar.gz src
EXPOSE 80
CMD bash -lc "caddy run --config /root/Caddyfile"
