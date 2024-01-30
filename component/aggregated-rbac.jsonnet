local kube = import 'lib/kube.libjsonnet';

local viewYawolLBs = kube.ClusterRole('syn:yawol-controller:view') {
  metadata+: {
    labels+: {
      'rbac.authorization.k8s.io/aggregate-to-view': 'true',
      'rbac.authorization.k8s.io/aggregate-to-edit': 'true',
      'rbac.authorization.k8s.io/aggregate-to-admin': 'true',
    },
  },
  rules: [
    {
      apiGroups: [ 'yawol.stackit.cloud' ],
      resources: [ '*' ],
      verbs: [ 'get', 'list', 'watch' ],
    },
  ],
};

local editYawolLBs = kube.ClusterRole('syn:yawol-controller:edit') {
  metadata+: {
    labels+: {
      'rbac.authorization.k8s.io/aggregate-to-edit': 'true',
      'rbac.authorization.k8s.io/aggregate-to-admin': 'true',
    },
  },
  rules: [
    {
      apiGroups: [ 'yawol.stackit.cloud' ],
      resources: [ '*' ],
      verbs: [ 'create', 'delete', 'deletecollection', 'patch', 'update' ],
    },
  ],
};

{
  '00_aggregated_rbac': [ viewYawolLBs, editYawolLBs ],
}
