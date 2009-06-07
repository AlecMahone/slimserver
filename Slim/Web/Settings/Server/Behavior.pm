package Slim::Web::Settings::Server::Behavior;

# $Id$

# Squeezebox Server Copyright 2001-2009 Logitech.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License,
# version 2.

use strict;
use base qw(Slim::Web::Settings);

use Slim::Utils::Prefs;

sub name {
	return Slim::Web::HTTP::protectName('BEHAVIOR_SETTINGS');
}

sub page {
	return Slim::Web::HTTP::protectURI('settings/server/behavior.html');
}

sub prefs {
	return (preferences('server'),
			qw(noGenreFilter searchSubString ignoredarticles splitList
			   browseagelimit groupdiscs persistPlaylists reshuffleOnRepeat saveShuffled composerInArtists
			   conductorInArtists bandInArtists variousArtistAutoIdentification useBandAsAlbumArtist 
			   useTPE2AsAlbumArtist variousArtistsString ratingImplementation)
		   );
}

sub handler {
	my ( $class, $client, $paramRef ) = @_;
	
	$paramRef->{ratingImplementations} = Slim::Schema->ratingImplementations;

	return $class->SUPER::handler( $client, $paramRef );
}


1;

__END__
