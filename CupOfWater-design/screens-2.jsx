// screens-2.jsx — История за день, Статистика недели, Статистика месяца, Достижения

// ─────────────────────────────────────────────────────────────
// 4. HISTORY — список записей за день
// ─────────────────────────────────────────────────────────────
function HistoryScreen({ dark }) {
  const c = colors(dark);
  const entries = [
    { time: "08:30", ml: 250, type: "Стакан воды", icon: "cup" },
    { time: "10:15", ml: 200, type: "Стакан воды", icon: "cup" },
    { time: "13:20", ml: 500, type: "Бутылка", icon: "bottle" },
    { time: "15:00", ml: 250, type: "Стакан воды", icon: "cup" }
  ];
  const total = entries.reduce((s, e) => s + e.ml, 0);
  return (
    <div style={{ background: c.bg, minHeight: "100%", color: c.text, padding: "8px 20px 80px", fontFamily: "Inter, system-ui" }}>
      {/* Day picker pills */}
      <div style={{ display: "flex", gap: 8, marginBottom: 16, overflow: "hidden" }}>
        {["Пн 8", "Вт 9", "Ср 10", "Чт 11", "Пт 12", "Сб 13", "Вс 14"].map((d, i) => (
          <div key={i} style={{
            flex: 1, textAlign: "center", padding: "10px 0", borderRadius: 14,
            background: i === 6 ? "var(--primary)" : c.surface,
            color: i === 6 ? "#fff" : c.muted,
            fontSize: 12, fontWeight: 600,
            border: i === 6 ? "none" : `1px solid ${c.divider}`,
          }}>{d.split(" ")[0]}<br/><span style={{ fontSize: 14, fontWeight: 700 }}>{d.split(" ")[1]}</span></div>
        ))}
      </div>

      {/* Daily summary */}
      <Card dark={dark} padding={18} style={{ marginBottom: 18 }}>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <div>
            <div style={{ fontSize: 13, color: c.muted, fontWeight: 500 }}>Сегодня выпито</div>
            <div style={{ fontSize: 30, fontWeight: 700, letterSpacing: "-0.02em", marginTop: 2 }}>
              {fmt(total)} <span style={{ fontSize: 15, color: c.muted, fontWeight: 500 }}>/ 2 500 мл</span>
            </div>
            <div style={{ fontSize: 12, color: "var(--success)", marginTop: 4, fontWeight: 600 }}>
              ✓ {entries.length} записей · {Math.round(total/2500*100)}% от цели
            </div>
          </div>
          <CircularWater size={86} progress={total/2500} dark={dark} label={`${Math.round(total/2500*100)}%`} sublabel="" animateWave={false}/>
        </div>
      </Card>

      <SectionLabel dark={dark} action="Добавить">Записи за день</SectionLabel>

      {/* Timeline */}
      <Card dark={dark} padding={0}>
        {entries.map((e, i) => (
          <div key={i} style={{
            display: "flex", alignItems: "center", gap: 14, padding: "14px 16px",
            borderTop: i === 0 ? "none" : `1px solid ${c.divider}`,
          }}>
            <div style={{
              width: 40, height: 40, borderRadius: 12,
              background: dark ? "rgba(79,195,247,0.12)" : "rgba(2,136,209,0.08)",
              display: "flex", alignItems: "center", justifyContent: "center",
            }}>
              <Icon name={e.icon} size={20} color="var(--primary)"/>
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 15, fontWeight: 600 }}>{e.type}</div>
              <div style={{ fontSize: 12, color: c.muted, marginTop: 2 }}>{e.time}</div>
            </div>
            <div style={{ fontSize: 16, fontWeight: 700, color: "var(--primary)" }}>+{e.ml} <span style={{ fontSize: 11, color: c.muted, fontWeight: 500 }}>мл</span></div>
          </div>
        ))}
      </Card>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 5. WEEKLY STATS
