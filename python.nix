# python package overrides
self: pkgs:
with pkgs;

{
  mpi4pi = mpi4pi.overridePythonAttrs {
    doCheck = false;
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
  statsmodels = statsmodels.overridePythonAttrs {
    propagatedBuildInputs = [numpy scipy pandas self.patsy cython matplotlib];
  };

  ggplot = buildPythonPackage rec {
    pname = "ggplot";
    version = "0.11.5";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "17s6aspq4i9jrqkg15pn7wazxnq66mbpcvc54nniby47b7mckfs8";
    };
    propagatedBuildInputs = [ six self.statsmodels self.brewer2mpl matplotlib scipy self.patsy pandas cycler numpy ];
    doCheck = false; # broken package
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

  cherrypy = cherrypy.overridePythonAttrs {
    doCheck = false; # needs network :8080?
  };

  ws4py = ws4py.overridePythonAttrs {
    propagatedBuildInputs = [ asyncio self.cherrypy gevent tornado ];
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

  primefac = buildPythonPackage rec {
    pname = "primefac";
    version = "1.1";
    name = "${pname}-${version}";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0l5g4wfmf47amal4qzvhpcymlw1rnjhkzbvd2j4k21x8pimi0a2j";
    };
  };

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

}
