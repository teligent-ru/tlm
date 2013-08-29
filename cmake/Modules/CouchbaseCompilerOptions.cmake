#
# Set Compiler Options used to build Couchbase
#

SET(CB_GNU_CPPFLAGS "-Wall -pedantic -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls -fno-strict-aliasing -fvisibility=hidden -pthread")
SET(CB_CLANG_CPPFLAGS "-Wall -pedantic -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls -fno-strict-aliasing -fvisibility=hidden -pthread")
SET(CB_MSVC_CPPFLAGS "")
SET(CB_SPRO_CPPFLAGS "-errfmt=error -errwarn -errshort=tags -xldscope=hidden -mt")

SET(CB_GNU_CXXFLAGS "-Wall -pedantic -Wmissing-declarations -Wredundant-decls -fno-strict-aliasing -fvisibility=hidden -pthread")
SET(CB_CLANG_CXXFLAGS "-Wall -pedantic -Wmissing-declarations -Wredundant-decls -fno-strict-aliasing -fvisibility=hidden -pthread")
SET(CB_MSVC_CXXFLAGS "")
SET(CB_SPRO_CXXFLAGS "-errfmt=error -errwarn -errshort=tags -xldscope=hidden -mt")

SET(CB_GNU_LDFLAGS "-pthread")

#
# Set flags for the C Compiler
#
IF ("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU")
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CB_GNU_CPPFLAGS}")
  SET(CMAKE_LINK_FLAGS "${CMAKE_LINK_FLAGS} ${CB_GNU_LDFLAGS}")
ELSEIF ("${CMAKE_C_COMPILER_ID}" STREQUAL "Clang")
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CB_CLANG_CPPFLAGS}")
  SET(CMAKE_LINK_FLAGS "${CMAKE_LINK_FLAGS} ${CB_GNU_LDFLAGS}")
ELSEIF ("${CMAKE_C_COMPILER_ID}" STREQUAL "MSVC")
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CB_MSVC_CPPFLAGS}")
  ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS=1)
ELSEIF ("${CMAKE_C_COMPILER_ID}" STREQUAL "SunPro")
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CB_SPRO_CPPFLAGS} -xc99=all")
ENDIF ("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU")

#
# Set flags for the C++ compiler
#
IF ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CB_GNU_CXXFLAGS}")
ELSEIF ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CB_CLANG_CXXFLAGS}")
ELSEIF ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CB_MSVC_CXXFLAGS}")
ELSEIF ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "SunPro")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CB_SPRO_CXXFLAGS} -xlang=c99")
ENDIF ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")

ADD_DEFINITIONS(-D_POSIX_PTHREAD_SEMANTICS)
ADD_DEFINITIONS(-D_GNU_SOURCE=1)
ADD_DEFINITIONS(-D__EXTENSIONS__=1)
ADD_DEFINITIONS(-D__STDC_FORMAT_MACROS)

IF (WIN32)
   IF ("${DEPS_INCLUDE_DIR}" STREQUAL "")
      SET(DEPS_INCLUDE_DIR c:/compile/couchbase/deps/include)
   ENDIF ()
   IF ("${DEPS_LIB_DIR}" STREQUAL "")
      SET(DEPS_LIB_DIR c:/compile/couchbase/deps/lib)
   ENDIF ()
   IF ("${CMAKE_INSTALL_PREFIX}" STREQUAL "")
      SET(CMAKE_INSTALL_PREFIX c:/compile/couchbase/install)
   ENDIF ()
ELSE (WIN32)
   IF ("${DEPS_INCLUDE_DIR}" STREQUAL "")
      SET(DEPS_INCLUDE_DIR /opt/couchbase/include)
   ENDIF ()
   IF ("${DEPS_LIB_DIR}" STREQUAL "")
      SET(DEPS_LIB_DIR /opt/couchbase/lib)
   ENDIF ()
   IF ("${CMAKE_INSTALL_PREFIX}" STREQUAL "")
      SET(CMAKE_INSTALL_PREFIX /opt/couchbase)
   ENDIF ()
   SET(INSTALL_ROOT ${CMAKE_INSTALL_PREFIX})
ENDIF (WIN32)

# Fix RPATH settings
SET(CMAKE_SKIP_BUILD_RPATH FALSE)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
IF(UNIX)
  SET(RPATH "\$ORIGIN/../lib:\$ORIGIN/../lib/memcached:")
ENDIF()
SET(RPATH "${RPATH}${INSTALL_ROOT}/lib:${INSTALL_ROOT}/lib/memcached:${DEPS_LIB_DIR}")
IF ("${CMAKE_INSTALL_RPATH}" STREQUAL "")
ELSE()
  SET(RPATH "${RPATH}:${CMAKE_INSTALL_RPATH}")
ENDIF()
SET(CMAKE_INSTALL_RPATH "${RPATH}")
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
