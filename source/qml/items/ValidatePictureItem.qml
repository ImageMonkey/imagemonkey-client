import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.imagemonkey.imagemonkey 1.0
import "../basiccomponents"

Item{
    id: validatePictureItem

    signal isActive()

    onIsActive: {
        restAPI.getRandomPicture();
    }

    QtObject{
        id: internal
        property string imageId: "";
        property var pendingRequests;
        Component.onCompleted: {
            pendingRequests = {};
        }
    }

    HttpsRequestWorkerThread{
        id: restAPI
        signal getRandomPicture();
        signal validatePicture(bool valid);

        onGetRandomPicture: {
            progressLoadingBar.visible = true;
            var getRandomPictureRequest = Qt.createQmlObject('import com.imagemonkey.imagemonkey 1.0; GetRandomPictureRequest{}',
                                                   restAPI);
            internal.pendingRequests[getRandomPictureRequest.getUniqueRequestId()] = "randomImg";
            restAPI.get(getRandomPictureRequest);
        }

        onValidatePicture: {
            progressLoadingBar.visible = true;
            var validatePictureRequest = Qt.createQmlObject('import com.imagemonkey.imagemonkey 1.0; ValidatePictureRequest{}',
                                                   restAPI);
            validatePictureRequest.set(internal.imageId, valid);
            validatePictureRequest.setData(JSON.stringify({"label": label.label, "sublabel": label.sublabel}));
            internal.pendingRequests[validatePictureRequest.getUniqueRequestId()] = "validateImg";
            restAPI.post(validatePictureRequest);
        }
    }

    Connections {
        target: restAPI
        onResultReady: {
            if(errorCode === 0){
                if(uniqueRequestId in internal.pendingRequests){
                    var reqType = internal.pendingRequests[uniqueRequestId];
                    if(reqType === "randomImg"){
                        var data = JSON.parse(result);
                        internal.imageId = data["uuid"];

                        if(internal.imageId !== ""){
                            label.label = data["label"];
                            label.sublabel = data["sublabel"];

                            if(label.sublabel === "")
                                label.text = data["label"];
                            else
                                label.text = data["sublabel"] + "/" + data["label"];

                            img.source = ConnectionSettings.getBaseUrl() + "donation/" + internal.imageId;
                            img.visible = true;
                            error.visible = false;
                            noButton.visible = true;
                            yesButton.visible = true;
                        }
                        else{
                            error.visible = true;
                            img.visible = false;
                            noButton.visible = false;
                            yesButton.visible = false;
                        }
                        progressLoadingBar.visible = false;
                    }
                    else if(reqType === "validateImg"){
                        progressLoadingBar.visible = false;
                        restAPI.getRandomPicture();
                    }

                    delete internal.pendingRequests[uniqueRequestId];
                }
            }
            else{
                if(uniqueRequestId in internal.pendingRequests){
                    delete internal.pendingRequests[uniqueRequestId];
                }
            }
        }
    }

    Text{
        id: label
        property string label: "";
        property string sublabel: "";
        anchors.top: parent.top
        anchors.topMargin: 5 * settings.pixelDensity
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 10 * settings.pixelDensity
        font.bold: true
    }

    Image{
        id: img
        anchors.top: label.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: yesButton.top
        anchors.bottomMargin: 5 * settings.pixelDensity
        fillMode: Image.PreserveAspectFit
        asynchronous: true
    }

    Button{
        id: yesButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10 * settings.pixelDensity
        anchors.horizontalCenterOffset: + ((yesButton.width/2) + (10 * settings.pixelDensity))
        Material.foreground: "white"
        Material.background: "green"
        height: 17 * settings.pixelDensity
        width: 50 * settings.pixelDensity
        text: qsTr("YES")
        visible: false
        onClicked: {
            restAPI.validatePicture(true);
        }
    }

    Button{
        id: noButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10 * settings.pixelDensity
        anchors.horizontalCenterOffset: - ((noButton.width/2) + (10 * settings.pixelDensity))
        Material.foreground: "white"
        Material.background: "red"
        height: 17 * settings.pixelDensity
        width: 50 * settings.pixelDensity
        text: qsTr("NO")
        visible: false
        onClicked: {
            restAPI.validatePicture(false);
        }
    }

    Text{
        id: error
        anchors.centerIn: parent
        width: parent.width - (10 * settings.pixelDensity)
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 6 * settings.pixelDensity
        text: qsTr("Nothing found")
        font.bold: true
        visible: false
    }

    LoadingIndicator{
        id: progressLoadingBar
        anchors.centerIn: parent
        visible: true
    }

}
