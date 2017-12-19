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

  gcc = self.gcc6.override {
    shell = bash + "/bin/bash";
  };
  stdenv = stdenv.override { allowedRequisites = null; };

  # intel infiniband/psm stuff
  infinipath-psm = callPackage base/infinipath-psm { };
  libpsm2 = callPackage base/libpsm2 { };
  rdma-core = callPackage base/rdma-core { };

  openmpi = callPackage devel/openmpi/1.10.7.nix { };
  openmpi2 = callPackage devel/openmpi/2.1.2.nix { };

  openblas = callPackage base/openblas { };
  blas = self.openblas;
  openblasCompat = self.openblas;

  fftw = callPackage base/fftw/precs.nix {
    mpi = null;
  };
  fftw-openmpi1 = callPackage base/fftw/precs.nix {
    mpi = openmpi;
  };
  fftw-openmpi2 = callPackage base/fftw/precs.nix {
    mpi = openmpi2;
  };

  hdf5 = callPackage <nixpkgs/pkgs/tools/misc/hdf5> {
    szip = null;
    mpi = null;
  };

  python2 = callPackage <nixpkgs/pkgs/development/interpreters/python/cpython/2.7> {
    self = self.python2;
    ucsEncoding = 4;
    CF = null;
    configd = null;
  };

  python3 = callPackage <nixpkgs/pkgs/development/interpreters/python/cpython/3.6> {
    self = self.python3;
    CF = null;
    configd = null;
  };

  numpy = callPackage <nixpkgs/pkgs/development/python-modules/numpy> {
    blas = self.openblas;
    inherit (python2.pkgs) fetchPypi buildPythonPackage isPy27 isPyPy nose;
  };

  pythonPackageList = [
    "six"
    "packaging"
    "pyparsing"
    "appdirs"
    "setuptools"
    "pip"
    "sip"
    "pyqt5"
    "tensorflow-gpu"
    "numpy"
    "scipy"
    "weave"
    "pyzmq"
    "cython"
    "matplotlib"
    "ipython"
    "ipython[all]"
    "flask"
    "cherrypy"
    "numexpr"
    "bottleneck"
    "pandas"
    "statsmodels"
    "husl"
    "ggplot"
    "scikit-learn"
    "ipdb"
    "MySQL-python    # python2 only"
    "paho-mqtt"
    "mpi4py"
    "wheel"
    "protobuf"
    "Theano"
    "urllib3"
    "biopython"
    "fuzzysearch"
    "virtualenv"
    "sqlalchemy"
    "psycopg2"
    "pyFFTW"
    "psutil"
    "py"
    "pytest"
    "pytools"
    "mako"
    "pycuda"
    "scikit-cuda"
    "h5py"
    "astropy"
    "fwrap"
    "Flask-SocketIO"
    "Flask-WTF"
    "HeapDict"
    "PyYAML"
    "Twisted"
    "ws4py"
    "sympy"
    "NucleoATAC    # python2 only"
    "olefile"
    "jupyter"
    "gevent"
    "metaseq"
    "DataSpyre"
    "s3transfer"
    "s3fs"
    "scikit-image"
    "statistics"
    "dask"
    "deepTools"
    "PIMS"
    "primefac"
    "leveldb"
    "distributed"
    "bearcart"
    "bokeh"
    "seaborn"
    "locket"
    "intervaltree"
    "emcee"
    "netCDF4"
    "partd"
    "pymultinest"
    "pystan"
    "python-gflags"
    "backports.ssl_match_hostname"
    "fusepy"
    "llfuse"
    "yt"
    "python-hglib"
    "glueviz"
    "matlab_wrapper"
    "einsum2"
    "nbodykit[extras]"
    "gobject-introspection"
    "pygobject"
    "pygtk"
    "gobject-introspection-devel"
    "pycairo"
  ];
}
