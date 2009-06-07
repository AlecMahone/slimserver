package Slim::Web::Settings::Player::Audio;

# $Id: Basic.pm 10633 2006-11-09 04:26:27Z kdf $

# Squeezebox Server Copyright 2001-2009 Logitech.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License,
# version 2.

use strict;
use base qw(Slim::Web::Settings);

use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Slim::Utils::Strings qw(string);

my $prefs = preferences('server');

sub name {
	return Slim::Web::HTTP::protectName('AUDIO_SETTINGS');
}

sub page {
	return Slim::Web::HTTP::protectURI('settings/player/audio.html');
}

sub needsClient {
	return 1;
}

sub prefs {
	my ($class, $client) = @_;

	my @prefs = qw(powerOnResume lameQuality maxBitrate);

	if ($client->hasPowerControl()) {
		push @prefs,'powerOffDac';
	}
	
	if ($client->hasDisableDac()) {
		push @prefs,'disableDac';
	}

	if ($client->maxTransitionDuration()) {
		push @prefs,qw(transitionType transitionDuration transitionSmart);
	}
	
	if ($client->hasDigitalOut()) {
		push @prefs,qw(digitalVolumeControl mp3SilencePrelude);
	}

	if ($client->hasPreAmp()) {
		push @prefs,'preampVolumeControl';
	}
	
	if ($client->hasAesbeu()) {
		push @prefs,'digitalOutputEncoding';
	}

	if ($client->hasExternalClock()) {
		push @prefs,'clockSource';
	}

	if ($client->hasEffectsLoop()) {
		push @prefs,'fxloopSource';
	}

	if ($client->hasEffectsLoop()) {
		push @prefs,'fxloopClock';
	}

	if ($client->hasPolarityInversion()) {
		push @prefs,'polarityInversion';
	}
	
	if ($client->hasDigitalIn()) {
		push @prefs,'wordClockOutput';
	}
	
	if ($client->canDoReplayGain(0)) {
		push @prefs,'replayGainMode';
	}

	if ($client->isa('Slim::Player::Boom')) {
		push @prefs, 'analogOutMode', 'bass', 'treble', 'stereoxl';
		
		if (Slim::Utils::PluginManager->isEnabled('Slim::Plugin::LineIn::Plugin')) {
			push @prefs, 'lineInLevel', 'lineInAlwaysOn';
		}
	}
	
	if ( $client->isa('Slim::Player::Squeezebox2') ) {
		push @prefs, 'mp3StreamingMethod';
	}

	return ($prefs->client($client), @prefs);
}


sub beforeRender {
	my ($class, $paramRef, $client) = @_;

	# Load any option lists for dynamic options.
	$paramRef->{'lamefound'}  = Slim::Utils::Misc::findbin('lame');
	
	my @formats = $client->formats();

	if ($formats[0] ne 'mp3') {
		$paramRef->{'allowNoLimit'} = 1;
	}

	$paramRef->{'prefs'}->{pref_maxBitrate} = Slim::Utils::Prefs::maxRate($client, 1);
}

1;

__END__
