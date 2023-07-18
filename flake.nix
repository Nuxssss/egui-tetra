{
inputs = {
	flake-utils.url = "github:numtide/flake-utils";
	rust-overlay.url = "github:oxalica/rust-overlay";
  };
outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
	flake-utils.lib.eachDefaultSystem (system:
  	let
    	overlays = [ (import rust-overlay) ];
    	pkgs = import nixpkgs { inherit system overlays; };
    	rustVersion = pkgs.rust-bin.stable.latest.default;
    	rustPlatform = pkgs.makeRustPlatform {
      	cargo = rustVersion;
      	rustc = rustVersion;
    	};
  	in {
    	devShell = pkgs.mkShell {
      	buildInputs = with pkgs; [ 
          (rustVersion.override { 
            extensions = [ "rust-src" "rust-analyzer" ]; 
            targets = [ "x86_64-unknown-linux-gnu" ];
          }) 
        ];
    	};
  	});
}