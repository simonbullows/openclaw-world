# OPENCLAW WORLD - PRODUCTION SCHEDULE

## Timeline: 8 Weeks to Alpha

---

## WEEK 1: Foundation

### Goals
- [ ] Project setup & structure
- [ ] Player movement (WASD + Jump)
- [ ] Camera control
- [ ] Basic terrain (flat with noise)

### Files Created
```
├── player.gd          # Movement & input
├── main.tscn          # Scene setup
└── terrain.gd        # Block storage
```

### Hours: 8

---

## WEEK 2: World Building

### Goals
- [ ] Chunk system (16x16)
- [ ] Terrain generation (biomes)
- [ ] Block placement (E key)
- [ ] Block breaking (Q key)
- [ ] Block types (grass, stone, wood)

### Files Created
```
├── world/
│   ├── chunk.gd
│   ├── terrain.gd     # Enhanced
│   ├── block_data.gd
│   └── world_gen.gd
└── assets/
    └── textures/
```

### Hours: 12

---

## WEEK 3: Survival Mechanics

### Goals
- [ ] Health system
- [ ] Hunger/thirst
- [ ] Day/night cycle
- [ ] Simple crafting (2x2)
- [ ] Inventory UI

### Files Created
```
├── survival/
│   ├── health.gd
│   ├── hunger.gd
│   └── crafting.gd
└── ui/
    ├── inventory.tscn
    └── hud.tscn
```

### Hours: 16

---

## WEEK 4: Basic AI

### Goals
- [ ] Bot spawning
- [ ] Bot movement (random)
- [ ] Bot needs (basic)
- [ ] Bot states (idle/wander)

### Files Created
```
├── bots/
│   ├── bot.tscn
│   ├── bot.gd
│   └── bot_data.gd
```

### Hours: 16

---

## WEEK 5: Colony System

### Goals
- [ ] Bot jobs (miner, builder)
- [ ] Bot needs decay
- [ ] Bot work tasks
- [ ] Bot rest/sleep

### Files Created
```
├── bots/
│   ├── brain.gd       # AI decision making
│   ├── needs.gd
│   └── jobs/
│       ├── job.gd
│       ├── miner.gd
│       └── builder.gd
```

### Hours: 20

---

## WEEK 6: Player Commands & Memory

### Goals
- [ ] Bot memory system
- [ ] Player → Bot commands
- [ ] Bot relationships
- [ ] Save/load system

### Files Created
```
├── bots/
│   ├── memory.gd
│   └── relationships.gd
├── save/
│   └── save_system.gd
└── ui/
    └── bot_panel.tscn
```

### Hours: 20

---

## WEEK 7: Polish & UI

### Goals
- [ ] Inventory UI
- [ ] Bot info panel
- [ ] Settings menu
- [ ] Audio (basic)
- [ ] Performance optimization

### Files Created
```
├── ui/
│   ├── menus/
│   ├── tooltips/
│   └── icons/
└── audio/
    ├── sfx/
    └── music/
```

### Hours: 16

---

## WEEK 8: Alpha Build

### Goals
- [ ] Bug fixing
- [ ] Testing
- [ ] Alpha release (internal)
- [ ] Collect feedback

### Hours: 16

---

## TOTAL: ~124 Hours (3 hours/day)

---

## MILESTONES

| Week | Milestone | Playable? |
|------|-----------|------------|
| 1 | Player can walk around | Yes |
| 2 | Can build with blocks | Yes |
| 3 | Survival works | Yes |
| 4 | Bots exist | Yes |
| 5 | Bots work | Yes |
| 6 | Bots remember | Yes |
| 7 | UI polished | Yes |
| 8 | Alpha! | Complete Game |

---

## BUGGET (If Commercial)

| Phase | Cost |
|-------|------|
| Art (assets) | $500 |
| Audio (music) | $300 |
| Marketing | $200 |
| **Total** | **$1,000** |

*As indie: Free + time*

---

## RISK MANAGEMENT

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Scope creep | High | Medium | Stick to MVP |
| Bot AI issues | Medium | High | Simplify states |
| Performance | Medium | High | Optimize chunks |
| Lost interest | Medium | High | Quick wins early |

---

## DAILY STANDUP (Dev Log)

```
Day X: [What done] → [What's next] → [Blockers]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Mon:  Player movement ✓ → Chunk system → None
Tue:  Chunk gen → Block placing → None
Wed:  Block types → Break block → Need sprites
...
```

---

## PLAYTEST CHECKPOINTS

| Week | Focus | Questions |
|------|-------|-----------|
| 2 | Movement | Feel good? |
| 4 | Building | Intuitive? |
| 6 | Bots | Fun watching them? |
| 8 | Overall | Would pay for this? |

---

*Production Plan v1.0 - 2026-02-28*
