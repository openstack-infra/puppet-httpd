Puppet::Type.type(:httpd_mod).provide :modfix do
    desc "Dummy provider for httpd_mod.

    Fake nil resources when there is no a2enmod binary available. Allows
    puppetd to run on a bootstrapped machine before apache package has been
    installed. Workaround for: http://projects.puppetlabs.com/issues/2384
    and followed up by https://tickets.puppetlabs.com/browse/MODULES-1725
    "

    def self.instances
        []
    end
end
