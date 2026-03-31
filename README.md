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

## Tips

- Put constraints up front (language/framework, database, hosting, “no new dependencies”, etc.).
- Define non-goals to avoid scope creep.
- If Copilot starts coding early, reply: “Stop. Return to TASKS only.”

---

## License

Add a license (MIT/Apache-2.0/etc.) if you plan to share this publicly.