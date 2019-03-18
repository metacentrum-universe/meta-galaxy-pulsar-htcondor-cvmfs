// stratum1
data "template_file" "stratum1" {
  template = "${file("templates/vm.tpl")}"
  vars {
    CPU = "${var.one["cpu"]}"
    VCPU = "${var.one["vcpu"]}"
    MEMORY = "${var.one["memory"]}"
    IMAGE = "${var.one["image"]}"
    IMAGE_UNAME = "${var.one["image_uname"]}"
    SWAP_IMAGE = "${var.one["swap_image"]}"
    SWAP_IMAGE_UNAME = "${var.one["swap_image_uname"]}"
    NETWORK = "${var.one["public_network"]}"
    NETWORK_UNAME = "${var.one["public_network_uname"]}"
    NETWORK_SG = "${var.one["security_group"]}"
  }
}

resource "opennebula_template" "stratum1" {
  name = "gphc-stratum1"
  description = "${data.template_file.stratum1.rendered}"
  permissions = "600"
}

resource "opennebula_vm" "stratum1" {
  template_id = "${opennebula_template.stratum1.id}"
  permissions = "600"
  connection {
    host = "${self.ip}"
    agent = true
  }
  provisioner "local-exec" {
    command = "until ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${self.ip} test -e /root/ready; do sleep 5; done"
  }
  provisioner "ansible" {
    become = "yes"
    local = "yes"
    plays {
      playbook = "ansible/stratum1.yml"
      vault_password_file = "/root/.vault_pass"
      extra_vars {
        cvmfs_type = "stratum1"
        cvmfs_already_exists = true
      }
    }
  }
}

// galaxy
data "template_file" "galaxy" {
  template = "${file("templates/vm.tpl")}"
  vars {
    CPU = "${var.one["cpu"]}"
    VCPU = "${var.one["vcpu"]}"
    MEMORY = "${var.one["memory"]}"
    IMAGE = "${var.one["image"]}"
    IMAGE_UNAME = "${var.one["image_uname"]}"
    SWAP_IMAGE = "${var.one["swap_image"]}"
    SWAP_IMAGE_UNAME = "${var.one["swap_image_uname"]}"
    NETWORK = "${var.one["public_network"]}"
    NETWORK_UNAME = "${var.one["public_network_uname"]}"
    NETWORK_SG = "${var.one["security_group"]}"
  }
}

resource "opennebula_template" "galaxy" {
  name = "gphc-galaxy"
  description = "${data.template_file.galaxy.rendered}"
  permissions = "600"
}

resource "opennebula_vm" "galaxy" {
  template_id = "${opennebula_template.galaxy.id}"
  permissions = "600"
  connection {
    host = "${self.ip}"
    agent = true
  }
  provisioner "local-exec" {
    command = "until ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${self.ip} test -e /root/ready; do sleep 5; done"
  }
  provisioner "ansible" {
    become = "yes"
    local = "yes"
    plays {
      playbook = "ansible/galaxy.yml"
      vault_password_file = "/root/.vault_pass"
      extra_vars {
        cvmfs_type = "client"
        cvmfs_stratum1_ip = "${opennebula_vm.stratum1.ip}"
        rabbitmq_galaxy_user_name = "${var.rabbitmq["galaxy_user_name"]}"
        rabbitmq_galaxy_user_password = "${var.rabbitmq["galaxy_user_password"]}"
        rabbitmq_admin_user_password = "${var.rabbitmq["admin_user_password"]}"
        rabbitmq_galaxy_vhost = "${var.rabbitmq["galaxy_vhost"]}"
        galaxy_ip = "${self.ip}"
        galaxy_amqp_url = "amqp://${var.rabbitmq["galaxy_user_name"]}:${var.rabbitmq["galaxy_user_password"]}@${self.ip}:5672/${var.rabbitmq["galaxy_vhost"]}"
        galaxy_jobs_directory = "${var.galaxy["jobs_directory"]}"
      }
    }
  }
}

