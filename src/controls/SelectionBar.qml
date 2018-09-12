import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui

Item
{
    id: control

    property var selectedPaths: []
    property alias selectionList : selectionList
    property alias anim : anim
    property int barHeight : iconSizes.big + (isMobile ? space.big : space.large) + space.medium
    property color animColor : "black"

    property int position: Qt.Horizontal
    property string iconName : "overflow-menu"
    property bool iconVisible: true

    signal iconClicked()
    signal modelCleared()
    signal exitClicked()

    height: if(position === Qt.Horizontal)
                barHeight
            else if(position === Qt.Vertical)
                parent.height
            else
                undefined

    width: if(position === Qt.Horizontal)
               parent.width
           else if(position === Qt.Vertical)
               barHeight
           else
               undefined


    visible: selectionList.count > 0

    Rectangle
    {
        id: bg
        anchors.fill: parent
        z:-1
        color: altColor
        radius: 4
        opacity: 0.6
        border.color: Qt.darker(altColor, 1.6)

        SequentialAnimation
        {
            id: anim
            PropertyAnimation
            {
                target: bg
                property: "color"
                easing.type: Easing.InOutQuad
                from: animColor
                to: Kirigami.Theme.complementaryBackgroundColor
                duration: 500
            }
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked: riseContent()
        }
    }

    GridLayout
    {
        anchors.fill: parent
        rows: if(position === Qt.Horizontal)
                  1
              else if(position === Qt.Vertical)
                  4
              else
                  undefined

        columns: if(position === Qt.Horizontal)
                     4
                 else if(position === Qt.Vertical)
                     1
                 else
                     undefined

        Rectangle
        {
            height: iconSizes.medium
            width: iconSizes.medium
            radius: Math.min(width, height)
            color: Maui.Style.dangerColor
            border.color: Qt.darker(color, 1.3)

            anchors.verticalCenter: parent.top
            anchors.horizontalCenter: parent.left
            Layout.column: if(position === Qt.Horizontal)
                               1
                           else if(position === Qt.Vertical)
                               1
                           else
                               undefined

            Layout.row: if(position === Qt.Horizontal)
                            1
                        else if(position === Qt.Vertical)
                            1
                        else
                            undefined
            Maui.ToolButton
            {
                anchors.centerIn: parent
                iconName: "window-close"
                iconColor: altColorText
                size: iconSizes.small
                flat: true
                onClicked:
                {
                    selectionList.model.clear()
                    exitClicked()
                }
            }
        }

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.column: if(position === Qt.Horizontal)
                               2
                           else if(position === Qt.Vertical)
                               1
                           else
                               undefined

            Layout.row: if(position === Qt.Horizontal)
                            1
                        else if(position === Qt.Vertical)
                            2
                        else
                            undefined

            Layout.alignment: if(position === Qt.Horizontal)
                                  Qt.AlignVCenter
                              else if(position === Qt.Vertical)
                                  Qt.AlignHCenter
                              else
                                  undefined
            ListView
            {
                id: selectionList
                anchors.fill: parent

                boundsBehavior: !isMobile? Flickable.StopAtBounds : Flickable.OvershootBounds
                orientation: if(position === Qt.Horizontal)
                                 ListView.Horizontal
                             else if(position === Qt.Vertical)
                                 ListView.Vertical
                             else
                                 undefined
                clip: true
                spacing: space.small

                focus: true
                interactive: true

                model: ListModel{}

                delegate: Maui.IconDelegate
                {
                    id: delegate
                    anchors.verticalCenter: position === Qt.Horizontal ? parent.verticalCenter : undefined
                    anchors.horizontalCenter: position === Qt.Vertical ? parent.horizontalCenter : undefined
                    height:  iconSizes.big + (isMobile ? space.medium : space.big)
                    width: iconSizes.big + (isMobile? space.big : space.large) + space.big
                    folderSize: iconSizes.big
                    showLabel: true
                    emblemAdded: true
                    keepEmblemOverlay: true
                    showSelectionBackground: false
                    labelColor: altColorText
                    showTooltip: true
                    showThumbnails: true
                    emblemSize: iconSizes.small
                    leftEmblem: "emblem-remove"

                    Connections
                    {
                        target: delegate
                        onLeftEmblemClicked: removeSelection(index)
                    }
                }

            }
        }
        Item
        {
            Layout.alignment: if(position === Qt.Horizontal)
                                  Qt.AlignRight || Qt.AlignVCenter
                              else if(position === Qt.Vertical)
                                  Qt.AlignCenter
                              else
                                  undefined
            Layout.fillWidth: position === Qt.Vertical
            Layout.fillHeight: position === Qt.Horizontal
            Layout.maximumWidth: iconSizes.medium
            Layout.column: if(position === Qt.Horizontal)
                               3
                           else if(position === Qt.Vertical)
                               1
                           else
                               undefined

            Layout.row: if(position === Qt.Horizontal)
                            1
                        else if(position === Qt.Vertical)
                            3
                        else
                            undefined
            Maui.ToolButton
            {
                visible: iconVisible
                anchors.centerIn: parent
                iconName: control.iconName
                iconColor: altColorText
                onClicked: iconClicked()
            }
        }

        Rectangle
        {
            height: iconSizes.medium
            width: iconSizes.medium
            radius: Math.min(width, height)
            color: highlightColor
            border.color: Qt.darker(color, 1.3)

            anchors.verticalCenter: parent.top
            anchors.horizontalCenter: parent.right
            Layout.column: if(position === Qt.Horizontal)
                               4
                           else if(position === Qt.Vertical)
                               1
                           else
                               undefined

            Layout.row: if(position === Qt.Horizontal)
                            1
                        else if(position === Qt.Vertical)
                            4
                        else
                            undefined
            Label
            {
                anchors.fill: parent
                anchors.centerIn: parent
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: fontSizes.default
                font.weight: Font.Bold
                font.bold: true
                color: highlightedTextColor
                text: selectionList.count
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    selectionList.model.clear()
                    modelCleared()
                }
            }
        }
    }

    onVisibleChanged:
    {
        if(position === Qt.Vertical) return

        if(typeof(riseContent) === "undefined") return

        if(control.visible)
            riseContent()
        else
            dropContent()
    }

    function clear()
    {
        selectedPaths = []
        selectionList.model.clear()
    }

    function removeSelection(index)
    {
        var path = selectionList.model.get(index).path
        if(selectedPaths.indexOf(path) > -1)
        {
            selectedPaths.splice(index, 1)
            selectionList.model.remove(index)
        }
    }

    function append(item)
    {
        if(selectedPaths.indexOf(item.path) < 0)
        {
            selectedPaths.push(item.path)

            for(var i = 0; i < selectionList.count ; i++ )
                if(selectionList.model.get(i).path === item.path)
                {
                    selectionList.model.remove(i)
                    return
                }

            selectionList.model.append(item)
            selectionList.positionViewAtEnd()

            if(position === Qt.Vertical) return
            if(typeof(riseContent) === "undefined") return

            riseContent()
        }
    }

    function animate(color)
    {
        animColor = color
        anim.running = true
    }
}