cmake_minimum_required(VERSION 3.16)
project(Pompier-Qt-Quick VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)

# Setup standard Qt project
qt_standard_project_setup(REQUIRES 6.8)

# --- 1. Ajouter l'exécutable ---
qt_add_executable(appPompier-Qt-Quick
    main.cpp
)

# --- 2. Déclarer les ressources (QML + icônes) ---
qt_add_qml_module(appPompier-Qt-Quick
    URI Pompier-Qt-Quick
    VERSION 1.0
    # Tous tes fichiers QML
    QML_FILES
        ui/App.qml
        ui/Header.qml
        ui/Tabs.qml
        ui/InterventionForm.qml
        ui/InfoCard.qml
    # Ressources (images, icônes)
    RESOURCES
        ui/icons/help.svg
        ui/icons/menu.svg
        ui/icons/check.svg
        ui/icons/clock.svg
)

# --- 3. Propriétés pour macOS/Windows ---
set_target_properties(appPompier-Qt-Quick PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# --- 4. Lier les bibliothèques Qt nécessaires ---
target_link_libraries(appPompier-Qt-Quick
    PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
)

# --- 5. Installation (optionnel) ---
include(GNUInstallDirs)
install(TARGETS appPompier-Qt-Quick
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
