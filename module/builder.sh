source $stdenv/setup

modfile="$out/modules/$parseName/$parseVersion"
mkdir -p `dirname "$modfile"`

root=$buildInputs
cat > $modfile <<EOF
#%Module1.0#####################################################################
#
# Module: $parseName-$parseVersion
#
# Autogenerated nix module

set pkg $parseName
set version $parseVersion
set root $root

proc ModulesHelp { } {
    puts stderr "Sets the environment for \$pkg-\$version"
}

module-whatis   "Sets the environment for \$pkg-\$version"

conflict $parseName

EOF

if [[ -d $root/bin ]] ; then
	echo 'prepend-path PATH $root/bin' >> $modfile
fi
if [[ -d $root/share/man ]] ; then
	echo 'prepend-path MANPATH $root/share/man' >> $modfile
fi
