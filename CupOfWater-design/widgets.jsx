// widgets.jsx — виджеты главного экрана iOS + Android
// Размеры:
//  iOS Small  ≈ 170×170  (2x2)
//  iOS Medium ≈ 364×170  (4x2)
//  iOS Large  ≈ 364×382  (4x4)
//  Android соответственно

function WidgetShell({ w, h, dark, children, platform = "ios", onTap }) {
  const c = colors(dark);
  const radius = platform === "ios" ? 22 : 28;
  return (
    <div style={{
      width: w, height: h, borderRadius: radius, overflow: "hidden",
      background: dark ? "linear-gradient(160deg, #0E2A40, #06141F)" : "#fff",
      boxShadow: dark
        ? "0 10px 30px rgba(0,0,0,0.5), 0 1px 0 rgba(255,255,255,0.05) inset"
        : "0 10px 30px rgba(2,79,122,0.15), 0 1px 0 rgba(255,255,255,1) inset",
      position: "relative", color: dark ? "#E6EFF7" : "#0E2235",
      fontFamily: "Inter, -apple-system, system-ui",
    }}>{children}</div>
  );
}

function WidgetAddBtn({ size = 40, dark, label, ml = 250 }) {
  return (
    <div style={{
      height: size, paddingLeft: 6, paddingRight: 14,
      borderRadius: 999,
      background: "linear-gradient(180deg, var(--water-top), var(--water-bottom))",
      color: "#fff", display: "inline-flex", alignItems: "center", gap: 8,
      boxShadow: "0 4px 14px rgba(2,136,209,0.45)",
      fontSize: 13, fontWeight: 700, letterSpacing: "-0.01em",
    }}>
      <div style={{ width: size - 12, height: size - 12, borderRadius: 999, background: "rgba(255,255,255,0.22)", display: "flex", alignItems: "center", justifyContent: "center" }}>
        <Icon name="plus" size={size-22} color="#fff" stroke={2.6}/>
      </div>
      {label || `+${ml} мл`}
    </div>
  );
}

// ─────────── iOS Small (2x2)
function WidgetIOSSmall({ dark, current = 1500, goal = 2500 }) {
  const progress = current/goal;
  return (
    <WidgetShell w={170} h={170} dark={dark} platform="ios">
      <div style={{ position: "absolute", inset: 0, display: "flex", flexDirection: "column", padding: 14 }}>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <div style={{ fontSize: 11, fontWeight: 700, color: "var(--primary)", textTransform: "uppercase", letterSpacing: "0.06em" }}>Вода</div>
          <Icon name="drop" size={14} color="var(--primary)"/>
        </div>
        <div style={{ flex: 1, display: "flex", alignItems: "center", justifyContent: "center" }}>
          <CircularWater size={110} progress={progress} dark={dark} label={`${Math.round(progress*100)}%`} sublabel="" animateWave={false}/>
        </div>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <div style={{ fontSize: 11, fontWeight: 600, color: dark ? "#93A8BC" : "#5B7184" }}>{fmt(current)}/{fmt(goal)}</div>
          <div style={{
            width: 28, height: 28, borderRadius: 999,
            background: "linear-gradient(180deg, var(--water-top), var(--water-bottom))",
            display: "flex", alignItems: "center", justifyContent: "center",
            boxShadow: "0 3px 10px rgba(2,136,209,0.45)",
          }}>
            <Icon name="plus" size={16} color="#fff" stroke={2.6}/>
          </div>
        </div>
      </div>
    </WidgetShell>
  );
}

