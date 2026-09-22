import QtQuick
import qs.Commons
import qs.Ui
import "RgbModel.js" as RgbModel

Column {
  id: root
  required property var panelRoot

  width: parent ? parent.width : Style.space(370)
  spacing: Style.space(8)

  PanelSectionHeader {
    text: root.panelRoot.mode === 0 ? "ZONE COLOR CONFIGURATION" : "EFFECT COLOR"
  }

  // Zone Selector Pills (only in Static mode)
  Row {
    visible: root.panelRoot.mode === 0
    width: parent.width
    spacing: Style.space(4)

    Repeater {
      model: [
        { id: 1, label: "Z1 (WASD)" },
        { id: 2, label: "Z2" },
        { id: 3, label: "Z3" },
        { id: 4, label: "Z4 (NUM)" },
        { id: 0, label: "ALL" }
      ]

      BorderSurface {
        width: (parent.width - Style.space(16)) / 5
        implicitHeight: Style.space(28)
        radius: Style.cornerRadius
        color: (root.panelRoot.selectedZone === modelData.id)
          ? Qt.rgba(Color.accent.r, Color.accent.g, Color.accent.b, 0.2)
          : (zoneMouse.containsMouse ? Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.08) : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04))
        borderSpec: Border.surfaceSpec("panels", "border", (root.panelRoot.selectedZone === modelData.id) ? Color.accent : Color.popups.border, 1)

        Text {
          anchors.centerIn: parent
          text: modelData.label
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.caption - Style.space(2)
          font.bold: root.panelRoot.selectedZone === modelData.id
          color: (root.panelRoot.selectedZone === modelData.id) ? Color.accent : (root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground)
        }

        MouseArea {
          id: zoneMouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: root.panelRoot.selectedZone = modelData.id
        }
      }
    }
  }

  // Notice for rainbow modes
  BorderSurface {
    visible: root.panelRoot.mode === 2 || root.panelRoot.mode === 3
    width: parent.width
    implicitHeight: Style.space(34)
    radius: Style.cornerRadius
    color: Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.03)
    borderSpec: Border.surfaceSpec("panels", "border", Color.popups.border, 1)

    Text {
      anchors.centerIn: parent
      text: root.panelRoot.mode === 3 ? "Rainbow Wave flows automatically across all 4 zones" : "Neon spectrum cycles automatically through all colors"
      font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
      font.pixelSize: Style.font.caption - Style.space(1)
      color: Qt.darker(Color.foreground, 1.4)
    }
  }

  // Color Swatches Palette (for Static, Breathing, Shifting, Zoom)
  Row {
    visible: root.panelRoot.mode === 0 || root.panelRoot.mode === 1 || root.panelRoot.mode === 4 || root.panelRoot.mode === 5
    width: parent.width
    spacing: Style.space(6)

    Repeater {
      model: RgbModel.presetColors()

      Rectangle {
        id: swatch
        width: (parent.width - (Style.space(6) * 7)) / 8
        height: Style.space(28)
        radius: Style.space(4)
        color: modelData.hex

        border.width: 1
        border.color: swatchMouse.containsMouse ? "#ffffff" : Qt.rgba(0, 0, 0, 0.4)

        MouseArea {
          id: swatchMouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (root.panelRoot.mode === 0) {
              if (root.panelRoot.selectedZone === 0) {
                root.panelRoot.setAllZonesColor(modelData.rgb[0], modelData.rgb[1], modelData.rgb[2]);
              } else {
                root.panelRoot.setZoneColor(root.panelRoot.selectedZone, modelData.rgb[0], modelData.rgb[1], modelData.rgb[2]);
              }
            } else {
              root.panelRoot.setColor(modelData.rgb[0], modelData.rgb[1], modelData.rgb[2]);
            }
          }
        }
      }
    }
  }
}
