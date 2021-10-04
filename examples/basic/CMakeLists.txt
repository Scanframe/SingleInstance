cmake_minimum_required(VERSION 3.7.0)

project("basic" LANGUAGES CXX)

# SingleApplication base class
#add_subdirectory(../.. SingleApplication)

add_executable(${PROJECT_NAME} main.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE SingleInstance::SingleInstance)



