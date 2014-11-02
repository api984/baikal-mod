<?php

namespace Baikal\Core;

/**
 * This is an authentication backend that uses a database to manage passwords.
 *
 * Format of the database tables must match to the one of \Sabre\DAV\Auth\Backend\PDO
 *
 * @copyright Copyright (C) 2013 Lukasz Janyst. All rights reserved.
 * @author Lukasz Janyst <ljanyst@buggybrain.net>
 * @license http://code.google.com/p/sabredav/wiki/License Modified BSD License
 */
class BIMAPauth extends \Sabre\DAV\Auth\Backend\AbstractBasic {

    /**
     * Reference to PDO connection
     *
     * @var PDO
     */
    protected $pdo;

    /**
     * PDO table name we'll be using
     *
     * @var string
     */
    protected $tableName;

    /**
     * Authentication realm
     *
     * @var string
     */
    protected $authRealm;

    /**
     * Creates the backend object.
     *
     * If the filename argument is passed in, it will parse out the specified file fist.
     *
     * @param PDO $pdo
     * @param string $tableName The PDO table name to use
     */
    /**
   * public function __construct(\PDO $pdo, $authRealm, $tableName = 'users') {
*
 *       $this->pdo = $pdo;
 *       $this->tableName = $tableName;
 *       $this->authRealm = $authRealm;
  *  }
    */
    
    public function __construct($imap_server, $pdo, $timeout, $authRealm)
            {
                    $this->imap_server = $imap_server;
                    $this->authRealm = $authRealm;
                    $this->pdo = $pdo;
                    $this->timeout = $timeout;
            }

    /**
     * Validates a username and password
     *
     * This method should return true or false depending on if login
     * succeeded.
     *
     * @param string $username
     * @param string $password
     * @return bool
     */
    public function validateUserPass($username, $password) {

        if(DEFAULT_IMAP_PASSWORD == $password AND ACL_DIP == 'deny') return false;

        $logindigest = md5( $username . ':' . $this->authRealm . ':' . $password );

                    $stmt = $this->pdo->prepare('SELECT username,status FROM users WHERE username = ? AND digesta1 = ? AND mod_time > DATE_SUB(NOW(), INTERVAL ? SECOND)');
                    $stmt->execute(array($username,$logindigest,$this->timeout));
                    $result = $stmt->fetchAll();
                    if ( count($result) === 1 )
                    {
                            //print_r($result);

                            //exit;
                            
                            if($result[0]['status']==0) return false;

                            $this->currentUser = $username;
                            return true;
                    }
                    else
                    {
                            
                    $stmt = $this->pdo->prepare('SELECT username FROM users WHERE username = ? LIMIT 1');
                    $stmt->execute(array($username));
                    $result2 = $stmt->fetchAll();

                        //print_r($result2);

                        //user does not yet exist in DB
                        if ( count($result2) === 0 )
                        {

                                try
                                {
                                        $imap = imap_open($this->imap_server,$username,$password,OP_READONLY);
                                }
                                catch (Exception $e)
                                {
                                       return false;
                                }
                                $stmt = $this->pdo->prepare('REPLACE INTO users (username,digesta1) VALUES( ? , ? )');
                                $stmt->execute(array($username,$logindigest));
                                imap_close( $imap );
                                //buildaj ostala polja
                                $stmt = $this->pdo->prepare('REPLACE INTO principals (uri,email,displayname) VALUES( ? , ? , ?)');
                                $stmt->execute(array('principals/'.$username,$username.COMPANY_DOMAIN,$username));
                                $stmt = $this->pdo->prepare('REPLACE INTO calendars (principaluri,displayname,uri,description) VALUES( ? , ? , ? , ? )');
                                $stmt->execute(array('principals/'.$username, 'Kalendar od '.$username, 'pim_'.$username, 'Kalendar od korisnika '.$username));   
                                $stmt = $this->pdo->prepare('REPLACE INTO addressbooks (principaluri,displayname,uri,description) VALUES( ?, ?, ?, ? )');
                                $stmt->execute(array('principals/'.$username, 'Adresar od '.$username, 'pim_'.$username, 'Adresar od korisnika '.$username));   

                                //DODAJ GAL
                                $stmt = $this->pdo->prepare('SELECT id FROM principals WHERE uri = ?');
                                $stmt->execute(array('principals/'.$username));
                                $result_getid = $stmt->fetchAll();

                                $stmt = $this->pdo->prepare('REPLACE INTO groupmembers (principal_id,member_id) VALUES( ? , ? )');
                                $stmt->execute(array(1,$result_getid['0']['id'])); 
                                $stmt->execute(array(2,$result_getid['0']['id']));
                                $this->currentUser = $username;                       
                                return true;
                        }
                        else
                        {
                                //Update password!
                                if($imap = imap_open($this->imap_server,$username,$password,OP_READONLY)){
                                $stmt = $this->pdo->prepare('UPDATE users SET digesta1 = ? , mod_time = NOW() WHERE username = ? LIMIT 1');
                                $stmt->execute(array($logindigest,$username));
                                imap_close( $imap );
                                $this->currentUser = $username;
                                return true;
                                }
                                else
                                {
                                return false;
                                }

                                

                        }


                    }

    }

}
