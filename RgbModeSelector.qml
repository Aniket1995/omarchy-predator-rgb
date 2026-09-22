import QtQuick
import qs.Commons
import qs.Ui
import "RgbModel.js" as RgbModel

Column {
  id: root
  required property var panelRoot

  width: parent ? parent.width : Style.space(370)
  spacing: Style.space(6)

  PanelSectionHeader {
    text: "LIGHTING MODES"
  }

  Grid {
    width: parent.width
    columns: 3
    spacing: Style.space(6)

    Repeater {
      model: [
        { mode: 0, label: "Static 4-Zone", icon: "\uf00a" },
        { mode: 1, label: "Breathing", icon: "\uf043" },
        { mode: 2, label: "Neon Spectrum", icon: "\uf53f" },
        { mode: 3, label: "Rainbow Wave", icon: "\uf0c9" },
        { mode: 4, label: "Color Shifting", icon: "\uf061" },
        { mode: 5, label: "Zoom Pulse", icon: "\uf065" }
      ]

      BorderSurface {
        id: modeBtn
        width: (parent.width - Style.space(12)) / 3
        implicitHeight: Style.space(42)
        radius: Style.cornerRadius
        color: (root.panelRoot.mode === modelData.mode)
          ? Qt.rgba(Color.accent.r, Color.accent.g, Color.accent.b, 0.16)
          : (btnMouse.containsMouse ? Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.08) : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04))
        borderSpec: Border.surfaceSpec("panels", "border", (root.panelRoot.mode === modelData.mode) ? Color.accent : Color.popups.border, 1)

        Row {
          anchors.centerIn: parent
          spacing: Style.space(6)

          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: modelData.icon
            font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.caption
            color: (root.panelRoot.mode === modelData.mode) ? Color.accent : Qt.darker(Color.foreground, 1.4)
          }

          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: modelData.label
            font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.caption - Style.space(1)
            font.bold: root.panelRoot.mode === modelData.mode
            color: (root.panelRoot.mode === modelData.mode) ? Color.accent : (root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground)
          }
        }

        MouseArea {
          id: btnMouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: root.panelRoot.setMode(modelData.mode)
        }
      }
    }
  }
}
