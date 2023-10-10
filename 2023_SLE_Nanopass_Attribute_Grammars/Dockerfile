FROM ghcr.io/siftech/nix-base-image:2023-10-09
RUN nix profile install nixpkgs#caddy
ADD Caddyfile /root/Caddyfile
ADD nanopass-ag /root/src
RUN cd /root/src && \
    nix develop .# -c "bash build.sh"

EXPOSE 80
CMD bash -lc "caddy run --config /root/Caddyfile"
