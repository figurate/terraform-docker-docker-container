## Requirements

No requirements.

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| command | Gradle command to execute | `string` | `"build"` | no |
| home\_dir | A path mounted as the (writable) home directory in the gradle container | `string` | `"~"` | no |
| host\_path | A path containing the project gradle input files (defaults to module root) | `any` | `null` | no |
| name | Docker container name | `string` | `"gradle"` | no |
| rm | Automatically remove container after execution | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| container\_logs | Logs from container execution |
| exit\_code | Exit code of container |
| output\_dir | The host output directory for any generated artefacts |

