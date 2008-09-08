use Test::More tests => 1;
use Config;

my $ok;

warn("\n\nCode borrowed from XML::Twig by MIROD\n");
warn "\nConfiguration:\n\n";

# required
warn "perl: $]\n";
warn "OS: $Config{'osname'} - $Config{'myarchname'}\n";

warn "\n";

warn version( 'POE', 'required' );
warn version( 'Module::Pluggable', 'required' );
warn version( 'Object::Accessor', 'required' );
warn version( 'Params::Check', 'required' );

warn "\n";

warn version( 'Test::More', 'required for build' );
warn version( 'File::Spec', 'required for build' );

warn "\n";

pass("Everything is cool");

exit 0;

sub version
  { my $module= shift;
    my $info= shift || '';
    $info &&= "($info)";
    my $version;
    if( eval "require $module")
      { $ok=1;
        import $module;
        $version= ${"$module\::VERSION"};
        $version=~ s{\s*$}{};
      }
    else
      { $ok=0;
        $version= '<not available>';
      }
    return format_warn( $module, $version, $info);
  }

sub format_warn
  { return  sprintf( "%-25s: %16s %s\n", @_); }

