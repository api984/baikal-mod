<?php
##############################################################################
#
#	Copyright notice
#
#	(c) 2014 Jérôme Schneider <mail@jeromeschneider.fr>
#	All rights reserved
#
#	http://baikal-server.com
#
#	This script is part of the Baïkal Server project. The Baïkal
#	Server project is free software; you can redistribute it
#	and/or modify it under the terms of the GNU General Public
#	License as published by the Free Software Foundation; either
#	version 2 of the License, or (at your option) any later version.
#
#	The GNU General Public License can be found at
#	http://www.gnu.org/copyleft/gpl.html.
#
#	This script is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#	GNU General Public License for more details.
#
#	This copyright notice MUST APPEAR in all copies of the script!
#
##############################################################################

##############################################################################
# System configuration
# Should not be changed, unless YNWYD
#
# RULES
#	0. All folder pathes *must* be suffixed by "/"
#	1. All URIs *must* be suffixed by "/" if pointing to a folder
#

# PATH to SabreDAV
define("BAIKAL_PATH_SABREDAV", PROJECT_PATH_FRAMEWORKS . "SabreDAV/lib/Sabre/");

# If you change this value, you'll have to re-generate passwords for all your users

//watch out for this one.... //// if changed you will need to refresh passwords... i kept default settings

define("BAIKAL_AUTH_REALM", 'BaikalDAV');

//this will atach a domain to the username as an email address
define("COMPANY_DOMAIN", '@company.local');

# Should begin and end with a "/"
define("BAIKAL_CARD_BASEURI", PROJECT_BASEURI . "card.php/");

# Should begin and end with a "/"
define("BAIKAL_CAL_BASEURI", PROJECT_BASEURI . "cal.php/");

# Define path to Baïkal Database SQLite file
define("PROJECT_SQLITE_FILE", PROJECT_PATH_SPECIFIC . "db/db.sqlite");

# MySQL > Use MySQL instead of SQLite ?
define("PROJECT_DB_MYSQL", TRUE); //IMPORTANT for this setup!

# MySQL > Host, including ':portnumber' if port is not the default one (3306)
define("PROJECT_DB_MYSQL_HOST", 'localhost');

# MySQL > Database name
define("PROJECT_DB_MYSQL_DBNAME", 'caldav');

//using static principal SHAREDTO
//we deny direct access because all users can see all shared calendars
//this way
//we enfore using column in database shared_to to give them access

//take a look at usernames used here. one has read and other has write

if(strpos($_SERVER['REQUEST_URI'],'SHAREDTO') === false){
	//principal COMPANY as a word in URI
    //create user caldav_cal with SELECT priviledges ONLY
    //use this user from command line to push data into mysql
    //you can extend this by adding a value that will always be used in uris
    //like shared_read_something
    
	if (strpos($_SERVER['REQUEST_URI'],'COMPANY') !== false OR strpos($_SERVER['REQUEST_URI'],'company') !== false) {
	    define("PROJECT_DB_MYSQL_USERNAME", 'caldav_gal');
	    //echo 'GAL Access';
	}else{

		# MySQL > Username
		define("PROJECT_DB_MYSQL_USERNAME", 'caldav');
	}	
}else{
    //using HTTPS or HTTP // switch https with http if needed
	header("Location: https://".$_SERVER['HTTP_HOST']);
}
	

//IMAP server switch if using 2 imap servers 
//current setup is for internal imap server and dovecot proxy server that has
//filtered users who can access IMAP mail if their password is strong and non
//default when they logon to their workstations if IMAP server is using LDAP
//backend or Kerberos to authenticate users


//dont forget to add your local subnet here if its not added just use
//same config on both imap server lines

$subject = $_SERVER['REMOTE_ADDR'];
$pattern = '/^(192\.168\.0\.*|192\.168\.1\.*|192\.168\.2\.*)/';

define('DEFAULT_IMAP_PASSWORD','user');

if(preg_match($pattern, $subject)){

	//echo 'using ulas01';
	define("IMAP_SERVER","{imap.server.local:143/imap/novalidate-cert}");
	define('ACL_DIP','allow');

} else {

	//echo 'using proxy';
	define("IMAP_SERVER","{dovecotproxy.server.local:143/imap/novalidate-cert}");
	define('ACL_DIP','deny');
}

# MySQL > Password
define("PROJECT_DB_MYSQL_PASSWORD", 'password');

# A random 32 bytes key that will be used to encrypt data
//you can use from your previous baikal installation if you want
define("BAIKAL_ENCRYPTION_KEY", 'add a encryption key here from');

# The currently configured Baïkal version
define("BAIKAL_CONFIGURED_VERSION", '0.2.7');
