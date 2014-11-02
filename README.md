baikal-mod
==========

Baikal 0.27 modded

Addes a few modifications mostly DB level.

Create 2 db users for baikal.
One has all DML priviledges, and one is only SELECT.

Select user is used for GLOBAL all users sharing. This will enable read only when you use a GLOBAL
addressbook that is IMPORTED from a PHP script or other source to the database. 

Admin has been removed from the repository becase I havent made any new mods on ot regarding administration.

So when you enable sharing you would need to use a DB GUI tool for now at least.

Import the baikal modded SQL database / sql file.

Edit the config.system.php and look at the notes. 

You have 2 static principals that you need to know. One would be COMPANY. If you rename it
please rename it also in config file and principals, calendars and addressbooks table in DB.

Other would be SHAREDTO principal. This one is used as a universal principal where you would share
other calendars or addressbook which are under SHAREDTO principal. The trick here is that this
account MUST NOT BE available DIRECTLY using URL GET/PROPFIND/PUT/DELETE etc.... 

Shared account are used using a column in addressbooks and calendars. Use short usernames. User logins.
These are comma seperated but it does not matter that much because I am using a LIKE SQL query on that field.
This can be made better but it works atleast. If you type all then cal/card will be available to everyone.
These users have full read and write access to this kind of sharing. There is no read only access on shares.
If someone deletes something just check accesslogs or do backups more frequently. I was thinking about
read only shares. But they must not be on db level... Didnt get any fast idea how to hack this.

Next important part would be that you dont use DEFAULT uri or /user/defeaut as defined in URI for
calendars and addressbooks. 

so url to that user share would be like /card.php/addressbooks/john/pim_john

user calendar or addressbook / just switch names:
/card.php/addressbooks/john/pim_john
/cal.php/calendars/john/pim_john
/cal.php/calendars/john/pim_sandy

shared method between users
/card.php/addressbooks/john/pim_sandy

shared method company addressbook
/card.php/addressbooks/john/pim_company_gal
-see that uri has company in it ... when its found by config.system.php it will use mysql read user
-so data wont be deleted since its global read only

remember that URI must be UNIQUE now. you cant have two pim_john or similar. /not sure if that gonna happen.

I forgot to mention that this mod used IMAP authentication as default and its tied to it.
So I hope you have a imap account somewhere. But you can mod it yourself a little.
If u use imap you will have a cache login of 4hours i think. So imap server load wont be high.
This was intentional because I have 200 users to install cal/card client :D

So other mods would be:
/ip filter if you have imap internal and external like dovecot acting as a proxy that has only some users allowed to connect.
/protected sharedto from direct linking
/readonly account redirect to mysql user with only select priviledges
/ban default password from external server/ this would be if users in a office all have same password.. so you can ban
access to them if they are connecting from the internet.

Just as a advice. You could really use HTTPs on this. Since its a nice combo so your password are at least encrypted
if sent over the net.

Mobile devices:
/iphone 3gs ios6.1.6
/iphone 4
/iphone 5
all seem to work well. use /well-known redirection if u use iphones and android too.... 

android carddav sync also has auto discovery.. use above redirection so you will get a list of all
addressbooks to add 1 by 1 multiple times... android cant add all addressbooks in 1 hit. 

iphone adds all available addressbooks and calendars... 

works with thunderbird and lightning well. if you use SOGo connector you must install Lightning before it as well because
it won-t work standalone... not sure why... but it wont sync if alone... :D

works on mac iCal and addressbook... but addressbook on lion 10.7 does not sync all addressbooks. calendars are all visible...
seems i need to fix it a little.... 

i did not try:
/windows phone
/blackberry os 10

i used nginx with php-fpm and mysql 5.5... 

SQL query for both cal and card will give you all available data on autodiscovery when used properly.
1st login on IMAP auto creates all data and adds user to groupmembers for COMPANY and SHAREDTO ID in DB.

I think this would be all.. will edit if something is missed :D !

















