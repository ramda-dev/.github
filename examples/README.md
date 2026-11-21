# Examples

Filled examples of the issue templates in [`.github/ISSUE_TEMPLATE`](../.github/ISSUE_TEMPLATE) and of the [pull request template](../.github/pull_request_template.md). Each was rewritten from work in a separate repository. Values such as milestones and issue numbers are illustrative.

| Example | Template | Shows |
| --- | --- | --- |
| [defect.md](defect.md) | Defect | A defect with a known cause, reproduced before filing, with the optional Constraints section |
| [build.md](build.md) | Build | Work that leaves no artifact, with both optional sections |
| [parent-with-leaves.md](parent-with-leaves.md) | Defect | A parent issue and one of its sub-issues |
| [release.md](release.md) | Release | A patch release, whose deliverables are URLs |
| [inquiry.md](inquiry.md) | Inquiry | A decision to make, which delivers the issue it gates |
| [pull-request.md](pull-request.md) | Pull request | A pull request that closes its issue |

The Research template has no example yet.

## Templates and forms

Each shape of work has a Markdown template and an issue form (`*_form.yml`). The form is for drafting in the browser and produces the same sections. Scripts and agents use the Markdown template.

| Template | Used for | Opens with |
| --- | --- | --- |
| Defect | Something behaves wrongly, and the cause is known | Observed, Location, Cause, Impact, Approach |
| Build | Something new, or a change made by intent | Goal, Source, Location, Approach |
| Research | Knowledge work whose output is a document or a record | Purpose, Scope, Method |
| Release | A version of the repository is cut | Version |
| Inquiry | A question to answer or a decision to make | Question, Context |

All but Inquiry close with Deliverables, Actionables, Criteria and Verification. Inquiry closes with Deliverables and Criteria.

## When an issue is ready

An issue is organized only when every required section of its shape holds content.

- A defect whose cause is not known is filed as an inquiry, and the defect follows from its answer.
- A choice still to be made is filed as an inquiry, or settled first. It does not sit inside an Approach.

An issue that is not ready stays a candidate: it has no milestone and no parent, and it may be free-form until it is scheduled.

## How an example reads

Each example has two parts. **Fields** is a JSON block of the values set outside the body. **Body** is a markdown block holding the body exactly as it is saved, so everything inside that block is example content and everything outside it belongs to the example file.

## The body of an issue

- Every heading in the template stays in the body, in the template's order. A section with nothing to say reads `None.`
- `Constraints` and `Excluded` are optional and follow the required sections.
- A deliverable is one line: a path or URL, then what it is. Any deliverable that is not declared with a filename or path requires an accompanying actionable for such declaration upon completion of the deliverable's premise.
- A criterion is a statement that is true or false once the work is done.
- A defect that has not been reproduced opens its Actionables with the step that reproduces it, by the method its test will use.
- A parent issue uses the shape of its leaves' work. Its Actionables open with closing each sub-issue and verifying their deliverables. Its Deliverables hold only what it produces beyond its leaves' output; with nothing of its own, they read "None of its own. Each sub-issue lists its deliverables."
- An inquiry delivers the issue that follows from its answer. When the answer calls for no work, it is recorded in the inquiry and the matter ends there. A line that opens with `If ...:` is ticked when its condition is settled.
- Work that waits on something outside the issue says so under `Constraints` or through a blocked-by link.
- The template's HTML comments are removed before the issue is saved.

## The fields of an issue

The template does not carry these. The keys below are the ones the examples use; they name where a value is set and are not an API payload.

| Key | Value |
| --- | --- |
| `title` | A kebab-case slug, such as `pathext-omission` |
| `type` | The issue type: `patch`, `bug`, `feature`, `chore`, `doc` or `inquiry` |
| `milestone` | A version of the repository, `vX.Y.Z`; `null` on a sub-issue |
| `parent` | The parent issue's title, or `null` |
| `evidence` | The issue field: `deliverable` when the work ends in artifacts, `actionable` otherwise |

## Filing an issue without a browser

`gh issue create --template` works only at an interactive terminal. A script or an agent reads the template that fits the shape of the work through the API, fills it in, and passes the result as a file:

```sh
# The templates that apply to a repository, organization defaults included
gh api graphql \
  -f query='query($o:String!,$r:String!){repository(owner:$o,name:$r){issueTemplates{name body}}}' \
  -f o=OWNER -f r=REPO

# After filling the sections and removing the comments
gh issue create -R OWNER/REPO --title "kebab-case-slug" --body-file body.md --type patch --milestone v0.2.5
```

A sub-issue takes `--parent NUMBER` in place of `--milestone`.
