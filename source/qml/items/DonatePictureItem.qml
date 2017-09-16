import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.imagemonkey.imagemonkey 1.0
import QuickNative 0.1
import "../basiccomponents"

Item{
    id: donatePictureItem

    signal isActive()

    QtObject{
        id: internal
        property string imageId: "";
        property var pendingRequests
        property bool initialized: false;
    }

    onIsActive: {
        if(!internal.initialized){
            internal.pendingRequests = {};
            internal.initialized = true;
        }
        restAPI.getRandomLabel();
    }

    NativeFileDialog {
        id: imagePicker
        selectMultiple: false
        onFileUrlChanged: {
            img.source = fileUrl;
            selectPictureButton.visible = false;
            img.visible = true;
            infoText.visible = true;
        }
        Component.onCompleted: {
            imagePicker.folder = shortcuts.pictures
        }
    }

    HttpsRequestWorkerThread{
        id: restAPI
        signal donatePicture();
        signal getRandomLabel();

        onDonatePicture: {
            loadingIndicator.visible = true;
            var donatePictureRequest = Qt.createQmlObject('import com.imagemonkey.imagemonkey 1.0; DonatePictureRequest{}',
                                                   restAPI);
            donatePictureRequest.set(imagePicker.fileUrl, label.text);
            internal.pendingRequests[donatePictureRequest.getUniqueRequestId()] = "donateImg";
            restAPI.post(donatePictureRequest);
        }

        onGetRandomLabel: {
            loadingIndicator.visible = true;
            var randomLabelRequest = Qt.createQmlObject('import com.imagemonkey.imagemonkey 1.0; GetRandomPictureLabelRequest{}',
                                                   restAPI);
            internal.pendingRequests[randomLabelRequest.getUniqueRequestId()] = "randomLabel";
            restAPI.get(randomLabelRequest);
        }
    }

    Connections {
        target: restAPI
        onResultReady: {
            if(errorCode === 0){
                if(uniqueRequestId in internal.pendingRequests){
                    var reqType = internal.pendingRequests[uniqueRequestId];
                    if(reqType === "randomLabel"){
                        var data = JSON.parse(result);
                        label.text = data["label"];
                        loadingIndicator.visible = false;
                    }
                    else if(reqType === "donateImg"){
                        img.source = "";
                        img.visible = false;
                        selectPictureButton.visible = true;
                        loadingIndicator.visible = false;
                        toast.show(qsTr("Successfully uploaded picture"), 2000);

                        restAPI.getRandomLabel(); //request another random label
                    }

                    delete internal.pendingRequests[uniqueRequestId];
                }
            }
            else{
                if(uniqueRequestId in internal.pendingRequests){
                    if(internal.pendingRequests[uniqueRequestId] === "donateImg"){
                        toast.show(qsTr("Couldn't upload picture!"), 2000);
                    }

                    delete internal.pendingRequests[uniqueRequestId];
                }
            }
        }
    }

    Text{
        id: label
        anchors.top: parent.top
        anchors.topMargin: 5 * settings.pixelDensity
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 10 * settings.pixelDensity
        font.bold: true
    }
    Text{
        id: labelDescription
        anchors.top: label.bottom
        anchors.topMargin: 3 * settings.pixelDensity
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 4 * settings.pixelDensity
        width: parent.width - (5 * settings.pixelDensity)
        wrapMode: Text.WordWrap
        text: qsTr("Upload a photo which represents the above.")
    }

    MaterialButton{
        id: selectPictureButton
        anchors.centerIn: parent
        text: "\ue432"
        backgroundColor: "black"
        font.pixelSize: 40 * settings.pixelDensity
        onClicked: imagePicker.open();
    }

    Image{
        id: img
        anchors.top: label.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: infoText.top
        fillMode: Image.PreserveAspectFit
        visible: false
        MouseArea{
            anchors.fill: parent
            onClicked: {
                imagePicker.open();
            }
        }
    }

    Text{
        id: infoText
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: uploadButton.top
        anchors.bottomMargin: 4 * settings.pixelDensity
        width: parent.width - (10 * settings.pixelDensity)
        wrapMode: Text.WordWrap
        font.pixelSize: 5 * settings.pixelDensity
        visible: false
        textFormat: Text.RichText
        text: qsTr("By uploading a photo you agree that you are the owner of the photo and you are comfortable with releasing the photo under the <a href=\"https://creativecommons.org/publicdomain/zero/1.0/\">CC0 license</a>.")
        onLinkActivated: Qt.openUrlExternally(link)
    }

    Button{
        id: uploadButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 5 * settings.pixelDensity
        width: 50 * settings.pixelDensity
        height: 17 * settings.pixelDensity
        text: qsTr("UPLOAD")
        visible: (img.visible && (label.text !== ""))
        Material.foreground: "white"
        Material.background: "#FF9800"
        onClicked: {
            restAPI.donatePicture();
        }
    }

    LoadingIndicator{
        id: loadingIndicator
        anchors.centerIn: parent
        visible: true
    }

    Toast{
        id: toast
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5 * settings.pixelDensity
    }

}
