local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';

local prometheus = import 'lib/prometheus.libsonnet';

local inv = kap.inventory();
local params = inv.parameters.yawol_controller;

local namespace =
  local ns = kube.Namespace(params.namespace) {
    metadata+: {
      labels+: {
        'openshift.io/cluster-monitoring': 'true',
      },
    },
  };
  if std.member(inv.applications, 'prometheus') then
    prometheus.RegisterNamespace(ns)
  else
    ns;

local openstack_credentials =
  local validate(data) =
    if std.objectHas(data, 'domain-id') && std.objectHas(data, 'domain-name') then
      error "OpenStack config options 'domain-id' and 'domain-name' are mutually exclusive"
    else if !std.objectHas(data, 'domain-id') && !std.objectHas(data, 'domain-name') then
      error "One of the OpenStack config options 'domain-id' or 'domain-name' must be set"
    else if std.objectHas(data, 'project-id') && std.objectHas(data, 'project-name') then
      error "OpenStack config options 'project-id' and 'project-name' are mutually exclusive"
    else if !std.objectHas(data, 'project-id') && !std.objectHas(data, 'project-name') then
      error "One of the OpenStack config options 'project-id' or 'project-name' must be set"
    else if !std.objectHas(data, 'auth-url') then
      error "OpenStack config option 'auth-url' must bet set"
    else if !std.objectHas(data, 'region') then
      error "OpenStack config option 'region' must bet set"
    else
      data;

  kube.Secret(params.openstack.secret_name) {
    data:: {},
    stringData: {
      'cloudprovider.conf': std.manifestIni({
        main: {},
        sections: {
          Global: validate(params.openstack.config),
        },
      }),
    },
  };

{
  '00_namespace': namespace,
  '00_openstack_credentials': openstack_credentials,
}
