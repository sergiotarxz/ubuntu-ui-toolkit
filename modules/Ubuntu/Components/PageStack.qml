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

import QtQuick 2.0
import "stack.js" as Stack

/*!
    \qmltype PageStack
    \inqmlmodule Ubuntu.Components 0.1
    \ingroup ubuntu
    \brief A stack of \l Page items that is used for inter-Page navigation.
        Pages on the stack can be popped, and new Pages can be pushed.
        The page on top of the stack is the visible one.
        Any non-Page Item that you want to use with PageStack should be created
        with its visible property set to false.

    Example:
    \qml
        import Ubuntu.Components 0.1
        import Ubuntu.Components.ListItems 0.1 as ListItem

        PageStack {
            id: pageStack
            Component.onCompleted: pageStack.push(page0)

            Page {
                id: page0
                title: "Root page"

                Column {
                    anchors.fill: parent
                    ListItem.Standard {
                        text: "Page one"
                        onClicked: pageStack.push(rect, {color: "red"})
                        progression: true
                    }
                    ListItem.Standard {
                        text: "Page two (external)"
                        onClicked: pageStack.push(Qt.resolvedUrl("MyCustomPage.qml"))
                        progression: true
                    }
                }
            }

            Rectangle {
                id: rect
                anchors.fill: parent
                visible: false
            }
        }
    \endqml
*/

Page {
    id: pageStack

    // override automatic height from Page
    height: undefined
    anchors.fill: parent

    /*!
      \preliminary
      The current size of the stack
     */
    //FIXME: would prefer this be readonly, but readonly properties are only bound at
    //initialisation. Trying to update it in push or pop fails. Not sure how to fix.
    property int depth: 0

    /*!
      \preliminary
      The currently active page
     */
    property Item currentPage

    title: currentPage && currentPage.hasOwnProperty("title") ? currentPage.title : ""
    flickable: currentPage && currentPage.hasOwnProperty("flickable") ? currentPage.flickable : null

    /*!
      \internal
      The instance of the stack from javascript
     */
    property var stack: new Stack.Stack()

    /*!
      The tools of currentPage. If the current page does not define tools,
      a default set of tools is used consisting of only a back button that is
      visible when depth > 1.
     */
//    property ToolbarActions // TODO: remove
    tools: currentPage && currentPage.hasOwnProperty("tools")
                               && currentPage.tools ? currentPage.tools : __defaultTools

    /*! \internal */
    onToolsChanged: if (tools) tools.__pageStack = pageStack;

    /*!
      \internal
      The tools to be used if page does not define tools. It features only
      the default back button.
     */
    property ToolbarActions __defaultTools: ToolbarActions { __pageStack: pageStack }

    /*!
      \internal
      Create a PageWrapper for the specified page.
     */
    function __createWrapper(page, properties) {
        var wrapperComponent = Qt.createComponent("PageWrapper.qml");
        // TODO: cache the component?
        var wrapperObject = wrapperComponent.createObject(pageContents);
        wrapperObject.reference = page;
        wrapperObject.parent = pageContents;
        wrapperObject.properties = properties;
        wrapperObject.pageStack = pageStack;
        return wrapperObject;
    }

    /*!
      \preliminary
      Push a page to the stack, and apply the given (optional) properties to the page.
     */
    function push(page, properties) {
        if (stack.size() > 0) stack.top().active = false;

        stack.push(__createWrapper(page, properties));
        stack.top().active = true;

        __stackUpdated();
    }

    /*!
      \preliminary
      Pop the top item from the stack if the stack size is at least 1.
      Do not do anything if 0 or 1 items are on the stack.
     */
    function pop() {
        if (stack.size() < 1) {
            print("WARNING: Trying to pop an empty PageStack. Ignoring.");
            return;
        }

        stack.top().pageStack = null;
        stack.top().active = false;
        if (stack.top().canDestroy) stack.top().destroyObject();
        stack.pop();
        if (stack.size() > 0) stack.top().active = true;

        __stackUpdated();
    }

    /*!
      \preliminary
      Deactivate the active page and clear the stack.
     */
    function clear() {
        while (stack.size() > 0) {
            stack.top().pageStack = null;
            stack.top().active = false;
            if (stack.top().canDestroy) stack.top().destroyObject();
            stack.pop();
        }
        __stackUpdated();
    }

    /*!
      \internal
     */
    function __stackUpdated() {
        pageStack.depth = stack.size();
        if (pageStack.depth > 0) currentPage = stack.top().object;
        else currentPage = null;
//        contents.updateHeader();
    }

    Item {
        id: contents
        parent: pageStack
        anchors.fill: pageStack

        Item {
            id: pageContents
            anchors.fill: parent
//            anchors {
//                left: parent.left
//                right: parent.right
//                bottom: parent.bottom
//                top: header.visible ? header.bottom : parent.top
//            }
        }

        // The header comes after the contents to ensure its z-order is higher.
        // This ensures flickable contents never overlap the header,
        // without having to resort to clipping.
//        Header {
//            id: header
//            anchors {
//                left: parent.left
//                right: parent.right
//                top: parent.top
//            }
//            height: units.gu(5)
//        }

//        function updateHeader() {
//            var stackSize = stack.size();
//            if (stackSize > 0) {
//                var item = stack.top().object;
//                if (item.__isPage === true) header.title = item.title;
//                else header.title = "";
//            } else {
//                header.title = "";
//            }
//        }
    }
}
