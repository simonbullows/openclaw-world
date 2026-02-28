# OPENCLAW WORLD
## Game Design Document & Production Plan

**Version:** 1.0
**Date:** 2026-02-28
**Genre:** Voxel Sandbox Survival / Life Simulation
**Target:** PC (Godot 4.2+)

---

# 1. CORE VISION

**Premise:** An open voxel world where AI agents (OpenClaw bots) live, work together, and survive. The player is a god-like figure who can interact, build, and observe their AI colony thriving.

**Unique Selling Point:** 
- First game where NPCs are actual AI agents with persistent memories
- Bots remember player interactions and learn from them
- Living, breathing AI society that plays itself when player is away

**Vibe:** Cozy, relaxing, slightly humorous. Like a mix of Minecraft + Sims + Westworld.

---

# 2. GAMEPLAY PILLARS

| Pillar | Description | Priority |
|--------|-------------|----------|
| **Build** | Place/break blocks, craft structures, terraform | Must Have |
| **Survive** | Hunger, health, shelter from elements | Should Have |
| **AI Society** | OpenClaw bots have jobs, relationships, needs | Must Have |
| **Explore** | Infinite procedurally generated world | Should Have |
| **Create** | Custom structures, blueprints, automation | Could Have |

---

# 3. MECHANICS

## 3.1 World Generation

**Algorithm:** Simplex Noise + Cellular Automata
- **Biomes:** Forest, Desert, Tundra, Ocean, Mountains
- **Structures:** Caves, Valleys, Rivers, Trees
- **Ores:** Coal, Iron, Gold, Diamond (depth-based)
- **Chunk System:** 16x16x64 chunks, load radius of 8

**World Size:** Infinite (procedural)

## 3.2 Building System

**Block Types:**
| ID | Block | Use | Obtain |
|----|-------|-----|--------|
| 1 | Grass | Decorative | Surface |
| 2 | Dirt | Decorative | Surface |
| 3 | Stone | Building | Underground |
| 4 | Wood | Building | Trees |
| 5 | Leaves | Decorative | Trees |
| 6 | Water | Decorative | Rivers |
| 7 | Sand | Building | Desert |
| 8 | Glass | Building | Crafted |
| 9 | Stone Brick | Building | Crafted |

**Crafting:** 3x3 grid, recipe book

## 3.3 Survival

| Stat | Description | Decay Rate | Fix |
|------|-------------|------------|-----|
| Hunger | Decreases over time | -1/min | Food |
| Thirst | Need water | -2/min | Drink |
| Health | Hit points | -5 on damage | Food + Bed |
| Energy | For actions | -1/action | Sleep |

## 3.4 OpenClaw AI System

**Bot Architecture:**
```
OpenClaw Bot
├── Personality (randomized)
├── Memory (persistent SQLite)
├── Needs (hunger, social, purpose)
├── Skills (building, mining, farming)
└── State Machine (idle, work, rest, social)
```

**Bot Types:**
| Bot | Role | Color | Skills |
|-----|------|-------|--------|
| Jeeves | Supervisor | Black | All-rounder, polite |
| Pepper | Worker | Orange | Building, mining |
| Researcher | Explorer | Blue | Finding resources |
| Writer | Social | Purple | Trading, talking |
| Coder | Crafter | Green | Advanced crafting |

**AI Behaviors:**
- Spawn with random personality
- Assign themselves jobs based on colony needs
- Remember player interactions
- Have conversations with each other
- Die if needs hit zero, respawn as new bot

## 3.5 Player Interaction

**First-Person Camera**
- WASD: Move
- Space: Jump
- E: Place block
- Q: Break block
- Mouse: Look
- Click: Interact

**God Mode (Toggle):**
- See all bots' needs
- Give commands
- Teleport
- Spawn items

---

# 4. PROGRESSION

## 4.1 Player Progression

1. **Day 1-3:** Learn basics, build shelter
2. **Day 4-7:** Meet bots, assign jobs
3. **Day 8-14:** Establish colony
4. **Day 15+:** Automate, expand, explore

## 4.2 Bot Progression

- Bots gain XP from tasks
- Level up skills
- Unlock new abilities
- Change personalities over time

---

# 5. ART STYLE

