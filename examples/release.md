# Example: A Release

This showcases an example of a patch release. Its deliverables are URLs, so each is evidenced by its own line once ticked, and no pull request closes the issue.

It was rewritten from a release in a separate repository. The fix it ships is the one in [defect.md](defect.md).

**Fields:**

```json
{
  "title": "nushell-mcp@v0.2.5",
  "type": "chore",
  "milestone": "v0.2.5",
  "parent": null,
  "evidence": "deliverable"
}
```

**Body:**

```md
### Version

`nushell-mcp` 0.2.5, a patch release, in milestone `v0.2.5`. It holds the `pathext-omission` fix.

### Deliverables

- [ ] `https://www.npmjs.com/package/nushell-mcp/v/0.2.5` - the published package
- [ ] `https://github.com/ramda-dev/nushell-mcp/releases/tag/v0.2.5` - the release, with its notes

### Actionables

- [ ] Bump the version (0.2.4 -> 0.2.5) in `package.json`
- [ ] Create the version tag `v0.2.5`
- [ ] Publish the package

### Criteria

- [ ] `package.json` carries 0.2.5
- [ ] The tag `v0.2.5` exists and its release is published
- [ ] The release notes document the resolution semantics of the fix

### Verification

`bun run check`, then `gh release view v0.2.5 --repo ramda-dev/nushell-mcp` and `npm view nushell-mcp@0.2.5 version`.
```
