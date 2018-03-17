source $stdenv/setup

kernels=$out/share/jupyter/kernels
mkdir -p $kernels
for kernel in $src/share/jupyter/kernels/* ; do
	dir=`basename $kernel`
	dst=$kernels/$prefix-$dir
	mkdir $dst
	ln -s $kernel/* $dst
	rm -f $dst/kernel.json
	jq '      .argv[0]|=env.src+"/bin/"+split("/")[-1]
		| .env.PATH=env.src+"/bin:/usr/bin"
		| .env.PYTHONHOME=env.src
		| .display_name+=env.note' \
		$kernel/kernel.json > $dst/kernel.json
done
