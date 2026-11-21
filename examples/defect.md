# Example: A Defect

This showcases an example of a defect whose cause is known and which was reproduced before it was filed, with the optional Constraints section.

It was rewritten from an issue in a separate repository. Its pull request is the one in [pull-request.md](pull-request.md), and the release that ships it is the one in [release.md](release.md).

**Fields:**

```json
{
  "title": "pathext-omission",
  "type": "bug",
  "milestone": "v0.2.5",
  "parent": null,
  "evidence": "deliverable"
}
```

**Body:**

```md
### Observed

On Windows, the nu children this server spawns cannot resolve external commands by bare name: `^where` fails while `^where.exe` succeeds. Bare names should resolve without the caller supplying environment overrides.

Reproduced on 2026-09-04 with nu 0.114.2-nightly.2 and bun 1.4.1: under the SDK's whitelist, `which nu` is empty, and adding `PATHEXT` alone restores resolution.

### Location

Every site that spawns nu: the one-shot default, env-layered and `cleanEnv` paths, and the long-lived `nu --mcp` children.

### Cause

The MCP TypeScript SDK launches stdio servers with a fixed environment whitelist that omits `PATHEXT`, `COMSPEC` and `TMP`, and every spawn site here passes the inherited environment through unchanged.

### Impact

Every Nushell execution on Windows under a host that launches the server through the SDK. POSIX hosts are not affected.

### Approach

Build the environment of each nu child through one function that backfills the Windows-essential variables: each takes the host's value when present and a Windows default otherwise.

### Deliverables

- [ ] `src/env.ts` - an environment builder that backfills the Windows-essential variables, used at every nu spawn site
- [ ] `test/env.test.ts` - regression coverage for the builder

### Actionables

None.

### Criteria

- [ ] Bare-name external commands resolve in Nushell executions on Windows without the caller supplying environment overrides
- [ ] `PATHEXT`, `COMSPEC` and `TMP` are present in every nu child on Windows
- [ ] Regression tests assert the presence of the essential variables per platform, and bare-name resolution of a known binary

### Verification

`bun run check` on Linux, then `bun test test/env.test.ts` under Windows Bun.

### Constraints

- `cleanEnv` leaks nothing from the host beyond the explicit allowlist
- Behavior on POSIX hosts is unchanged; the allowlist applies on Windows only
- Variable names are matched case-insensitively
```
