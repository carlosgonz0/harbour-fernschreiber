/*
    Copyright (C) 2020 Sebastian J. Wolf

    This file is part of Fernschreiber.

    Fernschreiber is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Fernschreiber is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Fernschreiber. If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.5
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0

Item {

    id: imageTumbnail

    property variant imageData;

    Image {

        Component.onCompleted: {
            if (imageData.local.is_downloading_completed) {
                singleImage.source = imageData.local.path;
            } else {
                tdLibWrapper.downloadFile(imageData.id);
            }
        }

        Connections {
            target: tdLibWrapper
            onFileUpdated: {
                if (id === imageData.id) {
                    console.log("File updated, completed? " + fileInformation.local.is_downloading_completed);
                    imageTumbnail.imageData = fileInformation;
                    if (imageTumbnail.imageData.local.is_downloading_completed) {
                        singleImage.source = imageTumbnail.imageData.local.path;
                    }
                }
            }
        }

        id: singleImage
        width: parent.width - Theme.paddingSmall
        height: parent.height - Theme.paddingSmall
        anchors.centerIn: parent

        fillMode: Image.PreserveAspectCrop
        autoTransform: true
        asynchronous: true
    }

    Image {
        id: imageLoadingBackgroundImage
        source: "../../images/background" + ( Theme.colorScheme ? "-black" : "-white" ) + ".png"
        anchors {
            centerIn: parent
        }
        width: parent.width - 2 * Theme.paddingLarge
        height: parent.height - 2 * Theme.paddingLarge
        visible: singleImage.status !== Image.Ready

        fillMode: Image.PreserveAspectFit
        opacity: 0.15
    }

}