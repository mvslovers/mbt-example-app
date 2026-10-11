# mbt-example-app

An example application for [MBT](https://github.com/mvslovers/mbt) (mbt):
three main programs, one each in **C, COBOL and assembler**, built on the
library [mbt-example-lib](https://github.com/mvslovers/mbt-example-lib)
(`mvsinfo.a`), which is itself written in all three. Every program calls
into the other two languages.

| Module | Language | Calls |
|---|---|---|
| `CINFO` | C | C, assembler (`MIJOBN`, `MITIME`), COBOL (`MIFMTD`, `MIFMTN` through their C wrappers) |
| `COBINFO` | COBOL | assembler (`MIJOBN`, `MITIME`), COBOL (`MIFMTD`, `MIFMTN`) |
| `ASMINFO` | assembler | assembler (`MIJOBN`, `MITIME`), COBOL (`MIFMTD`); the result goes to the console with `WTO` |

```
CINFO   job MVSINFOA on DEV1
CINFO   IPL 2026.284, now 2026.284 173643
CINFO    16,777,216  bytes in a 16 MB address space
COBINFO job MVSINFOA today 2026.284
ASMINFO job MVSINFOA today 2026.284
```

## The call matrix

The tests are named caller-2-callee, and their return code is the verdict
(`mbt test --mvs` runs each one in batch and under TSO):

| Test | Caller → callee |
|---|---|
| `C2COB` | C → COBOL |
| `C2ASM` | C → assembler |
| `ASM2COB` | assembler → COBOL |
| `COB2ASM` | COBOL → assembler |
| `COB2COB` | COBOL → COBOL, two COBOL programs in one load module |

**COBOL → C and assembler → C** are missing on purpose. A C function
expects its own stack in the caller's save area, which COBOL and plain
assembler do not provide; LIBC/370 is designing a glue routine for that
(libc370#502). The two tests follow once it is released.

How the calls fit together is described in the library's README: C passes
values, COBOL and the OS convention pass addresses with the last one
flagged, and the library bridges the two.

## Building and running

You need MBT 3, the CC/370 toolchain and
[cobc370](https://github.com/brazilofmux/cobc370) on `PATH` (or named in
`MBT_COBC370`):

```sh
mbt deps          # fetch mbt-example-lib from its GitHub release
mbt build --all   # CINFO, COBINFO, ASMINFO
mbt test --mvs    # the call matrix on the target
mbt deploy        # into MVSINFOA.DEV.LINKLIB
mbt run demo      # run the three programs and show their output
```

`mbt deps` stages the library under `.mbt/deps/`. Its `mvsinfo.h` reaches
the C compiler and its `MIPARMS` copybook reaches cobc370 without any
`-I` in [`mbt.toml`](mbt.toml), and the linker takes from `mvsinfo.a` only
the members a program calls (autocall). `mbt run demo` is a few lines of
Lua in [`mbt/init.lua`](mbt/init.lua).

**Note:** the COBOL tests need mbt with mvslovers/mbt#257 (a SYSOUT DD in
the test runner for COBOL's `DISPLAY`).
