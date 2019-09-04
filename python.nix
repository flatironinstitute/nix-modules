world:
# python package overrides
self: pkgs:
with pkgs;

{

  asyncio = null;

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

  brewer2mpl = buildPythonPackage rec {
    pname = "brewer2mpl";
    version = "1.4.1";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "070vbc4wclzlln3wq22y3n54bxlaf7641vg4fym8as3nx8dls29f";
    };
  };

  cherrypy = cherrypy.overridePythonAttrs {
    doCheck = false; # needs network :8080?
  };

  cvxopt = cvxopt.overridePythonAttrs {
    doCheck = false;
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

  jp_proxy_widget = buildPythonPackage rec {
    pname = "jp_proxy_widget";
    version = "1.0.0";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0y26dzblan9k1kn33g907s6s56hiakrx6ky76pm6m8nq0r7gi02j";
    };
    propagatedBuildInputs = [ requests ipywidgets ];
  };

  jupyterlab = jupyterlab.overridePythonAttrs {
    propagatedBuildInputs = jupyterlab.propagatedBuildInputs ++ [world.nodejs];
    postFixup = ''
      PATH=$out/bin:$PATH JUPYTERLAB_DIR=$out/share/jupyter/lab HOME=$PWD jupyter-labextension install @jupyterlab/hub-extension@0.12.0
      PATH=$out/bin:$PATH JUPYTERLAB_DIR=$out/share/jupyter/lab HOME=$PWD jupyter-lab build
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

  paramiko = paramiko.overridePythonAttrs {
    doCheck = false; # ipv6 EBUSY?
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

  pyslurm = buildPythonPackage rec {
    pname = "pyslurm";
    version = "18-08-8";

    src = world.fetchFromGitHub {
      repo = "pyslurm";
      owner = "PySlurm";
      rev = version;
      sha256 = "114m39hn6s5i1xjz204py5k7ggljgg5z2zz74j3zdd0g89rjmf8z";
    };

    buildInputs = [ cython world.slurm ];
    setupPyBuildFlags = [ "--slurm-lib=${world.slurm}/lib" "--slurm-inc=${world.slurm.dev}/include" ];

    doCheck = false;
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

  rednose = rednose.overridePythonAttrs {
    doCheck = false; # hang
  };

  scikitlearn = scikitlearn.overridePythonAttrs {
    doCheck = false; # whitespace doctest failures and others
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
