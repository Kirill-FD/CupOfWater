// prototype.jsx — interactive prototype: stateful навигация между экранами
// Использует все экраны из screens-*.jsx + IOSDevice frame.

function InteractivePrototype({ dark, accent, accentDeep, goal, fillPercent }) {
  const [screen, setScreen] = React.useState("home");
  const [current, setCurrent] = React.useState(Math.round(goal * (fillPercent ?? 0.6)));
  const [splash, setSplash] = React.useState(null);

  React.useEffect(() => {
    setCurrent(Math.round(goal * (fillPercent ?? 0.6)));
  }, [goal, fillPercent]);

  const add = (ml) => {
    if (!ml || ml <= 0) return;
    setCurrent(c => Math.min(goal + 500, c + ml));
    setSplash({ ml, t: Date.now() });
    setTimeout(() => setSplash(null), 900);
  };

  const c = colors(dark);
  const tabs = [
    { id: "home", icon: "drop", label: "Сегодня" },
    { id: "stats", icon: "chart", label: "Статистика" },
    { id: "profile", icon: "user", label: "Профиль" },
  ];

  let content;
  if (screen === "home") {
    content = <HomeScreen dark={dark} accent={accent} accentDeep={accentDeep}
                          current={current} goal={goal}
                          onTapCup={() => add(250)}
                          onAdd={(ml) => add(ml)}/>;
  } else if (screen === "stats") content = <WeekStatsScreen dark={dark}/>;
  else if (screen === "profile") content = <ProfileScreen dark={dark}/>;

  return (
    <div style={{ position: "relative", width: "100%", height: "100%", background: c.bg }}>
      <div style={{ position: "absolute", inset: 0, overflow: "auto" }}>
        {content}
      </div>

      {/* Splash add toast */}
      {splash && (
        <div key={splash.t} style={{
          position: "absolute", left: "50%", top: "30%", transform: "translateX(-50%)",
          padding: "12px 18px", borderRadius: 999,
          background: "linear-gradient(180deg, var(--water-top), var(--water-bottom))",
          color: "#fff", fontWeight: 700, fontSize: 16,
          boxShadow: "0 10px 30px rgba(2,136,209,0.5)",
          animation: "cw-rise .4s ease",
          zIndex: 30,
        }}>
          +{splash.ml} мл добавлено
        </div>
      )}

      {/* Bottom Tab Bar */}
      <div style={{
        position: "absolute", left: 12, right: 12, bottom: 28,
        background: dark ? "rgba(20,36,54,0.85)" : "rgba(255,255,255,0.92)",
        backdropFilter: "blur(20px) saturate(180%)",
        WebkitBackdropFilter: "blur(20px) saturate(180%)",
        borderRadius: 22, padding: "8px 8px",
        display: "flex", alignItems: "center", justifyContent: "space-around",
        border: `1px solid ${c.divider}`,
        boxShadow: dark ? "0 10px 40px rgba(0,0,0,0.5)" : "0 10px 40px rgba(2,79,122,0.15)",
        zIndex: 20,
      }}>
        {tabs.map(tab => (
          <TabBtn key={tab.id} {...tab} active={screen === tab.id} onClick={() => setScreen(tab.id)} dark={dark}/>
        ))}
      </div>
    </div>
  );
}

function TabBtn({ icon, label, active, onClick, dark }) {
  const c = colors(dark);
  return (
    <button onClick={onClick} style={{
      flex: 1, padding: "8px 0", border: "none", background: "transparent",
      display: "flex", flexDirection: "column", alignItems: "center", gap: 2,
      cursor: "pointer",
    }}>
      <Icon name={icon} size={22} color={active ? "var(--primary)" : c.muted} stroke={active ? 2.2 : 1.8}/>
      <span style={{ fontSize: 10, fontWeight: 600, color: active ? "var(--primary)" : c.muted }}>{label}</span>
    </button>
  );
}

Object.assign(window, { InteractivePrototype, TabBtn });
