source $stdenv/setup

shopt -s nullglob

modfile="$out/modules/$modName"
mkdir -p `dirname "$modfile"`

cat > $modfile <<EOF
#%Module1.0#####################################################################
#
# Autogenerated nix $name
# 

set pkg $pkgName
set version $pkgVersion

proc ModulesHelp { } {
    puts stderr "Sets the environment for nix-built \$pkg-\$version"
    puts stderr "Autogenerated for nix package $buildInputs"
}

module-whatis   "Sets the environment for nix-built \$pkg-\$version"

EOF

if [[ $modLoad ]] ; then
	echo "module load $modLoad" >> $modfile
	echo "prereq $modLoad" >> $modfile
fi
if [[ $modPrereq ]] ; then
	echo "prereq $modPrereq" >> $modfile
fi
if [[ $modConflict ]] ; then
	echo "conflict $modConflict" >> $modfile
fi

addList () {
	if [[ -e $1 ]] ; then
		for p in `< $1` ; do
			addPaths $p
		done
	fi
}

declare -A done
addPaths () {
	if [[ ${done[$1]} ]] ; then
		return
	fi
	done[$1]=1

	addList $1/nix-support/propagated-user-env-packages
	addList $1/nix-support/propagated-build-inputs

	if [[ -d $1/bin ]] ; then
		echo "prepend-path PATH $1/bin" >> $modfile
	fi
	if [[ -d $1/share/man ]] ; then
		echo "prepend-path MANPATH $1/share/man" >> $modfile
	fi
	if [[ -d $1/lib/pkgconfig ]] ; then
		echo "prepend-path PKG_CONFIG_PATH $1/lib/pkgconfig" >> $modfile
	fi
	if [[ -d $1/share/pkgconfig ]] ; then
		echo "prepend-path PKG_CONFIG_PATH $1/share/pkgconfig" >> $modfile
	fi
	if [[ -d $1/lib/cmake ]] ; then
		echo "prepend-path CMAKE_SYSTEM_PREFIX_PATH $1/lib/cmake" >> $modfile
	fi
	if [[ -d $1/lib/perl5/site_perl ]] ; then
		echo "prepend-path PERL5LIB $1/lib/perl5/site_perl" >> $modfile
	fi
	libs=($1/lib/lib*.so)
	if [[ $addLDLibraryPath && -n $libs ]] ; then
		echo "prepend-path LD_LIBRARY_PATH $1/lib" >> $modfile
	fi
	if [[ $addOpenGLDrivers ]] ; then
		echo "append-path LD_LIBRARY_PATH /run/opengl-driver/lib" >> $modfile
	fi
	if [[ $addCFlags && ( -d $1/include || -n $libs ) ]] ; then
		if [[ -z $gccPrereq ]] ; then
			#echo "prereq ${modPrefix}gcc" >> $modfile
			gccPrereq=1
		fi
		if [[ -d $1/include ]] ; then
			# nix uses -isystem but we'll just use -I
			echo "prepend-path -d \" \" NIX_${nixInfix}_CFLAGS_COMPILE -I$1/include" >> $modfile
		fi
		if [[ -n $libs ]] ; then
			echo "prepend-path -d \" \" NIX_${nixInfix}_LDFLAGS -L$1/lib" >> $modfile
		fi
	fi
}

if [[ -n $addLocales ]] ; then
	echo "setenv LOCALE_ARCHIVE $addLocales/lib/locale/locale-archive" >> $modfile
fi

echo "setenv ${modEnv}_BASE $buildInputs" >> $modfile
echo "setenv ${modEnv}_VERSION $pkgVersion" >> $modfile
for root in $buildInputs ; do
	addPaths $root
done
