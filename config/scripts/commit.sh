#!/bin/sh
git add .

TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
MESSAGE=$(gum input --value "$TYPE: " --placeholder "Message")
gum confirm "Commit changes?" && git commit -m "$MESSAGE"

git push origin -u
