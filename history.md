# Processo para Realização do Desafio

Criado Repositório no GitHub desafio-comment-api
Criado 2 Branches Develop e feature/create-app
Utilizado a feature/create-app para desenvolvimento do desafio.

Criado Dockerfile com a base na imagem python:3.7.4-slim devido que tem um número menor de vulnerabilidade.

Imagem DockerHub

Criado o Build da aplicação no GitHub Actions
Criado Token de acesso ao Docker Hub, configurado no GitHub Actions como Secrets no 
Realizado o Push da Imagem para o DockerHub

Utilizado o minikube para realizar o teste local

Antes de realizar a instalação, faço a verificação em qual contexto estou com o comando

  kubectl config current-context

# Deploy da API

Criado código IAC com Terraform armazenado no repositório como iac

Realizado os comandos
```
  terraform init
  terraform plan
  terraform apply -var-file="local.tfvars"
```
Após realizar Deploy da aplicação no minikube, realizado portFoward para porta 8001

Realizado teste no localhost:8000 recebido retorno
```
  * connect to 127.0.0.1 port 8000 from 127.0.0.1 port 65359 failed: Connection refused
  * Failed to connect to localhost port 8000 after 0 ms: Couldn't connect to server
```
Todos os Logs estão nesse mesmo documento no final.

## Testes realizado durante o processo

Realizado Build local da Imagem com o comando
```
  docker build --no-cache -t denisdamando/test-api:test-local .

  docker run -it denisdamando/test-api:test-local -p 8000:8000

  docker run -it denisdamando/test-api:latest /bin/bash  
```

Realizado o desafio com os recursos disponíveis.
Ferramentas utilizadas:

GitHub    - Utilizado para armazenamento do código
Docker    - Utilizado para construir o Backend-APi
DockerHub - armazenamento da imagem
Terraform - Deploy do Backend
Minikube  - Hospedagem da Aplicação

---
# Como faço a definição do Workflow completo do CICD e as ferramentas que utilizaria.
---

Definição da solução conforme o cenário proposto, sem levar em consideração a quantidade de solicitações da API e Escalabilidade do Backend.

Teria 2 repositórios:
  1. Para armazenamento da Automação de Infra.
  2. Gestão do código da aplicação.

Deploy da aplicação no Serviço Cloud como Google Cloud Run ou AWS ECS.
Realizaria o provisionamento do recurso com o Terraform IAC e criação do TFVARS para os respecivos ambientes develop / staging / production, onde pode ser criado os recursos em diferentes ambientes.
Armazenado o TFState em Bucket Privado.
Armazenamento das váriaveis no Valt Hashicorp
Nexus Artifacts (se necessário) ele permite mais repositórios na versão Free
Sonarqube para analise de código

O Processo de CICD com a seguinte definição:

  Build -> Validação de Segurança -> Analise de Código -> Deploy Dev
  Branch utilizada [Develop]

  Build -> Validação de Segurança -> Analise de Código -> Deploy Staging -> Aguardar a Homologação da App -> Definição de Janela para Deploy -> Deploy PRD
  Branch utilizada [release/version-app]

Pipeline utilização do GitHub Actions.
Monitoração com o Opentelemetry e Sentry.

==============

{
  "message": "comment created and associated with content_id 1", 
  "status": "SUCCESS"
}
{
  "message": "comment created and associated with content_id 1", 
  "status": "SUCCESS"
}
{
  "message": "comment created and associated with content_id 1", 
  "status": "SUCCESS"
}
{
  "message": "comment created and associated with content_id 2", 
  "status": "SUCCESS"
}
{
  "message": "comment created and associated with content_id 2", 
  "status": "SUCCESS"
}
{
  "message": "comment created and associated with content_id 2", 
  "status": "SUCCESS"
}
[
  {
    "comment": "first post!", 
    "email": "alice@example.com"
  }, 
  {
    "comment": "ok, now I am gonna say something more useful", 
    "email": "alice@example.com"
  }, 
  {
    "comment": "I agree", 
    "email": "bob@example.com"
  }
]
[
  {
    "comment": "I guess this is a good thing", 
    "email": "bob@example.com"
  }, 
  {
    "comment": "Indeed, dear Bob, I believe so as well", 
    "email": "charlie@example.com"
  }, 
  {
    "comment": "Nah, you both are wrong", 
    "email": "eve@example.com"
  }
]


curl -sv localhost:8001/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"first post!","content_id":1}' > ./log/response-log.log
* Host localhost:8001 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8001...
* Connected to localhost (::1) port 8001
> POST /api/comment/new HTTP/1.1
> Host: localhost:8001
> User-Agent: curl/8.7.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 68
>
} [68 bytes data]
* upload completely sent off: 68 bytes
< HTTP/1.1 200 OK
< Server: gunicorn/20.0.4
< Date: Wed, 26 Mar 2025 04:28:28 GMT
< Connection: close
< Content-Type: application/json
< Content-Length: 92
<
{ [92 bytes data]
* Closing connection

# Simulado erro de conexão

curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"ok, now I am gonna say something more useful","content_id":1}' >> ./log/response-log.log
* Host localhost:8000 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8000...
* connect to ::1 port 8000 from ::1 port 64758 failed: Connection refused
*   Trying 127.0.0.1:8000...
* connect to 127.0.0.1 port 8000 from 127.0.0.1 port 64759 failed: Connection refused
* Failed to connect to localhost port 8000 after 0 ms: Couldn't connect to server
* Closing connection


