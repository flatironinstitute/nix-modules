self: pkgs:
with pkgs;

{
  nss_sss = callPackage base/sssd/nss-client.nix { };

  gcc5 = wrapCC (gcc5.cc.override {
    langC = true;
    langCC = true;
    langFortran = true;
    langObjC = true;
    langObjCpp = true;
    enableShared = true;
    enableMultilib = false;
  });
  gfortran5 = self.gcc5;

  gcc6 = wrapCC (gcc6.cc.override {
    langC = true;
    langCC = true;
    langFortran = true;
    langObjC = true;
    langObjCpp = true;
    enableShared = true;
    enableMultilib = false;
  });
  gfortran6 = self.gcc6;

  gcc7 = wrapCC (gcc7.cc.override {
    langC = true;
    langCC = true;
    langFortran = true;
    langObjC = true;
    langObjCpp = true;
    enableShared = true;
    enableMultilib = false;
  });
  gfortran7 = self.gcc7;

  # Make gcc7 default world compiler
  gcc = self.gcc7;

  # intel infiniband/psm stuff
  infinipath-psm = callPackage base/infinipath-psm { };
  libpsm2 = callPackage base/libpsm2 { };
  rdma-core = callPackage base/rdma-core { };

  openmpi1 = callPackage devel/openmpi/1.nix { };
  openmpi2 = callPackage devel/openmpi/2.nix { };
  openmpi = self.openmpi1;

  osu-micro-benchmarks-openmpi1 = callPackage test/osu-micro-benchmarks {
    mpi = self.openmpi1;
  };
  osu-micro-benchmarks-openmpi2 = callPackage test/osu-micro-benchmarks {
    mpi = self.openmpi2;
  };

  #openblas = callPackage base/openblas { };
  #openblasCompat = self.openblas;
  blas = self.openblas;

  fftw = callPackage base/fftw/precs.nix {
    mpi = null;
  };
  fftw-openmpi1 = callPackage base/fftw/precs.nix {
    mpi = self.openmpi1;
  };
  fftw-openmpi2 = callPackage base/fftw/precs.nix {
    mpi = self.openmpi2;
  };

  fftwSinglePrec = self.fftw;
  fftwFloat = self.fftw;
  fftwLongDouble = self.fftw;

  nfft = callPackage devel/nfft {
    fftw = self.fftw;
  };

  hdf5 = import devel/hdf5/mpi.pp {
    hdf5 = <nixpkgs/pkgs/tools/misc/hdf5>;
    inherit callPackage;
    mpi = null;
  };
  hdf5-openmpi1 = callPackage devel/hdf5/mpi.pp {
    hdf5 = <nixpkgs/pkgs/tools/misc/hdf5>;
    mpi = self.openmpi1;
  };
  hdf5-openmpi2 = callPackage devel/hdf5/mpi.pp {
    hdf5 = <nixpkgs/pkgs/tools/misc/hdf5>;
    mpi = self.openmpi2;
  };

  hdf5_18 = import devel/hdf5/mpi.pp {
    hdf5 = <nixpkgs/pkgs/tools/misc/hdf5/1_8.nix>;
    inherit callPackage;
    mpi = null;
  };
  hdf5_18-openmpi1 = callPackage devel/hdf5/mpi.pp {
    hdf5 = <nixpkgs/pkgs/tools/misc/hdf5/1_8.nix>;
    mpi = self.openmpi1;
  };
  hdf5_18-openmpi2 = callPackage devel/hdf5/mpi.pp {
    hdf5 = <nixpkgs/pkgs/tools/misc/hdf5/1_8.nix>;
    mpi = self.openmpi2;
  };

  libuv = libuv.overrideAttrs (old: {
    doCheck = false;
  });

  # Patch qt5.10 to remove minimum linux kernel version linker checks (which are wrong on centos7 "3.10")
  # But this still doesn't work because other qt modules still use the old qtbase (nested scopes??)
  qt510 = qt510.overrideScope (super: self: {
    qtbase = super.qtbase.overrideAttrs (old: {
      postPatch = old.postPatch + ''
        sed -i '/global\/minimum-linux/d' src/corelib/global/global.pri
        rm src/corelib/global/minimum-linux.S
      '';
    });
  });

  # Switch to qt59 until above is solved
  qt5 = qt59;
  libsForQt5 = libsForQt59;

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
    dask
    #DataSpyre
    #deepTools
    distributed
    #einsum2
    emcee
    flask
    flask-socketio
    flask_wtf
    fusepy
    fuzzysearch
    gevent
    gflags
    ggplot
    h5py
    heapdict
    hglib
    husl
    intervaltree
    ipdb
    ipython #[all]
    jupyter #-- qt5
    leveldb
    llfuse
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
    partd
    PIMS
    pip
    primefac
    protobuf
    psutil
    psycopg2
    py
    pycairo
    pycuda
    pyfftw
    pygobject2
    #pymultinest
    pyparsing
    pyqt5 #-- qt5
    #pyslurm -- need matching version
    pystan
    pytest
    pytools
    pyyaml
    pyzmq
    s3fs
    s3transfer
    #scikit-cuda
    scikitimage
    scikitlearn
    scipy
    seaborn
    setuptools
    sip
    six
    sphinx
    sqlalchemy
    statsmodels
    sympy
    #tensorflow-gpu
    #Theano -- clblas
    twisted
    urllib3
    virtualenv
    wheel
    yt
  ] ++ (if isPy3k then [
    astropy
    bash_kernel
    glueviz #-- qt
    jupyterhub
    jupyterlab
    ws4py
  ] else [
    biopython #-- build failure on python3
    fwrap
    MySQL_python
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
    TermReadLineGnu
    HTMLParser
    HTTPDaemon
    #Git?
    TimeDuration
    TimeHiRes
    XMLParser
    XMLSAX
    Socket
    GetoptLong
  ];

  perl-all = buildEnv {
    inherit (perl) name;
    paths = [perl] ++ self.perlPackageList perlPackages;
  };

  R-all = rWrapper.override {
    packages = with rPackages; [
      AnnotationDbi
      BH
      BiocInstaller
      bit64
      blob
      getopt
      ggplot2
      JuniperKernel
      lazyeval
      memoise
      pkgconfig
      plogr
    ];
  };

  haskell-all = haskellPackages.ghcWithPackages (hp: with hp; [
    cabal-install
    stack
    ihaskell
  ]);

  julia = julia.overrideAttrs (old: {
    doCheck = false;
  });

  texlive-all = texlive.combined.scheme-full // {
    name = builtins.replaceStrings ["-combined-full"] [""] texlive.combined.scheme-full.name;
  };

  disBatch = callPackage flatiron/disBatch { };

  module-wrap = callPackage module/wrap { };

  modules =
    let
      module = pkg: callPackage ./module {
        inherit pkg;
      };
    in buildEnv {
      name = "modules";
      paths = map module (with self; [
        gcc5
        gcc6
        gcc7
        boost
        clang_4
        clang_5
        clang_6
        cmake
        cudatoolkit75
        cudatoolkit8
        cudatoolkit9
        cudnn6_cudatoolkit8
        cudnn_cudatoolkit75
        cudnn_cudatoolkit8
        cudnn_cudatoolkit9
        disBatch
        dstat
        eigen3_3
        elinks
        ffmpeg
        fftw
        fftw-openmpi1
        fftw-openmpi2
        gitFull
        gdb
        haskell-all
        hdf5
        hdf5-openmpi1
        hdf5-openmpi2
        hdf5_18
        hdf5_18-openmpi1
        hdf5_18-openmpi2
        hdfview
        hwloc
        jdk
        julia
        mercurial
        mplayer
        netcdf
        nodejs
        nfft
        openmpi1
        openmpi2
	osu-micro-benchmarks-openmpi1
	osu-micro-benchmarks-openmpi2
        perl-all
        python2-all
        python3-all
        (qt5.full // { name = builtins.replaceStrings ["-full"] [""] qt5.full.name; })
        R-all
        singularity
        subversion
        texlive-all
        valgrind
        vim
      ]);
    };

  jupyter = self.python3.withPackages (p: with p; [jupyterhub jupyterlab]);

  jupyter-env = buildEnv {
    name = "jupyter-env";
    paths = [
      self.jupyter
    ] ++ map (callPackage jupyter/kernel) [
      { env = self.python2-all; }
      { env = self.python3-all; }
      { env = self.R-all; kernelSrc = (callPackage jupyter/kernel/juniper { env = self.R-all; }); }
      { env = self.haskell-all; kernelSrc = (callPackage jupyter/kernel/ihaskell { env = self.haskell-all; }); }
      { env = "/cm/shared/sw/pkg-old/devel/python2/2.7.13"; prefix = "module-python2-2.7.13"; note = " (python2/2.7.13)"; }
      { env = "/cm/shared/sw/pkg-old/devel/python3/3.6.2";  prefix = "module-python3-3.6.2";  note = " (python3/3.6.2)"; }
      # TODO:
      #nodejs 
      #julia
    ];
  };
}
