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
    # WebEngineQuick   # Décommenter après installation via Qt Maintenance Tool
    # WebChannel       # Décommenter après installation via Qt Maintenance Tool
    Location
    Positioning
)

qt_standard_project_setup(REQUIRES 6.8)

# --- Exécutable ---
qt_add_executable(appPompier
    main.cpp
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
        ui/InterventionsList.qml
        ui/GestionCarte.qml
        ui/InfoCard.qml
        ui/StatusBadge.qml

    RESOURCES
        ui/icons/help.svg
        ui/icons/menu.svg
        ui/icons/check.svg
        ui/icons/clock.svg
        # ui/map.html   # Décommenter avec WebEngine

    SOURCES
        src/superviseurope.h
        src/superviseurope.cpp
        src/ficheurgence.h
        src/ficheurgence.cpp
        src/geocoding.h
        src/geocoding.cpp
        src/interventionmodel.h
        src/interventionmodel.cpp
        src/sendserver.h
        src/sendserver.cpp
        src/gestioncarte.h
        src/gestioncarte.cpp
        QML_FILES  ui/MarkerItem.qml


)

# --- Link Qt libs ---
target_link_libraries(appPompier
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Sql
        Qt6::Network
        # Qt6::WebEngineQuick   # Décommenter après installation
        # Qt6::WebChannel       # Décommenter après installation
        Qt6::Location
        Qt6::Positioning
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
