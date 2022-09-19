//file 
locals {
  filename_kustomize_tftpl = "kustomization.yaml.tftpl"
  filename_kustomize_yaml  = "kustomization.yaml"
  path_kustomize_base      = "kustomize/base"
  path_kustomize_overlays  = "kustomize/overlays"
  filename = {
    kustomize = {
      tftpl = local.filename_kustomize_tftpl
      yaml  = local.filename_kustomize_yaml
    }
  }
  path = {
    kustomize = {
      base     = local.path_kustomize_base
      overlays = local.path_kustomize_overlays
    }
  }

  file = {
    kustomize = {
      base = {
        tftpl = format(
          "%s/%s",
          local.path.kustomize.base,
          local.filename.kustomize.tftpl
        )
        yaml = format(
          "%s/%s",
          local.path.kustomize.base,
          local.filename.kustomize.yaml
        )
      }
    }
  }
}


locals {
  argocd_url = format(
    "%s/%s/%s/%s",
    var.argocd_url,
    var.argocd_version,
    var.ha_enabled ? var.argocd_path_ha : var.argocd_path,
    var.namespace_enabled ? var.argocd_manifest_namespace_install : var.argocd_manifest_cluster_install
  )

  kustomize = {
    base = templatefile(local.file.kustomize.base.tftpl, {
      argocd_url       = local.argocd_url
      argocd_namespace = var.argocd_namespace
    })
  }
}
