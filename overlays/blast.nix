# Add patches for runtime program `update-blastdb.pl`
# TODO: Currently, update_bladtdb.pl requires pkgs.google-cloud-sdk on system
# Make this wrapped on package runtime
_final: prev: {
  blast = prev.blast.overrideAttrs (oldAttrs: {
    buildInputs =
      (oldAttrs.buildInputs or [])
      ++ [
        prev.curl
        prev.wget
        prev.findutils
      ];
    postInstall =
      (oldAttrs.postInstall or "")
      + ''
        substituteInPlace $out/bin/update_blastdb.pl \
           --replace '/usr/bin/xargs' '${prev.findutils}/bin/xargs' \
           --replace 'foreach (qw(/usr/local/bin /usr/bin))' \
                     'foreach (qw(${prev.curl}/bin ${prev.wget}/bin /usr/local/bin /usr/bin))' \
           --replace 'local $ENV{PATH} = "/bin:/usr/bin";' \
                     'local $ENV{PATH} = "${
          prev.lib.makeBinPath [
            prev.gnutar
            prev.gzip
            prev.coreutils
          ]
        }:$ENV{PATH}";'
        chmod +x $out/bin/update_blastdb.pl
      '';
  });
}
