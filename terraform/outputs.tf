# Creates the anisible inventoy file and populates it with
resource "local_file" "ansible_inventory" {
  content = <<-EOT
# generated ${timestamp()}

[controller]
${aws_instance.controller.tags.Name} ansible_host=${aws_instance.controller.public_ip} private_ip=${aws_instance.controller.private_ip}

[compute]
%{ for i, instance in aws_instance.compute ~}
${instance.tags.Name} ansible_host=${instance.public_ip} private_ip=${instance.private_ip}
%{ endfor ~}

[cluster:children]
controller
compute
  EOT

  filename = "${path.module}/../ansible/inventory.ini"
}

output "controller_public_ip" {
  value = aws_instance.controller.public_ip
}

output "compute_public_ips" {
  value = aws_instance.compute[*].public_ip
}