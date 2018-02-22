# Terraform_Packer_wordpress
An experiment to see if a wordpress AMI can be made as automatically as possible 
some user intervention is needed becuase of the way the secrets work

To make it work simply ensure that you specifiy your AWS credentials either in:

~/.aws/credentials

or within RDS.tf

The script by deafult will assume you have set up the AWS credentials this way via the AWS command line 
I plan to relase an update to the Hashicorp suite install script to add the AWS secret and Acess keys via the .aws folder

Please also update these paramters in the wordpress_wpconfig.sh file otherwise this can lead to security issues
to do this go to https://api.wordpress.org/secret-key/1.1/salt/
Then copy and paste as required, The only reason this part is not yet automated is becuase I have not yet worked out a good way of updating the salt information 

define('AUTH_KEY',         '?bru(VEX<W`hUDI(CTjk_H;OyGI<WO{B4**Duou&RxRqOeAi{c#sI(Isb(YKbB?)');
define('SECURE_AUTH_KEY',  ';,s<pZ[@}&O`~:E }b(AL#4<PZ]dQm%I]nRTGbCxm!VI*)69*z=>].Z$&|J>ZYr~');
define('LOGGED_IN_KEY',    'eK a_p*ja=b.C</aX2VqSntS@x6kHfeL&baw)@;Mh_n x8:yS0H&I5&#&$%xAMAI');
define('NONCE_KEY',        'c80ljK)&[C,c%tSxsJLjHhEPX=1(1%]$r1{Ff7N)?(GbC)Is^krN.-P^Rjx36C{j');
define('AUTH_SALT',        '+P@D#LQ@`2KL+c}@qC%Ka{H_mO*u)EZ3|]JID]mFk[jY139uD?^b%r{7[}:Fsju,');
define('SECURE_AUTH_SALT', 'fmgPrB[[I 4LITaH}W#s_zxBl7_g|_H%1L4Pwng`yh6b`M>>-f6h<7$RqKjXDK!j');
define('LOGGED_IN_SALT',   'Gw.<slu{OP~NF@{e XMb:tzQ$sOWM,g@#f@PlIgzc5 UCdn^Rk4:R!Y89D$c0(<,');
define('NONCE_SALT',       '[Pv@uA[D+<mt8v2lShH>G_$A^=U-5bGzXaC#^gUx$@)sm{=X/_[xMdaVNu4wJ|_2'); 

