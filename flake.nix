{
	description = "GNOME Shell extension that extends the native MPRIS implementation ";

	inputs = {
		flake-parts = { type="github"; owner="hercules-ci"; repo="flake-parts"; };
		nixpkgs = { type="github"; owner="NixOS"; repo="nixpkgs"; ref="nixpkgs-unstable"; };
		gnome-improved-media-controls = {
			type="github"; owner="m-obeid"; repo="gnome-improved-media-controls";
			flake = false;
		};
	};

	outputs = inputs@{ flake-parts, ... }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			systems = [ "x86_64-linux" "aarch64-linux" ];
			perSystem = { self', pkgs, lib, ... }: {
				packages = let pkgName = "gnome-improved-media-controls"; in {
					default = self'.packages.${pkgName};
					${pkgName} = pkgs.stdenvNoCC.mkDerivation {
						name = pkgName;
						src = inputs.gnome-improved-media-controls;
						nativeBuildInputs = [pkgs.buildPackages.glib];

						configurePhase = ''
							substituteInPlace ./Makefile \
								--replace-fail '$(HOME)/.local' "$out"
						'';

						meta = {
							description = "GNOME Shell extension that extends the native MPRIS implementation ";
							homepage = "https://github.com/m-obeid/gnome-improved-media-controls";
							license = lib.licenses.mit;
							platforms = lib.platforms.linux;
						};
					};
				};
			};
		};
}		 
