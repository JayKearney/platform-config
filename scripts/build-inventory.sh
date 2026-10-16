#!/usr/bin/env bash
# Build services.yaml for infradoctor from the files this repo already has:
#   dependencies.yaml                    -> which service depends on which
#   charts/<service>/values-<env>.yaml   -> image.tag running in each environment
#
# Usage: bash scripts/build-inventory.sh [output-file]
set -euo pipefail

out="${1:-services.yaml}"
echo "services:" > "$out"

for service in $(yq 'keys | .[]' dependencies.yaml); do
  echo "  $service:" >> "$out"

  deps=$(yq ".\"$service\" | join(\", \")" dependencies.yaml)
  echo "    depends_on: [$deps]" >> "$out"

  if compgen -G "charts/$service/values-*.yaml" > /dev/null; then
    echo "    versions:" >> "$out"
    for file in charts/"$service"/values-*.yaml; do
      env=$(basename "$file" .yaml)   # values-prod
      env=${env#values-}              # prod
      tag=$(yq '.image.tag' "$file")
      echo "      $env: \"$tag\"" >> "$out"
    done
  fi
done

echo "Wrote $out:"
cat "$out"