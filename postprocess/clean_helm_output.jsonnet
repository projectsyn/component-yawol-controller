local com = import 'lib/commodore.libjsonnet';

local output_path = std.extVar('output_path');

local stem(elem) =
  local elems = std.split(elem, '.');
  std.join('.', elems[:std.length(elems) - 1]);

{
  [stem(file)]: std.filter(
    function(it) it != null,
    com.yaml_load_all(output_path + '/' + file)
  )
  for file in com.list_dir(output_path)
}
