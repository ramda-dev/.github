# Example: An Inquiry

This showcases an example of a decision to make. The work it gates already stands as a candidate, so the inquiry delivers that issue made ready.

It was rewritten from an issue in a separate repository.

**Fields:**

```json
{
  "title": "hooks-placement",
  "type": "inquiry",
  "milestone": "v0.4.0",
  "parent": null,
  "evidence": "deliverable"
}
```

**Body:**

```md
### Question

Do the plugin's hooks live in a plugin-level `hooks.json`, or in skill-scoped frontmatter?

### Context

No hooks are shipped yet, so placement is undecided. The answer gates #9, `nu-over-bash-hooks`: no hook is implemented before placement is settled, because changing it later means rework across every hook the plugin ships.

### Deliverables

- [ ] #9 - `nu-over-bash-hooks`, with its Approach filled from the answer, ready, in milestone `v0.4.0`

### Criteria

- [ ] A definite stance, with its rationale
- [ ] Recorded under `docs/decisions/`, where future contributors will find it

### Excluded

- Hook implementation, which belongs to #9
```
