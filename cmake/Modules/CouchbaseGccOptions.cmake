SET(CB_GNU_DEBUG "-g")
SET(CB_GNU_WARNINGS "-Wall -pedantic -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls -fno-strict-aliasing -Wno-overlength-strings")
SET(CB_GNU_VISIBILITY "-fvisibility=hidden")
SET(CB_GNU_THREAD "-pthread")
SET(CB_GNU_LANG_VER "-std=gnu99")

# We want RelWithDebInfo to have the same optimization level as
# Release, only differing in whether debugging information is enabled.
SET(CMAKE_C_FLAGS_RELEASE        "-O3 -DNDEBUG")
SET(CMAKE_C_FLAGS_RELWITHDEBINFO "-O3 -DNDEBUG -g")

IF ("${ENABLE_WERROR}" STREQUAL "YES")
   SET(CB_GNU_WERROR "-Werror")
ENDIF()

FOREACH(dir ${CB_SYSTEM_HEADER_DIRS})
   SET(CB_GNU_IGNORE_HEADER "${CB_GNU_IGNORE_HEADER} -isystem ${dir}")
ENDFOREACH(dir ${CB_SYSTEM_HEADER_DIRS})

SET(CMAKE_C_FLAGS "${CB_GNU_IGNORE_HEADER} ${CMAKE_C_FLAGS} ${CB_GNU_DEBUG} ${CB_GNU_LANG_VER} ${CB_GNU_WARNINGS} ${CB_GNU_VISIBILITY} ${CB_GNU_THREAD} ${CB_GNU_WERROR}")
SET(CMAKE_LINK_FLAGS "${CMAKE_LINK_FLAGS} ${CB_GNU_LDFLAGS}")
