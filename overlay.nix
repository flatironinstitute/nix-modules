self: pkgs:
with pkgs;

{
  nss_sss = callPackage base/sssd/nss-client.nix { };

  wrapCC = cc: wrapCCWith {
    inherit cc;
    bintools = self.binutils;
    libc = stdenv.cc.libc;
    #extraBuildCommands = ''
    #  echo "-L${self.nss_sss}/lib" >> $out/nix-support/cc-ldflags
    #'';
  };

  gcc6 = self.wrapCC (gcc6.cc.override {
    langC = true;
    langCC = true;
    langFortran = true;
    langObjC = true;
    langObjCpp = true;
    enableShared = true;
    enableMultilib = false;
  });
  gfortran6 = self.gcc6;

  gcc7 = self.wrapCC (gcc7.cc.override {
    langC = true;
    langCC = true;
    langFortran = true;
    langObjC = true;
    langObjCpp = true;
    enableShared = true;
    enableMultilib = false;
  });
  gfortran7 = self.gcc7;

  # Make gcc6 default world compiler
  gcc = self.gcc6.override {
    shell = bash + "/bin/bash";
  };
  stdenv = stdenv.override { allowedRequisites = null; };

  libuv = libuv.overrideAttrs (old: {
    preCheck = ''
      export LD_LIBRARY_PATH=${self.nss_sss}/lib
    '';
  });

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

  openblas = callPackage base/openblas { };
  openblasCompat = self.openblas;
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

  python2 = python2.override {
    self = self.python2;
    ucsEncoding = 4;
    CF = null;
    configd = null;
    packageOverrides = import ./python.nix;
  };

  python3 = python3.override {
    self = self.python3;
    CF = null;
    configd = null;
    packageOverrides = import ./python.nix;
  };

  python = self.python2;
  pythonPackages = self.python.pkgs;
  python2Packages = self.python2.pkgs;
  python3Packages = self.python3.pkgs;

  pythonPackageList = p: with p; [
    six
    packaging
    pyparsing
    appdirs
    setuptools
    pip
    sip
    pyqt5
    #tensorflow-gpu
    numpy
    scipy
    pyzmq
    cython
    matplotlib
    ipython #[all]
    flask
    cherrypy
    numexpr
    bottleneck
    pandas
    statsmodels
    husl
    ggplot
    scikitlearn
    ipdb
    paho-mqtt
    mpi4py
    wheel
    protobuf
    #Theano -- clblas
    urllib3
    biopython
    fuzzysearch
    virtualenv
    sqlalchemy
    psycopg2
    pyfftw
    psutil
    py
    pytest
    pytools
    Mako
    pycuda
    #scikit-cuda
    h5py
    astropy
    flask-socketio
    flask_wtf
    heapdict
    pyyaml
    twisted
    ws4py
    sympy
    olefile
    jupyter
    gevent
    #metaseq
    #DataSpyre
    s3transfer
    s3fs
    scikitimage
    dask
    #deepTools
    PIMS
    primefac
    leveldb
    distributed
    bearcart
    #bokeh #-- selenium, rustc
    seaborn
    locket
    intervaltree
    emcee
    netcdf4
    partd
    #pymultinest
    pystan
    gflags
    backports_ssl_match_hostname
    fusepy
    llfuse
    yt
    hglib
    glueviz
    matlab_wrapper
    #einsum2
    #nbodykit#[extras]
    pygobject2
    pycairo
    sphinx
  ] ++ (if isPy3k then [
  ] else [
    weave
    MySQL_python
    fwrap
    statistics
    #NucleoATAC
    pygtk
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

  rPackageList = p: with p; [
    AnnotationDbi
    BH
    BiocInstaller
    bit64
    blob
    getopt
    ggplot2
    lazyeval
    memoise
    pkgconfig
    plogr
  ];

  R-all = rWrapper.override {
    packages = self.rPackageList rPackages;
  };

  singularity = singularity.overrideAttrs (old: {
    postPatch = ''
      export LD_LIBRARY_PATH=${self.nss_sss}/lib
    '';
  });

  disBatch = callPackage flatiron/disBatch { };

  modules =
    let
      base = map (pkg: callPackage ./module {
        inherit pkg;
        addLDLibraryPath = true;
        addCFlags = false;
      }) (with self; [
        nss_sss
      ]);
      module = pkg: callPackage ./module {
        inherit pkg;
        modLoad = map (m: m.modName) base;
      };
    in buildEnv {
      name = "modules";
      paths = base ++ map module (with self; [
        gcc5
        gcc6
        gcc7
        boost
        clang_4
        clang_5
        cmake
        cudatoolkit75
        cudatoolkit8
        cudatoolkit9
        cudnn6_cudatoolkit8
        cudnn_cudatoolkit75
        cudnn_cudatoolkit8
        cudnn_cudatoolkit9
        disBatch
        eigen3_3
        ffmpeg
        fftw
        fftw-openmpi1
        fftw-openmpi2
        gitFull
        hdf5
        hdf5-openmpi1
        hdf5-openmpi2
        hdf5_18
        hdf5_18-openmpi1
        hdf5_18-openmpi2
        hdfview
        hwloc
        jdk
        mplayer
        netcdf
        nfft
        openmpi1
        openmpi2
        perl-all
        python2-all
        python3-all
        R-all
        singularity
      ]);
    };
}
