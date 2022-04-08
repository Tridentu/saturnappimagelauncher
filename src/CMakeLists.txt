# TODO: adapt "org.kde.plasma" here & elsewhere if needed (see README)
add_definitions(-DTRANSLATION_DOMAIN=\"plasma_applet_org.kde.plasma.saturnappimagelauncher\")

add_library(plasma_applet_saturnappimagelauncher MODULE saturnappimagelauncher.cpp)

kcoreaddons_desktop_to_json(plasma_applet_saturnappimagelauncher package/metadata.desktop SERVICE_TYPES plasma-applet.desktop)

target_link_libraries(plasma_applet_saturnappimagelauncher
                      Qt5::Gui
                      KF5::Plasma
                      KF5::ConfigCore
                      KF5::ConfigGui
                      KF5::KIOCore
                      KF5::Service
                      KF5::Activities
                      KF5::WindowSystem
                      KF5::Notifications
                      KF5::KIONTLM
                      KF5::KIOWidgets
                      KF5::I18n)


install(TARGETS plasma_applet_saturnappimagelauncher DESTINATION ${KDE_INSTALL_PLUGINDIR}/plasma/applets)

plasma_install_package(package io.github.tridentu.saturnappimagelauncher)
