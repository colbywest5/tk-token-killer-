---
name: tk:version
description: Show or bump project version
allowed-tools:
  - Read
  - Write
  - Bash
---

# /tk:version

Manage project version tracking.

## Usage

```
/tk:version              # Show current version
/tk:version bump patch   # 1.0.0 → 1.0.1
/tk:version bump minor   # 1.0.0 → 1.1.0
/tk:version bump major   # 1.0.0 → 2.0.0
/tk:version set 2.0.0    # Set specific version
/tk:version history      # Show version history
```

## Show Current Version

```bash
if [ -f ".tk/VERSION" ]; then
    cat .tk/VERSION | jq -r '.version'
else
    echo "No version tracking. Run /tk:map or /tk:init first."
fi
```

## Initialize Version

If no `.tk/VERSION` exists:

```bash
mkdir -p .tk
cat > .tk/VERSION << EOF
{
  "version": "0.1.0",
  "major": 0,
  "minor": 1,
  "patch": 0,
  "lastUpdated": "$(date -Iseconds)",
  "lastCommand": "/tk:version init",
  "history": [
    {
      "version": "0.1.0",
      "date": "$(date +%Y-%m-%d)",
      "command": "/tk:version init",
      "note": "Version tracking initialized"
    }
  ]
}
EOF
echo "Initialized: v0.1.0"
```

## Bump Version

```bash
# Read current
CURRENT=$(cat .tk/VERSION | jq -r '.version')
MAJOR=$(cat .tk/VERSION | jq -r '.major')
MINOR=$(cat .tk/VERSION | jq -r '.minor')
PATCH=$(cat .tk/VERSION | jq -r '.patch')

# Bump based on type
case "$BUMP_TYPE" in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"

# Update file
# Add to history
echo "Version: $CURRENT → $NEW_VERSION"
```

## Version History

```bash
cat .tk/VERSION | jq -r '.history[] | "\(.version) - \(.date) - \(.note)"'
```

## Auto-Bump Rules

| Action | Bump |
|--------|------|
| New feature (/tk:build) | MINOR |
| Bug fix (/tk:debug) | PATCH |
| Small change | PATCH |
| Breaking change | MAJOR |
| Deploy | No bump (records only) |

## Version Display

All build/debug/deploy commands show:
```
Project: v1.2.3
```

On completion:
```
v1.2.3 → v1.2.4
```
