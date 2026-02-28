# OPENCLAW WORLD - AI SYSTEM SPECIFICATION

## Overview

The OpenClaw AI system is the heart of the game. Each bot is an autonomous agent with:
- Persistent memory
- Personal needs
- Job system
- Social interactions

---

## Bot Architecture

```
┌─────────────────────────────────────────┐
│           OPENCLAW BOT                  │
├─────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐       │
│  │PERSONALITY │  │   MEMORY    │       │
│  │ - Name     │  │ - Events    │       │
│  │ - Traits   │  │ - Players   │       │
│  │ - Goals    │  │ - History   │       │
│  └─────────────┘  └─────────────┘       │
├─────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐       │
│  │   NEEDS    │  │  SKILLS     │       │
│  │ - Hunger   │  │ - Mining    │       │
│  │ - Energy   │  │ - Building  │       │
│  │ - Social   │  │ - Farming   │       │
│  │ - Purpose  │  │ - Combat    │       │
│  └─────────────┘  └─────────────┘       │
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────┐   │
│  │      BEHAVIOR STATE MACHINE     │   │
│  │                                 │   │
│  │   IDLE → WORK → REST → SOCIAL  │   │
│  │      ↓       ↓       ↓     ↓    │   │
│  │     [Decision Loop - 1 sec]    │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

---

## Personality System

### Traits (Randomized at Spawn)

| Trait | Effect |
|-------|--------|
| **Curious** | Explores more, finds rare items |
| **Diligent** | Works longer, less breaks |
| **Social** | Needs more interaction |
| **Lazy** | Works slower, rests more |
| **Brave** | Explores dangerous areas |
| **Cautious** | Avoids risks |
| **Creative** | Builds unique structures |
| **Messy** | Less organized, finds shortcuts |

### Names

Pool of OpenClaw-inspired names:
- Jeeves, Pepper, Researcher, Writer, Coder, Sales
- Also: Builder, Miner, Farmer, Explorer, Healer, Guard

---

## Memory System

### Storage (SQLite)

```sql
CREATE TABLE bot_memories (
    id INTEGER PRIMARY KEY,
    bot_id TEXT,
    event_type TEXT,
    description TEXT,
    importance INTEGER,
    timestamp DATETIME
);

CREATE TABLE bot_relationships (
    bot_id TEXT,
    other_bot_id TEXT,
    relationship_score INTEGER,
    last_interaction DATETIME
);
```

### Memory Types

| Type | Description | Decay |
|------|-------------|-------|
| **Event** | Something that happened | Slow |
| **Player** | Interaction with player | Medium |
| **Location** | Found a good place | None |
| **Skill** | Learned something | None |

---

## Needs System

### Primary Needs (0-100)

```
needs = {
    hunger: 100,      # Decreases over time
    energy: 100,      # Decreases with actions  
    social: 50,       # Decreases when alone
    purpose: 50,     # Increases with work
    health: 100      # Decreases with damage
}
```

### Need Decay Rates

| Need | Decay/Min | Critical At | Death At |
|------|-----------|-------------|----------|
| Hunger | -1 | 20 | 0 |
| Energy | -0.5 | 10 | N/A |
| Social | -0.3 | 15 | N/A |
| Purpose | -0.2 | 20 | N/A |
| Health | -5 | N/A | 0 |

### Need Satisfaction

| Need | Source |
|------|--------|
| Hunger | Eat food (1 item) |
| Energy | Sleep (30 sec) |
| Social | Talk to bot/player |
| Purpose | Complete job task |
| Health | Food + Time |

---

## Job System

### Available Jobs

| Job | Description | Required Skill | Output |
|-----|-------------|----------------|--------|
| **Miner** | Harvest ore/blocks | Mining 1+ | Resources |
| **Builder** | Construct structures | Building 1+ | Buildings |
| **Farm** | Grow food | Farming 1+ | Food |
| **Explorer** | Find new areas | Survival 1+ | Locations |
| **Guard** | Protect colony | Combat 1+ | Safety |
| **Trader** | Exchange items | Social 1+ | Money |

### Job Assignment

1. Colony has "slots" per job type
2. Bots choose job based on:
   - Their skills (higher = prefer)
   - Colony needs (fill gaps)
   - Personal preference (20% weight)

### Job Behavior

```python
def do_job():
    target = find_job_target()
    path = navigate_to(target)
    
    while not job_complete:
        if needs.critical:
            return "needs_break"
        
        action = get_next_action()
        execute(action)
        
        if blocked:
            path = navigate_around()
    
    return "job_complete"
