variable "one" {
  type = "map"
  default = {
    "image" = "METACLOUD-Debian-9-x86_64-Winterfell@metacloud-dukan"
    "image_uname" = "oneadmin"
    "swap_image" = "Linux swap"
    "swap_image_uname" = "cerit-sc-admin"
    "public_network" = "metacloud-brno-public-xkimle"
    "public_network_uname" = "xkimle"
    "security_group" = "101"
    "cpu" = "2"
    "vcpu" = "4"
    "memory" = "8192"
  }
}

variable "rabbitmq" {
  type = "map"
  default = {
    galaxy_vhost = "galaxyeu"
    galaxy_user_name = "galaxyeu"
  }
}

variable "galaxy" {
  type = "map"
  default = {
    jobs_directory = "/storage/brno11-elixir/home/galaxyeu/gphc/staging"
  }
}

variable "pulsar" {
  type = "map"
  default = {
    manager = "htcondor"
    staging_directory = "/storage/brno11-elixir/home/galaxyeu/gphc/staging"
    tool_dependency_directory = "/storage/brno11-elixir/home/galaxyeu/gphc/tools"
    directory = "/storage/brno11-elixir/home/galaxyeu/gphc/pulsar"
  }
}

variable "htcondor" {
  type = "map"
  default = {
    ip_addresses = "147.251.253.116, 147.251.253.117, 147.251.253.118, 147.251.253.119, 147.251.253.120, 147.251.253.121, 147.251.253.122"
  }
}
