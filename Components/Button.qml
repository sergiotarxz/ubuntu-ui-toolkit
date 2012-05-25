/*
 * Copyright 2012 Canonical Ltd.
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

import QtQuick 1.1

/*!
    \qmlclass Button
    \inqmlmodule UbuntuUIToolkit
    \brief The Button class adds an icon and text to the AbstractButton

    \b{This component is under heavy development.}

    A button can have text, an icon, or both.
*/
AbstractButton {
    id: button

    /*!
      \preliminary
      The dimensions of the button.
    */
    width: 150
    height: 50

    /*!
      \preliminary
      The relative positions of the icon with respect
      to the text of the button.
      TODO: make these readonly when readonly gets supported
    */
    property int leftOfText: 0
    property int rightOfText: 1
    property int aboveText: 2
    property int belowText: 3

    /*!
       \preliminary
       The source URL of the icon to display inside the button.
       Leave this value blank for a text-only button.
    */
    property alias iconSource: icon.source

    /*!
       \preliminary
       The text to display in the button. If an icon was defined,
       the text will be shown next to the icon, otherwise it will
       be centered. Leave blank for an icon-only button.
    */
    property alias text: label.text

    /*!
      \preliminary
      The size of the text that is displayed in the button.
    */
    property alias textSize: label.fontSize

    /*!
      \preliminary
      The color of the text.
    */
    property alias textColor: label.color

    /*!
       \preliminary

       The position of the icon relative to the text.
       top, bottom, left or right.
       If only text or only an icon is defined, this
       property is ignored and the text or icon is
       centered horizontally and vertically in the button.
    */
    property int iconPosition: button.leftOfText

    Image {
        id: icon
        fillMode: Image.PreserveAspectFit
        anchors.margins: 10
        height: {
            if (text===""||iconPosition==button.leftOfText||iconPosition==button.rightOfText) return button.height - 20;
            else return button.height - label.implicitHeight - 30;
        }
     }

    TextCustom {
        id: label
        anchors.margins: 10
        fontSize: "medium"
    }

    /*!
       \internal
    */
    function __alignIconText() {
        if (button.iconSource=="") {
            // no icon.
            label.anchors.centerIn = button;
        } else if (button.text=="") {
            icon.anchors.centerIn = button;
        } else if (iconPosition==button.aboveText) {
            icon.anchors.top = button.top;
            icon.anchors.horizontalCenter = button.horizontalCenter;
            label.anchors.top = icon.bottom;
            label.anchors.horizontalCenter = button.horizontalCenter;
        } else if (iconPosition==button.belowText) {
            icon.anchors.bottom = button.bottom;
            icon.anchors.horizontalCenter = button.horizontalCenter;
            label.anchors.bottom = icon.top;
            label.anchors.horizontalCenter = button.horizontalCenter;
        } else if (iconPosition==button.rightOfText) {
            icon.anchors.right = button.right;
            icon.anchors.verticalCenter = button.verticalCenter;
            label.anchors.right = icon.left;
            label.anchors.verticalCenter = button.verticalCenter;
        } else if (iconPosition==button.leftOfText) {
            icon.anchors.left = button.left;
            icon.anchors.verticalCenter = button.verticalCenter;
            label.anchors.left = icon.right;
            label.anchors.verticalCenter = button.verticalCenter;
        } // if textlocation
    } // alignIconText

    Component.onCompleted: __alignIconText()
}
