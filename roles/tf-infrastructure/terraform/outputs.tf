output "master_ipv4" {
  description = "Map of private ipv4 to public ipv4 for masters"
  value       = [hcloud_server.master.*.ipv4_address]
}

output "worker1_ipv4" {
  description = "Map of private ipv4 to public ipv4 for workers type 1"
  value       = [hcloud_server.worker1.*.ipv4_address]
}

output "worker2_ipv4" {
  description = "Map of private ipv4 to public ipv4 for workers type 2"
  value       = [hcloud_server.worker2.*.ipv4_address]
}

output "worker3_ipv4" {
  description = "Map of private ipv4 to public ipv4 for workers type 3"
  value       = [hcloud_server.worker3.*.ipv4_address]
}

output "worker4_ipv4" {
  description = "Map of private ipv4 to public ipv4 for workers type 4"
  value       = [hcloud_server.worker4.*.ipv4_address]
}

output "lb_ipv4" {
  description = "Map of private ipv4 to public ipv4 for loadbalancers"
  value       =  hcloud_load_balancer.k8s-loadbalancer.*.ipv4
}
