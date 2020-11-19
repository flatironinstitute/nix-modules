world:
# python package overrides
self: pkgs:
with pkgs;

{

  ansible = ansible.overridePythonAttrs {
    propagatedBuildInputs = ansible.propagatedBuildInputs ++ [pyparsing];
  };

  astropy = astropy.overridePythonAttrs {
    doCheck = false; # numpy deprecation warnings?
  };

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

  cheroot = cheroot.overridePythonAttrs {
    doCheck = false; # ipv6
    propagatedBuildInputs = [ more-itertools six jaraco_functools ];
  };

  cherrypy = cherrypy.overridePythonAttrs {
    doCheck = false; # needs network :8080?
  };

  cryptography = cryptography.overridePythonAttrs {
    doCheck = false; # hang
  };

  cvxopt = cvxopt.overridePythonAttrs {
    doCheck = false;
  };

  dulwich = dulwich.overridePythonAttrs {
    doCheck = false; # uses wrong (/bin) git
  };

  fast-histogram = buildPythonPackage rec {
    pname = "fast-histogram";
    version = "0.9";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "17vskyj3mqijc5qnkkjqph83ipavqk5gzvrsgacd3f8b0r1cw9b3";
    };
    propagatedBuildInputs = [ numpy ];
    checkInputs = [ hypothesis pytest ];
  };

  flit = flit.overridePythonAttrs {
    doCheck = false; # uses $HOME
  };

  fsspec = fsspec.overridePythonAttrs {
    doCheck = false; # broken open directory
  };

  fuzzysearch = buildPythonPackage rec {
    pname = "fuzzysearch";
    version = "0.7.3";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0k6a6yyfqjgdiyj709qljbdwh6ipnk0imzmjh7hsal7frqab38fm";
    };
    propagatedBuildInputs = [ attrs six ];
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
    propagatedBuildInputs = [ six self.statsmodels self.brewer2mpl matplotlib self.scipy self.patsy self.pandas cycler numpy ];
    doCheck = false; # broken package
  };

  glue-core = buildPythonPackage rec {
    pname = "glue-core";
    version = "0.15.6";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0rn2ksrfhyfjwi474p78qlry3clh8d081dna1wf6f6797pqm7izr";
    };
    propagatedBuildInputs = [ numpy self.pandas self.astropy matplotlib qtpy setuptools ipython ipykernel qtconsole dill self.xlrd h5py self.mpl-scatter-density ];
    doCheck = false;
  };

  glue-vispy-viewers = buildPythonPackage rec {
    pname = "glue-vispy-viewers";
    version = "0.12.2";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1kz8db3n5ajd0j442sarcipjxnxc5777n3dmxkaw4lsfc9r09h1v";
    };
    propagatedBuildInputs = [ numpy pyopengl self.glue-core qtpy self.scipy self.astropy ];
    doCheck = false;
  };

  glueviz = buildPythonPackage rec {
    pname = "glueviz";
    version = "0.15.2";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0ffrjx99mmyjivawr6cyl3ysrcjrcd3r0giyf5n2d1h2gx6v273n";
    };
    propagatedBuildInputs = [ self.glue-core self.glue-vispy-viewers ];
  };

  google-auth-httplib2 = google-auth-httplib2.overridePythonAttrs {
    doCheck = false; # EBUSY?
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

  #joblib = joblib.overridePythonAttrs {
  #  doCheck = false; # long, often get stuck, timeouts
  #};

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

  matlab_wrapper = buildPythonPackage rec {
    pname = "matlab_wrapper";
    version = "1";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "15v8qmvcgm75gszvsifppdzp9v7warphsszb1bvnw71s74svlpqi";
    };
    propagatedBuildInputs = [ numpy ];
  };

  mpi4py = mpi4py.overridePythonAttrs {
    doCheck = false;
  };

  mpl-scatter-density = buildPythonPackage rec {
    pname = "mpl-scatter-density";
    version = "0.7";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "083n4xkwjmxvij9i1xhfnxz8vk39ay0baam4nf0khvcihw47bkna";
    };
    propagatedBuildInputs = [ numpy matplotlib self.fast-histogram ];
    checkInputs = [ pytest ];
  };

  paramiko = paramiko.overridePythonAttrs {
    doCheck = false; # ipv6 EBUSY?
  };

  portend = portend.overridePythonAttrs {
    doCheck = false; # ipv6
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

  pyopenssl = pyopenssl.overridePythonAttrs {
    doCheck = false; # cert verf failures
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
    version = "2.19.1.1";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0f5hbv9dhsx3b5yn5kpq5pwi1kxzmg4mdbrndyz2p8hdpj6sv2zs";
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

  #scipy = scipy.overridePythonAttrs {
  #  doCheck = false; # segfault!
  #};

  subprocess32 = subprocess32.overridePythonAttrs {
    doCheck = false; # slow, needs user
  };

  weave = buildPythonPackage rec {
    pname = "weave";
    version = "0.17.0";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "164rf3g29vs0pvkp7jd041qmiyyhzxxcnswvy2slgb93dnpg60r7";
    };
    propagatedBuildInputs = [ numpy ];
    checkInputs = [ nose ];
    doCheck = false; # known failures? need user?
  };

  yt = yt.overridePythonAttrs {
    doCheck = isPy3k; # two failing tests
  };

}
