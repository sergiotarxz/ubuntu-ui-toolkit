/*
 * Copyright 2014 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Themes.Ambiance 0.1

MainView {
    width: units.gu(48)
    height: units.gu(60)

    Page {
        title: "Textfield"

        Flickable {
            anchors.fill: parent
            contentHeight: childrenRect.height

            Column {
                anchors.fill: parent

                Label {
                    text: "Below is a customized text field with clipping"
                }

                Item {
                    clip: true // Mustn't affect handler visibility
                    width: childrenRect.width
                    height: childrenRect.height

                    TextField {
                        objectName: "textfield"
                        placeholderText: "Type here"
                        width: units.gu(35)
                        height: units.gu(2)

                        style: TextFieldStyle {
                            overlaySpacing: 0
                            frameSpacing: 0
                            background: Item {}
                            color: UbuntuColors.lightAubergine
                        }
                    }
                }

                Repeater {
                    model: 30
                    Label {
                        text: "These labels are here to necessitate scrolling"
                    }
                }
            }
        }
    }
}
