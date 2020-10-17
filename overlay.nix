self: pkgs:
with pkgs;

let gccOpts = {
  langC = true;
  langCC = true;
  langFortran = true;
  langObjC = true;
  langObjCpp = true;
  enableShared = true;
  enableMultilib = false;
}; in

{
  nss_sss = callPackage base/sssd/nss-client.nix { };

  gcc6 = wrapCC (gcc6.cc.override gccOpts);
  gfortran6 = self.gcc6;

  gcc7 = wrapCC (gcc7.cc.override gccOpts);
  gfortran7 = self.gcc7;

  gcc8 = wrapCC (gcc8.cc.override gccOpts);
  gfortran8 = self.gcc8;

  gcc9 = wrapCC (gcc9.cc.override gccOpts);
  gfortran9 = self.gcc9;

  gcc10 = wrapCC (gcc10.cc.override gccOpts);
  gfortran10 = self.gcc10;

  gcc = self.gcc9;

  nix = nix.overrideAttrs (old: {
    patches = [./nix.patch];
    doInstallCheck = false;
  });

  openssl_1_0_2 = openssl_1_0_2.overrideAttrs (old: {
    postPatch = old.postPatch + ''
      sed -i 's:define\s\+X509_CERT_FILE\s\+.*$:define X509_CERT_FILE "/etc/pki/tls/certs/ca-bundle.crt":' crypto/cryptlib.h
    '';
  });

  openssl_1_1 = openssl_1_1.overrideAttrs (old: {
    postPatch = old.postPatch + ''
      sed -i 's:define\s\+X509_CERT_FILE\s\+.*$:define X509_CERT_FILE "/etc/pki/tls/certs/ca-bundle.crt":' include/internal/cryptlib.h
    '';
  });

  openssl = self.openssl_1_1;

  p11-kit = p11-kit.overrideAttrs (old: {
    doCheck = false;
    # 3 unknown failures
  });

  # intel infiniband/psm stuff
  infinipath-psm = callPackage base/infinipath-psm { };
  libpsm2 = callPackage base/libpsm2 { };

  slurm = callPackage base/slurm { };

  openmpi1 = callPackage devel/openmpi/1.nix { };
  openmpi2 = callPackage devel/openmpi/2.nix { };
  openmpi3 = callPackage devel/openmpi/3.nix { };
  openmpi4 = callPackage devel/openmpi/4.nix { };
  openmpi = self.openmpi4;
  openmpis = with self; [openmpi2 openmpi4];

  withMpi = pkg: mpi: pkg.override {
    inherit mpi;
  } // {
    inherit mpi;
  };

  gromacsWithMpi = mpi: gromacsDouble.override {
    mpiEnabled = if mpi == null then false else true;
    openmpi = mpi;
  } // {
    inherit mpi;
  };

  withMpis = pkg: map (self.withMpi pkg) self.openmpis;

  mvapich2 = callPackage devel/mvapich { };

  osu-micro-benchmarks = callPackage test/osu-micro-benchmarks {
    mpi = openmpi;
  };

  linuxPackages = linuxPackages.extend (self: super: {
    nvidia_x11 = callPackage (import nixpkgs/pkgs/os-specific/linux/nvidia-x11/generic.nix {
      version = "440.64";
      sha256_64bit = "0000927g5ml1rwgpydlrjzr55gza5dfkqkch29bbarpzd7dh0mf4";
      settingsSha256 = "000064wbijwyq032ircl1b78q0gwdvfq35gxaqw00d3ac2hjwpsg";
      persistencedSha256 = "00006v8c2si0zwy9j60yzrdn1b1pm0vr9kfvql3jkyjqfn4np44z";
    }) {
      libsOnly = true;
    };
  });

  fftw = callPackage base/fftw/precs.nix {
    mpi = null;
  };

  fftwSinglePrec = self.fftw;
  fftwFloat = self.fftw;
  fftwLongDouble = self.fftw;

  nfft = callPackage devel/nfft {
    fftw = self.fftw;
  };

  bash-completion = bash-completion.overrideAttrs (old: {
    doCheck = false; # something about users
  });

  bluez5 = bluez5.overrideAttrs (old: {
    doCheck = false; # 2 fails
  });

  libuv = libuv.overrideAttrs (old: {
    doCheck = false; # failure
  });

  poppler_min = poppler_min.overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags ++ ["-DENABLE_QT4=off"];
  });

  qt5 = qt514;

  python2 = python2.override {
    self = self.python2;
    ucsEncoding = 4;
    configd = null;
    packageOverrides = import ./python.nix self;
  };

  python3 = python3.override {
    self = self.python3;
    configd = null;
    packageOverrides = import ./python.nix self;
  };

  python = self.python2;
  pythonPackages = self.python.pkgs;
  python2Packages = self.python2.pkgs;
  python3Packages = self.python3.pkgs;

  pythonPackageList = p: with p; [
    appdirs
    backports_ssl_match_hostname
    bearcart
    #bokeh #-- selenium, rustc
    bottleneck
    cython
    #DataSpyre
    #deepTools
    dill
    #einsum2
    emcee
    flask
    flask_wtf
    fusepy
    fuzzysearch
    gevent
    gflags
    gmpy2
    heapdict
    husl
    intervaltree
    ipdb
    ipython #[all]
    jupyter
    leveldb
    locket
    Mako
    matlab_wrapper
    matplotlib
    #metaseq
    mpi4py
    #nbodykit#[extras]
    numexpr
    numpy
    olefile
    openpyxl
    packaging
    paho-mqtt
    pip
    primefac
    protobuf
    psutil
    psycopg2
    py
    pycairo
    #pycuda
    pygobject2
    #pymultinest
    pyparsing
    pyqt5 #-- qt5
    pyslurm
    pystan
    pytest
    pyyaml
    pyzmq
    s3transfer
    #scikit-cuda
    scikitlearn
    scipy
    setuptools
    shapely
    sip
    six
    sphinx
    sqlalchemy
    sympy
    #tess
    #Theano -- clblas
    twisted
    urllib3
    virtualenv
    wheel
    #yep
  ] ++ (if isPy3k then [
    astropy
    bash_kernel
    biopython #-- build failure on python3
    cherrypy
    dask
    distributed #-- dask
    flask-socketio
    ggplot
    glueviz #-- qt
    h5py
    hglib
    #jax
    joblib
    jupyterhub
    jupyterlab
    llfuse #-- unicode problems on python2
    netcdf4
    pandas
    paramiko
    partd
    pims #--dask
    pyfftw #-- pending 0.11 upgrade, dask
    pytools
    pytorch
    s3fs
    scikitimage #-- dask
    seaborn
    statsmodels
    #tensorflow #77771 #python3.8
    (tensorflow_2.override { cudaCapabilities = ["3.5" "3.7" "5.2" "6.0" "6.1" "7.0"]; })
    ws4py
  ] else [
    fwrap
    #MySQL_python
    #NucleoATAC
    pygtk
    statistics
    weave
    yt
  ]);

  python2-all = (self.python2.withPackages self.pythonPackageList).override {
    ignoreCollisions = true; # see #31080
  };
  python3-all = (self.python3.withPackages self.pythonPackageList).override {
    ignoreCollisions = true; # see #31080
  };

  perlPackageList = p: with p; [
    locallib
    FileWhich
    GetoptLong
    #Git?
    HTMLParser
    HTMLTemplate
    HTMLTree
    HTTPDaemon
    Socket
    TermReadLineGnu
    TimeDuration
    TimeHiRes
    XMLLibXML
    XMLParser
    XMLSAX
  ];

  perl-all = buildEnv {
    inherit (perl) name;
    paths = [perl] ++ self.perlPackageList perlPackages;
  };

  rPackageList = with rPackages; [
    AnnotationDbi
    BH
    BSgenome
    BiasedUrn
    #BiocInstaller # R version incompat?
    BiocManager
    DESeq2
    DT
    #DiffBind # zlib dep
    Formula
    GOstats
    GSEABase
    GenomicAlignments
    GenomicFeatures
    GenomicRanges
    IRanges
    IRkernel
    #JuniperKernel
    KEGGREST
    RBGL
    RCurl
    R_methodsS3
    R_oo
    R_utils
    RcppArmadillo
    RcppEigen
    RcppGSL
    Rsamtools
    Rtsne
    TFMPvalue
    VGAM
    VennDiagram
    acepack
    ade4
    askpass
    assertthat
    backports
    biomaRt
    bit64
    bitops
    blob
    caTools
    callr
    checkmate
    cli
    clipr
    clisymbols
    crosstalk
    desc
    devtools
    dplyr
    evaluate
    formatR
    fs
    futile_logger
    futile_options
    gdata
    genefilter
    getopt
    ggplot2
    glue
    gplots
    grImport
    gridExtra
    gtools
    hexbin
    highr
    hms
    htmlTable
    httpuv
    idr
    ini
    jpeg
    knitr
    lambda_r
    later
    lattice
    latticeExtra
    lazyeval
    limma
    markdown
    matrixStats
    memoise
    mime
    miniUI
    multtest
    nabor
    pheatmap
    pkgbuild
    pkgconfig
    pkgload
    plogr
    plotly
    png
    polynom
    poweRlaw
    preprocessCore
    preseqR
    processx
    progress
    promises
    ps
    purrr
    randomForest
    rcmdcheck
    readr
    remotes
    rlang
    rprojroot
    rstudioapi
    rtracklayer
    segmented
    seqinr
    sessioninfo
    shiny
    snow
    sourcetools
    sys
    tibble
    tidyr
    tidyselect
    viridis
    whisker
    xfun
    xopen
    xtable
    yaml
    zlibbioc
  ];

  R-all = rWrapper.override {
    packages = self.rPackageList;
  };

  rstudio-all = rstudioWrapper.override {
    packages = self.rPackageList;
  };

  go = go.overrideAttrs (old: {
    doCheck = false;
    # user.Current not defined?
  });

  haskell = haskell // {
    packageOverrides = import ./haskell.nix self;
  };

  haskell-all = haskellPackages.ghcWithPackages (hp: with hp; [
    cabal-install
    stack
  ]);

  ihaskell = import IHaskell/release.nix {
    nixpkgs = self;
    compiler = "ghc884";
    packages = (hp: with hp; []);
  };

  julia = callPackage ./julia { };

  julia_14 = callPackage ./julia/1.4.nix {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };

  julia_15 = callPackage ./julia/1.5.nix {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };

  julia-all = callPackage ./julia.nix { julia = self.julia; };
  julia_13-all = callPackage ./julia.nix { julia = self.julia_13; };
  julia_14-all = callPackage ./julia.nix { julia = self.julia_14; };
  julia_15-all = callPackage ./julia.nix { julia = self.julia_15; };

  texlive-all = texlive.combined.scheme-full // {
    name = builtins.replaceStrings ["-combined-full"] [""] texlive.combined.scheme-full.name;
  };

  biber = biber.overrideAttrs (old: {
    # #67903
    doCheck = false;
  });

  disBatch = callPackage flatiron/disBatch { };

  module-wrap = callPackage module/wrap { };

  emacs = emacs.override {
    withGTK2 = false;
    withGTK3 = false;
    imagemagick = imagemagick;
  };

  git = git.overrideAttrs (old: {
    # gettext UTF-8 failures?
    doInstallCheck = false;
  });

  gitFull = gitFull.overrideAttrs (old: {
    # gettext UTF-8 failures?
    doInstallCheck = false;
  });

  newt = newt.overrideAttrs (old: {
    configureFlags = "--without-tcl";
  });

  sage = sage.overrideAttrs (old: {
    # disable tests:
    buildInputs = [makeWrapper];
  });

  wecall = callPackage util/wecall {
    texlive = self.texlive-all;
  };

  i3-env = buildEnv {
    name = "${i3.name}-env";
    paths = [i3
      #i3lock
      i3status];
  };

  jupyter = self.python3.withPackages (p: with p; [jupyterhub jupyterlab jp_proxy_widget batchspawner]);

  ijulia-threads-wrapper = callPackage jupyter/kernel/julia {};

  threadedIJulia = julia: {
    env = julia;
    prefix = julia.name + "-threads";
    note = " threads (nix/${julia.name})";
    kernelWrapper = "${self.ijulia-threads-wrapper}/bin/ijulia-threads";
  };

  jupyter-env = buildEnv {
    name = "jupyter-env";
    paths = [
      self.jupyter
      self.nodejs
    ] ++ map (callPackage jupyter/kernel) [
      { env = self.python2-all; }
      { env = self.python3-all; }
      #{ env = self.R-all; kernelSrc = (callPackage jupyter/kernel/juniper { env = self.R-all; }); }
      { env = self.R-all; kernelSrc = (callPackage jupyter/kernel/ir { env = self.R-all; }); }
      { env = self.ihaskell; kernelSrc = (callPackage jupyter/kernel/ihaskell { env = self.ihaskell; }); }
      #{ env = self.julia-all; }
      #{ env = self.julia_13-all; }
      { env = self.julia_14-all; }
      { env = self.julia_15-all; }
      #(self.threadedIJulia self.julia-all)
      #(self.threadedIJulia self.julia_13-all)
      (self.threadedIJulia self.julia_14-all)
      (self.threadedIJulia self.julia_15-all)
      { env = "/cm/shared/sw/pkg-old/devel/python2/2.7.13"; ld_library_path = "/cm/shared/sw/pkg/devel/gcc/5.4.0/lib"; prefix = "module-python2-2.7.13"; note = " (python2/2.7.13)"; }
      { env = "/cm/shared/sw/pkg-old/devel/python3/3.6.2";  ld_library_path = "/cm/shared/sw/pkg/devel/gcc/5.4.0/lib"; prefix = "module-python3-3.6.2";  note = " (python3/3.6.2)"; }
      { env = "/cm/shared/sw/pkg/devel/python2/2.7.16";     ld_library_path = "/cm/shared/sw/pkg/devel/gcc/7.4.0/lib"; prefix = "module-python2-2.7.16"; note = " (python2/2.7.16)"; }
      { env = "/cm/shared/sw/pkg/devel/python3/3.7.3";      ld_library_path = "/cm/shared/sw/pkg/devel/gcc/7.4.0/lib"; prefix = "module-python3-3.7.3";  note = " (python3/3.7.3)"; }
      # TODO:
      #nodejs
    ] ++ map (callPackage jupyter/kernel/spec.nix) [
      { kernelspec = self.sage.kernelspec; }
    ];
  };

  modules = buildEnv {
    name = "modules";
    paths = map (pkg: callPackage ./module {
      inherit pkg;
    }) (with self; [
      gcc7
      gcc8
      gcc9
      gcc10
      ansible
      arpack
      binutils
      blas
      boost
      bzip2
      cargo
      chromium
      clang_7
      clang_8
      clang_9
      clang_10
      clang_11
      cmake
      coreutils
      cudatoolkit_9
      cudatoolkit_10
      cudatoolkit_11
      cudnn_cudatoolkit_9
      cudnn_cudatoolkit_10
      cudnn_cudatoolkit_11
      curl
      dep
      disBatch
      distcc
      dstat
      duplicity
      e2fsprogs
      eigen
      elinks
      emacs
      evince
      feh
      ffmpeg
      fftw
      firefox
      firefox-esr
      fio
      ghostscript
      gimp
      gitFull
      git-lfs
      gdb
      glibc
      gmp
      go
      gperftools
      gsl
      gsl_1
      haskell-all
      hdf5
      hdf5_1_8
      hdfview
      hwloc
      i3-env
      imagemagick
      inkscape
      ior
      jabref
      jdk
      #julia
      #julia_13
      julia_14
      julia_15
      keepassx2
      keepassxc
      lftp
      libgit2
      libjpeg
      libpng
      (libreoffice-still.override { libreoffice = libreoffice-still-unwrapped.overrideAttrs (old: { doCheck = false; }); })
      (libreoffice-fresh.override { libreoffice = libreoffice-fresh-unwrapped.overrideAttrs (old: { doCheck = false; }); })
      libseccomp
      libssh2
      libxml2
      llvm_7
      llvm_8
      llvm_9
      llvm_10
      llvm_11
      mercurial
      mkl
      mupdf
      netcdf
      nodejs-12_x
      nodejs-14_x
      nfft
      ocaml
      (octave.override { qscintilla = null; })
      openblas
      openmpi
      openssl
      paraview
      pass
      pdftk
      linuxPackages.perf
      perl-all
      petsc
      postgresql
      python2-all
      python3-all
      (qt5.full // { name = builtins.replaceStrings ["-full"] [""] qt5.full.name; })
      R-all
      readline
      rstudio-all
      rustc
      rxvt-unicode
      sage
      scribus
      smartmontools
      subversion
      swig
      texlive-all
      tmux
      unison
      valgrind
      vim
      (vim_configurable // { name = builtins.replaceStrings ["_configurable"] ["-custom"] vim_configurable.name; })
      vscode
      vtk
      wecall
      x264
      xscreensaver
      xz
      zlib
      zsh
    ] ++
      openmpis
    ++ lib.concatMap withMpis [
      fftw
      hdf5
      #hdf5_1_8 # - broken on openmpi4
      osu-micro-benchmarks
      scalapack
    ] ++ map (withMpi hdf5_1_8) [openmpi2]
      ++ map gromacsWithMpi ([null] ++ self.openmpis)
    ) ++ map (pkg: callPackage ./module {
      inherit pkg;
      addOpenGLDrivers = true;
    }) [
      mplayer
      mpv
    ] ++ [
      (callPackage ./module {
        pkg = self.rclone;
        modEnv = "NIX_RCLONE";
      })
      (callPackage ./module {
        pkg = self.nix;
        modConflict = ["nix/nix"];
        addCFlags = false;
      })
      (callPackage ./module {
        pkg = self.jupyter-env;
        pkgName = "jupyterhub";
        pkgVersion = self.jupyter.name;
        addCFlags = false;
      })
    ];
  };

}
