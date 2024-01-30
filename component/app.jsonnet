local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.yawol_controller;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('yawol-controller', params.namespace);

{
  'yawol-controller': app,
}
