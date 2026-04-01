# copilot-agent

Prompt templates to make GitHub Copilot (via VS Code Copilot Chat) follow a structured workflow:

**Plan → Design → Task list**

This helps prevent Copilot from jumping straight into code by forcing:
1) requirement gathering (spec),
2) a short design doc,
3) a granular checklist of TODOs.

---

## What you get

For any feature request, you’ll end up with three artifacts:

- **PLAN / Spec**: goals, non-goals, requirements, acceptance criteria, constraints, open questions
- **DESIGN**: proposed approach, key decisions, alternatives/tradeoffs, risks
- **TASKS**: small, ordered, checkable tasks (including tests + docs)

---

## How to use (VS Code Copilot Chat)

1. Open **Copilot Chat** in VS Code.
2. Start a new chat (recommended per feature).
3. Use either **One-shot** or **Step-by-step** below.
4. Only start coding after you approve the task list.

---

## One-shot prompt (fast)

Paste this into Copilot Chat and replace the feature request:

> You are my planning agent. Follow this workflow strictly:
>
> 1) **PLAN**: Ask clarifying questions if needed, then write a complete spec:
>    - Goal
>    - Users / use cases
>    - Non-goals
>    - Requirements
>    - Acceptance criteria (clear + testable)
>    - Constraints (stack, time, performance, security)
>    - Open questions / assumptions
>
> 2) **DESIGN**: Based on the spec, draft a design doc:
>    - Overview
>    - Architecture / components
>    - Data model (if any)
>    - API / interfaces (if any)
>    - Error handling
>    - Security & privacy considerations
>    - Observability (logs/metrics)
>    - Alternatives considered + tradeoffs
>    - Risks
>
> 3) **TASKS**: Produce an ordered, granular TODO list using markdown checkboxes.
>    - Keep tasks small (ideally 15–60 minutes each)
>    - Include tests and documentation tasks
>    - Do **not** write any code yet
>
> Feature request: <PASTE FEATURE REQUEST HERE>

---

## Step-by-step prompts (recommended)

### Step 1 — PLAN (Spec)

> Create a **PLAN/spec** for this feature. Ask clarifying questions first if anything is missing.
>
> Feature request: ...

After answering questions, ask Copilot:

> Update the spec using my answers. Make sure acceptance criteria are explicit and testable.

### Step 2 — DESIGN

> Using the approved spec, write a **DESIGN** doc. Include alternatives/tradeoffs and list key risks.

### Step 3 — TASKS

> Break the design into an ordered, granular **TASK** list with markdown checkboxes.
> Include implementation tasks, tests, docs, and verification steps.
> Do not write code.

---

## Output templates (copy/paste)

### PLAN (template)

- **Goal**
- **Users / use cases**
- **Non-goals**
- **Requirements**
- **Acceptance criteria**
- **Constraints**
- **Assumptions**
- **Open questions**

### DESIGN (template)

- **Overview**
- **Architecture**
- **Key decisions**
- **Interfaces / APIs**
- **Data model**
- **Error handling**
- **Security & privacy**
- **Observability**
- **Alternatives considered**
- **Risks**
- **Rollout / migration plan** (if applicable)

### TASKS (template)

- [ ] Task 1 (small + testable)
- [ ] Task 2
- [ ] Task 3
- [ ] Add/update tests
- [ ] Update docs
- [ ] Validate acceptance criteria

---

## Install (Windows/macOS/Linux)

This repository includes an OS-aware installer at:

- `install.sh` (macOS/Linux)
- `install.ps1` (Windows PowerShell)

### macOS / Linux (local clone)

```bash
git clone https://github.com/firmantr3/copilot-agent.git
cd copilot-agent
bash ./install.sh
```

### macOS / Linux (no clone, one-liner)

```bash
curl -fsSL https://raw.githubusercontent.com/firmantr3/copilot-agent/main/install.sh | bash
# or
wget -qO- https://raw.githubusercontent.com/firmantr3/copilot-agent/main/install.sh | bash
```

### Windows PowerShell (local clone)

```powershell
git clone https://github.com/firmantr3/copilot-agent.git
cd copilot-agent
pwsh -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

### Windows PowerShell (no clone, one-liner)

If using PowerShell 7+ (`pwsh`):
```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/firmantr3/copilot-agent/main/install.ps1' | iex"
```

If using Windows PowerShell 5.1 (classic):
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/firmantr3/copilot-agent/main/install.ps1' -UseBasicParsing | iex"
```

If you’re not sure which PowerShell you have, run:
```powershell
$PSVersionTable.PSVersion
```

### What it installs

- `agents/*` files → `~/.copilot/agents/` on macOS/Linux and `%USERPROFILE%\.copilot\agents` on Windows
- `prompts/generate-steering.prompt.md` →
  - macOS: `~/Library/Application Support/Code/User/prompts/generate-steering.prompt.md`
  - Linux: `~/.config/Code/User/prompts/generate-steering.prompt.md`
  - Windows: `%APPDATA%\Code\User\prompts\generate-steering.prompt.md`

### Troubleshooting

- Ensure `curl` or `wget` is installed on macOS/Linux.
- Ensure PowerShell execution policy allows script execution (`Bypass` in example).

## Using the agents

1. Start a new Copilot Chat session for your feature or bug request.
2. Use a higher-capability (“thinking/high”) model first to generate robust planning output.
3. Prompt in natural terms what you are planning to build, then iterate until you reach a complete `tasks.md` (or the task list step).
4. Once tasks are stable, switch to an efficient lower-cost model (e.g., “0x/low”) before executing code generation to save premium calls.

![App screenshot](assets/image.png)

### Plan Plus

- Can be used immediately as the primary planning agent.
- Focus on getting a clear spec, design, and task list in one session.

### Plan Kiro

- Kiro-style process requires steering generation first.
- In chat, run the command `/generate-steering`.
- Allow the agent to create `.kiro/steering/product.md`, `.kiro/steering/structure.md`, and `.kiro/steering/tech.md`.
- After steering exists, use `Plan Kiro` for optimized plan generation.

> Disclaimer: This workflow and templates are currently tested on TypeScript projects. Other languages may require adjustments in prompts and task expectations.

## Tips

- Put constraints up front (language/framework, database, hosting, “no new dependencies”, etc.).
- Define non-goals to avoid scope creep.
- If Copilot starts coding early, reply: “Stop. Return to TASKS only.”

---

## License

Add a license (MIT/Apache-2.0/etc.) if you plan to share this publicly.
