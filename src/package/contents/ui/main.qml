/*
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
    SPDX-License-Identifier: LGPL-2.1-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons
Item {
    id: root
    property var entriesModel: ListModel {
        
    }
    Timer {
      id: timer   
    }
    function delay(delayTime, doFunc) {
                                    timer.interval = delayTime;
                                    timer.repeat = false;
                                    timer.triggered.connect(doFunc);
                                    timer.start();
                                    
    }
    Plasmoid.compactRepresentation: MouseArea {
        id: compactRoot

        implicitWidth: PlasmaCore.Units.iconSizeHints.panel
        implicitHeight: PlasmaCore.Units.iconSizeHints.panel

        Layout.minimumWidth: Math.min(PlasmaCore.Units.iconSizeHints.panel, parent.height) * buttonIcon.aspectRatio
        Layout.minimumHeight: Math.min(PlasmaCore.Units.iconSizeHints.panel, parent.width) * buttonIcon.aspectRatio
        Layout.maximumWidth: Math.min(PlasmaCore.Units.iconSizeHints.panel, parent.height) * buttonIcon.aspectRatio
        Layout.maximumHeight: Math.min(PlasmaCore.Units.iconSizeHints.panel, parent.width) * buttonIcon.aspectRatio

        hoverEnabled: true
        // For some reason, onClicked can cause the plasmoid to expand after
        // releasing sometimes in plasmoidviewer.
        // plasmashell doesn't seem to have this issue.
        onClicked: {
            plasmoid.expanded = !plasmoid.expanded
            if(!plasmoid.expanded)
                appLauncherClosed();
        }

        DropArea {
            id: compactDragArea
            anchors.fill: parent
        }

        Timer {
            id: expandOnDragTimer
            // this is an interaction and not an animation, so we want it as a constant
            interval: 250
            running: compactDragArea.containsDrag
            onTriggered: plasmoid.expanded = true
        }

        PlasmaCore.IconItem {
            id: buttonIcon

        

            anchors.fill: parent
            source: plasmoid.icon
            active: parent.containsMouse || compactDragArea.containsDrag
            smooth: true
            roundToIconSize: true
        }
    }
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.fullRepresentation: StackLayout {
                id: layoutView
                currentIndex: 0
               width: 512 * PlasmaCore.Units.devicePixelRatio
                height: 456 * PlasmaCore.Units.devicePixelRatio    
    
    Rectangle {
        id: root2
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "#2E3440"
        radius: 4
        opacity: 0.75
        ColumnLayout {
            anchors.fill: parent
            height: parent.height
                GridLayout {
                    id: appGrid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.margins: 0.5 * PlasmaCore.Units.gridUnit
                    Layout.maximumHeight: 256  * PlasmaCore.Units.devicePixelRatio
                    Layout.maximumWidth: 256  * PlasmaCore.Units.devicePixelRatio
                    Repeater {
                        id: appRepeater
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: entriesModel
                        Rectangle {
                            id: appRoot
                            color: "#3B4252"
                            width: 128  * PlasmaCore.Units.devicePixelRatio
                            height: 140  * PlasmaCore.Units.devicePixelRatio
                            border.color: "#88c0d0"
                            border.width: 0
                            property var startRun: PropertyAnimation {
                                target: border
                                properties: "width"
                                from: 0
                                to: 4
                                duration: 1000
                                easing.type: Easing.OutElastic

                            }
                            property var stopRun: PropertyAnimation {
                                target: border
                                properties: "width"
                                from: 4
                                to: 0
                                duration: 250
                                easing.type: Easing.OutQuad

                            }
                            function getName(){
                                return appName.text;
                            }
                            ColumnLayout {
                                    height: parent.height
                                    width: parent.width
                                    PlasmaCore.IconItem {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        id: iconApp
                                                width: appRoot.width * 1.25
                                                height: appRoot.width * 1.25
                                                source:  model.icon
                                    }
                                    Rectangle {
                                        anchors.top: iconApp.bottom
                                        color: "#ECEFF4"
                                        width: parent.width
                                        height: parent.height * 0.2
                                        PlasmaComponents3.Label {
                                            id: appName
                                            width: parent.width
                                            height: parent.height
                                            text: model.name
                                            color: "#2E3440"
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            font.bold: true
                                            font.pixelSize: 18
                                        }
                                        
                                    }
                                    
                                        
                                        
                            }
                            
                            Component.onCompleted: {
                                repeater = appRepeater;   
                            }
                        
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                if(plasmoid.nativeInterface.currentProgram === getName())
                                    return;
                                stopRun.stop();
                                startRun.start();   
                                }
                                onExited: {
                                if(plasmoid.nativeInterface.currentProgram === getName())
                                    return;
                                startRun.stop();
                                stopRun.start();   
                                }
                                onClicked: {
                                        if(plasmoid.nativeInterface.currentProgram === "" || model.name !== plasmoid.nativeInterface.currentProgram){
                                            for (var i = 0; i < plasmoid.nativeInterface.entries.length; i++){
                                                var it = appRepeater.itemAt(i);
                                                if (it.getName() !== plasmoid.nativeInterface.currentProgram || plasmoid.nativeInterface.currentProgram === ""){
                                                    it.border.width = 0;
                                                }
                                            }
                                            plasmoid.nativeInterface.currentProgram = model.name;
                                            appRoot.startRun.stop();
                                            appRoot.border.width = 4;
                                            
                                            
                                        } else {
                                            appRan(plasmoid.nativeInterface.currentProgram);
                                        }
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    id: launchButton
                    width: 512 * PlasmaCore.Units.devicePixelRatio
                    height: (512 * PlasmaCore.Units.devicePixelRatio) / 8
                    color: "#2E344000"
                    property var inAnim: PropertyAnimation {
                                target: launchButton
                                properties: "height"
                                from:  (512 * PlasmaCore.Units.devicePixelRatio) / 8
                                to:  (512 * PlasmaCore.Units.devicePixelRatio) / 6
                                duration: 500
                                easing.type: Easing.OutQuad

                    }
                    property var outAnim: PropertyAnimation {
                                target: launchButton
                                properties: "height"
                                from:  (512 * PlasmaCore.Units.devicePixelRatio) / 6
                                to:  (512 * PlasmaCore.Units.devicePixelRatio) / 8
                                duration: 250
                                easing.type: Easing.OutQuad

                    }
                
                    RowLayout {
                        id: iconLaunch
                        width: parent.width
                        height: parent.height
                           PlasmaCore.IconItem {
                                        id: dashboardButton
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.alignment: Qt.AlignRight | Qt.Bottom
                                        source:  "xfdashboard"
                                        
                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            ToolTip.text: "List Mode"
                                            ToolTip.visible: containsMouse
                                            onEntered: {
                                                if(!containsMouse)
                                                    return;
                                                launchButton.outAnim.running = false;
                                                launchButton.inAnim.running = true;

                                            }
                                            onExited: {
                                                if(containsMouse)
                                                    return;
                                                launchButton.inAnim.running = false;
                                                launchButton.outAnim.running = true;
                                                

                                            }
                                            onClicked: {
                                                launchButton.inAnim.running = false;
                                                launchButton.outAnim.running = true;
                                                if (layoutView.currentIndex == 0)
                                                  layoutView.currentIndex = 1;
                                            }
                                            
                                        }
                            }
                            PlasmaCore.IconItem {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.alignment: Qt.AlignHCenter | Qt.Bottom
                                        source:  "launch"
                                        
                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onEntered: {
                                                if(!containsMouse)
                                                    return;
                                                launchButton.outAnim.running = false;
                                                launchButton.inAnim.running = true;

                                            }
                                            onExited: {
                                                if(containsMouse)
                                                    return;
                                                launchButton.inAnim.running = false;
                                                launchButton.outAnim.running = true;
                                                

                                            }
                                            onClicked: {
                                                if("" === plasmoid.nativeInterface.currentProgram)
                                                    return;
                                                launchButton.inAnim.running = false;
                                                launchButton.outAnim.running = true;
                                                appRan(plasmoid.nativeInterface.currentProgram)
                                            }
                                            
                                        }
                            }
                    }
                }
            }
    }
    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "#2E3440"
        radius: 4
        opacity: 0.75
        ColumnLayout {
            anchors.fill: parent
            height: parent.height
                ListView {
                    id: appList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.margins: 0.5 * PlasmaCore.Units.gridUnit
                    Layout.maximumHeight: 256  * PlasmaCore.Units.devicePixelRatio
                    Layout.maximumWidth: 300  * PlasmaCore.Units.devicePixelRatio
                    model: entriesModel
                    delegate: RowLayout {
                       PlasmaCore.IconItem {
                            id: dashboardButtonList
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignRight | Qt.Bottom
                            source:  model.icon
                       }
                       PlasmaComponents3.Label {
                                            id: appName
                                            width: parent.width
                                            height: parent.height
                                            text: model.name
                                            color: "#ECEFF4"
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            font.bold: true
                                            font.pixelSize: 24
                        }
                        MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                        if(plasmoid.nativeInterface.currentProgram === "" || model.name !== plasmoid.nativeInterface.currentProgram){
                                            plasmoid.nativeInterface.currentProgram = model.name;                                            
                                        } else {
                                            appRan(plasmoid.nativeInterface.currentProgram);
                                        }
                                }
                            }
                    }
                }
                Rectangle {
                    id: launchButtonList
                    width: 512 * PlasmaCore.Units.devicePixelRatio
                    height: (512 * PlasmaCore.Units.devicePixelRatio) / 8
                    color: "#2E344000"
                    property var inAnim: PropertyAnimation {
                                target: launchButtonList
                                properties: "height"
                                from:  (512 * PlasmaCore.Units.devicePixelRatio) / 8
                                to:  (512 * PlasmaCore.Units.devicePixelRatio) / 6
                                duration: 500
                                easing.type: Easing.OutQuad

                    }
                    property var outAnim: PropertyAnimation {
                                target: launchButtonList
                                properties: "height"
                                from:  (512 * PlasmaCore.Units.devicePixelRatio) / 6
                                to:  (512 * PlasmaCore.Units.devicePixelRatio) / 8
                                duration: 250
                                easing.type: Easing.OutQuad

                    }
                
                    RowLayout {
                        id: iconLaunchList
                        width: parent.width
                        height: parent.height
                           PlasmaCore.IconItem {
                                        id: dashboardButtonList
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.alignment: Qt.AlignRight | Qt.Bottom
                                        source:  "xfdashboard"
                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            ToolTip.text: "Grid Mode"
                                            ToolTip.visible: containsMouse
                                            onEntered: {
                                                if(!containsMouse)
                                                    return;
                                                launchButtonList.outAnim.running = false;
                                                launchButtonList.inAnim.running = true;

                                            }
                                            onExited: {
                                                if(containsMouse)
                                                    return;
                                                launchButtonList.inAnim.running = false;
                                                launchButtonList.outAnim.running = true;
                                                

                                            }
                                            onClicked: {
                                                launchButtonList.inAnim.running = false;
                                                launchButtonList.outAnim.running = true;
                                                if (layoutView.currentIndex == 1)
                                                  layoutView.currentIndex = 0;
                                            }
                                            
                                        }
                            }
                            PlasmaCore.IconItem {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.alignment: Qt.AlignHCenter | Qt.Bottom
                                        source:  "launch"
                                        
                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onEntered: {
                                                if(!containsMouse)
                                                    return;
                                                launchButtonList.outAnim.running = false;
                                                launchButtonList.inAnim.running = true;

                                            }
                                            onExited: {
                                                if(containsMouse)
                                                    return;
                                                launchButtonList.inAnim.running = false;
                                                launchButtonList.outAnim.running = true;
                                                

                                            }
                                            onClicked: {
                                                if("" === plasmoid.nativeInterface.currentProgram)
                                                    return;
                                                launchButtonList.inAnim.running = false;
                                                launchButtonList.outAnim.running = true;
                                                appRan(plasmoid.nativeInterface.currentProgram)
                                            }
                                            
                                        }
                            }
                    }
                }
    }
        }
        
    
    }
    
    property var repeater: plasmoid.fullRepresentation.appRepeater

    
    signal appLauncherClosed()
    signal appRan(string program)
    
    onAppRan: {
        for (var i = 0; i < plasmoid.nativeInterface.entries.length; i++){
           var it = repeater.itemAt(i);
           it.border.width = 0;
        }   
        if(plasmoid.nativeInterface.runProgram()){
           plasmoid.expanded = false;
           plasmoid.nativeInterface.currentProgram = ""
            
        }
    }
    
    onAppLauncherClosed: {
       for (var i = 0; i < plasmoid.nativeInterface.entries.length; i++){
            var it = repeater.itemAt(i);
            it.border.width = 0;
        }   
    }
    
    Component.onCompleted: {
        for( var i = 0; i < plasmoid.nativeInterface.entries.length; i++){
            entriesModel.append({ name: plasmoid.nativeInterface.entries[i], icon: plasmoid.nativeInterface.icons[i] });
        }
    }
}
