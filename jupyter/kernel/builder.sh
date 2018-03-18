source $stdenv/setup

kernels=$out/share/jupyter/kernels
mkdir -p $kernels
for kernel in $kernelSrc/share/jupyter/kernels/* ; do
	dir=`basename $kernel`
	dst=$kernels/$prefix-$dir
	mkdir $dst
	ln -s $kernel/* $dst
	rm -f $dst/kernel.json
	jq '      .argv[0]|=env.env+"/bin/"+split("/")[-1]
		| .env.PATH=env.env+"/bin:/usr/bin"
		| .env.PYTHONHOME=env.env
		| .display_name+=env.note' \
		$kernel/kernel.json > $dst/kernel.json
done
