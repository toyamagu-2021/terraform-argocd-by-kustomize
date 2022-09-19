resource "helmfile_release_set" "mystack" {
  content    = file("./helmfiles/helmfile.yaml")
  kubeconfig = ".kube/config"
  depends_on = [
    kubernetes_namespace.argocd,
    local_file.kustomize_base
  ]

  # If file does not exit, terraform plan will fail. #38
  skip_diff_on_missing_files = [
    local.file.kustomize.base.yaml
  ]
}

resource "local_file" "kustomize_base" {
  content  = local.kustomize.base
  filename = local.file.kustomize.base.yaml
}

resource "kubernetes_namespace" "argocd" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = "argocd"
  }
}
