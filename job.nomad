job "testing" {
  region = "global"
  datacenters = ["dc1"]
  type = "service"
  update {
    stagger      = "5s"
    max_parallel = 3
  }
  group "api" {
    count = 3
    network {
      mode = "bridge"
      port "http" {
        host_network = "nomad"
      }
    }
    service {
      #name = "api"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.consulcatalog.connect=true",
      ]
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "cockroachdb-pgsql"
              local_bind_port = 26257
            }
          }
        }
      }
      check {
        type     = "http"
        path     = "/ping"
        interval = "10s"
        timeout  = "2s"
      }
    }
    task "frontend" {
      driver = "docker"
      config {
        #image = "hashicorp/demo-webapp-lb-guide"
        image = "username/repository:0.0.1-testing-0001"
        ports = ["http"]

        auth {
          username = "your-username"
          password = "your-password"
        }
      }
      template {
        destination   = "local/config.yaml"
        env = true
        data = <<EOH
        DB_USERNAME={{ key "db/username"}}
        DB_PASSWORD={{ key "db/password"}}
        DB_NAME={{ key "db/dbname"}}
        EOH
      }
      env {
        LISTENING_PORT    = "${NOMAD_PORT_http}"
        NODE_IP = "${NOMAD_IP_http}"
        HTTP_LISTENING_ADDR = "${NOMAD_ADDR_http}"
      }
      resources {
        cpu    = 500 # MHz
        memory = 256 # MB
      }
    }
  }
}