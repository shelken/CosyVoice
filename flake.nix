{
  description = "Python venv development template";

  inputs = {
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    ...
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      pythonPackages = pkgs.python310Packages;
    in {
      devShells.default = pkgs.mkShell {
        name = "python-venv";
        venvDir = "./.venv";
        buildInputs = [
          # A Python interpreter including the 'venv' module is required to bootstrap
          # the environment.
          pkgs.python310

          # This executes some shell code to initialize a venv in $venvDir before
          # dropping into the shell
          pythonPackages.venvShellHook

          # Those are dependencies that we would like to use from nixpkgs, which will
          # add them to PYTHONPATH and thus make them accessible from within the venv.
        ];

        # Run this command, only after creating the virtual environment
        postVenvCreation = ''
          git submodule update --init --recursive
          pip install cython -i https://mirrors.aliyun.com/pypi/simple/ --trusted-host=mirrors.aliyun.com
          pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ --trusted-host=mirrors.aliyun.com
        '';

        # Now we can execute any commands within the virtual environment.
        # This is optional and can be left out to run pip manually.
        postShellHook = ''
        '';
      };
    });
}
