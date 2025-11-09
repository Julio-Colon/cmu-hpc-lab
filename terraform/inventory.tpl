[controller]
${controller_name} ansible_host=${controller_public_ip} private_ip=${controller_private_ip}

[compute]
%{ for instance in compute_instances ~}
${instance.tags.Name} ansible_host=${instance.public_ip} private_ip=${instance.private_ip}
%{ endfor ~}

[cluster:children]
controller
compute

[all:vars]
ansible_user=ubuntu