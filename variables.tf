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
variable "law_name"{
    type = string
    description = "log analytics name"
}
variable "sc_service_name"{
    type = string
    description = "app name"
}
variable "azure_bastion_subnet"{
    type = bool
    description = "azure_bastion_subnet"
}
variable "sc_pip"{
    type = string
    description = "sc_pip"
}
variable "sc_bastion_host"{
    type = string
    description = "sc_bastion_host"
}


