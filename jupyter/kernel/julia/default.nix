{ stdenv
, writeShellScriptBin
}:

writeShellScriptBin "ijulia-threads" ''
  export JULIA_NUM_THREADS=$SLURM_CPUS_PER_TASK
  exec "$@"
''