// ─────────── iOS Medium (4x2)
function WidgetIOSMedium({ dark, current = 1500, goal = 2500 }) {
  const progress = current/goal;
  return (
    <WidgetShell w={364} h={170} dark={dark} platform="ios">
      <div style={{ position: "absolute", inset: 0, display: "flex", padding: 16, gap: 14 }}>
        <div style={{ display: "flex", flexDirection: "column", justifyContent: "space-between", flex: 1 }}>
          <div>
            <div style={{ fontSize: 11, fontWeight: 700, color: "var(--primary)", textTransform: "uppercase", letterSpacing: "0.06em" }}>Сегодня</div>
            <div style={{ fontSize: 30, fontWeight: 700, letterSpacing: "-0.03em", marginTop: 2 }}>{fmt(current)} <span style={{ fontSize: 14, color: dark ? "#93A8BC" : "#5B7184", fontWeight: 500 }}>/ {fmt(goal)} мл</span></div>
            <div style={{ fontSize: 12, color: dark ? "#93A8BC" : "#5B7184", marginTop: 2 }}>{fmt(goal - current)} мл осталось</div>
          </div>
          <div style={{ display: "flex", gap: 6 }}>
            {[100, 200, 250, 500].map(ml => (
              <div key={ml} style={{
                flex: 1, padding: "8px 0", textAlign: "center", borderRadius: 11,
                background: ml === 250 ? "linear-gradient(180deg, var(--water-top), var(--water-bottom))" : (dark ? "rgba(79,195,247,0.1)" : "rgba(2,136,209,0.08)"),
                color: ml === 250 ? "#fff" : "var(--primary)",
                fontSize: 12, fontWeight: 700, letterSpacing: "-0.01em",
                boxShadow: ml === 250 ? "0 3px 8px rgba(2,136,209,0.35)" : "none",
              }}>+{ml}</div>
            ))}
          </div>
        </div>
        <div style={{ display: "flex", alignItems: "center" }}>
          <CircularWater size={130} progress={progress} dark={dark} label={`${Math.round(progress*100)}%`} sublabel="" animateWave={false}/>
        </div>
      </div>
    </WidgetShell>
  );
}

// ─────────── iOS Large (4x4)
function WidgetIOSLarge({ dark, current = 1500, goal = 2500 }) {
  const progress = current/goal;
  const week = [1.0, 0.84, 1.08, 0.76, 1.0, 0.92, progress];
  const days = ["П","В","С","Ч","П","С","В"];
  return (
    <WidgetShell w={364} h={382} dark={dark} platform="ios">
      <div style={{ position: "absolute", inset: 0, padding: 20, display: "flex", flexDirection: "column" }}>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <div>
            <div style={{ fontSize: 11, fontWeight: 700, color: "var(--primary)", textTransform: "uppercase", letterSpacing: "0.06em" }}>Сегодня</div>
            <div style={{ fontSize: 17, fontWeight: 700, marginTop: 2, letterSpacing: "-0.02em" }}>14 апреля</div>
          </div>
          <div style={{ fontSize: 12, color: "#FF8A3D", fontWeight: 700, display: "flex", gap: 4, alignItems: "center" }}>
            <Icon name="streak" size={14} color="#FF8A3D"/> 7 дней
          </div>
        </div>

        <div style={{ flex: 1, display: "flex", alignItems: "center", justifyContent: "center" }}>
          <CircularWater size={210} progress={progress} dark={dark}
            label={fmt(current)} sublabel={`из ${fmt(goal)} мл`} animateWave={false}/>
        </div>

        {/* week strip */}
        <div style={{ display: "flex", gap: 8, marginBottom: 12 }}>
          {week.map((v, i) => (
            <div key={i} style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", gap: 4 }}>
              <div style={{ width: "100%", height: 26, borderRadius: 4, background: dark ? "rgba(79,195,247,0.1)" : "rgba(2,136,209,0.08)", overflow: "hidden", display: "flex", alignItems: "flex-end" }}>
                <div style={{ width: "100%", height: `${Math.min(100, v*100)}%`, background: i === 6 ? "linear-gradient(180deg, var(--water-top), var(--water-bottom))" : (dark ? "rgba(79,195,247,0.5)" : "var(--primary)") }}/>
              </div>
              <div style={{ fontSize: 9, color: i === 6 ? "var(--primary)" : (dark ? "#93A8BC" : "#5B7184"), fontWeight: i === 6 ? 700 : 500 }}>{days[i]}</div>
            </div>
          ))}
        </div>

        {/* big add buttons */}
        <div style={{ display: "flex", gap: 8 }}>
          {[
            { ml: 200, icon: "drop" },
            { ml: 250, icon: "cup", primary: true },
            { ml: 500, icon: "bottle" },
          ].map(b => (
            <div key={b.ml} style={{
              flex: 1, height: 44, borderRadius: 14,
              background: b.primary ? "linear-gradient(180deg, var(--water-top), var(--water-bottom))" : (dark ? "rgba(79,195,247,0.1)" : "rgba(2,136,209,0.08)"),
              color: b.primary ? "#fff" : "var(--primary)",
              display: "flex", alignItems: "center", justifyContent: "center", gap: 6,
              fontSize: 13, fontWeight: 700, letterSpacing: "-0.01em",
              boxShadow: b.primary ? "0 6px 16px rgba(2,136,209,0.35)" : "none",
            }}>
              <Icon name={b.icon} size={16} color={b.primary ? "#fff" : "var(--primary)"} stroke={2}/>
              +{b.ml} мл
            </div>
          ))}
        </div>
      </div>
    </WidgetShell>
  );
}

