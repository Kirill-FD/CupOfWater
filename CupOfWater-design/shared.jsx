// shared.jsx — иконки, круговой прогресс с волной, общие компоненты CupOfWater

// ─────────────────────────────────────────────────────────────
// Icons (минимальный stroke-набор, 24x24)
// ─────────────────────────────────────────────────────────────
const Icon = ({ name, size = 24, color = "currentColor", stroke = 1.8 }) => {
  const p = { fill: "none", stroke: color, strokeWidth: stroke, strokeLinecap: "round", strokeLinejoin: "round" };
  const paths = {
    drop: <path d="M12 3c4 5 6 8 6 11a6 6 0 1 1-12 0c0-3 2-6 6-11z" {...p} />,
    plus: <g {...p}><path d="M12 5v14"/><path d="M5 12h14"/></g>,
    minus: <path d="M5 12h14" {...p}/>,
    chart: <g {...p}><path d="M4 20V10"/><path d="M10 20V4"/><path d="M16 20v-6"/><path d="M22 20H2"/></g>,
    history: <g {...p}><path d="M12 8v4l3 2"/><circle cx="12" cy="12" r="9"/></g>,
    bell: <g {...p}><path d="M6 8a6 6 0 1 1 12 0c0 7 3 8 3 8H3s3-1 3-8z"/><path d="M10 21a2 2 0 0 0 4 0"/></g>,
    settings: <g {...p}><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1.1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1.1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1z"/></g>,
    user: <g {...p}><circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/></g>,
    chevron: <path d="M9 6l6 6-6 6" {...p}/>,
    chevronDown: <path d="M6 9l6 6 6-6" {...p}/>,
    check: <path d="M5 12l5 5L20 7" {...p}/>,
    close: <g {...p}><path d="M6 6l12 12"/><path d="M18 6L6 18"/></g>,
    flame: <path d="M12 3c1 4 5 5 5 10a5 5 0 1 1-10 0c0-2 1-3 2-4 0 2 1 3 2 3 0-3 0-6 1-9z" {...p}/>,
    cup: <g {...p}><path d="M6 6h12l-1 14a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2L6 6z"/><path d="M6 11h12"/></g>,
    bottle: <g {...p}><path d="M10 2h4v3a4 4 0 0 1 2 3v11a2 2 0 0 1-2 2h-4a2 2 0 0 1-2-2V8a4 4 0 0 1 2-3V2z"/><path d="M9 14h6"/></g>,
    arrow: <g {...p}><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></g>,
    back: <g {...p}><path d="M19 12H5"/><path d="M11 6l-6 6 6 6"/></g>,
    moon: <path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z" {...p}/>,
    sun: <g {...p}><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M2 12h2M20 12h2M5 5l1.5 1.5M17.5 17.5L19 19M5 19l1.5-1.5M17.5 6.5L19 5"/></g>,
    coffee: <g {...p}><path d="M3 8h14v8a4 4 0 0 1-4 4H7a4 4 0 0 1-4-4V8z"/><path d="M17 11h2a2 2 0 0 1 0 4h-2"/><path d="M7 4v2M11 4v2"/></g>,
    leaf: <g {...p}><path d="M21 3c-7 0-14 5-14 13a5 5 0 0 0 5 5c8 0 9-7 9-18z"/><path d="M7 21l7-9"/></g>,
    edit: <g {...p}><path d="M14 4l6 6L9 21H3v-6z"/></g>,
    trash: <g {...p}><path d="M4 7h16"/><path d="M10 11v6M14 11v6"/><path d="M5 7l1 13a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2l1-13"/><path d="M9 7V4h6v3"/></g>,
    target: <g {...p}><circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="5"/><circle cx="12" cy="12" r="1.5"/></g>,
    streak: <path d="M13 3l-1 8h5l-7 10 1-8H6l7-10z" {...p}/>,
  };
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" style={{ display: "block" }}>
      {paths[name]}
    </svg>
  );
};

