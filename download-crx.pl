#!/usr/bin/perl

# Script to download a Google Chrome extension from the Chrome Web
# Store and optionally strip the CRX-specific header and dump the
# remaining ZIP archive.
#
# Author: Axel Beckert <axel@ethz.ch>
# Copyright: 2022 Axel Beckert
#            2022 ETH Zürich IT Security Center
# License: ISC (https://spdx.org/licenses/ISC)
# Credits: Some hints (and license) taken from
#          https://github.com/acvetkov/download-crx/blob/master/src/index.js

use Mojo::Base -strict;
use Mojo::UserAgent;
use Mojo::File;

# Constants / Configuration
my $url = 'https://update.googleapis.com/service/update2/crx?response=redirect&acceptformat=crx3&prodversion=38.0&testsource=download-crx&x=id%3DEXTENSION_ID%26installsource%3Dondemand%26uc';
my $user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36';
my $referer = 'https://chrome.google.com';

sub usage {
    die "Usage: $0 [--zip|-z] <extension id or extension URL>\n".
        "       $0 --extract|-x <file>\n".
        "       $0 [--extract|-x] <file>.crx\n".
        "       $0 [--extract|-x] ./<path to file>\n".
        "       $0 [--extract|-x] ../<path to file>\n".
        "       $0 [--extract|-x] /<path to file>\n";
}

# commandline parameter handling
my $extract_zip = 0;
my $extract_crx = 0;
if (defined($ARGV[0]) and ($ARGV[0] eq '--zip' or $ARGV[0] eq '-z')) {
    $extract_zip = 1;
    shift;
} elsif (defined($ARGV[0]) and
         ($ARGV[0] eq '--extract' or $ARGV[0] eq '-x')) {
    $extract_crx = 1;
    shift;
} elsif (defined($ARGV[0]) and
         (($ARGV[0] =~ m/\.crx$/ and
           $ARGV[0] !~ m(://)) or
          $ARGV[0] =~ m/^\.{0,2}/)) {
    $extract_crx = 1;
}
unless (@ARGV == 1) {
    &usage();
}

if ($extract_crx == 0) {
    my $extension_id;
    if ($ARGV[0] =~ /^[a-z]{32}$/) {
        $extension_id = $ARGV[0];
    }
    elsif ($ARGV[0] =~ m(^\Qhttps://chrome.google.com/webstore/detail/\E[-_A-Za-z0-9]+/([a-z]{32}$))) {
        $extension_id = $1;
    }
    else {
        warn "Can't find extension id in parameter \"$ARGV[0]\"!\n";
        &usage();
    }

    $url =~ s/EXTENSION_ID/$extension_id/;

    my $ua  = Mojo::UserAgent->new;
    my $result = $ua->max_redirects(10)
                    ->get($url => {
                        'Referer' => $referer,
                            'User-Agent' => $user_agent,
                         })->result;

    if ($result->is_success) {
        my $filename = "${extension_id}.crx";
        $result->save_to($filename);
        say "Saved as $filename";

        if ($extract_zip) {
            &extract_zip_from_crx($result->body, "${extension_id}.zip");
        }
    } else {
        warn $result->message;
    }
}
# $extract_crx == 1
else {
    my $filename = $ARGV[0];
    if ($filename !~ /\.crx$/) {
        warn '"'.$filename.'" does not end in ".crx". '.
             "Outcome maybe unexpected.\n";
    }
    $filename =~ s/\.crx$/.zip/;
    unless ($filename =~ /\.zip$/) {
        $filename .= '.zip';
    }
    &extract_zip_from_crx(Mojo::File->new($ARGV[0])->slurp, $filename);

}

sub extract_zip_from_crx {
    my ($crx, $filename) = @_;

    # Parse CRX format, generic part
    my $fixed_header = substr($crx, 0, 16);
    my ($magic, $version, $pubkey_or_header_len, $sign_len) =
        unpack('A4I4I4I4', $fixed_header);
    #say ($magic, ' ', $version, ' ', $pubkey_or_header_len);
    warn "Unknown magic \"$magic\", tool may fail.\n"
        unless $magic eq "Cr24";

    my $zip_file = Mojo::File->new($filename);

    # Format 2, according to
    # http://www.dre.vanderbilt.edu/~schmidt/android/android-4.0/external/chromium/chrome/common/extensions/docs/crx.html
    if ($version == 2) {
        my $zip = substr($crx, 16 + $pubkey_or_header_len + $sign_len);
        $zip_file->spurt($zip);
        }
    # Format 3, according to https://github.com/ahwayakchih/crx3/blob/master/lib/crx3.proto
    elsif ($version == 3) {
        my $zip = substr($crx, 12 + $pubkey_or_header_len);
        $zip_file->spurt($zip);
    }
    else {
        die "Unknown CRX version $version, ZIP file extraction not suppport (yet).\n"
    }
    say "Saved as $filename";
}
