# AWS Lambda Module

Este módulo de Terraform crea una función Lambda con su grupo de seguridad e IAM Role asociados, permitiendo configuraciones flexibles de acceso y permisos.

## Recursos principales

- **aws_security_group.lambda_service**  
    Grupo de seguridad para la función Lambda, configurable para aceptar tráfico desde CIDRs, Security Groups o Prefix Lists.

- **aws_iam_role.iam_lambda_role**  
    Rol IAM para la función Lambda, con política de confianza definida externamente.

- **aws_iam_role_policy_attachment.role_policy_attach**  
    Adjunta políticas IAM al rol Lambda según la lista de permisos proporcionada.

- **aws_lambda_function.lambda**  
    Implementa la función Lambda, asociada al grupo de seguridad y rol IAM definidos.

## Variables principales

| Variable                   | Descripción                                      | Tipo     | Obligatoria |
|----------------------------|--------------------------------------------------|----------|-------------|
| `lambda_function_name`     | Nombre de la función Lambda                      | string   | Sí          |
| `vpc_id`                   | ID de la VPC donde se crea el SG                 | string   | Sí          |
| `allowed_cidrs`            | Lista de CIDRs permitidos (opcional)             | list     | No          |
| `allowed_security_groups`  | Lista de SGs permitidos (opcional)               | list     | No          |
| `allowed_prefix_list_ids`  | Lista de Prefix Lists permitidos (opcional)      | list     | No          |
| `sg_listener_port_from`    | Puerto inicial para reglas de ingreso            | number   | Sí          |
| `sg_listener_port_to`      | Puerto final para reglas de ingreso              | number   | Sí          |
| `sg_listener_protocol`     | Protocolo para reglas de ingreso                 | string   | Sí          |
| `subnet_ids`               | Subnets donde se desplegará Lambda               | list     | Sí          |
| `lambda_runtime`           | Runtime de la función Lambda                     | string   | Sí          |
| `permissions_name`         | Lista de nombres de permisos IAM                 | list     | Sí          |
| `tags`                     | Tags para los recursos                          | map      | No          |

## Ejemplo de uso

```hcl
module "lambda" {
    source                  = "./tf-module-lambda"
    lambda_function_name    = "my-lambda"
    vpc_id                  = "vpc-xxxxxxx"
    allowed_cidrs           = ["10.0.0.0/16"]
    sg_listener_port_from   = 443
    sg_listener_port_to     = 443
    sg_listener_protocol    = "tcp"
    subnet_ids              = ["subnet-xxxxxx"]
    lambda_runtime          = "python3.9"
    permissions_name        = ["AWSLambdaBasicExecutionRole"]
    tags                    = { Environment = "dev" }
}
```

## Notas

- El archivo de política de confianza debe estar en `policies/ecs-trusted_policy.json`.
- Las políticas IAM deben existir previamente y ser referenciadas correctamente.
