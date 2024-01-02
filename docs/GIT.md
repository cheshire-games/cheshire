### Creating new branch from main
`git checkout main && git pull && git checkout -b "BRANCH-NAME"`

### Commit and push local changes to remote branch
`git add . && git commit -m "COMMIT MESSAGE" && git push`

### Get changes from main to local branch
`git fetch && git rebase origin/main`