curl -sv localhost:8001/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"ok, now I am gonna say something more useful","content_id":1}' >> ./log/response-log.log
* Host localhost:8001 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8001...
* Connected to localhost (::1) port 8001
> POST /api/comment/new HTTP/1.1
> Host: localhost:8001
> User-Agent: curl/8.7.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 101
>
} [101 bytes data]
* upload completely sent off: 101 bytes
< HTTP/1.1 200 OK
< Server: gunicorn/20.0.4
< Date: Wed, 26 Mar 2025 04:30:57 GMT
< Connection: close
< Content-Type: application/json
< Content-Length: 92
<
{ [92 bytes data]
* Closing connection

curl -sv localhost:8001/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"bob@example.com","comment":"I agree","content_id":1}' >> ./log/response-log.log
* Host localhost:8001 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8001...
* Connected to localhost (::1) port 8001
> POST /api/comment/new HTTP/1.1
> Host: localhost:8001
> User-Agent: curl/8.7.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 62
>
} [62 bytes data]
* upload completely sent off: 62 bytes
< HTTP/1.1 200 OK
< Server: gunicorn/20.0.4
< Date: Wed, 26 Mar 2025 04:33:25 GMT
< Connection: close
< Content-Type: application/json
< Content-Length: 92
<
{ [92 bytes data]
* Closing connection

curl -sv localhost:8001/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"bob@example.com","comment":"I guess this is a good thing","content_id":2}' >> ./log/response-log.log
* Host localhost:8001 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8001...
* Connected to localhost (::1) port 8001
> POST /api/comment/new HTTP/1.1
> Host: localhost:8001
> User-Agent: curl/8.7.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 83
>
} [83 bytes data]
* upload completely sent off: 83 bytes
< HTTP/1.1 200 OK
< Server: gunicorn/20.0.4
< Date: Wed, 26 Mar 2025 04:35:23 GMT
< Connection: close
< Content-Type: application/json
< Content-Length: 92
<
{ [92 bytes data]
* Closing connection

curl -sv localhost:8001/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"charlie@example.com","comment":"Indeed, dear Bob, I believe so as well","content_id":2}' >> ./log/response-log.log
* Host localhost:8001 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8001...
* Connected to localhost (::1) port 8001
> POST /api/comment/new HTTP/1.1
> Host: localhost:8001
> User-Agent: curl/8.7.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 97
>
} [97 bytes data]
* upload completely sent off: 97 bytes
< HTTP/1.1 200 OK
< Server: gunicorn/20.0.4
< Date: Wed, 26 Mar 2025 04:36:38 GMT
< Connection: close
< Content-Type: application/json
< Content-Length: 92
<
{ [92 bytes data]
* Closing connection

curl -sv localhost:8001/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"eve@example.com","comment":"Nah, you both are wrong","content_id":2}' >> ./log/response-log.log
* Host localhost:8001 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8001...
* Connected to localhost (::1) port 8001
> POST /api/comment/new HTTP/1.1
> Host: localhost:8001
> User-Agent: curl/8.7.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 78
>
} [78 bytes data]
* upload completely sent off: 78 bytes
< HTTP/1.1 200 OK
< Server: gunicorn/20.0.4
< Date: Wed, 26 Mar 2025 04:38:15 GMT
< Connection: close
< Content-Type: application/json
< Content-Length: 92
<
{ [92 bytes data]
* Closing connection

curl -sv localhost:8001/api/comment/list/1
* Host localhost:8001 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8001...
* Connected to localhost (::1) port 8001
> GET /api/comment/list/1 HTTP/1.1
> Host: localhost:8001
> User-Agent: curl/8.7.1
> Accept: */*
>
* Request completely sent off
< HTTP/1.1 200 OK
< Server: gunicorn/20.0.4
< Date: Wed, 26 Mar 2025 04:39:14 GMT
< Connection: close
< Content-Type: application/json
< Content-Length: 251
<
[
  {
    "comment": "first post!",
    "email": "alice@example.com"
  },
  {
    "comment": "ok, now I am gonna say something more useful",
    "email": "alice@example.com"
  },
  {
    "comment": "I agree",
    "email": "bob@example.com"
  }
]
* Closing connection

curl -sv localhost:8001/api/comment/list/2
* Host localhost:8001 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8001...
* Connected to localhost (::1) port 8001
> GET /api/comment/list/2 HTTP/1.1
> Host: localhost:8001
> User-Agent: curl/8.7.1
> Accept: */*
>
* Request completely sent off
< HTTP/1.1 200 OK
< Server: gunicorn/20.0.4
< Date: Wed, 26 Mar 2025 04:40:39 GMT
< Connection: close
< Content-Type: application/json
< Content-Length: 278
<
[
  {
    "comment": "I guess this is a good thing",
    "email": "bob@example.com"
  },
  {
    "comment": "Indeed, dear Bob, I believe so as well",
    "email": "charlie@example.com"
  },
  {
    "comment": "Nah, you both are wrong",
    "email": "eve@example.com"
  }
]
* Closing connection
