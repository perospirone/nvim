# AI-assisted development workflow

Notes to self: how I work with coding agents on this machine (Neovim + tmux +
a terminal agent such as Crush or Claude Code). Two modes: vibecoding a
throwaway prototype, and normal work where I stay the reviewer.

## Ground rules

- The agent proposes, I approve. Nothing gets committed or pushed without me
  reading the diff first.
- Small steps. One change, verify it, then the next. A change that is never
  independently verified is a change I do not understand.
- Every project gets an `AGENTS.md` (commands, layout, conventions, gotchas).
  It is the highest-leverage prompt there is, because agents otherwise guess.
- The agent must run the build/tests/linter and paste the output. "Should work"
  is not a result. If it cannot run something, it says so.
- I never type credentials into an agent session. Public repos clone
  anonymously; a password prompt means the repo is private, renamed, or deleted.

## The review loop (normal development)

1. Branch per task: `git switch -c feature-x`, or a worktree for parallel agents:
   `git worktree add ../proj-agent feature-x`.
2. Ask for a plan first when the change touches more than one file, then let it
   implement. Keep the task description concrete and scoped.
3. Read the diff before committing:
   - `git diff` in a terminal, or `<leader>gd` (`:DiffviewOpen`) inside Neovim.
   - Hunk by hunk: accept what I understand, revert what I do not
     (`:Gitsigns reset_hunk` once gitsigns is in place).
   - Check the lockfile/manifest separately: agents add and bump dependencies
     quietly.
4. Run the tests myself, or watch the agent run them, before the commit.
5. Commit message explains why. One logical change per commit.

## Where agents actually go wrong

- Inventing APIs, flags, or config keys that do not exist. Verify against real
  docs or the installed source, not against its memory.
- Silent scope creep: reformatting untouched files, renaming things nobody asked
  for, "while I was here" refactors.
- Dependency drift and lockfile churn.
- Deleting tests or weakening assertions to make a run go green.
- Comments that narrate the diff instead of explaining the code.
- Security-sensitive paths: auth, input validation, secrets, payments. Those I
  write and review by hand.

## Vibecoding the prototype

- Decide up front what is disposable: internal structure, naming, styling.
- Freeze the parts that are expensive to change later: API routes, schemas,
  types, the data model.
- Keep tests around those boundaries, even in a prototype. They are what makes
  "the agent changed something" a detectable event.
- Prefer rewriting the internals once the idea is validated over progressively
  patching AI-generated architecture.
- Do not let prototype state leak into the real project: separate repo, branch,
  or at minimum a clear directory with its own history.

## Editor setup that supports this

- Terminal agent in a tmux pane next to Neovim, in the project root. Crush is a
  terminal application, not a Neovim plugin, so tmux is the integration: no
  extra plugin needed, and the same pane works for any agent CLI.
- `autoread` plus a `FocusGained`/`BufEnter` `checktime` autocmd: files the agent
  writes on disk reload when I come back to the window.
- Persistent undo (`undofile`): an agent's bad edit is recoverable after closing
  the buffer.
- Diff review inside the editor: `diffview.nvim` for the whole change,
  gitsigns for hunks, `:Telescope diagnostics` to triage breakage across files.
- Format on save plus LSP diagnostics stay on, so obvious damage shows up
  immediately instead of at the next build.

## Prompting habits worth keeping

- State the goal, the constraints, and what "done" means (tests passing, specific
  command output).
- Give the file paths and the commands to run; do not make it discover the
  project from scratch on every turn.
- Ask for the smallest diff that solves the problem.
- Ask it to explain a subtle change before applying it when I am unsure.
- For anything multi-file, ask for the plan first and correct the plan, not the
  code.