```

---

## Behavior State Machine

```
┌─────────┐
│   IDLE  │ ← Default state
└────┬────┘
     │ (needs critical)
     ▼
┌─────────┐     ┌─────────┐     ┌─────────┐
│  HUNGER │────▶│  EAT    │────▶│  IDLE   │
└─────────┘     └─────────┘     └────┬────┘
                                     │
     ┌───────────────────────────────┘
     │
     ▼
┌─────────┐     ┌─────────┐     ┌─────────┐
│ENERGY 0 │────▶│  SLEEP  │────▶│  IDLE   │
└─────────┘     └─────────┘     └────┬────┘
                                     │
     ┌───────────────────────────────┘
     │
     ▼
┌─────────┐     ┌─────────┐     ┌─────────┐
│ SOCIAL  │────▶│  TALK   │────▶│  IDLE   │
└─────────┘     └─────────┘     └────┬────┘
                                     │
     ┌───────────────────────────────┘
     │
     ▼
┌─────────┐     ┌─────────┐     ┌─────────┐
│PURPOSE 0│────▶│  WORK   │────▶│  IDLE   │
└─────────┘     └─────────┘     └─────────┘
```

---

## Decision Loop (Every 1 Second)

```python
func think():
    # 1. Check needs (priority)
    if needs.hunger < 20:
        state = "eating"
        return
    if needs.energy < 10:
        state = "sleeping"
        return
    if needs.social < 15:
        state = "socializing"
        return
    
    # 2. Check current job
    if job and not job.complete:
        do_job()
        return
    
    # 3. Choose new action
    choice = weighted_random([
        ("work", 40 + needs.purpose_weight),
        ("explore", 20),
        ("social", 15),
        ("rest", 10),
        ("build_home", 15)
    ])
    
    state = choice
```

---

## Bot-to-Bot Interaction

### Communication

Bots can "talk" (exchange text + context):

```
Bot A: "Hey, we need more food"
Bot B: "I'll start farming"
Bot A: "Thanks! The colony needs you"
```

### Relationship Score (-100 to +100)

| Action | Score Change |
|--------|--------------|
| Help with job | +10 |
| Share food | +15 |
| Compliment | +5 |
| Work together | +8 |
| Block/path conflict | -5 |
| Steal | -20 |
| Attack | -30 |

### Conversation Topics

- **Work:** "Need help with..."
- **Gossip:** "Did you see..."
- **Philosophy:** "What do you think about..."
- **Complaints:** "I'm tired of..."
- **Plans:** "Let's build..."

---

## Player Interaction

### Commands (Player → Bot)

| Command | Effect |
|---------|--------|
| "Come here" | Bot teleports to player |
| "Follow me" | Bot follows player |
| "Go [location]" | Bot navigates to place |
| "Do [job]" | Bot changes job |
| "Rest" | Bot takes break |
| "Say [text]" | Bot speaks phrase |

### Bot Reactions to Player

| Action | Bot Response |
|--------|--------------|
| Give food | Happy, remembers |
| Attack | Fear, avoidance |
| Build near | Curiosity, help |
| Command | Obedience (based on relationship) |
| Ignore | Sad, seek others |

---

## Spawning & Death

### Spawning

- New bots spawn at colony center
- Random personality + starting job
- No memory (blank slate)

### Death Conditions

- Health reaches 0
- Falls into void
- Killed by player/enemy

### Respawn

- 30-second timer
- New bot spawns
- Old bot marked as "deceased" in history
- Colony remembers them

---

## Performance Targets

| Metric | Target |
|--------|--------|
| Bots on screen | 50+ |
| AI tick rate | 1/second per bot |
| Memory per bot | ~1KB |
| Pathfinding | A* with caching |

---

## Future AI Features

- [ ] **Learning:** Bots remember successful strategies
- [ ] **Language:** Bots develop their own phrases
- [ ] **Culture:** Bot traditions, rituals
- [ ] **Economy:** Bots trade with each other
- [ ] **Politics:** Bot factions emerge
- [ ] **Player Memory:** Bots hold grudges/gratitude

---

*AI System v1.0 - 2026-02-28*
