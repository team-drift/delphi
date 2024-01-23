# PTU-SDK
PTU-SDK is an SDK provided by FLIR -- with additional utilities/wrappers written by DRIFT -- necessary to control the gimbal. 

In this documentation, we outline the PTU-SDK works and how to use it.

## Project Stack

This project is written in the `C++17` standard,
and utilizes the following components:

- FLiR Base PTU-SDK - The base sdk as provided by FLiR, which facilitates low-level communication with the gimbal
    - FLiR Cerial Library - A networking library used by the base sdk
- PyBind11 - A library for easily creating python bindings for C++
- Python Setuptools - A python build system for creating python modules from this project
- CMake - Building all components of the sdk
- clang-tidy - Checks and linting to ensure code quality
- clang-format - Formatting rules for the project
- gcc/clang - Either compiler can be utilized depending on developer preference

Of these components, CMake, gcc/clang, and Python are REQUIRED for building this project!
The rest are either provided with the project, or are optional.

## Project Structure

This section describes the outline of the project,
which includes the physical layout of the project files,
CMake build targets, and how components in this project interact.

### File Structure

This project has the following outline:

```
PTU-SDK/
├── build
├── dist
├── docs
├── include
│   └── dptu
├── libs
│   └── ptu-sdk
│       └── cerial
├── python
│   └── pdptu
├── src
└── utils
    ├── drift
    └── sdk-examples
```

Some of these directories will NOT be included in version control,
so they may not be present in a fresh clone.
All these directories will be auto-generated in one way or another
if you preform the operations outlined in the documentation.
Directories not included in version control are:

- build - CMake generated build files, your final build binaries will be placed here when building with CMake!
- dist - Final Python source distributions / wheels that are built via setuptools

The other directories are described below:

- docs - Contains documentation for this project
- include - Header files for custom libraries created for this project
    - dptu - header files for the drift PTU sdk
- src - Source files for custom libraries created for this project
- python - Python bindings for the drift PTU sdk
- utils - Development/testing utilities to simplify certain gimbal operations
    - drift - Utilities produced by drift
    - sdk-examples - Utilities provided with the base sdk, these are unaltered
- libs - External libraries vendored with this project. Required for building any project components
    - ptu-sdk - The provided base sdk, mostly unaltered
        - cerial - 'Cerial' library utilized by the base sdk, mostly unaltered

The directories to keep in mind are `include/`, `src/`, and `utils/drift`.
All others are either automatically generated or are not meant to be changed,
as we are striving to keep the provided base components static as much as possible.
Any new components are alterations can be be done in the three directories specified most of the time!

### CMake Structure

This project uses CMake in all build scenarios!
All components in this project are CMake enabled,
allowing most operations to be done via CMake.
This project defines many targets that can be built,
but most of the time you only want to focus on a few
Below is a outline of the targets, children of a target depends on them:

```
cerial
└── ptusdk
    ├── dptu
    │   ├── driftutil
    │   └── pdptu
    └── sdkexamples
```

- cerial - Networking library required by the base sdk
- ptusdk - Provided base sdk library
- sdkexamples - Builds ALL provided base sdk example binaries, can be executed
- dptu - DRIFT wrapper library around the base sdk
- driftutil - Builds ALL DRIFT utility binaries, can be executed
- pdptu - Python bindings for dptu as a shared library. Building this yourself is usually not required, see the python section

## CMake

As mentioned earlier in this document, this project is build via [CMake](https://cmake.org/).
It is recommended to handle this process through your IDE,
but it is possible to do so manually.

Build Steps:

1. Create a build directory: `mkdir build`
2. Navigate to build directory: `cd build/`
3. Invoke CMake to configure the project: `cmake ..`

After the project has been configured, you will see the `build`
directory has been populated with many files!
Pretty much all of these can be ignored, but later down the line
we will outline some files that are relevant.

4. Build your target: `make [TARGET]`

Where `[TARGET]` is the name of the target you wish to build.
You can see a list of targets above in the CMake Structure section.
For example, if you wish to build the `dptu` target:

```bash
make dptu
```

Any dependencies will be automatically built for you,
so don't worry about building any dependencies.

5. Locate your build

If you are building a library, it will be in format `.a` for a static library,
or `.so` for a shared library. Unless you are building the python bindings,
all libraries built by this project are static, and will have filetype `.a`.

Executables have varying filetypes. On Unix like systems,
they will not have a file extension.
On Windows, they will have a `.exe` extension.

CMake organizes the `build` directory in the same way the project is structured.
This means it places binaries in locations that are comparable to that of the project.
For example, if you build the `demo` executable,
you can find it in:

```
build/utils/drift/demo
```

The same goes for other components, simply follow the directories to locate your binary.
Once you have located your binary, you can move it to wherever you like!
From there, you can utilize it as you see fit.

If you experience any strange errors,
or mess up the state of the build system,
then you can safely delete the build directory and restart.
The build directory does not contain any valuable information!
So deleting and reconfiguring has no large consequences,
other than the time that is required to re-create and re-build any components.

## Python

This project also contains Python bindings that allow
this code to be worked with and utilized in Python!
This is done via [PyBind11](https://github.com/pybind/pybind11),
which greatly simplifies this procedure.
PyBind11 is automatically fetched by CMake at configure time,
so it is not necessary to install this dependency system wide!
Here are the steps to build the python module:

1. First, create a python virtual environment: `python -m venv venv/`
2. Activate the virtual environment: `source venv/bin/activate`
3. Next, install build tools: `pip install build`
4. Invoke the build system: `python -m build`

From here, it will build your python module and place it into the `dist/` directory.
This command will create two types of distributions, which we will cover below.

### Source Distribution

A source distribution is a Python package that contains
the files necessary to build your Python module.
When asked to install this package,
Python will use the contents to build the module for the system it is running on.
This is the recommended way to distribute the Python module!
It is best to have other developers build the module from scratch on their own systems,
instead of having to worry about platform differences and cross-compilation.

The downside to this approach is that source distributions require extra time
to install on the end of the receiver, as they will need to build the module themselves.
This will also require the receiver to have build tools installed,
such as CMake and a compiler (gcc/clang), which may be trivial or very difficult
to install depending on your platform.

### Wheel Distribution

A so-called 'wheel' is a type of Python package that contains a pre-built module.


## Development Environment

Developers may work on the project using any tools they like!
It is possible to work with this project with nothing more than a text editor,
given that you have the requirements satisfied in the tech stack portion of this document.
However, this is not recommended, so we will provide a minimum development environment recommendation

VSCode is the recommended IDE for this project!
It is highly configurable and offers all the features you could want.
Any IDE that has support for C++ and CMake would suffice (such as CLion),
but we will focus on VSCode in this section.

Alongside VSCode, you will want the following extensions:

- [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) - Enables C/C++ Development in VSCode
- [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) - Adds support for CMake enabled projects
- [Doxygen Generator](https://marketplace.visualstudio.com/items?itemName=cschlosser.doxdocgen) - Simplifies the process of creating doxygen documentation

These extensions are the bare minimum, and it is recommended to install other extensions
that enhance your workflow, such as the GitHub integration extension.

Alongside these extensions, we suggest the following changes:

- `C_Cpp.codeAnalysis.clangTidy.enabled = true` - Enables clang-tidy checks to be preformed by VSCode
- `C_Cpp.codeAnalysis.clangTidy.useBuildPath = true` - Instructs clang-tidy to utilize CMake `compile-commands.json`

This will allow VSCode to build and analyze this project for you!
