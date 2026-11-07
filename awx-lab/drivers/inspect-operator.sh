#!/bin/sh
# Inspect the downloaded AWX Operator release tree and capture
# what it would deploy. Nothing here is applied to any cluster;
# there is no cluster. Usage: inspect-operator.sh <operator-dir> <transcript>
set -eu
OP="$1"; OUT="$2"
{
  echo "Operator tree: $OP (awx-operator 2.19.1, released with AWX 24.6.1)"
  echo; echo '== Top level =='; ls "$OP"
  echo; echo '== awx-demo.yml -- the smallest AWX custom resource in the release =='
  cat "$OP/awx-demo.yml"
  echo; echo '== Custom resource definitions shipped (config/crd/bases/) =='
  ls "$OP/config/crd/bases/"
  echo; echo '== Lines in the AWX CRD =='; wc -l "$OP/config/crd/bases/awx.ansible.com_awxs.yaml"
  echo; echo '== Images the installer defaults name (roles/installer/defaults/main.yml) =='
  grep -nE '_image:|_image_version:|_redis_image|_postgres_image|ee_images|control_plane_ee|_init_projects' "$OP/roles/installer/defaults/main.yml" | head -20
  grep -A5 'ee_images:' "$OP/roles/installer/defaults/main.yml" | head -6
  echo; echo '== Default replicas and resource requests =='
  grep -nE '^replicas:|^web_replicas:|^task_replicas:' "$OP/roles/installer/defaults/main.yml"
  sed -n '/^task_resource_requirements:/,/^csrf/p' "$OP/roles/installer/defaults/main.yml" | head -22
  grep -A3 '^postgres_storage_requirements:' "$OP/roles/installer/defaults/main.yml"
  grep -nE '^projects_storage_size:|^projects_storage_access_mode:|^projects_persistence:' "$OP/roles/installer/defaults/main.yml"
  echo; echo '== Deployment and statefulset templates the operator renders =='
  ls "$OP/roles/installer/templates/deployments/" "$OP/roles/installer/templates/statefulsets/"
  echo; echo '== Admin account defaults =='
  grep -nE '^admin_user:|^admin_password_secret:' "$OP/roles/installer/defaults/main.yml"
  echo; echo '== Service / ingress defaults =='
  grep -nE '^service_type:|^ingress_type:' "$OP/roles/installer/defaults/main.yml"
  echo; echo '== Kustomize entry point (config/default/kustomization.yaml, head) =='
  head -25 "$OP/config/default/kustomization.yaml"
  echo; echo '== Sample with resource limits (config/samples/awx_v1beta1_awx_resource_limits.yaml) =='
  cat "$OP/config/samples/awx_v1beta1_awx_resource_limits.yaml"
} > "$OUT" 2>&1
echo "operator inspection done"
