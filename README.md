# HCP Consul Cluster Peering Demo

This repo will contain everything you need to deploy HCP Consul, AWS EKS and a HashiCup application with various services.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Description](#description)
- [Demo Steps](#steps)
- [Contributors](#contributors)

## Prerequisites

This demo repo utilises the following products in order to successfully operate:

1. Terraform ([Installation Setup](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli))
2. Terraform Cloud ([Sign up link](https://app.terraform.io/public/signup/account))
3. HCP Consul ([Sign up link](https://portal.cloud.hashicorp.com/sign-up))
   - [Service Principal Setup](https://developer.hashicorp.com/hcp/docs/hcp/security/service-principals#create-a-service-principal)
4. AWS Account ([Sign up link](https://aws.amazon.com/resources/create-account/))
   - [Retrieve Access Keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)

_Additional configuration to the code can be made to enable it to operate in your own environments_

## Description

In this demo, you will:

- Deploy 2 managed Kubernetes environments with Terraform
- Deploy 2 HCP Consul with Terraform
- Deploy parts of microservices from HashiCups, a demo application, across both Kuberenetes cluster
- Conduct Cluster Peering through the HCP Consul Management Plane
- Connect services across the peered HCP Consul clusters

### Scenario Overview

HashiCups is a coffee-shop demo application. It has a microservices architecture and uses Consul service mesh to securely connect the services. In this tutorial, you will deploy HashiCups services on Kubernetes clusters in two different AWS regions. By peering the Consul clusters, the frontend services in one region will be able to communicate with the API services in the other.

![HCP Consul Architecture](images/hcp-consul-architecture.png)

HashiCups uses the following microservices:

1. `nginx`

   - Description: NGINX instance that routes requests to the frontend microservice and serves as a reverse proxy to the public-api service.

2. `frontend`

   - Description: Provides a React-based UI.

3. `public-api`

   - Description: GraphQL public API that communicates with the products-api and the payments services.

4. `product-api`

   - Description: Stores the core HashiCups application logic, including authentication, coffee (product) information, and orders.

5. `postgres`

   - Description: Postgres database instance that stores user, product, and order information.

6. `payments`
   - Description: gRPC-based Java application service that handles customer payments.

## How-to Steps

1. Deploy Kubernetes clusters and HCP Consul

```
terraform -chdir=dc1 init

terraform -chdir=dc1 apply --auto-approve

terraform -chdir=dc2 init

terraform -chdir=dc2 apply --auto-approve
```

2. Configure `kubectl`
   _This command stores the cluster connection information in the `dc1` alias_

```
aws eks \
    update-kubeconfig \
    --region <Insert Region EKS deployed into> \
    --name <Insert EKS cluster name> \
    --alias=dc1
```

_This command stores the cluster connection information in the `dc2` alias_

```
aws eks \
    update-kubeconfig \
    --region <Insert Region EKS deployed into> \
    --name <Insert EKS cluster name> \
    --alias=dc2
```

3. Confirm Consul is deployed in the Kubernetes pods by inspecting them
   `kubectl --context=dc1 get pods`

`kubectl --context=dc2 get pods`

4. Deploy HashiCups

_Deploy the `frontend`, `nginx`, `public-api` and `payments` services along with the `intentions-dc1` to the `dc1` Kubernetes cluster_

```
for service in {frontend,nginx,public-api,payments,intentions-dc1}; do kubectl --context=dc1 apply -f hashicups-v1.0.2/$service.yaml; done
```

_Deploy the `product-api` and `postgres` services along with the `intentions-dc2` to the `dc2` Kubernetes cluster_

```
for service in {products-api,postgres,intentions-dc2}; do kubectl --context=dc2 apply -f hashicups-v1.0.2/$service.yaml; done
```

5. Confirm services are registered with HCP Consul
   _Verify that services are deployed in `dc1` HCP Consul cluster_
   `consul catalog services`

_Verify that services are deployed in `dc2` HCP Consul cluster_
`consul catalog services`

6. Explore the HashiCups application in the browser

`kubectl --context=dc1 port-forward deploy/nginx 8080:80`

## Contributors

Thank you Tony Phan for helping me troubleshoot and expanding my knowledge about HashiCorp Consul
