import QtQuick
import qs.Commons
import qs.Ui
import "RgbModel.js" as RgbModel

Item {
  id: root
  required property var panelRoot

  width: parent ? parent.width : Style.space(370)
  implicitHeight: heroColumn.implicitHeight

  Column {
    id: heroColumn
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: Style.space(8)

    // 1. Predator 4-Zone RGB Emblem
    Image {
      id: bigLogo
      anchors.horizontalCenter: parent.horizontalCenter
      width: Style.space(72)
      height: Style.space(72)
      source: Qt.resolvedUrl("assets/predator_rgb_logo_badge.png")
      fillMode: Image.PreserveAspectFit
      smooth: true
      mipmap: true
      opacity: root.panelRoot.power ? 1.0 : 0.45

      Behavior on opacity {
        NumberAnimation { duration: 200 }
      }
    }

    // 2. Predator High-Resolution Wordmark
    Image {
      id: predatorWordmark
      anchors.horizontalCenter: parent.horizontalCenter
      width: Style.space(136)
      height: Style.space(20)
      source: Qt.resolvedUrl("assets/predator_text_highres.png")
      fillMode: Image.PreserveAspectFit
      smooth: true
      mipmap: true
      opacity: root.panelRoot.power ? 1.0 : 0.5

      Behavior on opacity {
        NumberAnimation { duration: 200 }
      }
    }

    // 3. Dynamic Profile & Effect Status Subtitle
    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      text: root.panelRoot.power
        ? (RgbModel.modeName(root.panelRoot.mode).toUpperCase() + " • " + (root.panelRoot.mode === 0 ? "4-ZONE STATIC" : "SPECTRUM FX"))
        : "BACKLIGHT INACTIVE • HARDWARE SLEEP"
      font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
      font.pixelSize: Style.font.caption
      font.bold: true
      color: root.panelRoot.power ? Color.accent : Qt.darker(Color.foreground, 1.8)
      opacity: 0.95

      Behavior on color {
        ColorAnimation { duration: 200 }
      }
    }
  }
}
