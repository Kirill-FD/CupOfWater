// screens-3.jsx — Settings, Notifications, Profile

// ─────────────────────────────────────────────────────────────
// 7. SETTINGS
// ─────────────────────────────────────────────────────────────
function Row({ icon, iconColor, title, value, dark, last, toggle, toggleOn }) {
  const c = colors(dark);
  return (
    <div style={{
      display: "flex", alignItems: "center", gap: 14, padding: "14px 16px",
      borderTop: last ? "none" : undefined,
      borderBottom: last ? "none" : `1px solid ${c.divider}`,
    }}>
      <div style={{
        width: 32, height: 32, borderRadius: 9,
        background: (iconColor || "var(--primary)"),
        display: "flex", alignItems: "center", justifyContent: "center",
      }}>
        <Icon name={icon} size={18} color="#fff" stroke={2}/>
      </div>
      <div style={{ flex: 1, fontSize: 15, fontWeight: 500 }}>{title}</div>
      {value && <div style={{ fontSize: 14, color: c.muted, fontWeight: 500 }}>{value}</div>}
      {toggle !== undefined ? (
        <div style={{
          width: 44, height: 26, borderRadius: 999,
          background: toggleOn ? "var(--primary)" : c.divider,
          position: "relative", transition: "background .2s",
        }}>
          <div style={{
            position: "absolute", top: 3, left: toggleOn ? 21 : 3,
            width: 20, height: 20, borderRadius: 999, background: "#fff",
            boxShadow: "0 1px 3px rgba(0,0,0,0.2)", transition: "left .2s",
          }}/>
        </div>
      ) : (
        <Icon name="chevron" size={16} color={c.faint}/>
      )}
    </div>
  );
}

