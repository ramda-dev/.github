#!/usr/bin/env nu

# Apply the repository baseline to repositories of the organization that owns this `.github` repository.
#
# For each repository it makes three things match the organization's standard:
# * the labels, copied from this repository, with every other label deleted;
# * the `reviewable` workflow, copied from `workflow-templates/` and committed to the default branch;
# * the merge options: squash merging only, titled by the pull request.
#
# Every step is safe to repeat. It needs `gh` signed in with the `repo` and `workflow` scopes.
#
# Example: ./scripts/repository-baseline.nu ramda-dev/nu-lib ramda-dev/scholar

const WORKFLOW: string = '.github/workflows/reviewable.yml'
const TEMPLATE: string = 'workflow-templates/reviewable.yml'
const LABELS_QUERY: string = 'query($o:String!,$r:String!){repository(owner:$o,name:$r){labels(first:100){nodes{id name}}}}'
const LABEL_DELETE: string = 'mutation($id:ID!){deleteLabel(input:{id:$id}){clientMutationId}}'
const MERGE_OPTIONS: record = {
  allow_squash_merge: true
  allow_merge_commit: false
  allow_rebase_merge: false
  delete_branch_on_merge: true
  allow_update_branch: true
  allow_auto_merge: false
  squash_merge_commit_title: PR_TITLE
  squash_merge_commit_message: PR_BODY
}

# Send the input record to the GitHub API as a JSON body.
def api [method: string, path: string]: record -> record {
  to json | ^gh api --method $method $path --input - | from json
}

# Read a file's base64 content through the API, or null when the file does not exist.
def remote-file [repo: string, path: string]: nothing -> oneof<record, nothing> {
  let response = ^gh api $"repos/($repo)/contents/($path)" | complete
  if $response.exit_code != 0 { return null }
  $response.stdout | from json | update content { str replace --all "\n" '' } | select sha content
}

# Make the repository's labels match the reference repository's, and delete the rest.
def sync-labels [repo: string, reference: string]: nothing -> record<kept: int, pruned: int> {
  let wanted = ^gh label list --repo $reference --limit 100 --json name,color,description | from json
  for label in $wanted {
    ^gh label create $label.name --repo $repo --color $label.color --description $label.description --force
  }
  # Deleted by node id, because a label named `.` or `?` cannot be addressed in a REST path.
  let parts = $repo | parse '{owner}/{name}' | first
  let extra = ^gh api graphql -f $"query=($LABELS_QUERY)" -f $"o=($parts.owner)" -f $"r=($parts.name)"
    | from json
    | get data.repository.labels.nodes
    | where name not-in $wanted.name
  for label in $extra { ^gh api graphql -f $"query=($LABEL_DELETE)" -f $"id=($label.id)" | ignore }
  {kept: ($wanted | length) pruned: ($extra | length)}
}

# Add the workflow from the organization's templates, or update it when its content differs.
def sync-workflow [repo: string, reference: string, message: string]: nothing -> string {
  let template = remote-file $reference $TEMPLATE
  if $template == null { error make {msg: $"($reference) has no ($TEMPLATE)"} }
  let current = remote-file $repo $WORKFLOW
  if $current != null and $current.content == $template.content { return unchanged }
  {message: $message content: $template.content}
  | merge (if $current == null { {} } else { {sha: $current.sha} })
  | api PUT $"repos/($repo)/contents/($WORKFLOW)"
  | ignore
  if $current == null { 'added' } else { 'updated' }
}

# Apply the baseline to each repository given as `<owner>/<name>`.
def main [
  ...repos: string # Repositories to bring to the baseline, each as `<owner>/<name>`
  --message (-m): string = 'ci: add the reviewable workflow' # Commit message for the workflow file
]: nothing -> table {
  $repos | each {|repo|
    let reference = $"($repo | path dirname)/.github"
    let labels = sync-labels $repo $reference
    let workflow = sync-workflow $repo $reference $message
    $MERGE_OPTIONS | api PATCH $"repos/($repo)" | ignore
    {repo: $repo ...$labels workflow: $workflow merge: squash-only}
  }
}