// pulsar
data "template_file" "pulsar" {
  template = "${file("templates/vm.tpl")}"
  vars {
    CPU = "${var.one["cpu"]}"
    VCPU = "${var.one["vcpu"]}"
    MEMORY = "${var.one["memory"]}"
    IMAGE = "${var.one["image"]}"
    IMAGE_UNAME = "${var.one["image_uname"]}"
    SWAP_IMAGE = "${var.one["swap_image"]}"
    SWAP_IMAGE_UNAME = "${var.one["swap_image_uname"]}"
    NETWORK = "${var.one["public_network"]}"
    NETWORK_UNAME = "${var.one["public_network_uname"]}"
    NETWORK_SG = "${var.one["security_group"]}"
  }
}

resource "opennebula_template" "pulsar" {
  name = "gphc-pulsar"
  description = "${data.template_file.pulsar.rendered}"
  permissions = "600"
}

resource "opennebula_vm" "pulsar" {
  template_id = "${opennebula_template.pulsar.id}"
  permissions = "600"
  connection {
    host = "${self.ip}"
    agent = true
  }
  provisioner "local-exec" {
    command = "until ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${self.ip} test -e /root/ready; do sleep 5; done"
  }
  provisioner "ansible" {
    become = "yes"
    local = "yes"
    plays {
      playbook = "ansible/pulsar.yml"
      vault_password_file = "/root/.vault_pass"
      extra_vars {
        cvmfs_type = "client"
        cvmfs_stratum1_ip = "${opennebula_vm.stratum1.ip}"
        pulsar_message_queue_url = "amqp://${var.rabbitmq["galaxy_user_name"]}:${var.rabbitmq["galaxy_user_password"]}@${opennebula_vm.galaxy.ip}:5672/${var.rabbitmq["galaxy_vhost"]}"
        pulsar_bind_ip = "${self.ip}"
        pulsar_manager = "${var.pulsar["manager"]}"
        pulsar_staging_directory = "${var.pulsar["staging_directory"]}"
        pulsar_tool_dependency_directory = "${var.pulsar["tool_dependency_directory"]}"
        pulsar_directory = "${var.pulsar["directory"]}"
        // not working for some reason
        pulsar_require_certificate = false
        //
        htcondor_node_type = "master"
        htcondor_master_ip = "${self.ip}"
        htcondor_ip_addresses = "${var.htcondor["ip_addresses"]}"
      }
    }
  }
}

// worker
data "template_file" "worker" {
  template = "${file("templates/vm.tpl")}"
  vars {
    CPU = "${var.one["cpu"]}"
    VCPU = "${var.one["vcpu"]}"
    MEMORY = "${var.one["memory"]}"
    IMAGE = "${var.one["image"]}"
    IMAGE_UNAME = "${var.one["image_uname"]}"
    SWAP_IMAGE = "${var.one["swap_image"]}"
    SWAP_IMAGE_UNAME = "${var.one["swap_image_uname"]}"
    NETWORK = "${var.one["public_network"]}"
    NETWORK_UNAME = "${var.one["public_network_uname"]}"
    NETWORK_SG = "${var.one["security_group"]}"
  }
}

resource "opennebula_template" "worker" {
  name = "gphc-worker"
  description = "${data.template_file.worker.rendered}"
  permissions = "600"
}

resource "opennebula_vm" "worker" {
  template_id = "${opennebula_template.worker.id}"
  permissions = "600"
  connection {
    host = "${self.ip}"
    agent = true
  }
  provisioner "local-exec" {
    command = "until ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${self.ip} test -e /root/ready; do sleep 5; done"
  }
  provisioner "ansible" {
    become = "yes"
    local = "yes"
    plays {
      playbook = "ansible/worker.yml"
      vault_password_file = "/root/.vault_pass"
      extra_vars {
        cvmfs_type = "client"
        cvmfs_stratum1_ip = "${opennebula_vm.stratum1.ip}"
        htcondor_node_type = "slave"
        htcondor_master_ip = "${opennebula_vm.pulsar.ip}"
        htcondor_ip_addresses = "${var.htcondor["ip_addresses"]}"
      }
    }
  }
}
