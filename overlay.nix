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

  gcc5 = wrapCC (gcc5.cc.override gccOpts);
  gfortran5 = self.gcc5;

  gcc6 = wrapCC (gcc6.cc.override gccOpts);
  gfortran6 = self.gcc6;

  gcc7 = wrapCC (gcc7.cc.override gccOpts);
  gfortran7 = self.gcc7;

  gcc8 = wrapCC (gcc8.cc.override gccOpts);
  gfortran8 = self.gcc8;

  gcc9 = wrapCC (gcc9.cc.override gccOpts);
  gfortran9 = self.gcc9;

  gcc = self.gcc8;

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
  openmpi = self.openmpi3;
  openmpis = with self; [openmpi1 openmpi2 openmpi3 openmpi4];

  withMpi = pkg: mpi: pkg.override {
    inherit mpi;
  } // {
    inherit mpi;
  };

  withMpis = pkg: map (self.withMpi pkg) self.openmpis;

  mvapich2 = callPackage devel/mvapich { };

  osu-micro-benchmarks = callPackage test/osu-micro-benchmarks {
    mpi = openmpi;
  };

  blas = self.openblas;

  linuxPackages = linuxPackages.extend (self: super: {
    nvidia_x11 = callPackage (import nixpkgs/pkgs/os-specific/linux/nvidia-x11/generic.nix {
      version = "418.56";
      sha256_64bit = "1cg7927g5ml1rwgpydlrjzr55gza5dfkqkch29bbarpzd7dh0mf4";
      settingsSha256 = "150c64wbijwyq032ircl1b78q0gwdvfq35gxaqw00d3ac2hjwpsg";
      persistencedSha256 = "07wh6v8c2si0zwy9j60yzrdn1b1pm0vr9kfvql3jkyjqfn4np44z";
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

  libuv = libuv.overrideAttrs (old: {
    doCheck = false; # failure
  });

  # Switch to qt59 due to 5.11 issues
  qt5 = qt59;
  libsForQt5 = libsForQt59;

  poppler_min = poppler_min.overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags ++ ["-DENABLE_QT4=off"];
  });

  python2 = python2.override {
    self = self.python2;
    ucsEncoding = 4;
    CF = null;
    configd = null;
    packageOverrides = import ./python.nix self;
  };

  python3 = python3.override {
    self = self.python3;
    CF = null;
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
    cherrypy
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
    ggplot
    gmpy2
    h5py
    heapdict
    hglib
    husl
    intervaltree
    ipdb
    ipython #[all]
    joblib
    jupyter
    leveldb
    locket
    Mako
    matlab_wrapper
    matplotlib
    #metaseq
    mpi4py
    #nbodykit#[extras]
    netcdf4
    numexpr
    numpy
    olefile
    packaging
    paho-mqtt
    pandas
    paramiko
    partd
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
    pytools
    pyyaml
    pyzmq
    s3fs
    s3transfer
    #scikit-cuda
    scikitlearn
    scipy
    seaborn
    setuptools
    shapely
    sip
    six
    sphinx
    sqlalchemy
    statsmodels
    sympy
    tensorflow
    #tess
    #Theano -- clblas
    twisted
    urllib3
    virtualenv
    wheel
    #yep
    yt
  ] ++ (if isPy3k then [
    astropy
    bash_kernel
    dask
    distributed #-- dask
    flask-socketio
    glueviz #-- qt
    jupyterhub
    jupyterlab
    llfuse #-- unicode problems on python2
    pims #--dask
    pyfftw #-- pending 0.11 upgrade, dask
    pytorch
    scikitimage #-- dask
    ws4py
  ] else [
    biopython #-- build failure on python3
    fwrap
    #MySQL_python
    #NucleoATAC
    pygtk
    statistics
    weave
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

  R-all = rWrapper.override {
    packages = with rPackages; [
      AnnotationDbi
      BH
      #BiocInstaller # R version incompat?
      bit64
      blob
      #DESeq2
      devtools
      getopt
      ggplot2
      IRkernel
      JuniperKernel
      lazyeval
      memoise
      pkgconfig
      plogr
      RcppGSL
    ];
  };

  go = go.overrideAttrs (old: {
    doCheck = false;
    # user.Current not defined?
  });

  go_1_12 = go_1_12.overrideAttrs (old: {
    doCheck = false;
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
    compiler = "ghc865";
    packages = (hp: with hp; []);
  };

  julia = julia.overrideAttrs (old: {
    doCheck = false;
  });

  texlive-all = texlive.combined.scheme-full // {
    name = builtins.replaceStrings ["-combined-full"] [""] texlive.combined.scheme-full.name;
  };

  biber = biber.overrideAttrs (old: {
    # #67903
    doCheck = false;
  });

  disBatch = callPackage flatiron/disBatch { };

  module-wrap = callPackage module/wrap { };

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

  jupyter = self.python3.withPackages (p: with p; [jupyterhub jupyterlab jp_proxy_widget]);

  jupyter-env = buildEnv {
    name = "jupyter-env";
    paths = [
      self.jupyter
    ] ++ map (callPackage jupyter/kernel) [
      { env = self.python2-all; }
      { env = self.python3-all; }
      { env = self.R-all; kernelSrc = (callPackage jupyter/kernel/juniper { env = self.R-all; }); }
      { env = self.R-all; kernelSrc = (callPackage jupyter/kernel/ir { env = self.R-all; }); }
      { env = self.ihaskell; kernelSrc = (callPackage jupyter/kernel/ihaskell { env = self.ihaskell; }); }
      { env = "/cm/shared/sw/pkg-old/devel/python2/2.7.13"; ld_library_path = "/cm/shared/sw/pkg/devel/gcc/5.4.0/lib"; prefix = "module-python2-2.7.13"; note = " (python2/2.7.13)"; }
      { env = "/cm/shared/sw/pkg-old/devel/python3/3.6.2";  ld_library_path = "/cm/shared/sw/pkg/devel/gcc/5.4.0/lib"; prefix = "module-python3-3.6.2";  note = " (python3/3.6.2)"; }
      { env = "/cm/shared/sw/pkg/devel/python2/2.7.16";     ld_library_path = "/cm/shared/sw/pkg/devel/gcc/7.4.0/lib"; prefix = "module-python2-2.7.16"; note = " (python2/2.7.16)"; }
      { env = "/cm/shared/sw/pkg/devel/python3/3.7.3";      ld_library_path = "/cm/shared/sw/pkg/devel/gcc/7.4.0/lib"; prefix = "module-python3-3.7.3";  note = " (python3/3.7.3)"; }
      # TODO:
      #nodejs 
      #julia
    ] ++ map (callPackage jupyter/kernel/spec.nix) [
      { kernelspec = self.sage.kernelspec; }
    ];
  };

  modules = buildEnv {
    name = "modules";
    paths = map (pkg: callPackage ./module {
      inherit pkg;
    }) (with self; [
      gcc5
      gcc7
      gcc8
      gcc9
      arpack
      boost
      bzip2
      cargo
      chromium
      clang_5
      clang_6
      clang_7
      clang_8
      #clang_9
      cmake
      #cudatoolkit_7_5
      #cudatoolkit_8
      cudatoolkit_9
      cudatoolkit_9_0
      cudatoolkit_9_1
      cudatoolkit_9_2
      cudatoolkit_10
      cudatoolkit_10_0
      #cudnn6_cudatoolkit_8
      #cudnn_cudatoolkit_7_5
      #cudnn_cudatoolkit_8
      cudnn_cudatoolkit_9
      cudnn_cudatoolkit_9_0
      cudnn_cudatoolkit_9_1
      cudnn_cudatoolkit_9_2
      cudnn_cudatoolkit_10
      cudnn_cudatoolkit_10_0
      curl
      dep
      disBatch
      dstat
      duplicity
      eigen
      elinks
      emacs
      evince
      feh
      ffmpeg
      fftw
      firefox
      fio
      ghostscript
      gitFull
      git-lfs
      gdb
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
      imagemagick
      ior
      jdk
      julia
      keepassx2
      keepassxc
      libgit2
      (libreoffice-still.override { libreoffice = libreoffice-still-unwrapped.overrideAttrs (old: { doCheck = false; }); })
      (libreoffice-fresh.override { libreoffice = libreoffice-fresh-unwrapped.overrideAttrs (old: { doCheck = false; }); })
      libseccomp
      libssh2
      libxml2
      mercurial
      mkl
      mupdf
      netcdf
      nodejs-10_x
      nodejs-12_x
      nfft
      ocaml
      (octave.override { qscintilla = null; })
      openmpi
      openssl
      paraview
      pass
      pdftk
      linuxPackages.perf
      petsc
      python2-all
      python3-all
      (qt5.full // { name = builtins.replaceStrings ["-full"] [""] qt5.full.name; })
      R-all
      rclone
      rustc
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
    ] ++ map (withMpi hdf5_1_8) [openmpi1 openmpi2 openmpi3]
    ) ++ map (pkg: callPackage ./module {
      inherit pkg;
      addOpenGLDrivers = true;
    }) [
      mplayer
      mpv
    ] ++ [
      (callPackage ./module {
        pkg = self.perl-all;
        addLocales = glibcLocales;
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
