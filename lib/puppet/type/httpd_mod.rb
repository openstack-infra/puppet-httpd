Puppet::Type.newtype(:httpd_mod) do
    @doc = "Manage Apache 2 modules on Debian and Ubuntu"

    ensurable

    def initialize(*args)
      super
      self[:before] = ["Service['httpd']"].select { |ref| catalog.resource(ref) }
    end

    newparam(:name) do
       desc "The name of the module to be managed"

       isnamevar
    end

    autorequire(:package) { catalog.resource(:package, 'httpd') }
end
