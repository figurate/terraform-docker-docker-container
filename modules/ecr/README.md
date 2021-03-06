## Requirements

No requirements.

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_config | A path mounted as the (readonly) directory containing AWS credentials | `string` | `"~/.aws"` | no |
| aws\_region | The AWS region of the target ECR repository(s) | `any` | n/a | yes |
| command | ECR command to execute | `list` | <pre>[<br>  "login"<br>]</pre> | no |
| host\_path | A writeable path containing the project AWS input files (defaults to module root) | `any` | `null` | no |
| name | Docker container name | `string` | `"ecr"` | no |
| rm | Automatically remove container after execution | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| container\_logs | Logs from container execution |
| exit\_code | Exit code of container |

