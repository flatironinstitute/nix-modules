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

  # Make gcc7 default world compiler
  gcc = self.gcc7;

  nix = nix.overrideAttrs (old: {
    patches = [./nix.patch];
    doInstallCheck = false;
  });

  # intel infiniband/psm stuff
  infinipath-psm = callPackage base/infinipath-psm { };
  libpsm2 = callPackage base/libpsm2 { };
  rdma-core = callPackage base/rdma-core { };

  hwloc = callPackage base/hwloc { };
  slurm = callPackage base/slurm { };

  openmpi1 = callPackage devel/openmpi/1.nix { };
  openmpi2 = callPackage devel/openmpi/2.nix { };
  openmpi3 = callPackage devel/openmpi/3.nix { };
  openmpi = self.openmpi2;

  mvapich2 = callPackage devel/mvapich { };

  osu-micro-benchmarks-openmpi1 = callPackage test/osu-micro-benchmarks {
    mpi = self.openmpi1;
  };
  osu-micro-benchmarks-openmpi2 = callPackage test/osu-micro-benchmarks {
    mpi = self.openmpi2;
  };
  osu-micro-benchmarks-openmpi3 = callPackage test/osu-micro-benchmarks {
    mpi = self.openmpi3;
  };

  #openblas = callPackage base/openblas { };
  #openblasCompat = self.openblas;
  blas = self.openblas;

  linuxPackages = linuxPackages_4_4.extend (self: super: {
    nvidia_x11 = callPackage (import nixpkgs/pkgs/os-specific/linux/nvidia-x11/generic.nix {
      version = "410.78";
      sha256_64bit = "1ciabnmvh95gsfiaakq158x2yws3m9zxvnxws3p32lz9riblpdjx";
      settingsSha256 = "1677g7rcjbcs5fja1s4p0syhhz46g9x2qqzyn3wwwrjsj7rwaz77";
      persistencedSha256 = "01kvd3zp056i4n8vazj7gx1xw0h4yjdlpazmspnsmwg24ijb82x4";
    }) {
      libsOnly = true;
    };
  });

  fftw = callPackage base/fftw/precs.nix {
    mpi = null;
  };
  fftw-openmpi1 = callPackage base/fftw/precs.nix {
    mpi = self.openmpi1;
  };
  fftw-openmpi2 = callPackage base/fftw/precs.nix {
    mpi = self.openmpi2;
  };
  fftw-openmpi3 = callPackage base/fftw/precs.nix {
    mpi = self.openmpi3;
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
  hdf5-openmpi3 = callPackage devel/hdf5/mpi.pp {
    hdf5 = <nixpkgs/pkgs/tools/misc/hdf5>;
    mpi = self.openmpi3;
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
  hdf5_18-openmpi3 = callPackage devel/hdf5/mpi.pp {
    hdf5 = <nixpkgs/pkgs/tools/misc/hdf5/1_8.nix>;
    mpi = self.openmpi3;
  };

  gsl = gsl.overrideAttrs (old: {
    doCheck = false;
    # FAIL: mcholesky_invert unscaled hilbert (  4,  4)[0,2]: -2.55795384873636067e-13                        0
    #  (-2.55795384873636067e-13 observed vs 0 expected) [789499]
  });

  fflas-ffpack = fflas-ffpack.overrideAttrs (old: {
    doCheck = false;
  });

  libuv = libuv.overrideAttrs (old: {
    doCheck = false;
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
    dask
    #DataSpyre
    #deepTools
    distributed
    #einsum2
    emcee
    flask
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
    pims
    pip
    primefac
    protobuf
    psutil
    psycopg2
    py
    pycairo
    #pycuda
    #pyfftw #-- pending 0.11 upgrade
    pygobject2
    #pymultinest
    pyparsing
    pyqt5 #-- qt5
    pyslurm
    pystan
    pytest
    pytools
    pytorch
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
    shapely
    sip
    six
    sphinx
    sqlalchemy
    statsmodels
    sympy
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
    flask-socketio
    glueviz #-- qt
    jupyterhub
    jupyterlab
    llfuse #-- unicode problems on python2
    ws4py
  ] else [
    biopython #-- build failure on python3
    fwrap
    MySQL_python
    #NucleoATAC
    pygtk
    statistics
    tensorflow
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
      #AnnotationDbi
      BH
      #BiocInstaller
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
    #ihaskell
  ]);

  julia = julia.overrideAttrs (old: {
    doCheck = false;
  });

  texlive-all = texlive.combined.scheme-full // {
    name = builtins.replaceStrings ["-combined-full"] [""] texlive.combined.scheme-full.name;
  };

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

  rcs = rcs.overrideAttrs (old: {
    # unknown t999 failure
    doCheck = false;
  });

  sage = sage.overrideAttrs (old: {
    # disable tests:
    buildInputs = [makeWrapper];
  });

  wecall = callPackage util/wecall {
    texlive = self.texlive-all;
  };

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
        gcc8
        arpack
        boost
        clang_4
        clang_5
        clang_6
        clang_7
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
        dep
        disBatch
        dstat
        eigen
        elinks
        feh
        ffmpeg
        fftw
        fftw-openmpi1
        fftw-openmpi2
        fftw-openmpi3
        gitFull
        gdb
        gmp
        go
        haskell-all
        hdf5
        hdf5-openmpi1
        hdf5-openmpi2
        hdf5-openmpi3
        hdf5_18
        hdf5_18-openmpi1
        hdf5_18-openmpi2
        hdf5_18-openmpi3
        hdfview
        hwloc
        jdk
        julia
        mercurial
        mplayer
        mpv
        mupdf
        netcdf
        nodejs-6_x
        nodejs-8_x
        nodejs-10_x
        nfft
        octave
        openmpi1
        openmpi2
        openmpi3
        openssl
        osu-micro-benchmarks-openmpi1
        osu-micro-benchmarks-openmpi2
        osu-micro-benchmarks-openmpi3
        perl-all
	#petsc
        python2-all
        python3-all
        (qt5.full // { name = builtins.replaceStrings ["-full"] [""] qt5.full.name; })
        R-all
        rclone
	sage
        singularity
	smartmontools
        subversion
        texlive-all
        valgrind
        vim
        vscode
        vtk
	wecall
        xscreensaver
      ]) ++ [
        (callPackage ./module {
          pkg = self.nix;
          modConflict = ["nix/nix"];
          addCFlags = false;
        })
      ];
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
      #{ env = self.haskell-all; kernelSrc = (callPackage jupyter/kernel/ihaskell { env = self.haskell-all; }); }
      { env = "/cm/shared/sw/pkg-old/devel/python2/2.7.13"; ld_library_path = "/cm/shared/sw/pkg/devel/gcc/5.4.0/lib"; prefix = "module-python2-2.7.13"; note = " (python2/2.7.13)"; }
      { env = "/cm/shared/sw/pkg-old/devel/python3/3.6.2";  ld_library_path = "/cm/shared/sw/pkg/devel/gcc/5.4.0/lib"; prefix = "module-python3-3.6.2";  note = " (python3/3.6.2)"; }
      # TODO:
      #nodejs 
      #julia
    ] ++ map (callPackage jupyter/kernel/spec.nix) [
      { kernelspec = self.sage.kernelspec; }
    ];
  };
}
