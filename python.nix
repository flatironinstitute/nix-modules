world:
# python package overrides
self: pkgs:
with pkgs;

{

  bearcart = buildPythonPackage rec {
    pname = "bearcart";
    version = "0.1.3";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0krk7ir21jd2awq0sdrfnpwag5hvxyry17m6kxsrrj81jw43pnza";
    };
    doCheck = false; # broken imports
  };

  cherrypy = cherrypy.overridePythonAttrs {
    doCheck = false; # needs network :8080?
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

  engineio = buildPythonPackage rec {
    pname = "python-engineio";
    version = "2.0.1";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0c1ccz6fp783ppwwbsgm20i9885fqzyhdvsq6j3nqmyl9q6clvr6";
    };
    propagatedBuildInputs = [ six ];
    doCheck = false; # tox
  };

  flask-socketio = buildPythonPackage rec {
    pname = "Flask-SocketIO";
    version = "2.9.3";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0nbdljbr2x8fcl2zd8d4amlwyhn32m91cm0bpm1waac5vf8gf8yz";
    };
    propagatedBuildInputs = [ flask self.engineio self.socketio ];
    doCheck = false; # broken imports
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

  ggplot = buildPythonPackage rec {
    pname = "ggplot";
    version = "0.11.5";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "17s6aspq4i9jrqkg15pn7wazxnq66mbpcvc54nniby47b7mckfs8";
    };
    propagatedBuildInputs = [ six self.statsmodels self.brewer2mpl matplotlib scipy self.patsy self.pandas cycler numpy ];
    doCheck = false; # broken package
  };

  glue-core = buildPythonPackage rec {
    pname = "glue-core";
    version = "0.12.3";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1fppsalszd7hb18wk0apq5g9bq4bgik79ffk624xxq5w48yqsj5m";
    };
    propagatedBuildInputs = [ numpy self.pandas astropy matplotlib qtpy setuptools ipython ipykernel qtconsole dill self.xlrd h5py ];
    doCheck = false;
  };

  glue-vispy-viewers = buildPythonPackage rec {
    pname = "glue-vispy-viewers";
    version = "0.9";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1lwiqlhvkmhvh8bl7waydkfr1hdri3xszr2v3x147vf29wc1xy4a";
    };
    propagatedBuildInputs = [ numpy pyopengl self.glue-core qtpy scipy astropy ];
    doCheck = false;
  };

  glueviz = buildPythonPackage rec {
    pname = "glueviz";
    version = "0.12.2";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "18xxhkbl56h19cys8li1qcqd3ymhigwjhc700yxbgj75vw51g8hg";
    };
    propagatedBuildInputs = [ self.glue-core self.glue-vispy-viewers ];
  };

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

  jupyterlab_launcher = buildPythonPackage rec {
    pname = "jupyterlab_launcher";
    version = "0.10.5";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1v1ir182zm2dl14lqvqjhx2x40wnp0i32n6rldxnm1allfpld1n7";
    };
    propagatedBuildInputs = [ notebook ];
    doCheck = false; # no attribute 'token'?
  };

  jupyterlab = buildPythonPackage rec {
    pname = "jupyterlab";
    version = "0.31.12";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1hp6p9bsr863glildgs2iy1a4l99m7rxj2sy9fmkxp5zhyhqvsrz";
    };
    propagatedBuildInputs = [ notebook self.jupyterlab_launcher ];
    # some jupyterlab commands need node:
    buildInputs = [world.nodejs];
    # No tests in archive
    doCheck = false;
    # really ugly and messy and lazy:
    postFixup = ''
      echo $out
      PATH=$out/bin:$PATH JUPYTERLAB_DIR=$out/share/jupyter/lab HOME=$PWD jupyter-labextension install @jupyterlab/hub-extension
    '';
  };

  matlab_wrapper = buildPythonPackage rec {
    pname = "matlab_wrapper";
    version = "0.9.8";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0zcx78y61cpk08akniz9wpdc09s5bchis736h31l5kvss8s8qg50";
    };
    propagatedBuildInputs = [ numpy ];
  };

  mpi4py = mpi4py.overridePythonAttrs {
    doCheck = false;
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

  PIMS = buildPythonPackage rec {
    pname = "PIMS";
    version = "0.4.1";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1pf96krhafn281y4jlib7kn7xvdspz61y7ks29qlxd00x5as2lva";
    };
    propagatedBuildInputs = [ self.slicerator six numpy ];
    checkInputs = [ nose ];
    doCheck = false; # missing files?
  };

  primefac = buildPythonPackage rec {
    pname = "primefac";
    version = "1.1";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0l5g4wfmf47amal4qzvhpcymlw1rnjhkzbvd2j4k21x8pimi0a2j";
    };
  };

  pystan = buildPythonPackage rec {
    pname = "pystan";
    version = "2.17.0.0";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0jayb6xkxmyl984vyfdhp0zl6qbia95xjgzys8ki875b1rf9sa17";
    };
    propagatedBuildInputs = [ cython numpy matplotlib ];
    doCheck = false; # long, slow tests
  };

  scikitlearn = scikitlearn.overridePythonAttrs {
    doCheck = false; # whitespace doctest failures and others
  };

  slicerator = buildPythonPackage rec {
    pname = "slicerator";
    version = "0.9.8";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0rsn1x59wwgwhd4nkm2kj0sp9q9gjbqzpmnbhlhqgn2z85mdf7dr";
    };
    propagatedBuildInputs = [ six ];
  };

  socketio = buildPythonPackage rec {
    pname = "python-socketio";
    version = "1.8.4";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1k12l4xdbvx3acrj7z5m3sx0s75c3wxs958jncaisdw5gvhpr00k";
    };
    propagatedBuildInputs = [ six self.engineio ];
    doCheck = false; # tox
  };

  statistics = buildPythonPackage rec {
    pname = "statistics";
    version = "3.4.0b3";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1ifhv9x5rjzjnpl2w62nvxpbj62vdz0pd5s3g45q0138cvcqad6j";
    };
    propagatedBuildInputs = [docutils];
    doCheck = false;
  };

  subprocess32 = subprocess32.overridePythonAttrs {
    doCheck = false; # slow, needs user
  };

  weave = buildPythonPackage rec {
    pname = "weave";
    version = "0.16.0";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0jnm3584mfichgwgrd1gk5i42ll9c08nkw9716n947n4338f6ghs";
    };
    propagatedBuildInputs = [ numpy ];
    checkInputs = [ nose ];
    doCheck = false; # known failures? need user?
  };

  # only 0.9 in nix:
  xlrd = buildPythonPackage rec {
    pname = "xlrd";
    version = "1.1.0";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1qnp51lf6bp6d4m3x8av81hknhvmlvgmzvm86gz1bng62daqh8ca";
    };
    buildInputs = [ nose ];
    checkPhase = ''
      nosetests -v
    '';
  };

  yt = buildPythonPackage rec {
    pname = "yt";
    version = "3.4.0";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0k3d15sqld35ki3ab939xhhk3bmym4ci32hxjs1klivp2ryhalny";
    };
    propagatedBuildInputs = [ cython matplotlib setuptools sympy numpy ipython ];
    doCheck = false; # unknown failure
  };

}
