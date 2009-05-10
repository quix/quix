
%w[
  singleton_class
  tap
  let
  try
].each { |method|
  require "quix/ext/object/#{method}" unless respond_to? method
}