**Visual Style:** Voxel + Low-poly
- Bright, saturated colors
- Soft shadows
- No anti-aliasing (crisp edges)

**Color Palette:**
- Grass: #4a7c59
- Sky: #87ceeb
- Water: #4a90d9
- Wood: #8b6914
- Stone: #808080

**UI:** Minimal, rounded corners, semi-transparent

---

# 6. AUDIO

**Sound Effects:**
- Block place/break (satisfying "clunk")
- Footsteps (material-based)
- Bot chatter (random phrases)
- Ambient nature sounds

**Music:**
- Peaceful, lo-fi
- Dynamic (intensity based on nearby activity)

---

# 7. TECHNICAL ARCHITECTURE

## 7.1 Godot Project Structure

```
openclaw-world/
├── project.godot
├── main.tscn              # Main game scene
├── player/
│   ├── player.tscn
│   └── player.gd
├── world/
│   ├── terrain.gd         # Chunk management
│   ├── chunk.tscn
│   ├── block_types.gd
│   └── world_gen.gd
├── bots/
│   ├── bot.tscn
│   ├── bot.gd
│   ├── brain.gd           # AI decision making
│   ├── memory.gd          # Persistent memory
│   └── jobs/
│       ├── miner.gd
│       ├── builder.gd
│       ├── farmer.gd
│       └── explorer.gd
├── crafting/
│   ├── crafting_system.gd
│   └── recipes.tres
├── ui/
│   ├── hud.tscn
│   ├── inventory.tscn
│   └── bot_panel.tscn
├── save/
│   └── save_system.gd
└── assets/
    ├── textures/
    ├── models/
    └── audio/
```

## 7.2 Data Storage

**SQLite Database:**
- World state (blocks)
- Bot memories
- Player inventory
- Game statistics

---

# 8. ROADMAP

## Phase 1: Foundation (Weeks 1-2)
- [ ] Player movement & camera
- [ ] Basic terrain generation
- [ ] Place/break blocks
- [ ] Simple bot AI (random walking)

## Phase 2: Survival (Weeks 3-4)
- [ ] Health/hunger system
- [ ] Day/night cycle
- [ ] Basic crafting
- [ ] Bot needs system

## Phase 3: Colony (Weeks 5-6)
- [ ] Bot job assignments
- [ ] Bot memory system
- [ ] Bot-to-bot interaction
- [ ] Player commands

## Phase 4: Polish (Weeks 7-8)
- [ ] Audio
- [ ] UI/UX
- [ ] Performance optimization
- [ ] Bug fixing

## Phase 5: Expand (Ongoing)
- [ ] Multiplayer (stretch goal)
- [ ] More biomes
- [ ] More bot types
- [ ] Story mode

---

# 9. RISKS & MITIGATION

| Risk | Impact | Mitigation |
|------|--------|------------|
| Performance with many bots | High | LOD, tick rate adjustment |
| AI becoming stuck | Medium | Behavior validation, reset |
| World save corruption | High | Auto-backup, validation |
| Scope creep | High | Strict prioritization |

---

# 10. SUCCESS METRICS

**Launch Criteria:**
- 60 FPS with 20+ bots
- No critical bugs
- 1 hour minimum gameplay loop

**Success Metrics:**
- Bot population cap: 50
- Biomes: 5
- Block types: 20+
- Playtime: Unlimited (sandbox)

---

# 11. MARKETING

**Trailer Moments:**
- Bots working together building
- Epic landscape flyover
- Player commanding army of bots

**Platforms:** Itch.io, Steam (if successful)
**Price:** Free (open source) → Donations

---

# 12. TEAM ROLES (Indie Studio)

| Role | Responsibilities |
|------|------------------|
| **Lead** | Simon - Design, direction |
| **Code** | Jeeves - Engine, AI |
| **Code** | Kimi - Mechanics, systems |
| **Art** | Outsourced/Asset packs |
| **Audio** | Free sound libraries |
| **QA** | Community/Playtesters |

---

# 13. IMMEDIATE NEXT STEPS

1. **Today:** Confirm concept with Simon
2. **This week:** Phase 1 prototype (movement + terrain)
3. **Next week:** Bot AI basics
4. **Month 1:** Playable alpha

---

*Document Version: 1.0*
*Last Updated: 2026-02-28*
