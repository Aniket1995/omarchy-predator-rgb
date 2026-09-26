import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "RgbModel.js" as RgbModel

Panel {
  id: root
  moduleName: "local.predator-rgb"
  ipcTarget: "local.predator-rgb"

  // Critical for Bar layout: provides slot dimensions to Bar.qml
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  // RGB State
  property bool power: true
  property int mode: 3 // 0=Static, 1=Breath, 2=Neon, 3=Wave, 4=Shifting, 5=Zoom
  property int speed: 5
  property int brightness: 100
  property int direction: 1
  property color activeColor: "#00e5ff"
  property int selectedZone: 1 // 1..4 or 0 for All
  property var zoneColors: ({ "1": "#00e5ff", "2": "#00e5ff", "3": "#00e5ff", "4": "#00e5ff" })

  readonly property string ctlScript: Qt.resolvedUrl("bin/predator-rgb-ctl").toString().replace(/^file:\/\//, "")

  function getZoneColor(z) {
    var key = String(z);
    return (zoneColors && zoneColors[key]) ? zoneColors[key] : activeColor;
  }

  function handleStatus(rawText) {
    try {
      if (!rawText || rawText.trim() === "") return;
      var data = JSON.parse(rawText);
      root.power = data.power !== false;
      root.mode = Number(data.mode) || 0;
      root.speed = Number(data.speed) || 5;
      root.brightness = Number(data.brightness) || 100;
      root.direction = Number(data.direction) || 1;
      if (data.color && data.color.length === 3) {
        root.activeColor = RgbModel.rgbToHex(data.color[0], data.color[1], data.color[2]);
      }
      if (data.zones) {
        var zc = {};
        for (var i = 1; i <= 4; i++) {
          var k = String(i);
          if (data.zones[k] && data.zones[k].length === 3) {
            zc[k] = RgbModel.rgbToHex(data.zones[k][0], data.zones[k][1], data.zones[k][2]);
          } else {
            zc[k] = root.activeColor;
          }
        }
        root.zoneColors = zc;
      }
    } catch (e) {}
  }

  function fetchStatus() {
    if (!statusProc.running) statusProc.running = true;
  }

  function togglePower() {
    root.power = !root.power;
    Util.execDetached(ctlScript + " --toggle-power");
    statusTimer.restart();
  }

  function setMode(m) {
    root.mode = m;
    Util.execDetached(ctlScript + " --set-mode " + m);
    statusTimer.restart();
  }

  function setBrightness(b) {
    root.brightness = b;
    if (b > 0) root.power = true;
    Util.execDetached(ctlScript + " --set-brightness " + b);
    statusTimer.restart();
  }

  function setSpeed(s) {
    root.speed = s;
    Util.execDetached(ctlScript + " --set-speed " + s);
    statusTimer.restart();
  }

  function setDirection(d) {
    root.direction = d;
    Util.execDetached(ctlScript + " --set-direction " + d);
    statusTimer.restart();
  }

  function setColor(r, g, b) {
    root.activeColor = RgbModel.rgbToHex(r, g, b);
    Util.execDetached(ctlScript + " --set-color " + r + " " + g + " " + b);
    statusTimer.restart();
  }

  function setZoneColor(z, r, g, b) {
    var hex = RgbModel.rgbToHex(r, g, b);
    var updated = Object.assign({}, root.zoneColors);
    updated[String(z)] = hex;
    root.zoneColors = updated;
    root.mode = 0;
    Util.execDetached(ctlScript + " --set-zone " + z + " " + r + " " + g + " " + b);
    statusTimer.restart();
  }

  function setAllZonesColor(r, g, b) {
    var hex = RgbModel.rgbToHex(r, g, b);
    root.activeColor = hex;
    root.zoneColors = { "1": hex, "2": hex, "3": hex, "4": hex };
    root.mode = 0;
    Util.execDetached(ctlScript + " --set-all-zones " + r + " " + g + " " + b);
    statusTimer.restart();
  }

  function applyPreset(p) {
    Util.execDetached(ctlScript + " --preset " + p);
    statusTimer.restart();
  }

  Process {
    id: statusProc
    command: [root.ctlScript, "--status"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.handleStatus(text)
    }
  }

  Timer {
    id: statusTimer
    interval: 350
    running: false
    repeat: false
    onTriggered: root.fetchStatus()
  }

  Timer {
    id: pollTimer
    interval: 1500
    running: root.opened
    repeat: true
    triggeredOnStart: true
    onTriggered: root.fetchStatus()
  }

  Component.onCompleted: root.fetchStatus()
  onOpenedChanged: { if (root.opened) root.fetchStatus(); }

  // ---------- Status Bar Button ----------
  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    slotSize: Style.bar.iconSlot
    tooltipText: root.power ? ("Predator RGB: " + RgbModel.modeName(root.mode)) : "Predator RGB: Off"

    iconComponent: Component {
      Item {
        anchors.fill: parent

        Image {
          id: barLogo
          anchors.centerIn: parent
          width: Style.space(16)
          height: Style.space(16)
          source: Qt.resolvedUrl("assets/predator_rgb_bar_24.png")
          fillMode: Image.PreserveAspectFit
          smooth: true
          mipmap: true
          opacity: root.power ? 1.0 : 0.35
        }

        // Active color indicator dot
        Rectangle {
          visible: root.power
          anchors.bottom: parent.bottom
          anchors.horizontalCenter: parent.horizontalCenter
          width: Style.space(6)
          height: Style.space(2)
          radius: 1
          color: (root.mode === 2 || root.mode === 3) ? Color.accent : root.activeColor
        }
      }
    }

    onPressed: function(b) {
      if (b === Qt.RightButton) {
        root.togglePower()
      } else {
        root.toggle()
      }
    }
  }

  // ---------- Popup Panel ----------
  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(370))
    contentHeight: panel.fittedContentHeight(contentColumn.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: contentColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: Style.space(12)

        // 1. Popup Hero Title & 4-Zone Logo
        RgbHero {
          panelRoot: root
        }

        PanelSeparator { width: parent.width }

        // 2. Interactive 4-Zone Visualizer
        RgbVisualizer {
          panelRoot: root
        }

        PanelSeparator { width: parent.width }

        // 3. Lighting Mode Selector
        RgbModeSelector {
          panelRoot: root
        }

        PanelSeparator { width: parent.width }

        // 4. Zone Colors / Swatches
        RgbZoneColors {
          panelRoot: root
        }

        PanelSeparator { width: parent.width }

        // 5. Brightness, Speed, Direction & Power
        RgbControlsCard {
          panelRoot: root
        }

        PanelSeparator { width: parent.width }

        // 6. Quick Presets
        RgbPresetsCard {
          panelRoot: root
        }
      }
    }
  }
}
