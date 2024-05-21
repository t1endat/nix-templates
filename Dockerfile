# nix builder
FROM nixos/nix:latest

# Enable flakes
RUN echo 'experimental-features = nix-command flakes' >> /etc/nix/nix.conf

# update package
RUN nix-channel --update

# Copy flake.nix into our working dir
COPY . /work
WORKDIR /work

# run to enable env
RUN nix develop \
    --extra-experimental-features "nix-command flakes" \
    --accept-flake-config \
    --impure 
    
# CMD ["nix", "develop", "--impure", "--accept-flake-config"]

