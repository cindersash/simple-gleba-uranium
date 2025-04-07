#!/bin/bash
set -euo pipefail

# Usage: ./tag-release.sh [--force]

FORCE=false
ARG1=${1:-}
if [ "$ARG1" == "--force" ]; then
  FORCE=true
fi

# Ensure jq is installed
if ! command -v jq &>/dev/null; then
  echo "Error: 'jq' is not installed. Please install it to continue."
  exit 1
fi

# Read version from info.json
TAG_NAME=$(jq -r '.version' info.json)

# Check if the version was found
if [ -z "$TAG_NAME" ]; then
  echo "Error: Version not found in info.json"
  exit 1
fi

echo "Version: ${TAG_NAME}"

# Check if tag exists locally
TAG_EXISTS_LOCALLY=false
if git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
  TAG_EXISTS_LOCALLY=true
  echo "Tag $TAG_NAME already exists locally."
fi

# Check if tag exists remotely
TAG_EXISTS_REMOTELY=false
if git ls-remote --tags origin "$TAG_NAME" | grep -q "refs/tags/$TAG_NAME"; then
  TAG_EXISTS_REMOTELY=true
  echo "Tag $TAG_NAME already exists remotely."
  if [ "$FORCE" != true ]; then
    echo "Error: Use --force to overwrite the existing remote tag."
    exit 1
  fi
fi

# Final confirmation
if [ "$FORCE" = true ]; then
  echo "⚠️  WARNING: You are about to FORCE OVERWRITE tag $TAG_NAME (both locally and remotely) if it exists."
else
  echo "The version to be tagged and pushed is: $TAG_NAME"
fi

read -r -p "Type 'Y' to confirm: " CONFIRMATION
if [ "$CONFIRMATION" != "Y" ]; then
  echo "Operation cancelled."
  exit 0
fi

# Delete local tag if it exists and --force was used
if [ "$TAG_EXISTS_LOCALLY" = true ]; then
  if [ "$FORCE" = true ]; then
    echo "Deleting existing local tag $TAG_NAME..."
    git tag -d "$TAG_NAME"
    echo "Creating tag $TAG_NAME..."
    git tag "$TAG_NAME"
  fi
else
  echo "Creating tag $TAG_NAME..."
  git tag "$TAG_NAME"
fi

# Push the tag
if [ "$FORCE" = true ] && [ "$TAG_EXISTS_REMOTELY" = true ]; then
  echo "Force pushing tag $TAG_NAME to origin..."
  git push origin ":refs/tags/$TAG_NAME"  # Delete remote tag first
  git push origin "$TAG_NAME"
else
  echo "Pushing tag $TAG_NAME to origin..."
  git push origin "$TAG_NAME"
fi

echo "✅ Tag $TAG_NAME pushed successfully!"
