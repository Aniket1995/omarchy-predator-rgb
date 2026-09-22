.pragma library

// RgbModel.js: State helpers and color logic for Predator RGB Keyboard Plugin

function rgbToHex(r, g, b) {
  var rh = Math.max(0, Math.min(255, Math.round(r))).toString(16).padStart(2, '0');
  var gh = Math.max(0, Math.min(255, Math.round(g))).toString(16).padStart(2, '0');
  var bh = Math.max(0, Math.min(255, Math.round(b))).toString(16).padStart(2, '0');
  return "#" + rh + gh + bh;
}

function hexToRgb(hex) {
  var clean = hex.replace("#", "");
  if (clean.length === 3) {
    clean = clean[0] + clean[0] + clean[1] + clean[1] + clean[2] + clean[2];
  }
  var num = parseInt(clean, 16);
  if (isNaN(num)) return [0, 229, 255];
  return [
    (num >> 16) & 255,
    (num >> 8) & 255,
    num & 255
  ];
}

function modeName(mode) {
  switch (Number(mode)) {
    case 0: return "Static (4-Zone)";
    case 1: return "Breathing";
    case 2: return "Neon Spectrum";
    case 3: return "Rainbow Wave";
    case 4: return "Color Shifting";
    case 5: return "Zoom Pulse";
    default: return "Unknown";
  }
}

function modeIcon(mode) {
  switch (Number(mode)) {
    case 0: return "\uf00a"; // 4 blocks / grid
    case 1: return "\uf043"; // pulse/drop
    case 2: return "\uf53f"; // palette / rainbow
    case 3: return "\uf0c9"; // wave lines
    case 4: return "\uf061"; // right shift arrow
    case 5: return "\uf065"; // zoom/expand
    default: return "\uf11c";
  }
}

function presetColors() {
  return [
    { name: "Predator Cyan", hex: "#00e5ff", rgb: [0, 229, 255] },
    { name: "Predator Red", hex: "#ff2a44", rgb: [255, 42, 68] },
    { name: "Ice Blue", hex: "#0077ff", rgb: [0, 119, 255] },
    { name: "Neon Purple", hex: "#a855f7", rgb: [168, 85, 247] },
    { name: "Acid Green", hex: "#10b981", rgb: [16, 185, 129] },
    { name: "Solar Orange", hex: "#f97316", rgb: [249, 115, 22] },
    { name: "Golden Amber", hex: "#eab308", rgb: [234, 179, 8] },
    { name: "Pure White", hex: "#ffffff", rgb: [255, 255, 255] }
  ];
}
