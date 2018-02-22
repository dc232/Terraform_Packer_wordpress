#!/bin/bash
#cd /usr/share/nginx/html
cat << "EOF" >> /var/www/html/wp-config.php
<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'dbtest');

/** MySQL database username */
define('DB_USER', 'dbusername');

/** MySQL database password */
define('DB_PASSWORD', 'dbpassword');

/** MySQL hostname */
define('DB_HOST', 'dbhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8mb4');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '?bru(VEX<W`hUDI(CTjk_H;OyGI<WO{B4**Duou&RxRqOeAi{c#sI(Isb(YKbB?)');
define('SECURE_AUTH_KEY',  ';,s<pZ[@}&O`~:E }b(AL#4<PZ]dQm%I]nRTGbCxm!VI*)69*z=>].Z$&|J>ZYr~');
define('LOGGED_IN_KEY',    'eK a_p*ja=b.C</aX2VqSntS@x6kHfeL&baw)@;Mh_n x8:yS0H&I5&#&$%xAMAI');
define('NONCE_KEY',        'c80ljK)&[C,c%tSxsJLjHhEPX=1(1%]$r1{Ff7N)?(GbC)Is^krN.-P^Rjx36C{j');
define('AUTH_SALT',        '+P@D#LQ@`2KL+c}@qC%Ka{H_mO*u)EZ3|]JID]mFk[jY139uD?^b%r{7[}:Fsju,');
define('SECURE_AUTH_SALT', 'fmgPrB[[I 4LITaH}W#s_zxBl7_g|_H%1L4Pwng`yh6b`M>>-f6h<7$RqKjXDK!j');
define('LOGGED_IN_SALT',   'Gw.<slu{OP~NF@{e XMb:tzQ$sOWM,g@#f@PlIgzc5 UCdn^Rk4:R!Y89D$c0(<,');
define('NONCE_SALT',       '[Pv@uA[D+<mt8v2lShH>G_$A^=U-5bGzXaC#^gUx$@)sm{=X/_[xMdaVNu4wJ|_2');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
EOF