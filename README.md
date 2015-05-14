## Overview


puppet-httpd is the openstack-infra fork of puppetlabs-apache. We
forked at the 0.0.4 release.


## Why we forked


We forked because we were unable to upgrade to later versions of the
apache module, and in some cases because we were unwilling to do this.
The modern apache module takes the position of fully modelling the
apache config file. The older module, that this forked from, takes the
position of weakly modelling, it accepts a template and puts that in a
vhost. This allows us to write our vhosts in the apache syntax with a
thin erb layer on top of it.

However, with the apache module pinned to 0.0.4, we were unable to
bring in new modules that depended on a newer apache module. Groups
who consumed our puppet code downstream couldn't use the modern apache
module either.

We forked to the httpd namespace so that this module (weakly modelling)
and a modern puppetlabs-apache module (strongly modelling) could
co-exist.

This also allows us to add features and bugfixes to this module
without changing its weakly modelled architecture.


## Classes


TODO


## Defined types


TODO


# License

Copyright (C) 2012 Puppet Labs Inc

Puppet Labs can be contacted at: info@puppetlabs.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


# Project website

Though this project is mirrored to github, that is just a mirror. This
is a sub project under the OpenStack umbrella, and so has more process
associated with it than your typical Puppet module.

This module is under the direction of the openstack-infra team.
Website: http://docs.openstack.org/infra/system-config/

The official git repository is at:
https://git.openstack.org/cgit/openstack-infra/puppet-httpd/

Bugs can be submitted against this module at:
https://storyboard.openstack.org/#!/search?q=puppet-httpd

And contributions should be submitted through review.openstack.org
by following http://docs.openstack.org/infra/manual/developers.html


# Contact

You can reach the maintainers of this module on freenode in #openstack-infra
and on the openstack-infra mailing list.





