/***************************************************************************
 *   Copyright (C) 2018 by Jeremy Whiting <jeremypwhiting@gmail.com>       *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation version 2 of the License.                *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.          *
 ***************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Item {
    id: mapPage
    anchors.fill: parent

    signal menuClicked()
    signal settingsClicked()
    signal allServersClicked()

    Item {
        id: headerArea
        width: parent.width
        height: 57
        anchors.top: parent.top

        Rectangle {
            id: toolBarTop
            anchors.fill: parent
            color: defaultColor

            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 1
                verticalOffset: 1
                color: "#80000000"
            }

            Image {
                id: menuImage
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
                source: "../images/menu-left.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: { mapPage.menuClicked() }
                }
            }

            Row {
                id: centerBox
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8

                Image {
                    id: statusIcon
                    source: "../images/lock-unlock.png"
                }

                Text {
                    id: statusText
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 18
                    font.family: "Roboto"
                    font.bold: true
                    color: "white"
                    text: qsTr("Not Connected");
                }
            }

            Image {
                id: settingsImage
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 20
                source: "../images/settings.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: { mapPage.settingsClicked(); }
                }
            }
        }
    }

    Image {
        id: background
        z: -1
        anchors.top: headerArea.top - 55
        anchors.left: parent.left
        source: "../maps/DE-NotConnected.png"
    }

    Column {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 12

        width: 335
        height: childrenRect.height

        ServerCard {
            id: currentServerCard
            showButton: true
//            expandable: false
        }

        Rectangle {
            id: allServersButton
            width: parent.width
            height: 56
            color: "white"
            radius: 5

            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 1
                verticalOffset: 1
                color: "#80000000"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("SHOW ALL SERVERS");
                color: defaultColor
                font.family: "Roboto-Bold"
                font.bold: true
                font.pixelSize: 16
            }

            MouseArea {
                anchors.fill: parent
                onClicked: { mapPage.allServersClicked(); }
            }
        }


    }
}