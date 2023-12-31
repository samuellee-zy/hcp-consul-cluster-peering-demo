# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "helm_values_file" {
  description = "The filename of the generated kubectl config. Will block on cluster creation until the cluster is really ready."
  value       = abspath(local_file.helm_values.filename)
}