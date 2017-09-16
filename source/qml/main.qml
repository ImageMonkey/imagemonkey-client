import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Window 2.2
import "items"

ApplicationWindow {
    visible: true
    width: 640
    height: 800
    title: qsTr("ImageMonkey")

    Component.onCompleted: {
        settings.pixelDensity = Screen.logicalPixelDensity //set pixel density
        donatePictureItem.isActive();
    }

    QtObject{
        id: settings
        property double pixelDensity
    }

    Settings {
        category: "General"
    }

    TabBar {
        id: tabbar
        width: parent.width
        position: TabBar.Footer
        anchors.bottom: parent.bottom
        Material.foreground: "black"
        Material.background: "white"
        Material.accent: "#FF9800"
        TabButton {
            text: qsTr("Donate")
        }
        TabButton {
            text: qsTr("Validate")
        }
        onCurrentIndexChanged: {
            if(currentIndex === 0)
                donatePictureItem.isActive();
            else
                validatePictureItem.isActive();
        }
    }

    StackLayout {
        id: stackLayout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: tabbar.top
        //width: parent.width
        currentIndex: tabbar.currentIndex
        DonatePictureItem {
            id: donatePictureItem
        }
        ValidatePictureItem {
            id: validatePictureItem
        }
    }

    FontLoader{
        id: materialDesignLoader
        source: "../fonts/material-design-icons.ttf"
    }

    FontLoader{
        id: fontawesomeLoader
        source: "../fonts/fontawesome-webfont.ttf"
    }
}
