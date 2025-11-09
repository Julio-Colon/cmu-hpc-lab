# Creates the anisible inventoy file and populates it with
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = templatefile("${path.module}/inventory.tpl", {
    # Pass variables from our Terraform resources into the template
    timestamp            = timestamp()
    controller_name      = aws_instance.controller.tags.Name
    controller_public_ip = aws_instance.controller.public_ip
    controller_private_ip= aws_instance.controller.private_ip
    compute_instances    = aws_instance.compute
  })
}

output "controller_public_ip" {
  value = aws_instance.controller.public_ip
}

output "compute_public_ips" {
  value = aws_instance.compute[*].public_ip
}