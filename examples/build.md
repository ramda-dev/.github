# Example: A Build without Deliverables

This showcases an example of work that leaves no artifact, with both optional sections. Its Deliverables section reads `None.`, so its evidence is actionable and it is closed by hand with a note.

It was rewritten from an issue in a separate repository.

**Fields:**

```json
{
  "title": "issue-status-backfill",
  "type": "chore",
  "milestone": "v0.4.1",
  "parent": null,
  "evidence": "actionable"
}
```

**Body:**

```md
### Goal

Records that show what was done. Closed issues #3 and #4 carry `status = 'completed'` while every task under them reads `completed = false`, so completion state does not survive past the session that produced it.

### Source

This issue.

### Location

The task records under the closed issues #3 and #4.

### Approach

Correct the records by hand: set each task and subtask to its true state, and record the date it was actually closed.

### Deliverables

None.

### Actionables

- [ ] Set every task and subtask under each closed issue to its true completion state
- [ ] Record the actual closure date on each completed task

### Criteria

- [ ] Every task and subtask under a closed issue reflects its true completion state
- [ ] Task completion carries a closure date, not a boolean

### Verification

Read the tasks under #3 and #4: each shows its true state, and each completed task shows a closure date.

### Constraints

- Metadata correction only: no issue's definition or scope is altered

### Excluded

- Issues that are still open or were aborted
```
