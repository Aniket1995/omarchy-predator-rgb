import QtQuick
import qs.Commons
import qs.Ui

Column {
  id: root
  required property var panelRoot

  width: parent ? parent.width : Style.space(370)
  spacing: Style.space(6)

  PanelSectionHeader {
    text: "QUICK PRESETS"
  }

  Row {
    width: parent.width
    spacing: Style.space(6)

    Repeater {
      model: [
        { id: "predator", label: "Predator Cyan", color: "#00e5ff" },
        { id: "neon", label: "Neon", color: "#a855f7" },
        { id: "wave", label: "Wave", color: "#0077ff" },
        { id: "turbo", label: "Turbo Red", color: "#ff2a44" }
      ]

      BorderSurface {
        width: (parent.width - (Style.space(6) * 3)) / 4
        implicitHeight: Style.space(32)
        radius: Style.cornerRadius
        color: presetMouse.containsMouse ? Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.08) : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
        borderSpec: Border.surfaceSpec("panels", "border", Color.popups.border, 1)

        Row {
          anchors.centerIn: parent
          spacing: Style.space(4)

          Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: Style.space(8)
            height: Style.space(8)
            radius: width / 2
            color: modelData.color
          }

          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: modelData.label
            font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.caption - Style.space(2)
            color: root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground
          }
        }

        MouseArea {
          id: presetMouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: root.panelRoot.applyPreset(modelData.id)
        }
      }
    }
  }
}
