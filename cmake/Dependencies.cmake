# This list is required for static linking and exported to Caffe2Config.cmake
set(Caffe2_LINKER_LIBS "")

# ---[ Threads
find_package(Threads REQUIRED)
list(APPEND Caffe2_LINKER_LIBS ${CMAKE_THREAD_LIBS_INIT})

# ---[ ATLAS
find_package(Atlas REQUIRED)
include_directories(SYSTEM ${ATLAS_INCLUDE_DIRS})
list(APPEND Caffe2_LINKER_LIBS ${ATLAS_LIBRARIES})

# ---[ Google-glog
include("cmake/External/glog.cmake")
add_definitions(-DCAFFE2_USE_GOOGLE_GLOG)
include_directories(SYSTEM ${GLOG_INCLUDE_DIRS})
list(APPEND Caffe2_LINKER_LIBS ${GLOG_LIBRARIES})

# ---[ Google-gflags
include("cmake/External/gflags.cmake")
include_directories(SYSTEM ${GFLAGS_INCLUDE_DIRS})
list(APPEND Caffe2_LINKER_LIBS ${GFLAGS_LIBRARIES})

# ---[ Googletest
add_subdirectory(${CMAKE_SOURCE_DIR}/third_party/googletest)
include_directories(SYSTEM ${CMAKE_SOURCE_DIR}/third_party/googletest/googletest/include)

# ---[ LMDB
if(USE_LMDB)
  find_package(LMDB REQUIRED)
  include_directories(SYSTEM ${LMDB_INCLUDE_DIR})
  list(APPEND Caffe2_LINKER_LIBS ${LMDB_LIBRARIES})
  add_definitions(-DUSE_LMDB)
  if(ALLOW_LMDB_NOLOCK)
    add_definitions(-DALLOW_LMDB_NOLOCK)
  endif()
endif()

# ---[ LevelDB
if(USE_LEVELDB)
  find_package(LevelDB REQUIRED)
  include_directories(SYSTEM ${LevelDB_INCLUDE})
  list(APPEND Caffe2_LINKER_LIBS ${LevelDB_LIBRARIES})
  add_definitions(-DUSE_LEVELDB)
endif()

# ---[ Snappy
if(USE_LEVELDB)
  find_package(Snappy REQUIRED)
  include_directories(SYSTEM ${Snappy_INCLUDE_DIR})
  list(APPEND Caffe2_LINKER_LIBS ${Snappy_LIBRARIES})
endif()

# ---[ CUDA
include(cmake/Cuda.cmake)
if(NOT HAVE_CUDA)
  if(CPU_ONLY)
    message(STATUS "-- CUDA is disabled. Building without it...")
  else()
    message(WARNING "-- CUDA is not detected by cmake. Building without it...")
  endif()

  # TODO: remove this not cross platform define in future. Use caffe_config.h instead.
  add_definitions(-DCPU_ONLY)
endif()

# ---[ NCCL
include("cmake/External/nccl.cmake")
include_directories(SYSTEM ${NCCL_INCLUDE_DIRS})
list(APPEND Caffe2_LINKER_LIBS ${NCCL_LIBRARIES})

# ---[ OpenCV
if(USE_OPENCV)
  find_package(OpenCV QUIET COMPONENTS core highgui imgproc imgcodecs)
  include_directories(SYSTEM ${OpenCV_INCLUDE_DIRS})
  list(APPEND Caffe2_LINKER_LIBS ${OpenCV_LIBS})
  message(STATUS "OpenCV found (${OpenCV_CONFIG_PATH})")
  add_definitions(-DUSE_OPENCV)
endif()

# ---[ EIGEN
include_directories(SYSTEM ${CMAKE_SOURCE_DIR}/third_party/eigen)
