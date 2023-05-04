terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    aws = {
      soursource = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "digitalocean" {
token = var.do_token
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

resource "digitalocean_ssh_key" "my_ssh_key" {
  name = var.my_ssh_key_name
  public_key = file(var.my_ssh_key_path)
  }

  data "digitalocean_ssh_key" "rebrain_ssh_key" {
    name = var.rebrain_ssh_key
  }

  data "digitalocean_sizes" "main" {
  filter {
    key    = "cpu_size"
    values = [var.parametrs.cpu_size]
  }

  filter {
    key    = "ram_size"
    values = [var.parametrs.ram_size]
  }
filter {
    key    = "disk_size"
    values = [var.parametrs.disk_size]
  }

  sort {
    key       = "price_monthly"
    direction = "asc"
  }
}

data "digitalocean_regions" "available" {
  filter {
    key    = "available"
    values = ["true"]
  }
}

resource "digitalocean_tag" "devops_tag" {
  name = var.devops_tag
}

resource "digitalocean_tag" "email_tag" {
  name = var.email_tag
}

resource "digitalocean_droplet" "second_server" {
  count = var.vps_count
  image = var.parametrs.image_type
  name = var.parametrs.image_name
  region = element(data.digitalocean_regions.available.regions, 0).slug
  size = element(data.digitalocean_sizes.main.sizes, 0).slug
  ssh_keys = [data.digitalocean_ssh_key.rebrain_ssh_key.id, digitalocean_ssh_key.my_ssh_key.id]
  tags = [digitalocean_tag.devops_tag.id, digitalocean_tag.email_tag.id]

  connection {
    type = "ssh"
    user = "root"
    host = self.ipv4_address
    agent = false
    private_key = file("${var.my_ssh_key_path}")
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"root:${random_password.password[count.index].result}\" | sudo chpasswd",
    ]
  }
}

resource "aws_route53_zone" "primary" {
  name = var.aws_zone
}

locals = {
  vps_ip = [digitalocean_droplet.second_server[count.index].ipv4_address]
}

resource "aws_route53_record" "my_dns" {
  count = var.vps_count
  zone_id = aws_route53_record.primary.zone_id
  name = "${digitalocean_tag.email_tag.id}-${count.index+1}"
  ttl = "500"
  type = "A"
  records = locals.vps_ip
}
