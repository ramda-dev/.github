# Example: A Pull Request

This showcases an example of a pull request that provides an issue's deliverables and closes it. One verification box stays unchecked, because what it names was not proven by this change.

It was rewritten from a pull request in a separate repository. Its issue is the one in [defect.md](defect.md).

**Fields:**

```json
{
  "title": "fix(env): backfill PATHEXT and peers for Nushell children on Windows",
  "branch": "fix/pathext-omission",
  "draft": false
}
```

**Body:**

```md
## Summary

Nushell children inherit the server's environment unchanged. When the host launches the server without `PATHEXT`, every nu child lacks it, and bare-name external resolution fails even though the right directory is on `PATH`.

This adds `withEssentials` (`src/env.ts`), a Windows-only backfill applied at every nu spawn site: `PATHEXT`, `COMSPEC` and `TMP` take the host's value when present and a Windows default otherwise. Behavior on POSIX hosts is unchanged.

Closes #2

## Verification

- [x] The regression tests fail on `main` under Windows Bun 1.4.1 and pass on this branch
- [x] `test/env.test.ts` passes on Windows (10 pass) and on Linux (6 pass, 4 Windows-only skipped)
- [x] `bun run check` passes on Linux (159 pass, 4 skip)
- [ ] The full suite on Windows: 158 pass, 5 fail. The same 5 fail on `main`, so they are not caused by this change

## Before merging

None.
```
