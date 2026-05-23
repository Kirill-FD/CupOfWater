// screens.jsx — все экраны CupOfWater (платформо-агностичные React-компоненты)
// Каждый экран принимает { dark, accent, ...data } и рендерит контент.
// Экраны не включают device chrome (status bar, nav bar) — это даёт frame.

const PHONE_W = 402;          // iOS frame inner width
const ANDROID_W = 412;        // Android frame inner width

// Helpers
const fmt = (n) => n.toLocaleString("ru-RU");
const colors = (dark) => ({
  bg: dark ? "#0A1929" : "#F5F9FF",
  surface: dark ? "#142436" : "#FFFFFF",
  surface2: dark ? "#1A2C42" : "#EAF3FB",
  text: dark ? "#E6EFF7" : "#0E2235",
  muted: dark ? "#93A8BC" : "#5B7184",
  faint: dark ? "#5E7286" : "#93A4B6",
  divider: dark ? "rgba(255,255,255,0.08)" : "rgba(14,34,53,0.08)",
});

// ─────────────────────────────────────────────────────────────
// Card primitive
// ─────────────────────────────────────────────────────────────
function Card({ children, dark, padding = 16, style = {}, onClick }) {
  const c = colors(dark);
  return (
    <div onClick={onClick} style={{
      background: c.surface, borderRadius: 20, padding,
      border: `1px solid ${c.divider}`,
      boxShadow: dark ? "none" : "0 1px 2px rgba(2,79,122,0.04), 0 4px 12px rgba(2,79,122,0.06)",
      cursor: onClick ? "pointer" : "default",
      ...style,
    }}>{children}</div>
  );
}

function SectionLabel({ children, dark, action }) {
  const c = colors(dark);
  return (
    <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "0 4px", marginBottom: 10 }}>
      <span style={{ fontSize: 13, fontWeight: 600, color: c.muted, textTransform: "uppercase", letterSpacing: "0.06em" }}>{children}</span>
      {action && <span style={{ fontSize: 13, fontWeight: 500, color: "var(--primary)" }}>{action}</span>}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 1. HOME — главный экран