function SettingsScreen({ dark }) {
  const c = colors(dark);
  return (
    <div style={{ background: c.bg, minHeight: "100%", color: c.text, padding: "8px 16px 80px", fontFamily: "Inter, system-ui" }}>
      <SectionLabel dark={dark}>Цель</SectionLabel>
      <Card dark={dark} padding={0} style={{ marginBottom: 18 }}>
        <Row icon="target" iconColor="var(--primary)" title="Дневная цель" value="2 500 мл" dark={dark}/>
        <Row icon="user" iconColor="#7C5BD8" title="Вес" value="62 кг" dark={dark}/>
        <Row icon="leaf" iconColor="#3DAB72" title="Активность" value="Средняя" dark={dark} last/>
      </Card>

      <SectionLabel dark={dark}>Единицы и формат</SectionLabel>
      <Card dark={dark} padding={0} style={{ marginBottom: 18 }}>
        <Row icon="drop" iconColor="var(--primary)" title="Объём" value="Миллилитры" dark={dark}/>
        <Row icon="cup" iconColor="#FF8A3D" title="Размер стакана" value="250 мл" dark={dark} last/>
      </Card>

      <SectionLabel dark={dark}>Внешний вид</SectionLabel>
      <Card dark={dark} padding={0} style={{ marginBottom: 18 }}>
        <Row icon={dark ? "moon" : "sun"} iconColor={dark ? "#7C5BD8" : "#FF8A3D"} title="Тема" value={dark ? "Тёмная" : "Светлая"} dark={dark}/>
        <Row icon="drop" iconColor="#00BCD4" title="Акцентный цвет" value="Океан" dark={dark} last/>
      </Card>

      <SectionLabel dark={dark}>Синхронизация</SectionLabel>
      <Card dark={dark} padding={0} style={{ marginBottom: 18 }}>
        <Row icon="check" iconColor="var(--success)" title="Облачная синхронизация" dark={dark} toggle toggleOn={true}/>
        <Row icon="bell" iconColor="#FF8A3D" title="Apple Health / Google Fit" dark={dark} toggle toggleOn={false} last/>
      </Card>

      <div style={{ fontSize: 12, color: c.faint, textAlign: "center", marginTop: 24 }}>
        CupOfWater · v1.2.0
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 8. NOTIFICATIONS — расписание push
// ─────────────────────────────────────────────────────────────
function NotificationsScreen({ dark }) {
  const c = colors(dark);
  const reminders = [
    { time: "08:00", label: "После пробуждения", on: true, ml: 250 },
    { time: "10:30", label: "Утренний перерыв", on: true, ml: 250 },
    { time: "12:30", label: "Обед", on: true, ml: 500 },
    { time: "15:00", label: "После обеда", on: true, ml: 250 },
    { time: "17:00", label: "Полдник", on: false, ml: 250 },
    { time: "19:30", label: "Ужин", on: true, ml: 250 },
    { time: "21:30", label: "Перед сном", on: false, ml: 200 },
  ];
  return (
    <div style={{ background: c.bg, minHeight: "100%", color: c.text, padding: "8px 20px 80px", fontFamily: "Inter, system-ui" }}>
      {/* Master toggle */}
      <Card dark={dark} padding={16} style={{ marginBottom: 14 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 14 }}>
          <div style={{
            width: 44, height: 44, borderRadius: 13, background: "var(--primary)",
            display: "flex", alignItems: "center", justifyContent: "center",
          }}>
            <Icon name="bell" size={22} color="#fff" stroke={2}/>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 15, fontWeight: 600 }}>Напоминания</div>
            <div style={{ fontSize: 12, color: c.muted, marginTop: 2 }}>Мягкие push в течение дня</div>
          </div>
          <div style={{
            width: 50, height: 30, borderRadius: 999, background: "var(--primary)", position: "relative",
          }}>
            <div style={{ position: "absolute", top: 3, left: 23, width: 24, height: 24, borderRadius: 999, background: "#fff", boxShadow: "0 1px 3px rgba(0,0,0,0.2)" }}/>
          </div>
        </div>
      </Card>

      <Card dark={dark} padding={16} style={{ marginBottom: 18 }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 12 }}>
          <div>
            <div style={{ fontSize: 13, color: c.muted, fontWeight: 500 }}>Активный период</div>
            <div style={{ fontSize: 18, fontWeight: 700, marginTop: 2 }}>08:00 — 22:00</div>
          </div>
          <Icon name="edit" size={18} color={c.muted}/>
        </div>
        {/* day rail */}
        <div style={{ position: "relative", height: 32, background: c.surface2, borderRadius: 8 }}>
          <div style={{
            position: "absolute", top: 0, bottom: 0, left: "33%", right: "8%",
            background: "linear-gradient(90deg, var(--water-top), var(--water-bottom))",
            borderRadius: 8, opacity: 0.85,
          }}/>
          {reminders.filter(r => r.on).map((r, i) => {
            const h = parseInt(r.time);
            const left = (h / 24) * 100;
            return <div key={i} style={{
              position: "absolute", top: 4, bottom: 4, left: `calc(${left}% - 1px)`,
              width: 2, background: "#fff",
            }}/>;
          })}
        </div>
        <div style={{ display: "flex", justifyContent: "space-between", marginTop: 6, fontSize: 10, color: c.faint, fontWeight: 500 }}>
          <span>0</span><span>6</span><span>12</span><span>18</span><span>24</span>
        </div>
      </Card>

      <SectionLabel dark={dark} action="+ Добавить">Расписание</SectionLabel>
      <Card dark={dark} padding={0}>
        {reminders.map((r, i) => (
          <div key={i} style={{
            display: "flex", alignItems: "center", gap: 14, padding: "14px 16px",
            borderTop: i === 0 ? "none" : `1px solid ${c.divider}`,
            opacity: r.on ? 1 : 0.5,
          }}>
            <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: "-0.02em", width: 60 }}>{r.time}</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 600 }}>{r.label}</div>
              <div style={{ fontSize: 12, color: c.muted, marginTop: 2 }}>{r.ml} мл</div>
            </div>
            <div style={{
              width: 40, height: 24, borderRadius: 999,
              background: r.on ? "var(--primary)" : c.divider, position: "relative",
            }}>
              <div style={{
                position: "absolute", top: 3, left: r.on ? 19 : 3,
                width: 18, height: 18, borderRadius: 999, background: "#fff",
                boxShadow: "0 1px 2px rgba(0,0,0,0.2)",
              }}/>
            </div>
          </div>
        ))}
      </Card>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 9. PROFILE
