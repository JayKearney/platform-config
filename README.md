# platform-config

Example platform configuration repo: VPC ranges in Terraform, Helm values per service and
environment, and the service dependency map.

Every pull request is audited by [infradoctor](https://github.com/JayKearney/infradoctor):

| Job | Check | Fails the PR when |
|---|---|---|
| Network (VPC overlaps) | `infradoctor network check terraform/` | Two VPC ranges overlap |
| Services (versions and dependencies) | `infradoctor versions` / `infradoctor deps` | An environment is a major version behind, or dependencies are unknown or circular |

The service inventory is built during the run by `scripts/build-inventory.sh`, from
`charts/<service>/values-<env>.yaml` (`image.tag`) and `dependencies.yaml`. Nothing is
maintained by hand twice.

## Layout