// ─────────────────────────────────────────────────────────────
function HomeScreen({ dark, accent, accentDeep, current = 1500, goal = 2500, streak = 7, weekValues, onTapCup, onAdd, animate = true, lang = "ru" }) {
  const c = colors(dark);
  const progress = Math.min(1, current / goal);
  const [customMl, setCustomMl] = React.useState(300);
  const handleAdd = (ml) => { if (typeof onAdd === "function") onAdd(ml); };
  const T = lang === "ru" ? {
    today: "Сегодня", left: "осталось", goal: "цель", tap: "Тап для +250 мл",
    streak: "дней подряд", today2: "Сегодня", week: "За неделю",
  } : {
    today: "Today", left: "left", goal: "goal", tap: "Tap for +250 ml",
    streak: "day streak", today2: "Today", week: "This week",
  };
  const remaining = Math.max(0, goal - current);
  return (
    <div style={{ background: c.bg, minHeight: "100%", padding: "8px 20px 100px", color: c.text, fontFamily: "Inter, system-ui" }}>
      {/* Date header (без приветствия) */}
      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginTop: 8, marginBottom: 14 }}>
        <div style={{ fontSize: 13, color: c.muted, fontWeight: 500 }}>{T.today}, 14 апр</div>
        <div style={{
          width: 40, height: 40, borderRadius: 999, background: c.surface,
          border: `1px solid ${c.divider}`,
          display: "flex", alignItems: "center", justifyContent: "center",
          color: "var(--primary)", fontWeight: 600, fontSize: 14,
        }}>А</div>
      </div>

      {/* Big progress + tap */}
      <div style={{
        display: "flex", flexDirection: "column", alignItems: "center", gap: 18,
        padding: "8px 0 4px",
      }}>
        <div onClick={onTapCup} style={{ cursor: "pointer", animation: animate ? "cw-rise .5s ease" : "none" }}>
          <CircularWater
            size={260}
            progress={progress}
            dark={dark}
            accent={accent}
            accentDeep={accentDeep}
            label={`${fmt(current)}`}
            sublabel={`из ${fmt(goal)} мл`}
            animateWave={animate}
          />
        </div>
        <div style={{ textAlign: "center" }}>
          <div style={{ fontSize: 14, color: c.muted, fontWeight: 500 }}>
            {remaining > 0 ? `${fmt(remaining)} мл ${T.left}` : "Цель достигнута 🎉"}
          </div>
        </div>
      </div>

      {/* Quick volumes */}
      <div style={{ marginTop: 20 }}>
        <SectionLabel dark={dark}>Быстрое добавление</SectionLabel>
        <div style={{ display: "flex", gap: 10 }}>
          <VolumeChip ml="100" icon="drop" dark={dark} onClick={() => handleAdd(100)}/>
          <VolumeChip ml="200" icon="cup" dark={dark} onClick={() => handleAdd(200)}/>
          <VolumeChip ml="250" icon="cup" active dark={dark} onClick={() => handleAdd(250)}/>
          <VolumeChip ml="500" icon="bottle" dark={dark} onClick={() => handleAdd(500)}/>
        </div>

        {/* Custom slider + add */}
        <div style={{
          marginTop: 12,
          display: "flex", alignItems: "center", gap: 12,
          padding: "12px 14px",
          background: c.surface,
          border: `1px solid ${c.divider}`,
          borderRadius: 18,
        }}>
          <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: 6 }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline" }}>
              <span style={{ fontSize: 12, color: c.muted, fontWeight: 600, letterSpacing: "0.04em", textTransform: "uppercase" }}>Свой объём</span>
              <span style={{ fontSize: 18, fontWeight: 700, color: c.text, letterSpacing: "-0.02em" }}>
                {customMl} <span style={{ fontSize: 12, color: c.muted, fontWeight: 600 }}>мл</span>
              </span>
            </div>
            <input
              type="range" min="0" max="1000" step="10"
              value={customMl}
              onChange={(e) => setCustomMl(parseInt(e.target.value, 10))}
              style={{
                width: "100%",
                appearance: "none",
                WebkitAppearance: "none",
                height: 6, borderRadius: 999,
                background: `linear-gradient(90deg, var(--primary) 0%, var(--primary) ${customMl/10}%, ${c.divider} ${customMl/10}%, ${c.divider} 100%)`,
                outline: "none",
                cursor: "pointer",
              }}
              className="cw-slider"
            />
          </div>
          <button
            onClick={() => handleAdd(customMl)}
            disabled={customMl === 0}
            style={{
              width: 48, height: 48, borderRadius: 14,
              border: "none",
              background: customMl === 0 ? c.divider : "linear-gradient(180deg, var(--water-top), var(--water-bottom))",
              color: "#fff",
              display: "flex", alignItems: "center", justifyContent: "center",
              cursor: customMl === 0 ? "default" : "pointer",
              boxShadow: customMl === 0 ? "none" : "0 6px 18px rgba(2,136,209,0.35)",
              flexShrink: 0,
            }}
            aria-label="Добавить выбранный объём"
          >
            <Icon name="plus" size={22} color="#fff" stroke={2.6}/>
          </button>
        </div>
      </div>

      {/* Stats row */}
      <div style={{ marginTop: 22, display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
        <Card dark={dark} padding={14}>
          <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <Icon name="streak" size={18} color="#FF8A3D"/>
            <span style={{ fontSize: 12, color: c.muted, fontWeight: 600 }}>Streak</span>
          </div>
          <div style={{ fontSize: 22, fontWeight: 700, marginTop: 8, letterSpacing: "-0.02em" }}>{streak} <span style={{ fontSize: 12, color: c.muted, fontWeight: 500 }}>{T.streak}</span></div>
        </Card>
        <Card dark={dark} padding={14}>
          <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <Icon name="chart" size={18} color="var(--primary)"/>
            <span style={{ fontSize: 12, color: c.muted, fontWeight: 600 }}>{T.week}</span>
          </div>
          <div style={{ marginTop: 6 }}>
            <MiniBars values={weekValues || [1.0, 0.8, 1.1, 0.7, 0.95, 1.0, progress]} max={1.2} height={32} color="var(--primary)" todayIndex={6}/>
          </div>
        </Card>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 2. ONBOARDING — несколько шагов
// ─────────────────────────────────────────────────────────────
function OnboardingScreen({ dark, step = 1 }) {
  const c = colors(dark);
  const total = 3;
  const slides = [
    { title: "Пейте воду\nпо науке", body: "Мы рассчитаем вашу личную норму и будем мягко напоминать в течение дня.", icon: "drop" },
    { title: "Один тап —\n+250 мл", body: "Стакан, бутылка — добавляйте любой объем быстрее." , icon: "cup" },
    { title: "Расскажите\nо себе", body: "Это поможет точнее рассчитать дневную цель.", icon: "user" },
  ];
  const s = slides[step - 1];
  return (
    <div style={{ background: c.bg, minHeight: "100%", color: c.text, padding: "20px 24px 40px", display: "flex", flexDirection: "column", fontFamily: "Inter, system-ui" }}>
      {/* Progress dots */}
      <div style={{ display: "flex", gap: 6, justifyContent: "center", marginTop: 12 }}>
        {Array.from({ length: total }).map((_, i) => (
          <div key={i} style={{
            height: 4, width: i === step - 1 ? 28 : 8, borderRadius: 2,
            background: i === step - 1 ? "var(--primary)" : c.divider,
            transition: "all .3s",
          }}/>
        ))}
      </div>

      {/* Hero illustration — placeholder striped */}
      <div style={{ flex: 1, display: "flex", alignItems: "center", justifyContent: "center", margin: "30px 0" }}>
        <div style={{
          width: 220, height: 220, borderRadius: "50%",
          background: `radial-gradient(circle at 35% 30%, ${dark ? "#1A3A52" : "#E1F2FB"}, ${dark ? "#0F2A40" : "#C5E5F7"})`,
          display: "flex", alignItems: "center", justifyContent: "center",
          position: "relative", overflow: "hidden",
        }}>
          <CircularWater size={170} progress={(step) / total} dark={dark} label="" sublabel="" animateWave={true}/>
        </div>
      </div>

      {/* Copy */}
      <div style={{ flex: "0 0 auto", marginBottom: 24 }}>
        <h1 style={{ fontSize: 32, fontWeight: 700, lineHeight: 1.1, letterSpacing: "-0.03em", margin: 0, whiteSpace: "pre-line" }}>{s.title}</h1>
        <p style={{ fontSize: 15, color: c.muted, marginTop: 12, lineHeight: 1.45 }}>{s.body}</p>
      </div>

      {/* If step 3 — form preview */}
      {step === 3 && (
        <div style={{ display: "flex", flexDirection: "column", gap: 10, marginBottom: 18 }}>
          <Card dark={dark} padding={14}>
            <div style={{ fontSize: 12, color: c.muted, fontWeight: 600 }}>ВЕС</div>
            <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: "-0.02em" }}>62 кг</div>
          </Card>
          <Card dark={dark} padding={14}>
            <div style={{ fontSize: 12, color: c.muted, fontWeight: 600 }}>РЕКОМЕНДУЕМАЯ ЦЕЛЬ</div>
            <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: "-0.02em" }}>2 500 мл / день</div>
          </Card>
        </div>
      )}

      {/* CTA */}
      <button style={{
        height: 56, borderRadius: 16, border: "none",
        background: "linear-gradient(180deg, var(--water-top), var(--water-bottom))",
        color: "#fff", fontSize: 16, fontWeight: 600,
        boxShadow: "0 8px 22px rgba(2,136,209,0.35)", cursor: "pointer",
      }}>{step === total ? "Начать" : "Дальше"}</button>
      {step < total && (
        <button style={{
          height: 44, marginTop: 8, borderRadius: 16, border: "none", background: "transparent",
          color: c.muted, fontSize: 14, fontWeight: 500, cursor: "pointer",
        }}>Пропустить</button>
      )}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 3. QUICK ADD (модалка выбора объёма)
