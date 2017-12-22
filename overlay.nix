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
    #packageOverrides = import ./python.nix;
  };
  
  python3 = callPackage <nixpkgs/pkgs/development/interpreters/python/cpython/3.6> {
    self = self.python3;
    CF = null;
    configd = null;
    #packageOverrides = import ./python.nix;
  };

  pythonPackageList = p: with p; let
    husl = buildPythonPackage rec {
      pname = "husl";
      version = "4.0.3";
      name = "${pname}-${version}";
      src = fetchPypi {
        inherit pname version;
        sha256 = "1fahd35yrpvdqzdd1r6r416d0csg4jbxwlkzm19sa750cljn47ca";
      };
      doCheck = false;
    };
    brewer2mpl = buildPythonPackage rec {
      pname = "brewer2mpl";
      version = "1.4.1";
      name = "${pname}-${version}";
      src = fetchPypi {
        inherit pname version;
        sha256 = "070vbc4wclzlln3wq22y3n54bxlaf7641vg4fym8as3nx8dls29f";
      };
    };
    # only 0.3.0 in nix:
    patsy = buildPythonPackage rec {
      pname = "patsy";
      version = "0.4.1";
      name = "${pname}-${version}";

      src = fetchPypi {
        inherit pname version;
        extension = "zip";
        sha256 = "1m6knyq8hbqlx242y4da02j0x86j4qggs1j7q186w3jv0j0c476w";
      };

      buildInputs = [ nose ];
      propagatedBuildInputs = [six numpy];
    };
    # for updated patsy:
    statsmodels = buildPythonPackage rec {
      pname = "statsmodels";
      version = "0.8.0";
      name = "${pname}-${version}";
      src = fetchPypi {
        inherit pname version;
        sha256 = "26431ab706fbae896db7870a0892743bfbb9f5c83231644692166a31d2d86048";
      };
      checkInputs = [ nose ];
      propagatedBuildInputs = [numpy scipy pandas patsy cython matplotlib];
      doCheck = false;
    };
    ggplot = buildPythonPackage rec {
      pname = "ggplot";
      version = "0.11.5";
      name = "${pname}-${version}";
      src = fetchPypi {
        inherit pname version;
        sha256 = "17s6aspq4i9jrqkg15pn7wazxnq66mbpcvc54nniby47b7mckfs8";
      };
      propagatedBuildInputs = [ six statsmodels brewer2mpl matplotlib scipy patsy pandas cycler numpy ];
    };
    fuzzysearch = buildPythonPackage rec {
      pname = "fuzzysearch";
      version = "0.5.0";
      name = "${pname}-${version}";
      src = fetchPypi {
        inherit pname version;
        sha256 = "0qh62w1fsww41x7f5jnl86a38kqzxp3mj3klkrmfpp0sij0h3nsj";
      };
      propagatedBuildInputs = [ six ];
    };
    fwrap = buildPythonPackage rec {
      pname = "fwrap";
      version = "0.1.1";
      name = "${pname}-${version}";
      src = fetchPypi {
        inherit pname version;
        sha256 = "0vc5nzsxmgjl88q71bwy1p35s9179685q507v1lbbhzwfsqxc8n1";
      };
      propagatedBuildInputs = [ numpy ];
      checkInputs = [ nose ];
    };
  in [
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
    MySQL_python    # python2 only
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
    fwrap
    #Flask-SocketIO
    flask_wtf
    heapdict
    pyyaml
    twisted
    #ws4py -- depends on cherrypy
    sympy
    #NucleoATAC    # python2 only
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
    pygtk
    #gobject-introspection-devel
    pycairo
  ];

  python2-all = python2.withPackages self.pythonPackageList;
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
        cudnn6_cudtoolkit8
        cudnn_cudtoolkit75
        cudnn_cudtoolkit8
        cudnn_cudtoolkit9
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
        python2 #-all
        python3 #-all
      ]);
    };
}
