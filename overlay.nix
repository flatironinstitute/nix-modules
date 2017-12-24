self: pkgs:
with pkgs;

{
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

  # Make gcc6 default world compiler
  gcc = self.gcc6.override {
    shell = bash + "/bin/bash";
  };
  stdenv = stdenv.override { allowedRequisites = null; };

  # intel infiniband/psm stuff
  infinipath-psm = callPackage base/infinipath-psm { };
  libpsm2 = callPackage base/libpsm2 { };
  rdma-core = callPackage base/rdma-core { };

  openmpi1 = callPackage devel/openmpi/1.nix { };
  openmpi2 = callPackage devel/openmpi/2.nix { };
  openmpi = self.openmpi1;

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

  hdf5 = callPackage <nixpkgs/pkgs/tools/misc/hdf5> {
    szip = null;
    mpi = null;
  };

  python2 = callPackage <nixpkgs/pkgs/development/interpreters/python/cpython/2.7> {
    self = self.python2;
    ucsEncoding = 4;
    CF = null;
    configd = null;
    packageOverrides = import ./python.nix;
  };
  
  python3 = callPackage <nixpkgs/pkgs/development/interpreters/python/cpython/3.6> {
    self = self.python3;
    CF = null;
    configd = null;
    packageOverrides = import ./python.nix;
  };

  # re-apply packageOverrides to make sure they're in scope
  pythonPackageList = p: let pp = import ./python.nix pp p; in with p // pp; [
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
    #weave -- part of scipy
    pyzmq
    cython
    matplotlib
    ipython #[all]
    flask
    #cherrypy -- broken, maybe :8080 conflict
    numexpr
    bottleneck
    pandas
    statsmodels
    husl
    ggplot
    scikitlearn
    ipdb
    paho-mqtt
    (mpi4py.overridePythonAttrs {
      doCheck = false;
    })
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
    #Flask-SocketIO
    flask_wtf
    heapdict
    pyyaml
    twisted
    #ws4py -- depends on cherrypy
    sympy
    olefile
    jupyter
    gevent
    #metaseq
    #DataSpyre
    s3transfer
    s3fs
    scikitimage
    #statistics
    dask
    #deepTools
    #PIMS
    #primefac
    leveldb
    distributed
    #bearcart
    bokeh
    seaborn
    locket
    intervaltree
    emcee
    netcdf4
    partd
    #pymultinest
    #pystan
    gflags
    backports_ssl_match_hostname
    fusepy
    llfuse
    #yt
    hglib
    #glueviz
    #matlab_wrapper
    #einsum2
    #nbodykit#[extras]
    #gobject-introspection
    pygobject2
    #gobject-introspection-devel
    pycairo
  ] ++ lib.optionals (!isPy3k) [
    MySQL_python
    fwrap
    #NucleoATAC    # python2 only
    pygtk
  ];

  python2-all = (python2.withPackages self.pythonPackageList).override {
    ignoreCollisions = true; # see #31080
  };
  python3-all = python3.withPackages self.pythonPackageList;

  osu-micro-benchmarks-openmpi1 = callPackage test/osu-micro-benchmarks {
    mpi = self.openmpi1;
  };
  osu-micro-benchmarks-openmpi2 = callPackage test/osu-micro-benchmarks {
    mpi = self.openmpi2;
  };

  nss_sss = callPackage base/sssd/nss-client.nix { };

  modules =
    let
      base = map (pkg: callPackage ./module {
        inherit pkg;
        addLDLibraryPath = true;
        addCCFlags = false;
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
        cmake
        cudnn6_cudatoolkit8
        cudnn_cudatoolkit75
        cudnn_cudatoolkit8
        cudnn_cudatoolkit9
        cudatoolkit75
        cudatoolkit8
        cudatoolkit9
        openmpi1
        openmpi2
        fftw
        fftw-openmpi1
        fftw-openmpi2
        hdf5
        netcdf
        python2-all
        python3-all
      ]);
    };
}