// ─────────────────────────────────────────────────────────────
function WeekStatsScreen({ dark }) {
  const c = colors(dark);
  const days = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"];
  const values = [2400, 2100, 2700, 1900, 2500, 2300, 1500]; // last is today partial
  const goal = 2500;
  const max = 3000;
  const avg = Math.round(values.reduce((a,b)=>a+b,0) / values.length);
  return (
    <div style={{ background: c.bg, minHeight: "100%", color: c.text, padding: "8px 20px 80px", fontFamily: "Inter, system-ui" }}>
      {/* Period switcher */}
      <div style={{ display: "flex", background: c.surface, borderRadius: 12, padding: 4, gap: 4, marginBottom: 18 }}>
        {["Неделя", "Месяц", "Год"].map((p, i) => (
          <div key={i} style={{
            flex: 1, textAlign: "center", padding: "10px 0", borderRadius: 9,
            background: i === 0 ? "var(--primary)" : "transparent",
            color: i === 0 ? "#fff" : c.muted, fontSize: 13, fontWeight: 600,
          }}>{p}</div>
        ))}
      </div>

      {/* Headline metric */}
      <div style={{ marginBottom: 18 }}>
        <div style={{ fontSize: 13, color: c.muted, fontWeight: 500 }}>Среднее за неделю</div>
        <div style={{ display: "flex", alignItems: "baseline", gap: 10, marginTop: 4 }}>
          <div style={{ fontSize: 36, fontWeight: 700, letterSpacing: "-0.03em" }}>{fmt(avg)}</div>
          <div style={{ fontSize: 14, color: c.muted, fontWeight: 500 }}>мл / день</div>
        </div>
        <div style={{ fontSize: 13, color: "var(--success)", marginTop: 4, fontWeight: 600 }}>↑ +12% к прошлой неделе</div>
      </div>

      {/* Chart */}
      <Card dark={dark} padding={18} style={{ marginBottom: 14 }}>
        <div style={{ display: "flex", alignItems: "flex-end", gap: 10, height: 160, paddingBottom: 22, position: "relative" }}>
          {/* goal line */}
          <div style={{
            position: "absolute", left: 0, right: 0, top: 160 - (goal/max)*160 - 22,
            borderTop: `1.5px dashed ${dark ? "rgba(79,195,247,0.4)" : "rgba(2,136,209,0.4)"}`,
          }}>
            <div style={{ position: "absolute", right: 0, top: -18, fontSize: 10, color: "var(--primary)", fontWeight: 600 }}>Цель {fmt(goal)}</div>
          </div>
          {values.map((v, i) => {
            const h = (v / max) * 160;
            const reachedGoal = v >= goal;
            const isToday = i === 6;
            return (
              <div key={i} style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", gap: 8, height: "100%", justifyContent: "flex-end" }}>
                <div style={{
                  width: "100%", height: h, borderRadius: "8px 8px 4px 4px",
                  background: isToday
                    ? "linear-gradient(180deg, var(--water-top), var(--water-bottom))"
                    : reachedGoal
                      ? (dark ? "rgba(79,195,247,0.6)" : "var(--primary)")
                      : (dark ? "rgba(79,195,247,0.3)" : "rgba(2,136,209,0.4)"),
                  position: "relative",
                }}>
                  {isToday && <div style={{
                    position: "absolute", top: -22, left: "50%", transform: "translateX(-50%)",
                    fontSize: 10, fontWeight: 700, color: "var(--primary)", whiteSpace: "nowrap"
                  }}>{fmt(v)}</div>}
                </div>
                <div style={{ fontSize: 11, color: isToday ? "var(--primary)" : c.muted, fontWeight: isToday ? 700 : 500 }}>{days[i]}</div>
              </div>
            );
          })}
        </div>
      </Card>

      {/* Stats grid */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
        <Card dark={dark} padding={14}>
          <div style={{ fontSize: 11, color: c.muted, fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.05em" }}>Дней с целью</div>
          <div style={{ fontSize: 24, fontWeight: 700, marginTop: 6, letterSpacing: "-0.02em" }}>5 <span style={{ fontSize: 14, color: c.muted, fontWeight: 500 }}>/ 7</span></div>
        </Card>
        <Card dark={dark} padding={14}>
          <div style={{ fontSize: 11, color: c.muted, fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.05em" }}>Лучший день</div>
          <div style={{ fontSize: 24, fontWeight: 700, marginTop: 6, letterSpacing: "-0.02em" }}>2,7 <span style={{ fontSize: 14, color: c.muted, fontWeight: 500 }}>л · Ср</span></div>
        </Card>
        <Card dark={dark} padding={14}>
          <div style={{ fontSize: 11, color: c.muted, fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.05em" }}>Streak</div>
          <div style={{ fontSize: 24, fontWeight: 700, marginTop: 6, letterSpacing: "-0.02em", color: "#FF8A3D" }}>7 <span style={{ fontSize: 14, color: c.muted, fontWeight: 500 }}>дней</span></div>
        </Card>
        <Card dark={dark} padding={14}>
          <div style={{ fontSize: 11, color: c.muted, fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.05em" }}>Всего за неделю</div>
          <div style={{ fontSize: 24, fontWeight: 700, marginTop: 6, letterSpacing: "-0.02em" }}>15,4 <span style={{ fontSize: 14, color: c.muted, fontWeight: 500 }}>л</span></div>
        </Card>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 6. MONTH STATS — heatmap-календарь
// ─────────────────────────────────────────────────────────────
function MonthStatsScreen({ dark }) {
  const c = colors(dark);
  // 30 дней — random-but-stable progress
  const seed = [0.9,1.0,0.7,0.8,1.1,0.4,0,0.95,1.05,0.6,0.85,1.0,1.15,0.5,0.9,1.0,0.7,0.8,0.9,1.0,0.6,0.7,0.95,1.0,1.1,0.8,0.9,1.0,0.7,0.6];
  const cellSize = 40;
  const colorFor = (v) => {
    if (v === 0) return c.surface;
    if (v < 0.5) return dark ? "rgba(79,195,247,0.18)" : "rgba(2,136,209,0.16)";
    if (v < 0.8) return dark ? "rgba(79,195,247,0.36)" : "rgba(2,136,209,0.36)";
    if (v < 1.0) return dark ? "rgba(79,195,247,0.6)" : "rgba(2,136,209,0.6)";
    return "var(--primary)";
  };
  return (
    <div style={{ background: c.bg, minHeight: "100%", color: c.text, padding: "8px 20px 80px", fontFamily: "Inter, system-ui" }}>
      <div style={{ display: "flex", background: c.surface, borderRadius: 12, padding: 4, gap: 4, marginBottom: 18 }}>
        {["Неделя", "Месяц", "Год"].map((p, i) => (
          <div key={i} style={{
            flex: 1, textAlign: "center", padding: "10px 0", borderRadius: 9,
            background: i === 1 ? "var(--primary)" : "transparent",
            color: i === 1 ? "#fff" : c.muted, fontSize: 13, fontWeight: 600,
          }}>{p}</div>
        ))}
      </div>

      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 16 }}>
        <Icon name="back" size={22} color={c.muted}/>
        <div style={{ fontSize: 18, fontWeight: 700, letterSpacing: "-0.02em" }}>Апрель 2026</div>
        <Icon name="chevron" size={22} color={c.muted}/>
      </div>

      {/* Heatmap calendar */}
      <Card dark={dark} padding={16} style={{ marginBottom: 14 }}>
        <div style={{ display: "grid", gridTemplateColumns: "repeat(7, 1fr)", gap: 6, marginBottom: 8 }}>
          {["П","В","С","Ч","П","С","В"].map((d,i)=>(
            <div key={i} style={{ textAlign: "center", fontSize: 11, color: c.muted, fontWeight: 600 }}>{d}</div>
          ))}
        </div>
        <div style={{ display: "grid", gridTemplateColumns: "repeat(7, 1fr)", gap: 6 }}>
          {[null,null,null].map((_,i)=>(<div key={`pad-${i}`}/>))}
          {seed.map((v, i) => (
            <div key={i} style={{
              aspectRatio: "1", borderRadius: 9, background: colorFor(v),
              display: "flex", alignItems: "center", justifyContent: "center",
              fontSize: 11, fontWeight: 600,
              color: v >= 0.8 ? "#fff" : c.muted,
              border: i === 13 ? `2px solid var(--primary)` : "none",
            }}>{i+1}</div>
          ))}
        </div>
        {/* legend */}
        <div style={{ display: "flex", alignItems: "center", gap: 6, marginTop: 14, fontSize: 11, color: c.muted, fontWeight: 500 }}>
          <span>Меньше</span>
          {[0.2,0.5,0.8,1.0].map((v,i)=>(
            <div key={i} style={{ width: 14, height: 14, borderRadius: 4, background: colorFor(v) }}/>
          ))}
          <span>Больше</span>
        </div>
      </Card>

      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
        <Card dark={dark} padding={14}>
          <div style={{ fontSize: 11, color: c.muted, fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.05em" }}>Цель достигнута</div>
          <div style={{ fontSize: 24, fontWeight: 700, marginTop: 6, letterSpacing: "-0.02em" }}>21 <span style={{ fontSize: 14, color: c.muted, fontWeight: 500 }}>/ 30 дн</span></div>
        </Card>
        <Card dark={dark} padding={14}>
          <div style={{ fontSize: 11, color: c.muted, fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.05em" }}>Среднее</div>
          <div style={{ fontSize: 24, fontWeight: 700, marginTop: 6, letterSpacing: "-0.02em" }}>2,2 <span style={{ fontSize: 14, color: c.muted, fontWeight: 500 }}>л / день</span></div>
        </Card>
      </div>
    </div>
  );
}

Object.assign(window, { HistoryScreen, WeekStatsScreen, MonthStatsScreen });