// ─────────────────────────────────────────────────────────────
function ProfileScreen({ dark }) {
  const c = colors(dark);
  const achievements = [
    { i: "streak", l: "7 дней", on: true, color: "#FF8A3D" },
    { i: "target", l: "30 целей", on: true, color: "var(--primary)" },
    { i: "drop", l: "100 л", on: true, color: "#00BCD4" },
    { i: "flame", l: "Месяц", on: false, color: c.faint },
    { i: "leaf", l: "Эко", on: false, color: c.faint },
    { i: "bottle", l: "1000 л", on: false, color: c.faint },
  ];
  return (
    <div style={{ background: c.bg, minHeight: "100%", color: c.text, padding: "0 20px 80px", fontFamily: "Inter, system-ui" }}>
      {/* Hero */}
      <div style={{ textAlign: "center", padding: "24px 0 18px" }}>
        <div style={{
          width: 96, height: 96, borderRadius: 999, margin: "0 auto",
          background: "linear-gradient(135deg, var(--water-top), var(--water-bottom))",
          display: "flex", alignItems: "center", justifyContent: "center",
          color: "#fff", fontSize: 36, fontWeight: 700, letterSpacing: "-0.02em",
          boxShadow: "0 10px 30px rgba(2,136,209,0.35)",
        }}>А</div>
        <div style={{ fontSize: 22, fontWeight: 700, marginTop: 14, letterSpacing: "-0.02em" }}>Аня Морозова</div>
        <div style={{ fontSize: 13, color: c.muted, marginTop: 2 }}>В CupOfWater с 2 марта 2026</div>
      </div>

      {/* Lifetime stats */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 10, marginBottom: 22 }}>
        <Card dark={dark} padding={14} style={{ textAlign: "center" }}>
          <div style={{ fontSize: 22, fontWeight: 700, color: "var(--primary)", letterSpacing: "-0.02em" }}>43</div>
          <div style={{ fontSize: 11, color: c.muted, fontWeight: 600, marginTop: 2 }}>дней</div>
        </Card>
        <Card dark={dark} padding={14} style={{ textAlign: "center" }}>
          <div style={{ fontSize: 22, fontWeight: 700, color: "var(--primary)", letterSpacing: "-0.02em" }}>91 л</div>
          <div style={{ fontSize: 11, color: c.muted, fontWeight: 600, marginTop: 2 }}>выпито</div>
        </Card>
        <Card dark={dark} padding={14} style={{ textAlign: "center" }}>
          <div style={{ fontSize: 22, fontWeight: 700, color: "#FF8A3D", letterSpacing: "-0.02em" }}>7</div>
          <div style={{ fontSize: 11, color: c.muted, fontWeight: 600, marginTop: 2 }}>streak</div>
        </Card>
      </div>

      <SectionLabel dark={dark} action="Все">Достижения</SectionLabel>
      <Card dark={dark} padding={16} style={{ marginBottom: 22 }}>
        <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 14 }}>
          {achievements.map((a, i) => (
            <div key={i} style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 8 }}>
              <div style={{
                width: 60, height: 60, borderRadius: 18,
                background: a.on
                  ? `linear-gradient(135deg, ${a.color}, ${a.color}aa)`
                  : (dark ? "rgba(255,255,255,0.04)" : "rgba(2,136,209,0.05)"),
                border: a.on ? "none" : `1px dashed ${c.divider}`,
                display: "flex", alignItems: "center", justifyContent: "center",
                boxShadow: a.on ? `0 6px 14px ${a.color}55` : "none",
              }}>
                <Icon name={a.i} size={28} color={a.on ? "#fff" : c.faint} stroke={2}/>
              </div>
              <div style={{ fontSize: 11, fontWeight: 600, color: a.on ? c.text : c.muted, textAlign: "center" }}>{a.l}</div>
            </div>
          ))}
        </div>
      </Card>

      {/* Settings — inline в профиле */}
      <SectionLabel dark={dark}>Цель</SectionLabel>
      <Card dark={dark} padding={0} style={{ marginBottom: 18 }}>
        <Row icon="target" iconColor="var(--primary)" title="Дневная цель" value="2 500 мл" dark={dark}/>
        <Row icon="user" iconColor="#7C5BD8" title="Вес" value="62 кг" dark={dark}/>
        <Row icon="leaf" iconColor="#3DAB72" title="Активность" value="Средняя" dark={dark} last/>
      </Card>

      <SectionLabel dark={dark}>Напоминания</SectionLabel>
      <Card dark={dark} padding={0} style={{ marginBottom: 18 }}>
        <Row icon="bell" iconColor="#FF8A3D" title="Push-напоминания" dark={dark} toggle toggleOn={true}/>
        <Row icon="history" iconColor="var(--primary)" title="Расписание" value="7 в день · 08–22" dark={dark} last/>
      </Card>

      <SectionLabel dark={dark}>Внешний вид и формат</SectionLabel>
      <Card dark={dark} padding={0} style={{ marginBottom: 18 }}>
        <Row icon={dark ? "moon" : "sun"} iconColor={dark ? "#7C5BD8" : "#FF8A3D"} title="Тема" value={dark ? "Тёмная" : "Светлая"} dark={dark}/>
        <Row icon="drop" iconColor="#00BCD4" title="Акцентный цвет" value="Океан" dark={dark}/>
        <Row icon="cup" iconColor="var(--primary)" title="Размер стакана" value="250 мл" dark={dark} last/>
      </Card>

      <SectionLabel dark={dark}>Синхронизация</SectionLabel>
      <Card dark={dark} padding={0} style={{ marginBottom: 18 }}>
        <Row icon="check" iconColor="var(--success)" title="Облачная синхронизация" dark={dark} toggle toggleOn={true} last/>
      </Card>

      <div style={{ fontSize: 12, color: c.faint, textAlign: "center", marginTop: 18 }}>
        CupOfWater · v1.2.0
      </div>
    </div>
  );
}

Object.assign(window, { SettingsScreen, NotificationsScreen, ProfileScreen, Row });
