Kind = "exported-services"
Name = "default"
Services = [
  {
    ## The name and namespace of the service to export.
    Name      = "products-api"
    Namespace = "default"

    ## The list of peer clusters to export the service to.
    Consumers = [
      {
        ## The peer name to reference in config is the one set
        ## during the peering process.
        Peer = "dc1-front-default"
      }
    ]
  }
]
