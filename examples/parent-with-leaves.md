# Example: A Parent with Leaves

This showcases an example of a parent issue with sub-issues.

It was rewritten from a separate repository's work that contained several deliverables and was filed as a single issue.
It is split here to show how the sections divide between a parent and its sub-issues: the parent uses the shape of its leaves' work and states the outcome, and each sub-issue carries its own deliverables.

## Parent

**Fields:**

```json
{
  "title": "windows-portability",
  "type": "chore",
  "milestone": "v0.3.0",
  "parent": null,
  "evidence": "deliverable"
}
```

**Body:**

```md
### Observed

The test suite assumes a POSIX host. Under Windows Bun, tests fail for reasons unrelated to the code they cover. The suite should pass on Windows as it does on Linux.

### Location

The test suite, run under Windows Bun from the WSL share with `--cwd`.

### Cause

Three assumptions: temp paths handed to nu in double quotes are read as escape sequences, `--include-path` fragments drive-letter paths, and one test spawns the `sleep` external, which Windows lacks.

### Impact

Every run of the suite on Windows.

### Approach

One sub-issue per cause.

### Deliverables

None of its own. Each sub-issue lists its deliverables.

### Actionables

- [ ] Close each attached sub-issue
- [ ] Verify the contents of all deliverables are acceptable

Any issues identified with the deliverables after their issues are closed are opened as separate sub-issues.

### Criteria

- [ ] `bun test` passes under Windows Bun (1.4.x, nu 0.114.x) run from the WSL share with `--cwd`
- [ ] No test is skipped or weakened to get there

### Verification

`bun test` under Windows Bun, run from the WSL share with `--cwd`.

### Excluded

- Changes to behavior on POSIX hosts
```

## Sub-issue

**Fields:**

```json
{
  "title": "include-dirs-separator",
  "type": "patch",
  "milestone": null,
  "parent": "windows-portability",
  "evidence": "deliverable"
}
```

**Body:**

```md
### Observed

On Windows, an `includeDirs` path that carries a drive letter does not reach nu whole, and the raw-vehicle `includeDirs` test fails from a UNC working directory. Each directory should reach nu as it was given.

### Location

`src/env.ts`, where the environment of a nu child is built.

### Cause

`includeDirs` reaches nu through the `--include-path` flag, which fragments drive-letter paths on Windows.

### Impact

Any caller that passes `includeDirs` on Windows.

### Approach

Prepend `includeDirs` to `NU_LIB_DIRS` with the platform separator, replacing the flag.

### Deliverables

- [ ] `src/env.ts` - `withIncludeDirs`: `includeDirs` prepended to `NU_LIB_DIRS` with the platform separator, replacing the flag
- [ ] `test/env.test.ts` - unit coverage: the platform separator, precedence over an existing `NU_LIB_DIRS`, and case-insensitive key reuse on Windows

### Actionables

None.

### Criteria

- [ ] The raw-vehicle `includeDirs` test passes from a UNC working directory

### Verification

`bun test test/env.test.ts`, then the raw-vehicle `includeDirs` test from a UNC working directory.
```
