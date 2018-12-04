#!/usr/bin/perl -w

use strict;

use LWP::UserAgent;
use Text::CSV_XS qw( csv );
use JSON::PP qw(decode_json);
# Uncomment these for debugging
# use LWP::ConsoleLogger::Easy qw( debug_ua );
# use Data::Dumper;
my @array=`cat ids1.csv | cut -d "," -f 2`;
my $i=0;
for ($i=0;$i<115;$i++)
{
my $PROJECT_ID="$array[$i]"; # numeric project id, can be found in project -> general settings
my $GITLAB_API_PRIVATE_TOKEN='Av2QWijsvF8x4BkLV-w5'; # obtained from https://gitlab.com/profile/personal_access_tokens
my $baseurl = "https://gitlab.com/"; # change if using a private install
chomp $array[$i];
my $username = "$array[$i].csv";
$baseurl .= "api/v4/";
my $issuesurl = $baseurl."projects/".$PROJECT_ID."/issues";

my @issues = ();
my $page = 1;
my $totalpages;

do
{

	my %query_hash = (
			'per_page' => 100,
			'page' => $page
			);

	print "Fetching page $page".(defined($totalpages)?" (of $totalpages)":"")."\n";

	my $ua = LWP::UserAgent->new();
# debug_ua($ua);
	$ua->default_header('PRIVATE-TOKEN' => $GITLAB_API_PRIVATE_TOKEN);

	my $uri = URI->new($issuesurl);
	$uri->query_form(%query_hash);
	my $resp = $ua->get($uri);
	if (!$resp->is_success) {
		die $resp->status_line;
	}
	$totalpages = int($resp->header("X-Total-Pages"));

	my $resptext;
	$resptext = $resp->decoded_content;

	my $issuedata = decode_json($resptext);

	push(@issues, @{$issuedata});
}
while ($page++ < $totalpages);

my $outputfname = "issues.csv";
my $csv = Text::CSV_XS->new ({ binary => 1, eol => $/ });
open my $fh, ">", $username or die "$username: $!";

my @headings = [
#"URL",
#"Milestone",
#"Author",
	"Title",
	"Description",
#"State",
#"Assignees",
	"Labels",
#"Created At",
#"Updated At",
#"Closed At",
#"Due date",
#"Confidental",
#"Weight",
#"Locked",
#"Time estimate",
#"Time spent",
#"Human Time estimate",
#"Human Time spent",
];
$csv->print ($fh, @headings) or $csv->error_diag;

foreach my $i (@issues)
{
#    print Dumper([$i])."\n";
	my @values = [
#$i->{'web_url'},
#$i->{'milestone'}->{'title'},
#$i->{'author'}->{'username'},
		$i->{'title'},
		$i->{'description'},
#$i->{'state'},
#join(',', map {$_->{'username'}} @{$i->{'assignees'}}),
		join(',', @{$i->{'labels'}}),
#$i->{'created_at'},
#$i->{'updated_at'},
#$i->{'closed_at'},
#$i->{'due_date'},
#$i->{'confidential'},
#$i->{'weight'},
#$i->{'discussion_locked'},
#$i->{'time_stats'}->{'time_estimate'},
#$i->{'time_stats'}->{'total_time_spent'},
#$i->{'time_stats'}->{'human_time_estimate'},
#$i->{'time_stats'}->{'human_total_time_spent'},
#$i->{'closed_by'}->{'username'},

		];
	$csv->print ($fh, @values) or $csv->error_diag;    
}

close $fh or die "$username: $!";

print "Issues saved to $username\n";
}

