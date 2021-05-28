variable "project-name" {
    default = "Practise"
}

variable "env" {
    default = "Development"
}

variable "cluster_name" {
    default = "Practise"
}

variable "map_user" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::661984667850:user/devuser"
      username = "devuser"
      groups   = ["system:masters"]
    },
  ]
}