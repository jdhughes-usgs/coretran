# ================================
# CMAKE Script for setting up the fortran compiling and linking flags for different operating systems and compilers

# Call this cmake file from your project's CMakeLists.txt using 'include(/path/to/FortranEnvironment.cmake)'

# ++++++++++++++++++++++++++++++++


enable_language(Fortran)

option (BUILD_SHARED_LIBS "Shared or static libraries"  ON)

# Check if linux
if(UNIX AND NOT APPLE)
  set(LINUX TRUE)
endif()


# ================================
# Default the Build type to RELEASE
# ================================
# Make sure the build type is uppercase
string(TOUPPER "${CMAKE_BUILD_TYPE}" BT)

if(BT STREQUAL "RELEASE")
  set(CMAKE_BUILD_TYPE RELEASE CACHE STRING
    "Choose the type of build, options are DEBUG, or RELEASE."
    FORCE)
elseif(BT STREQUAL "DEBUG")
  set(CMAKE_BUILD_TYPE DEBUG CACHE STRING
    "Choose the type of build, options are DEBUG, or RELEASE."
    FORCE)
elseif(NOT BT)
  set(CMAKE_BUILD_TYPE RELEASE CACHE STRING
    "Choose the type of build, options are DEBUG, or RELEASE."
    FORCE)
  message(STATUS "CMAKE_BUILD_TYPE not given, defaulting to RELEASE.")
else()
  message(FATAL_ERROR "CMAKE_BUILD_TYPE not valid, choices are DEBUG, or RELEASE.")
endif(BT STREQUAL "RELEASE")
# ++++++++++++++++++++++++++++++++

# ================================
# Find the openmp package and add compiler-specific flags
# ================================
find_package(OpenMP)
if(OPENMP_FOUND)
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${OpenMP_Fortran_FLAGS}")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
endif()
# ++++++++++++++++++++++++++++++++

# ================================
# Set gfortran compile flags
# ================================
if(CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
  include(${CMAKE_MODULE_PATH}/gfortran_flags.cmake)

# ================================
# Set INTEL compile flags
# ================================
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
  include(${CMAKE_MODULE_PATH}/intel_flags.cmake)

endif()

# ================================
# Set the output directories for compiled libraries and module files.
# Paths are relative to the build folder where you call cmake
# ================================
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../lib) # Static library location
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../lib) # Shared library location
# Place module files in specific include folder
set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../include)
# Place executables in bin
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../bin)

# ++++++++++++++++++++++++++++++++

# ================================
# Display information to the user
# ================================
message(STATUS "Build type is ${CMAKE_BUILD_TYPE} use option -DCMAKE_BUILD_TYPE=[DEBUG RELEASE] to switch")

if(BT STREQUAL "RELEASE")
  message(STATUS "Using the following compile flags \n ${CMAKE_Fortran_FLAGS_RELEASE}")
elseif(BT STREQUAL "DEBUG")
  message(STATUS "Using the following compile flags \n ${CMAKE_Fortran_FLAGS_DEBUG}")
endif()

if(BUILD_SHARED_LIBS)
  message(STATUS "Building with -DBUILD_SHARED_LIBS=ON")
else()
  message(STATUS "Building with -DBUILD_SHARED_LIBS=OFF")
endif()
message(STATUS "Using the following library link flags \n ${CMAKE_SHARED_LINKER_FLAGS}")
message(STATUS "Using the following program link flags \n ${CMAKE_EXE_LINKER_FLAGS}")

message(STATUS "make install will install to ${CMAKE_INSTALL_PREFIX}")
message(STATUS "To change, use option -DCMAKE_INSTALL_PREFIX:PATH=/path/to/install/to")
