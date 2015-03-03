#!/usr/bin/perl 

use Term::ANSIColor qw(:constants);
use strict "refs";

my @moduleArray = (  {module => "CGI", tested_versions => "4.010", prohibited_versions => ""}
		, {module => "Digest-SHA", tested_versions => "5.47", prohibited_versions => ""}
		, {module => "TimeDate", tested_versions => "2.24", prohibited_versions => ""}
		, {module => "DateTime", tested_versions => "1.12", prohibited_versions => ""}
		, {module => "DateTime-TimeZone", tested_versions => "1.79", prohibited_versions => ""}
		, {module => "DBI", tested_versions => "1.632", prohibited_versions => ""}
		, {module => "Template::Toolkit", tested_versions => "2.26", prohibited_versions => ""}
		, {module => "Email::Send", tested_versions => "2.199", prohibited_versions => ""}
		, {module => "Email::MIME", tested_versions => "1.926", prohibited_versions => ""}
		, {module => "URI", tested_versions => "1.65", prohibited_versions => ""}
		, {module => "List::MoreUtils", tested_versions => "0.33", prohibited_versions => ""}
		, {module => "Math::Random::ISAAC", tested_versions => "1.004", prohibited_versions => ""}
		, {module => "DBD::mysql", tested_versions => "4.028", prohibited_versions => ""}
		, {module => "GD", tested_versions => "12", prohibited_versions => ""}
		, {module => "Chart", tested_versions => "2.4.6", prohibited_versions => ""}
		, {module => "Template::GD", tested_versions => "1.56", prohibited_versions => ""}
		, {module => "GDTextUtil", tested_versions => "0.86", prohibited_versions => ""}
		, {module => "GDGraph", tested_versions => "1.48", prohibited_versions => ""}
		, {module => "MIME::tools", tested_versions => "5.505", prohibited_versions => ""}
		, {module => "libwww::perl", tested_versions => "6.06", prohibited_versions => ""}
		, {module => "XML::Twig", tested_versions => "3.48", prohibited_versions => ""}
		, {module => "PatchReader", tested_versions => "0.9.6", prohibited_versions => ""}
		, {module => "perl::ldap", tested_versions => "0.64", prohibited_versions => ""}
		, {module => "Authen::SASL", tested_versions => "2.16", prohibited_versions => ""}
		, {module => "Net::SMTP::SSL", tested_versions => "1.01", prohibited_versions => ""}
		, {module => "RadiusPerl", tested_versions => "0.24", prohibited_versions => ""}
		, {module => "SOAP::Lite", tested_versions => "1.11, 1.12", prohibited_versions => "1.15, 1.13"}
		, {module => "XMLRPC::Lite", tested_versions => "0.717", prohibited_versions => ""}
		, {module => "JSON::RPC", tested_versions => "1.06", prohibited_versions => ""}
		, {module => "JSON::XS", tested_versions => "3.01", prohibited_versions => ""}
		, {module => "Test::Taint", tested_versions => "1.06", prohibited_versions => ""}
		, {module => "HTML::Parser", tested_versions => "3.71", prohibited_versions => ""}
		, {module => "HTML::Scrubber", tested_versions => "0.11", prohibited_versions => ""}
		, {module => "Encode", tested_versions => "2.35", prohibited_versions => ""}
		, {module => "Encode::Detect", tested_versions => "1.01", prohibited_versions => ""}
		, {module => "Email::Reply", tested_versions => "1.203", prohibited_versions => ""}
		, {module => "HTML::FormatText-WithLinks", tested_versions => "0.14", prohibited_versions => ""}
		, {module => "File::Slurp", tested_versions => "9999.19", prohibited_versions => ""}
		, {module => "File::Mime", tested_versions => "0.26", prohibited_versions => ""}
		, {module => "IO::stringy", tested_versions => "2.110", prohibited_versions => ""}
		);
#check module existence
sub module_exist{
	my ($current_version) = @_;
	if ($current_version eq "") {
		return 0;
	} else {
		return 1;
	}
}

#check whether the current version is prohibited or tested
sub test_version{
	my ($current_version, $exist, @test_versions) = @_;
	if($exist) {
		foreach my $j (0 .. $#test_versions) {
			if($test_versions[$j] eq $current_version) {
				return 1;
			} 
		}
	}
	return 0;
}

#print the appropriate output
sub print_output{
	my ($wanted_module, $current_version, $is_tested, $is_prohibited, $tested_version, $exist) = @_;

	if($exist) {
		print GREEN, "module $wanted_module installed version $current_version \n", RESET;
		if($is_prohibited) {
			print RED, "Version $current_version of this module not supported\n", RESET;
			if($tested_version ne "") {
				print BLUE, "Tested version(s) : $tested_version\n", RESET;
			}
		}
		#Display the tested modules if the installed one is not in the list
		else { 
			if(!$is_tested && $tested_version ne "") {
				print YELLOW, "Tested version(s) : $tested_version\n", RESET;
			}
		}
	} else {
		print RED, "module $wanted_module missing\n", RESET;
	}
	print "\n\n";
}

#########################################
#main
#########################################
my $wanted_module;
my $current_version;
my @tested_versions;
my @prohibited_versions;
my $is_tested;
my $is_prohibited;
my $exist;
my $tested_versions;

foreach my $i (0 .. $#moduleArray) {
	$is_tested = 0;
	$is_prohibited = 0;

	$wanted_module = $moduleArray[$i]{'module'};
	eval "require ($wanted_module)";

	no strict 'refs';
	$current_version = ${"$moduleArray[$i]{'module'}::VERSION"};
	use strict 'refs';

	#split the tested version's array and the prohibited verion's array
	@tested_versions = split (/, /, $moduleArray[$i]{'tested_versions'});
	@prohibited_versions = split (/, /, $moduleArray[$i]{'prohibited_versions'});
	
	$exist = module_exist ($current_version);
	$is_tested = test_version($current_version, $exist, @tested_versions);
	$is_prohibited = test_version($current_version, $exist, @prohibited_versions);
	
	$tested_versions = $moduleArray[$i]{'tested_versions'};
	print_output($wanted_module, $current_version, $is_tested, $is_prohibited, $tested_versions, $exist);
}
