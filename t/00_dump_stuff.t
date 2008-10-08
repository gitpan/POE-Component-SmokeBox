use Test::More tests => 1;
use Config;

my $ok;

diag("\n\nCode borrowed from XML::Twig by MIROD\n");
diag "\nConfiguration:\n\n";

# required
diag "perl: $]\n";
diag "OS: $Config{'osname'} - $Config{'myarchname'}\n";

diag "\n";

diag version( 'POE', 'required' );
diag version( 'Module::Pluggable', 'required' );
diag version( 'Object::Accessor', 'required' );
diag version( 'Params::Check', 'required' );
diag version( 'Digest::MD5', 'required' );

diag "\n";

diag version( 'Test::More', 'required for build' );
diag version( 'File::Spec', 'required for build' );

diag "\n";

sleep 1;

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

