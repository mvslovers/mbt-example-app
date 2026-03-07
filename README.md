# mbt-example-app

Example batch application for the [mbt](https://github.com/mvslovers/mbt) build
system, demonstrating how to build an MVS 3.8j application that depends on an
external library.

The program produces a formatted MVS system information report including:

- Job name, system ID, and IPL date from MVS control blocks
- Hex dump of the CVT (Communication Vector Table)
- JES2 job queue listing

## Building

```sh
git clone --recurse-submodules https://github.com/mvslovers/mbt-example-app.git
cd mbt-example-app
cp .env.example .env        # enter your MVS connection details (host, port, credentials)
make bootstrap               # download crent370 + mbt-example-lib
make build                   # cross-compile and assemble on MVS
make link                    # link the load module
```

> **Note:** If `mbt-example-lib` has no published release yet, build and
> package it first (`make package` in the lib directory). This installs
> the artifacts to the local cache so `make bootstrap` can resolve them.

## Running

Submit as a batch job on MVS:

```jcl
//MVSINFO  JOB (001),'SYSINFO',CLASS=A,MSGCLASS=H
//STEP1    EXEC PGM=MVSINFOA
//STEPLIB  DD DSN=your.load.library,DISP=SHR
//SYSPRINT DD SYSOUT=*
```

## Key Concepts Demonstrated

### Using a Non-Autocall Library

The dependency `mbt-example-lib` uses `autocall = false` because its
modules export multiple functions per member. This project declares
which members to pull in:

```toml
[link.module.dep_includes]
"mvslovers/mbt-example-lib" = "*"    # include all members
```

This generates explicit `INCLUDE NCALIB(member)` statements in the
link JCL, ensuring all required symbols are resolved.

### Project Structure

```
mbt-example-app/
├── project.toml          # declares dependencies + link module
├── Makefile              # 2-line mbt include
├── .env.example          # MVS connection template
├── src/
│   └── mvsinfoa.c        # main program
└── mbt/                  # build system (git submodule)
```

## See Also

- [mbt-example-lib](https://github.com/mvslovers/mbt-example-lib) — the
  library this application depends on
- [mbt](https://github.com/mvslovers/mbt) — MVS Build Tools
