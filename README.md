cat > README.md <<'EOF'
# platform-config

Example platform configuration repo: VPC ranges in Terraform, Helm values per service and
environment, and the service dependency map.

Every pull request is audited by [infradoctor](https://github.com/JayKearney/infradoctor):

| Job | Check | Fails the PR when |
|---|---|---|
| Network (VPC overlaps) | `infradoctor network check terraform/ --known terraform/known-ranges.txt` | Two VPC ranges overlap, or a VPC overlaps a range used outside this repo |
| Services (versions and dependencies) | `infradoctor versions` / `infradoctor deps` | An environment is a major version behind, or dependencies are unknown or circular |

Problems show up as annotations on the exact line in the pull request's "Files changed" view.

The service inventory is built during the run by `scripts/build-inventory.sh`, from
`charts/<service>/values-<env>.yaml` (`image.tag`) and `dependencies.yaml`. Nothing is
maintained by hand twice.

## Layout

```
terraform/network/vpcs.tf          VPC address plan
terraform/network/sandbox.tf       VPC created with the community module
terraform/known-ranges.txt         ranges used outside this repo (other accounts, VPN)
charts/<service>/values-<env>.yaml Helm values per environment
dependencies.yaml                  which service depends on which
scripts/build-inventory.sh         builds services.yaml for infradoctor
.github/workflows/audit.yml        runs the audit on every PR
```

The EKS pod range `100.64.0.0/16` is reused in every cluster VPC on purpose and is marked
with `# infradoctor: allow-overlap`.

The Terraform here is only checked, never applied.
EOF