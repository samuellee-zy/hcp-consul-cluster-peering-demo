Kind      = "service-intentions"
Name      = "products-api"

Sources = [
  {
    Name   = "public-api"
    Peer   = "dc1-front-default"
    Action = "allow"
  }
]
