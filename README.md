# swapadd

A small native Windows command-line utility for displaying active paging files or creating an additional paging file in the running system.

## Usage

Run without arguments to display paging-file names, sizes, current usage, and peak usage, followed by physical-memory, registry-quota, and paged-pool information:

```cmd
swapadd
```

To request a new paging file:

```text
swapadd filename minsize[K|M|G] maxsize[K|M|G]
```

For example, from an elevated command prompt:

```cmd
swapadd C:\additional-pagefile.sys 256M 1G
```

This requests an initial/minimum size of 256 MiB and a maximum size of 1 GiB. Unsuffixed sizes are bytes; uppercase `K`, `M`, and `G` multiply by powers of 1024. Use positive sizes with the minimum no larger than the maximum, and choose a volume with enough free space.

Creation requires the **Create a pagefile** privilege (`SeCreatePagefilePrivilege`). The tool attempts to enable it in the process token before calling `NtCreatePagingFile`; elevation alone cannot grant a privilege absent from that token.

Successful creation prints `OK.`. The tool changes the running system and does not write persistent paging-file configuration to the registry. Configure paging files separately in Windows if they should be created again at subsequent boots. There is no command to remove a paging file.

Query and creation failures are reported to standard error and returned as translated Windows error codes. Invalid argument counts or size syntax display usage and return a nonzero exit code.

## Build

The repository contains [swapadd.cpp](swapadd.cpp) and a legacy Microsoft [NMake makefile](Makefile). It requires a Windows C++ build environment with `cl`, `link`, and `nmake`, Windows headers/import libraries, and the shared LTRData dependencies:

- Headers from [LTRData/include](https://github.com/LTRData/include), including `ntdll.h`, `winstrct.h`, and `winstrct.hpp`. The makefile expects the checkout at `../include`; add that directory to the compiler's include search path.
- Matching-architecture `winstrct.lib` and `winstrcp.lib` on the linker search path. These are requested by the shared headers; related support sources are in [LTRData/libsrc](https://github.com/LTRData/libsrc).
- `../lib/minwcrt.lib`, which the makefile lists as a prerequisite even though it does not pass it explicitly to the linker.

After arranging those dependencies, an example from an x64 compiler command prompt is:

```cmd
mkdir amd64
nmake CPU=amd64
```

The output is `amd64/swapadd.exe`. The `CPU` value selects the output directory and makefile options; it does not select a compiler toolchain. Create the output directory before building. Without an explicit `CPU`, the makefile uses `_BUILDARCH` if set, otherwise `i386`.

The repository retains its original 2021 source and legacy build setup, with no automated build or test configuration.

## License

[MIT License](LICENSE), copyright Olof Lagerkvist.
