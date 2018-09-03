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

  fast-histogram = buildPythonPackage rec {
    pname = "fast-histogram";
    version = "0.4";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "068l53nway4778aavjf4hdg4ha216z2lajihrrsdx7hcjdbymz4a";
    };
    propagatedBuildInputs = [ numpy ];
    checkInputs = [ hypothesis ];
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

  flit = flit.overridePythonAttrs {
    doCheck = false; # uses $HOME
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
    version = "0.13.3";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1sbpcqamsk8g1yn4f75hmkl9jj5azn0y5jrpzgpq2v1n32f3wkns";
    };
    propagatedBuildInputs = [ numpy self.pandas astropy matplotlib qtpy setuptools ipython ipykernel qtconsole dill self.xlrd h5py self.mpl-scatter-density ];
    doCheck = false;
  };

  glue-vispy-viewers = buildPythonPackage rec {
    pname = "glue-vispy-viewers";
    version = "0.10";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0jia4yf100khqz41r4v8nf0z2a7icyrkgrjljynglziz1x3qnvp7";
    };
    propagatedBuildInputs = [ numpy pyopengl self.glue-core qtpy scipy astropy ];
    doCheck = false;
  };

  glueviz = buildPythonPackage rec {
    pname = "glueviz";
    version = "0.13.3";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0avmdpbzfcwp5ilv7wdz9n1fiviqyf2m5sgzhyd40dsrirh1grl0";
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

  jupyterlab = jupyterlab.overridePythonAttrs {
    buildInputs = [world.nodejs];
    postFixup = ''
      PATH=$out/bin:$PATH JUPYTERLAB_DIR=$out/share/jupyter/lab HOME=$PWD jupyter-labextension install @jupyterlab/hub-extension@0.11.0
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

  mpl-scatter-density = buildPythonPackage rec {
    pname = "mpl-scatter-density";
    version = "0.3";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0lc6cl5q33n0g534sng9dagbdbr0rny3hqnc1mbm5im8mrr335cq";
    };
    propagatedBuildInputs = [ numpy matplotlib self.fast-histogram ];
    checkInputs = [ pytest ];
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
    version = "2.17.1.0";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0y4vaa1yybgxpnfjpdsgxpzrz4jg4q3bias1866480n0019ipyfl";
    };
    propagatedBuildInputs = [ cython numpy matplotlib ];
    doCheck = false; # long, slow tests
  };

  pytest-sugar = pytest-sugar.overridePythonAttrs {
    doCheck = false; # strange test error
  };

  pytorch = pytorch.overridePythonAttrs {
    doCheck = false; # needs cuda
  };

  pywavelets = pywavelets.overridePythonAttrs {
    doCheck = false; # numeric test failure
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
    version = "3.4.1";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "15aq0rjbzramayikjfbfvbzp9dszlbi5zh40nsiyg0qnw9zw9kx4";
    };
    propagatedBuildInputs = [ cython matplotlib setuptools sympy numpy ipython ];
    doCheck = false; # unknown failure
  };

}
