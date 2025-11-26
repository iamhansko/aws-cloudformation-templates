# Cognito Identity Pool

## Architecture
<img src="assets/cognito.png" width="400px" alt="cognito" style="background-color:#ffffff;">

## Structure
```
workshop
├── cognito-lambdas
|   ├── ApiGWAuthZ
|   |   └── authz-lambda
|   ├── CreateAuthChallenge
|   ├── DefineAuthChallenge
|   ├── MigrateUser
|   ├── PreToken
|   └── VerifyAuthChallenge
└── cognito-web
    ├── web-app
    |   ├── authn
    |   ├── node_modules
    |   └── public
    └── web-ui-js
        └── node_modules
```

## References
- [Amazon Cognito Workshop](https://catalog.workshops.aws/workshops/137bc34c-33d9-43a8-bf8f-2d4f6c22c333/en-US)