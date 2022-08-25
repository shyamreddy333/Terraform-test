variable "rgname"{
    type = string
    description = "resource group name"
}
variable "rglocation"{
    type = string
    description = "rg location"
}
variable "app_insights_name"{
    type = string
    description = "app_insights_name"
}
variable "law_id"{
    type = bool
    description = "log analytics ID"
}
variable "law_name"{
    type = string
    description = "log analytics name"
}
variable "sc_service_name"{
    type = string
    description = "app name"
}
variable "app_subnet_id"{
    type = bool
    description = "app_subnet_id"
}
variable "service_runtime_subnet_id"{
    type = bool
    description = "service_runtime_subnet_id"
}
variable "sc_cidr"{
    type = list(string)
    description = "sc_cidr"
}

