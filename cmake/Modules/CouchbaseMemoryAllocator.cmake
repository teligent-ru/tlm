SET(COUCHBASE_MEMORY_ALLOCATOR "" CACHE STRING "The memory allocator to use. ")
SET_PROPERTY(CACHE COUCHBASE_MEMORY_ALLOCATOR PROPERTY STRINGS
             system tcmalloc jemalloc)

INCLUDE(FindCouchbaseTcMalloc)
INCLUDE(FindCouchbaseJemalloc)

IF (COUCHBASE_MEMORY_ALLOCATOR)
   IF ("${COUCHBASE_MEMORY_ALLOCATOR}" STREQUAL "tcmalloc")
      IF (TCMALLOC_FOUND)
         SET(MEMORY_ALLOCATOR tcmalloc)
      ELSE (TCMALLOC_FOUND)
         MESSAGE(FATAL_ERROR "Could not find TcMalloc")
      ENDIF (TCMALLOC_FOUND)
   ELSEIF ("${COUCHBASE_MEMORY_ALLOCATOR}" STREQUAL "jemalloc")
      IF (JEMALLOC_FOUND)
         SET(MEMORY_ALLOCATOR jemalloc)
      ELSE (JEMALLOC_FOUND)
         MESSAGE(FATAL_ERROR "Could not find JEMalloc")
      ENDIF (JEMALLOC_FOUND)
   ELSEIF ("${COUCHBASE_MEMORY_ALLOCATOR}" STREQUAL "system")
      SET(MEMORY_ALLOCATOR system)
   ELSE ("${COUCHBASE_MEMORY_ALLOCATOR}" STREQUAL "system")
      MESSAGE(FATAL_ERROR "Unknow memory allocator specified")
   ENDIF ("${COUCHBASE_MEMORY_ALLOCATOR}" STREQUAL "tcmalloc")

ELSE (COUCHBASE_MEMORY_ALLOCATOR)
   # No allocator explicitly selected by user, prefer jemalloc on Linux/OSX,
   # tcmalloc on Windows.
   IF (WIN32)
      IF (TCMALLOC_FOUND)
         SET(MEMORY_ALLOCATOR tcmalloc)
      ELSE (TCMALLOC_FOUND)
         SET(MEMORY_ALLOCATOR system)
      ENDIF (TCMALLOC_FOUND)
   ELSE (WIN32)
      IF (JEMALLOC_FOUND)
        SET(MEMORY_ALLOCATOR jemalloc)
      ELSEIF (TCMALLOC_FOUND)
        SET(MEMORY_ALLOCATOR tcmalloc)
      ELSE (JEMALLOC_FOUND)
        SET(MEMORY_ALLOCATOR system)
      ENDIF (JEMALLOC_FOUND)
   ENDIF(WIN32)
ENDIF (COUCHBASE_MEMORY_ALLOCATOR)

# Finally, set the appropriate defines for our selected memory allocator.
IF (MEMORY_ALLOCATOR STREQUAL "tcmalloc")
    ADD_DEFINITIONS(-DHAVE_TCMALLOC)
    SET(MALLOC_LIBRARIES ${TCMALLOC_LIBRARIES})
    SET(MALLOC_INCLUDE_DIR ${TCMALLOC_INCLUDE_DIR})
    MESSAGE(STATUS "Using TcMalloc")
ELSEIF (MEMORY_ALLOCATOR STREQUAL "jemalloc")
    ADD_DEFINITIONS(-DHAVE_JEMALLOC)
    SET(MALLOC_LIBRARIES ${JEMALLOC_LIBRARIES})
    SET(MALLOC_INCLUDE_DIR ${JEMALLOC_INCLUDE_DIR})
    MESSAGE(STATUS "Using JEMalloc")
ELSEIF (MEMORY_ALLOCATOR STREQUAL "system")
    MESSAGE(STATUS "Using system-supplied malloc")
ENDIF (MEMORY_ALLOCATOR STREQUAL "tcmalloc")
