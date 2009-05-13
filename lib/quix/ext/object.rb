
%w[
  singleton_class
  tap
  let
  try
  deep_dup
].each { |method|
  require "quix/ext/object/#{method}" unless respond_to? method
}