// ─────────── Android Material You — общие
function AndroidWidgetBase({ w, h, dark, children }) {
  return (
    <div style={{
      width: w, height: h, borderRadius: 28, overflow: "hidden",
      background: dark ? "#1A2C42" : "#E1F2FB",
      boxShadow: dark ? "0 10px 30px rgba(0,0,0,0.5)" : "0 8px 24px rgba(2,79,122,0.15)",
      position: "relative", color: dark ? "#E6EFF7" : "#0E2235",
      fontFamily: "Roboto, system-ui",
    }}>
      {children}
    </div>
  );
}

// ─────────── Android 2x2
function WidgetAndroid2x2({ dark, current = 1500, goal = 2500 }) {
  const progress = current/goal;
  return (
    <AndroidWidgetBase w={170} h={170} dark={dark}>
      <div style={{ position: "absolute", inset: 0, padding: 14, display: "flex", flexDirection: "column", justifyContent: "space-between" }}>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <Icon name="drop" size={20} color="var(--primary)"/>
          <div style={{ fontSize: 26, fontWeight: 500, letterSpacing: "-0.02em" }}>{Math.round(progress*100)}<span style={{ fontSize: 14, opacity: 0.7 }}>%</span></div>
        </div>
        <div style={{ flex: 1, marginTop: 10, display: "flex", alignItems: "center" }}>
          <div style={{ width: "100%", height: 14, borderRadius: 999, background: dark ? "rgba(255,255,255,0.08)" : "rgba(2,136,209,0.12)", overflow: "hidden" }}>
            <div style={{ width: `${progress*100}%`, height: "100%", background: "linear-gradient(90deg, var(--water-top), var(--water-bottom))", borderRadius: 999 }}/>
          </div>
        </div>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", gap: 10 }}>
          <div style={{ fontSize: 13, fontWeight: 500 }}>{(current/1000).toFixed(1)}/{(goal/1000).toFixed(1)} л</div>
          <div style={{
            height: 36, padding: "0 14px", borderRadius: 18,
            background: "var(--primary)", color: "#fff", display: "flex", alignItems: "center", gap: 4,
            fontSize: 13, fontWeight: 600,
          }}>
            <Icon name="plus" size={16} color="#fff" stroke={2.4}/> 250
          </div>
        </div>
      </div>
    </AndroidWidgetBase>
  );
}

// ─────────── Android 4x2
function WidgetAndroid4x2({ dark, current = 1500, goal = 2500 }) {
  const progress = current/goal;
  return (
    <AndroidWidgetBase w={364} h={170} dark={dark}>
      <div style={{ position: "absolute", inset: 0, padding: 16, display: "flex", gap: 16 }}>
        <div style={{ flex: 1, display: "flex", flexDirection: "column", justifyContent: "space-between" }}>
          <div>
            <div style={{ fontSize: 13, fontWeight: 500, opacity: 0.7 }}>Сегодня</div>
            <div style={{ fontSize: 32, fontWeight: 500, letterSpacing: "-0.02em", marginTop: 2 }}>{(current/1000).toFixed(1)} <span style={{ fontSize: 14, opacity: 0.7 }}>/ {(goal/1000).toFixed(1)} л</span></div>
          </div>
          <div style={{ display: "flex", gap: 8 }}>
            {[150, 250, 500].map(ml => (
              <div key={ml} style={{
                flex: 1, height: 40, borderRadius: 20,
                background: ml === 250 ? "var(--primary)" : (dark ? "rgba(255,255,255,0.06)" : "rgba(255,255,255,0.6)"),
                color: ml === 250 ? "#fff" : "var(--primary)",
                display: "flex", alignItems: "center", justifyContent: "center", gap: 4,
                fontSize: 13, fontWeight: 600,
              }}>
                <Icon name="plus" size={14} color={ml === 250 ? "#fff" : "var(--primary)"} stroke={2.4}/> {ml}
              </div>
            ))}
          </div>
        </div>
        <div style={{ display: "flex", alignItems: "center" }}>
          <CircularWater size={130} progress={progress} dark={dark}
            label={`${Math.round(progress*100)}%`} sublabel="" animateWave={false}
            accent="var(--primary)" accentDeep="var(--primary-dark)"/>
        </div>
      </div>
    </AndroidWidgetBase>
  );
}

