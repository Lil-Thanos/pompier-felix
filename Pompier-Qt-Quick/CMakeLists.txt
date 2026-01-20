cmake_minimum_required(VERSION 3.16)

project(PompierQtQuick VERSION 0.1 LANGUAGES CXX)

# C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Qt
find_package(Qt6 REQUIRED COMPONENTS
    Quick
    QuickControls2
    Sql
    Network
)

qt_standard_project_setup(REQUIRES 6.8)

# --- Exécutable ---
qt_add_executable(appPompier
    main.cpp
)

# --- Backend C++ ---
set(BACKEND_SOURCES
    src/superviseurope.cpp
    src/superviseurope.h
    src/ficheurgence.cpp
    src/ficheurgence.h
    src/geocoding.cpp
    src/geocoding.h
)

# --- QML module ---
qt_add_qml_module(appPompier
    URI Pompier
    VERSION 1.0

    QML_FILES
        ui/App.qml
        ui/Header.qml
        ui/Tabs.qml
        ui/InterventionForm.qml
        ui/InfoCard.qml

    RESOURCES
        ui/icons/help.svg
        ui/icons/menu.svg
        ui/icons/check.svg
        ui/icons/clock.svg

    SOURCES
        ${BACKEND_SOURCES}
)

# --- Link Qt libs ---
target_link_libraries(appPompier
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Sql
        Qt6::Network
)

# --- App properties ---
set_target_properties(appPompier PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# --- Install ---
include(GNUInstallDirs)
install(TARGETS appPompier
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

qt_finalize_executable(appPompier)
