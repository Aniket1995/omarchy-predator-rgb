import QtQuick
import qs.Commons
import qs.Ui

Column {
  id: root
  required property var panelRoot

  width: parent ? parent.width : Style.space(370)
  spacing: Style.space(8)

  PanelSectionHeader {
    text: "GLOBAL CONTROLS"
  }

  // 1. Master Backlight Power Card
  BorderSurface {
    width: parent.width
    implicitHeight: Style.space(52)
    radius: Style.cornerRadius
    color: Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
    borderSpec: Border.surfaceSpec("panels", "border", root.panelRoot.power ? Color.accent : Color.popups.border, 1)

    Item {
      anchors.fill: parent
      anchors.margins: Style.space(10)

      Column {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: Style.space(2)

        Text {
          text: "KEYBOARD BACKLIGHT"
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.body
          font.bold: true
          color: root.panelRoot.power ? Color.accent : (root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground)
        }

        Text {
          text: root.panelRoot.power ? "Backlight LEDs Active" : "LEDs Powered Off"
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.caption
          color: Qt.darker(Color.foreground, 1.4)
        }
      }

      // Pill toggle
      Item {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: Style.space(48)
        height: Style.space(26)

        Rectangle {
          anchors.fill: parent
          radius: height / 2
          color: root.panelRoot.power ? Color.accent : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.08)
          border.width: 1
          border.color: root.panelRoot.power ? Color.accent : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.22)

          Rectangle {
            width: Style.space(20)
            height: Style.space(20)
            radius: height / 2
            anchors.verticalCenter: parent.verticalCenter
            x: root.panelRoot.power ? parent.width - width - Style.space(3) : Style.space(3)
            color: "#ffffff"

            Behavior on x {
              NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: root.panelRoot.togglePower()
        }
      }
    }
  }

  // 2. Brightness Stepper
  BorderSurface {
    width: parent.width
    implicitHeight: Style.space(56)
    radius: Style.cornerRadius
    color: Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
    borderSpec: Border.surfaceSpec("panels", "border", Color.popups.border, 1)

    Column {
      anchors.fill: parent
      anchors.margins: Style.space(8)
      spacing: Style.space(6)

      Row {
        width: parent.width
        Text {
          anchors.left: parent.left
          text: "BRIGHTNESS"
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.caption
          font.bold: true
          color: Qt.darker(Color.foreground, 1.4)
        }
        Text {
          anchors.right: parent.right
          text: root.panelRoot.power ? root.panelRoot.brightness + "%" : "0%"
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.caption
          font.bold: true
          color: Color.accent
        }
      }

      Row {
        width: parent.width
        spacing: Style.space(6)

        Repeater {
          model: [25, 50, 75, 100]

          BorderSurface {
            width: (parent.width - (Style.space(6) * 3)) / 4
            implicitHeight: Style.space(24)
            radius: Style.space(3)
            color: (root.panelRoot.power && root.panelRoot.brightness === modelData)
              ? Qt.rgba(Color.accent.r, Color.accent.g, Color.accent.b, 0.22)
              : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
            borderSpec: Border.surfaceSpec("panels", "border", (root.panelRoot.power && root.panelRoot.brightness === modelData) ? Color.accent : Color.popups.border, 1)

            Text {
              anchors.centerIn: parent
              text: modelData + "%"
              font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
              font.pixelSize: Style.font.caption - Style.space(2)
              font.bold: root.panelRoot.power && root.panelRoot.brightness === modelData
              color: (root.panelRoot.power && root.panelRoot.brightness === modelData) ? Color.accent : Color.foreground
            }

            MouseArea {
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: root.panelRoot.setBrightness(modelData)
            }
          }
        }
      }
    }
  }

  // 3. Animation Speed & Direction (for dynamic modes)
  Row {
    visible: root.panelRoot.mode !== 0
    width: parent.width
    spacing: Style.space(8)

    // Speed
    BorderSurface {
      width: (root.panelRoot.mode === 3 || root.panelRoot.mode === 4) ? (parent.width - Style.space(8)) / 2 : parent.width
      implicitHeight: Style.space(56)
      radius: Style.cornerRadius
      color: Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
      borderSpec: Border.surfaceSpec("panels", "border", Color.popups.border, 1)

      Column {
        anchors.fill: parent
        anchors.margins: Style.space(8)
        spacing: Style.space(6)

        Row {
          width: parent.width
          Text {
            anchors.left: parent.left
            text: "SPEED"
            font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.caption
            font.bold: true
            color: Qt.darker(Color.foreground, 1.4)
          }
          Text {
            anchors.right: parent.right
            text: "Level " + root.panelRoot.speed
            font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.caption
            font.bold: true
            color: Color.accent
          }
        }

        Row {
          width: parent.width
          spacing: Style.space(4)

          Repeater {
            model: [
              { speed: 2, label: "Slow" },
              { speed: 5, label: "Mid" },
              { speed: 7, label: "Fast" },
              { speed: 9, label: "Max" }
            ]

            BorderSurface {
              width: (parent.width - (Style.space(4) * 3)) / 4
              implicitHeight: Style.space(24)
              radius: Style.space(3)
              color: (root.panelRoot.speed === modelData.speed)
                ? Qt.rgba(Color.accent.r, Color.accent.g, Color.accent.b, 0.22)
                : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
              borderSpec: Border.surfaceSpec("panels", "border", (root.panelRoot.speed === modelData.speed) ? Color.accent : Color.popups.border, 1)

              Text {
                anchors.centerIn: parent
                text: modelData.label
                font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.caption - Style.space(2)
                font.bold: root.panelRoot.speed === modelData.speed
                color: (root.panelRoot.speed === modelData.speed) ? Color.accent : Color.foreground
              }

              MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.panelRoot.setSpeed(modelData.speed)
              }
            }
          }
        }
      }
    }

    // Direction (only for Wave and Shifting)
    BorderSurface {
      visible: root.panelRoot.mode === 3 || root.panelRoot.mode === 4
      width: (parent.width - Style.space(8)) / 2
      implicitHeight: Style.space(56)
      radius: Style.cornerRadius
      color: Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
      borderSpec: Border.surfaceSpec("panels", "border", Color.popups.border, 1)

      Column {
        anchors.fill: parent
        anchors.margins: Style.space(8)
        spacing: Style.space(6)

        Text {
          text: "DIRECTION"
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.caption
          font.bold: true
          color: Qt.darker(Color.foreground, 1.4)
        }

        Row {
          width: parent.width
          spacing: Style.space(4)

          Repeater {
            model: [
              { dir: 1, label: "\uf060 R→L" },
              { dir: 2, label: "L→R \uf061" }
            ]

            BorderSurface {
              width: (parent.width - Style.space(4)) / 2
              implicitHeight: Style.space(24)
              radius: Style.space(3)
              color: (root.panelRoot.direction === modelData.dir)
                ? Qt.rgba(Color.accent.r, Color.accent.g, Color.accent.b, 0.22)
                : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
              borderSpec: Border.surfaceSpec("panels", "border", (root.panelRoot.direction === modelData.dir) ? Color.accent : Color.popups.border, 1)

              Text {
                anchors.centerIn: parent
                text: modelData.label
                font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.caption - Style.space(2)
                font.bold: root.panelRoot.direction === modelData.dir
                color: (root.panelRoot.direction === modelData.dir) ? Color.accent : Color.foreground
              }

              MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.panelRoot.setDirection(modelData.dir)
              }
            }
          }
        }
      }
    }
  }
}
