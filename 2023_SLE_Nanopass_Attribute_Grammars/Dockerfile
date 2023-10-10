FROM ghcr.io/siftech/nix-base-image:2023-10-09
RUN nix profile install nixpkgs#caddy
ADD Caddyfile /root/Caddyfile
ADD nanopass-ag /root/src
RUN cd /root/src \
 && nix build -L \
 && mkdir -p /www/nag \
 && cp -r /root/src/result/* /www/nag
EXPOSE 80
CMD bash -lc "caddy run --config /root/Caddyfile"
