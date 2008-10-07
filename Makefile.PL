use strict;
use inc::Module::Install;
name 'POE-Component-SmokeBox';
author 'Chris Williams <chris@bingosnet.co.uk>';
license 'perl';
perl_version '5.006';
abstract_from 'lib/POE/Component/SmokeBox.pm';
version_from 'lib/POE/Component/SmokeBox.pm';
build_requires 'Test::More' => 0.47;
build_requires 'File::Spec' => 0;
requires 'POE' => 1.0001;
requires 'Module::Pluggable' => 0;
requires 'Params::Check' => 0;
requires 'Object::Accessor' => 0;
requires 'Digest::MD5' => 0;
tests 't/*.t t/*/*.t';

print <<NOTICE;

\a--------------------------------------------------------------
Hi,

This is a developer release of POE::Component::SmokeBox.

Thanks for your interest.

Any bug reports, feature requests, send an email to 
<bug-POE-Component-SmokeBox\@rt.cpan.org>

--------------------------------------------------------------

NOTICE

sleep(5);

WriteAll();
