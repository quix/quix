
%w[
  singleton_class
  tap
  let
  try
].each { |elem|
  require 'quix/ext/object/#{elem}' unless respond_to? elem
}