// ─────────────────────────────────────────────────────────────
function QuickAddScreen({ dark, selected = 250 }) {
  const c = colors(dark);
  const items = [
    { ml: 100, icon: "drop", label: "Глоток" },
    { ml: 150, icon: "drop", label: "Полстакана" },
    { ml: 200, icon: "cup", label: "Стакан" },
    { ml: 250, icon: "cup", label: "Большой стакан" },
    { ml: 400, icon: "bottle", label: "0,4 л" },
    { ml: 500, icon: "bottle", label: "Бутылка" },
  ];
  return (
    <div style={{ background: dark ? "rgba(0,0,0,0.5)" : "rgba(14,34,53,0.45)", minHeight: "100%", display: "flex", flexDirection: "column", justifyContent: "flex-end", fontFamily: "Inter, system-ui" }}>
      <div style={{
        background: c.bg, borderRadius: "28px 28px 0 0",
        padding: "12px 20px 28px", color: c.text,
        boxShadow: "0 -10px 40px rgba(0,0,0,0.15)",
      }}>
        <div style={{ width: 36, height: 4, borderRadius: 2, background: c.divider, margin: "4px auto 18px" }}/>
        <h2 style={{ margin: 0, fontSize: 22, fontWeight: 700, letterSpacing: "-0.02em" }}>Сколько вы выпили?</h2>
        <p style={{ fontSize: 13, color: c.muted, margin: "4px 0 16px" }}>Выберите объём или введите вручную</p>

        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 10 }}>
          {items.map(it => (
            <div key={it.ml} style={{
              padding: "14px 10px",
              background: it.ml === selected ? "linear-gradient(180deg, var(--water-top), var(--water-bottom))" : c.surface,
              border: it.ml === selected ? "none" : `1px solid ${c.divider}`,
              borderRadius: 18, color: it.ml === selected ? "#fff" : c.text,
              display: "flex", flexDirection: "column", alignItems: "center", gap: 8,
              boxShadow: it.ml === selected ? "0 6px 18px rgba(2,136,209,0.3)" : "none",
            }}>
              <Icon name={it.icon} size={26} color={it.ml === selected ? "#fff" : "var(--primary)"}/>
              <div style={{ fontSize: 16, fontWeight: 700 }}>{it.ml} мл</div>
              <div style={{ fontSize: 11, opacity: 0.75 }}>{it.label}</div>
            </div>
          ))}
        </div>

        {/* Custom input */}
        <Card dark={dark} padding={14} style={{ marginTop: 14, display: "flex", alignItems: "center", gap: 12 }}>
          <Icon name="edit" size={20} color={c.muted}/>
          <span style={{ flex: 1, fontSize: 15, color: c.muted }}>Свой объём…</span>
          <span style={{ fontSize: 13, color: "var(--primary)", fontWeight: 600 }}>мл</span>
        </Card>

        <button style={{
          height: 54, width: "100%", borderRadius: 16, border: "none", marginTop: 18,
          background: "linear-gradient(180deg, var(--water-top), var(--water-bottom))",
          color: "#fff", fontSize: 16, fontWeight: 600, cursor: "pointer",
          boxShadow: "0 8px 22px rgba(2,136,209,0.35)",
        }}>Добавить {selected} мл</button>
      </div>
    </div>
  );
}

Object.assign(window, { HomeScreen, OnboardingScreen, QuickAddScreen, Card, SectionLabel, colors, fmt });
