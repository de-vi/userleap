output "app_endpoint" {
  value = module.app_dns.alias_record_fqdn
}
