import QtQuick
import qs.Commons
import qs.Ui
import "RgbModel.js" as RgbModel

BorderSurface {
  id: root
  required property var panelRoot

  width: parent ? parent.width : Style.space(370)
  implicitHeight: Style.space(72)
  radius: Style.cornerRadius
  color: Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
  borderSpec: Border.surfaceSpec("panels", "border", Color.popups.border, 1)

  Column {
    anchors.fill: parent
    anchors.margins: Style.space(8)
    spacing: Style.space(6)

    // Header label
    Item {
      width: parent.width
      height: Style.space(16)

      Text {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text: "4-ZONE KEYBOARD PREVIEW"
        font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
        font.pixelSize: Style.font.caption - Style.space(2)
        font.bold: true
        color: Qt.darker(root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground, 1.5)
      }

      Text {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: root.panelRoot.power ? (root.panelRoot.mode === 0 ? "Click zone to pick color" : RgbModel.modeName(root.panelRoot.mode)) : "LIGHTING OFF"
        font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
        font.pixelSize: Style.font.caption - Style.space(2)
        color: root.panelRoot.power ? Color.accent : Qt.darker(Color.foreground, 1.8)
      }
    }

    // 4 Keyboard Zones Row
    Row {
      width: parent.width
      height: Style.space(38)
      spacing: Style.space(6)

      Repeater {
        model: [
          { id: 1, label: "WASD", keys: "\uf11c 1" },
          { id: 2, label: "MID-L", keys: "2" },
          { id: 3, label: "MID-R", keys: "3" },
          { id: 4, label: "NUMPAD", keys: "4" }
        ]

        Rectangle {
          id: zoneRect
          width: (parent.width - Style.space(18)) / 4
          height: parent.height
          radius: Style.space(4)

          // Color calculation
          property color zoneColor: {
            if (!root.panelRoot.power) return "#1e2229";
            if (root.panelRoot.mode === 0) {
              return root.panelRoot.getZoneColor(modelData.id);
            }
            if (root.panelRoot.mode === 2 || root.panelRoot.mode === 3) {
              // Wave / Neon simulation
              var hues = [0.0, 0.25, 0.5, 0.75];
              return Qt.hsla((hues[index] + waveAnim.waveOffset) % 1.0, 0.9, 0.55, 1.0);
            }
            // Dynamic color for Breath / Shift / Zoom
            return root.panelRoot.activeColor;
          }

          color: Qt.rgba(zoneColor.r, zoneColor.g, zoneColor.b, 0.18)
          border.width: (root.panelRoot.mode === 0 && root.panelRoot.selectedZone === modelData.id) ? 2 : 1
          border.color: (root.panelRoot.mode === 0 && root.panelRoot.selectedZone === modelData.id)
            ? Color.accent
            : Qt.rgba(zoneColor.r, zoneColor.g, zoneColor.b, 0.5)

          Column {
            anchors.centerIn: parent
            spacing: Style.space(2)

            Text {
              anchors.horizontalCenter: parent.horizontalCenter
              text: modelData.label
              font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
              font.pixelSize: Style.font.caption - Style.space(2)
              font.bold: true
              color: root.panelRoot.power ? zoneRect.zoneColor : Qt.darker(Color.foreground, 2.0)
            }

            Rectangle {
              anchors.horizontalCenter: parent.horizontalCenter
              width: Style.space(16)
              height: Style.space(3)
              radius: 1.5
              color: root.panelRoot.power ? zoneRect.zoneColor : Qt.darker(Color.foreground, 2.0)
            }
          }

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              if (root.panelRoot.mode !== 0) {
                root.panelRoot.setMode(0);
              }
              root.panelRoot.selectedZone = modelData.id;
            }
          }
        }
      }
    }
  }

  // Wave simulation ticker
  Item {
    id: waveAnim
    property real waveOffset: 0.0

    NumberAnimation on waveOffset {
      running: root.panelRoot.power && (root.panelRoot.mode === 2 || root.panelRoot.mode === 3)
      loops: Animation.Infinite
      from: 0.0
      to: 1.0
      duration: Math.max(1200, 3200 - (root.panelRoot.speed * 280))
    }
  }
}