// ─────────── Android 4x4
function WidgetAndroid4x4({ dark, current = 1500, goal = 2500 }) {
  const progress = current/goal;
  const week = [1.0, 0.84, 1.08, 0.76, 1.0, 0.92, progress];
  const days = ["П","В","С","Ч","П","С","В"];
  return (
    <AndroidWidgetBase w={364} h={382} dark={dark}>
      <div style={{ position: "absolute", inset: 0, padding: 22, display: "flex", flexDirection: "column" }}>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 8 }}>
          <div>
            <div style={{ fontSize: 13, fontWeight: 500, opacity: 0.7 }}>CupOfWater</div>
            <div style={{ fontSize: 18, fontWeight: 500, marginTop: 2, letterSpacing: "-0.02em" }}>14 апреля</div>
          </div>
          <div style={{ display: "flex", gap: 4, alignItems: "center", padding: "6px 10px", borderRadius: 999, background: dark ? "rgba(255,138,61,0.15)" : "rgba(255,138,61,0.12)" }}>
            <Icon name="streak" size={14} color="#FF8A3D"/>
            <span style={{ fontSize: 12, fontWeight: 700, color: "#FF8A3D" }}>7</span>
          </div>
        </div>

        <div style={{ flex: 1, display: "flex", alignItems: "center", justifyContent: "center" }}>
          <CircularWater size={210} progress={progress} dark={dark}
            label={fmt(current)} sublabel={`из ${fmt(goal)} мл`} animateWave={false}
            accent="var(--primary)" accentDeep="var(--primary-dark)"/>
        </div>

        <div style={{ display: "flex", gap: 6, marginBottom: 14 }}>
          {week.map((v, i) => (
            <div key={i} style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", gap: 4 }}>
              <div style={{ width: "100%", height: 24, borderRadius: 6, background: dark ? "rgba(255,255,255,0.06)" : "rgba(255,255,255,0.6)", overflow: "hidden", display: "flex", alignItems: "flex-end" }}>
                <div style={{ width: "100%", height: `${Math.min(100, v*100)}%`, background: i === 6 ? "var(--primary)" : (dark ? "rgba(79,195,247,0.5)" : "rgba(2,136,209,0.5)") }}/>
              </div>
              <div style={{ fontSize: 10, fontWeight: i === 6 ? 700 : 500, opacity: i === 6 ? 1 : 0.6 }}>{days[i]}</div>
            </div>
          ))}
        </div>

        <div style={{ display: "flex", gap: 8 }}>
          {[
            { ml: 200, icon: "drop" },
            { ml: 250, icon: "cup", primary: true },
            { ml: 500, icon: "bottle" },
          ].map(b => (
            <div key={b.ml} style={{
              flex: 1, height: 48, borderRadius: 24,
              background: b.primary ? "var(--primary)" : (dark ? "rgba(255,255,255,0.06)" : "rgba(255,255,255,0.6)"),
              color: b.primary ? "#fff" : "var(--primary)",
              display: "flex", alignItems: "center", justifyContent: "center", gap: 6,
              fontSize: 13, fontWeight: 600,
            }}>
              <Icon name={b.icon} size={18} color={b.primary ? "#fff" : "var(--primary)"} stroke={2}/>
              +{b.ml} мл
            </div>
          ))}
        </div>
      </div>
    </AndroidWidgetBase>
  );
}

Object.assign(window, {
  WidgetIOSSmall, WidgetIOSMedium, WidgetIOSLarge,
  WidgetAndroid2x2, WidgetAndroid4x2, WidgetAndroid4x4,
  WidgetShell, WidgetAddBtn, AndroidWidgetBase,
});
