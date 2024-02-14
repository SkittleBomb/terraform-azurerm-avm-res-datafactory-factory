variable "data_factory_credentials" {
  type = map(object({
    user_assigned_identity_name = optional(string, null)
    credential_description      = optional(string, null)
    user_assigned_identity_id   = optional(string, null)
    credential_annotations      = optional(list(string), null)
  }))
  default     = {}
  description = "Configuration for the Data Factory Credentials and User Assigned Managed Identities."
}
