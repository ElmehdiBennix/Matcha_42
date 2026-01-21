################################################################################################################
# name: safe-commit.sh
# description: script to verify branch names and commit messages follow the established conventions and verify that no sensitive information is being committed.
################################################################################################################

#!/bin/bash

BRANCH_NAME_REGEX="^(feat|fix|docs|style|refactor|test|chore)\/[a-z0-9._-]+$"
COMMIT_MESSAGE_REGEX="^(feat|fix|docs|style|refactor|test|chore)(\([a-z0-9._-]+\))?: .{1,500}$"
LEAKS_PATTERN="(password|secret|api[_-]?key|token|credentials?)[:=]\s*['\"]?[A-Za-z0-9_\-+/=]{8,}['\"]?"

# Get the current branch name
CURRENT_BRANCH=$(git branch --show-current)

# Validate branch name
if [[ ! $CURRENT_BRANCH =~ $BRANCH_NAME_REGEX ]]; then
    echo "Error: Branch name '$CURRENT_BRANCH' does not follow the naming convention."
    echo "Branch names must start with one of the following prefixes: feat/, fix/, docs/, style/, refactor/, test/, chore/ followed by a descriptive name."
    exit 1
fi

# Get commit message from user input the validate it against the regex
echo "commit message must follow the conventional commit format."
echo "Format: <type>(<scope>): <description>"
echo "Where <type> is one of: feat, fix, docs, style, refactor, test, chore"
echo "----------------------------------------"
echo "Enter commit message: "
read -r COMMIT_MESSAGE

if [[ ! $COMMIT_MESSAGE =~ $COMMIT_MESSAGE_REGEX ]]; then
    echo "Error: Commit message does not follow the conventional commit format."
    echo "Please use the format: <type>(<scope>): <description>"
    echo "Where <type> is one of: feat, fix, docs, style, refactor, test, chore"
    exit 1
else
    echo "Commit message format is valid."
    git commit -m "$COMMIT_MESSAGE"
fi

# Check for sensitive information in staged files
STAGED_FILES=$(git diff --cached --name-only)
for FILE in $STAGED_FILES; do
    if grep -Eiq "$LEAKS_PATTERN" "$FILE"; then
        echo "Error: Potential sensitive information found in file '$FILE'."
        echo "Please remove any sensitive information before committing."
        exit 1
    fi
done

echo "All checks passed. Proceeding with commit."