// ─────────────────────────────────────────────────────────────
// CircularWaterProgress — главный визуал
// ─────────────────────────────────────────────────────────────
function CircularWater({ size = 260, progress = 0.6, dark = false, accent, accentDeep, label, sublabel, animateWave = true }) {
  const a = accent || (dark ? "#4FC3F7" : "#0288D1");
  const aDeep = accentDeep || (dark ? "#0288D1" : "#01579B");
  const aLight = dark ? "#81D4FA" : "#4FC3F7";
  const stroke = 14;
  const r = (size - stroke) / 2;
  const c = 2 * Math.PI * r;
  const cx = size / 2, cy = size / 2;
  const fillId = `wfill-${size}-${dark ? "d" : "l"}`;
  const wgradId = `wgrad-${size}-${dark ? "d" : "l"}`;
  const innerR = r - stroke / 2 - 4;
  // wave geometry
  const waveLevel = cy + innerR - innerR * 2 * progress;
  return (
    <div style={{ width: size, height: size, position: "relative" }}>
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`} style={{ position: "absolute", inset: 0 }}>
        <defs>
          <linearGradient id={wgradId} x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor={aLight}/>
            <stop offset="100%" stopColor={a}/>
          </linearGradient>
          <clipPath id={fillId}>
            <circle cx={cx} cy={cy} r={innerR}/>
          </clipPath>
        </defs>
        {/* track */}
        <circle cx={cx} cy={cy} r={r} fill="none"
          stroke={dark ? "rgba(255,255,255,0.08)" : "rgba(2,136,209,0.12)"} strokeWidth={stroke}/>
        {/* water inside */}
        <g clipPath={`url(#${fillId})`}>
          <rect x="0" y={waveLevel} width={size} height={size} fill={`url(#${wgradId})`}/>
          {/* waves */}
          <g style={animateWave ? { animation: "cw-wave 4s linear infinite" } : {}}>
            <path d={`M ${-size} ${waveLevel}
              q ${size/4} -10 ${size/2} 0
              t ${size/2} 0
              t ${size/2} 0
              t ${size/2} 0
              V ${size} H ${-size} Z`}
              fill={`url(#${wgradId})`} opacity="0.85"/>
          </g>
          <g style={animateWave ? { animation: "cw-wave2 6s linear infinite" } : {}}>
            <path d={`M ${-size} ${waveLevel + 4}
              q ${size/4} 8 ${size/2} 0
              t ${size/2} 0
              t ${size/2} 0
              t ${size/2} 0
              V ${size} H ${-size} Z`}
              fill={aDeep} opacity="0.45"/>
          </g>
          {/* shine */}
          <ellipse cx={cx - innerR*0.4} cy={waveLevel + 16} rx={innerR*0.3} ry="3" fill="rgba(255,255,255,0.4)"/>
        </g>
        {/* progress arc */}
        <circle cx={cx} cy={cy} r={r} fill="none"
          stroke={a} strokeWidth={stroke} strokeLinecap="round"
          strokeDasharray={c} strokeDashoffset={c * (1 - progress)}
          transform={`rotate(-90 ${cx} ${cy})`}
          style={{ transition: "stroke-dashoffset 0.8s cubic-bezier(.4,0,.2,1)" }}/>
        {/* glass rim */}
        <circle cx={cx} cy={cy} r={innerR} fill="none"
          stroke={dark ? "rgba(255,255,255,0.06)" : "rgba(255,255,255,0.6)"} strokeWidth="1"/>
      </svg>
      <div style={{
        position: "absolute", inset: 0, display: "flex", flexDirection: "column",
        alignItems: "center", justifyContent: "center", color: dark ? "#fff" : "#0E2235",
        textShadow: progress > 0.4 ? "0 1px 8px rgba(0,0,0,0.18)" : "none",
        pointerEvents: "none",
      }}>
        <div style={{ fontSize: size*0.18, fontWeight: 700, letterSpacing: "-0.02em", lineHeight: 1 }}>
          {label}
        </div>
        {sublabel && (
          <div style={{ fontSize: size*0.055, marginTop: 6, opacity: 0.75, fontWeight: 500 }}>
            {sublabel}
          </div>
        )}
      </div>
    </div>
  );
}

// CSS for waves — injected once
if (typeof document !== "undefined" && !document.getElementById("cw-anim")) {
  const s = document.createElement("style");
  s.id = "cw-anim";
  s.textContent = `
@keyframes cw-wave { 0% { transform: translateX(0); } 100% { transform: translateX(50%); } }
@keyframes cw-wave2 { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }
@keyframes cw-pulse { 0%,100% { transform: scale(1); } 50% { transform: scale(1.05); } }
@keyframes cw-rise { from { transform: translateY(8px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
.cw-slider::-webkit-slider-thumb { -webkit-appearance: none; appearance: none; width: 18px; height: 18px; border-radius: 50%; background: #fff; border: 2px solid var(--primary); box-shadow: 0 2px 6px rgba(2,136,209,0.4); cursor: pointer; }
.cw-slider::-moz-range-thumb { width: 18px; height: 18px; border-radius: 50%; background: #fff; border: 2px solid var(--primary); box-shadow: 0 2px 6px rgba(2,136,209,0.4); cursor: pointer; }
`;
  document.head.appendChild(s);
}

// ─────────────────────────────────────────────────────────────
// Mini bar — used in widgets / weekly stats
// ─────────────────────────────────────────────────────────────
function MiniBars({ values, max, height = 50, color = "#0288D1", trackColor, gap = 4, radius = 3, todayIndex }) {
  const tc = trackColor || "rgba(2,136,209,0.12)";
  return (
    <div style={{ display: "flex", alignItems: "flex-end", gap, height, width: "100%" }}>
      {values.map((v, i) => {
        const h = Math.max(2, (v / max) * height);
        const isToday = i === todayIndex;
        return (
          <div key={i} style={{ flex: 1, height, position: "relative", display: "flex", alignItems: "flex-end" }}>
            <div style={{ position: "absolute", inset: 0, background: tc, borderRadius: radius }}/>
            <div style={{
              position: "relative", width: "100%", height: h,
              background: isToday ? color : color,
              opacity: isToday ? 1 : 0.55,
              borderRadius: radius,
            }}/>
          </div>
        );
      })}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Quick volume chip
// ─────────────────────────────────────────────────────────────
function VolumeChip({ ml, icon, active, onClick, dark }) {
  const bg = active
    ? "linear-gradient(180deg, var(--water-top), var(--water-bottom))"
    : (dark ? "rgba(255,255,255,0.06)" : "var(--surface)");
  const color = active ? "#fff" : "var(--on-surface)";
  return (
    <button onClick={onClick} style={{
      flex: 1, minWidth: 0, padding: "12px 8px",
      background: bg, color,
      border: active ? "none" : `1px solid var(--divider)`,
      borderRadius: 18,
      display: "flex", flexDirection: "column", alignItems: "center", gap: 6,
      cursor: "pointer", boxShadow: active ? "var(--shadow-sm)" : "none",
      transition: "all .2s",
    }}>
      <Icon name={icon || "drop"} size={22} color={color}/>
      <span style={{ fontSize: 13, fontWeight: 600 }}>{ml} мл</span>
    </button>
  );
}

Object.assign(window, { Icon, CircularWater, MiniBars, VolumeChip });
