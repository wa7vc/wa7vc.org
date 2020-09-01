import Config


config :marvin, topologies: [
  local: [
    strategy: Cluster.Strategy.Epmd,
    config: [hosts: [:"wa7vc@127.0.0.1", :"marvin@127.0.0.1"]]
    ]
]
