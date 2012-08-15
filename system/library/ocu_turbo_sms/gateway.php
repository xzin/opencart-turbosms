<?php

/**
 * OpenCart Ukrainian Community
 *
 * LICENSE
 *
 * This source file is subject to the GNU General Public License, Version 3
 * It is also available through the world-wide-web at this URL:
 * http://www.gnu.org/copyleft/gpl.html
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@opencart.ua so we can send you a copy immediately.
 *
 * @category   OpenCart
 * @package    OCU TurboSMS
 * @copyright  Copyright (c) 2011 Eugene Kuligin by OpenCart Ukrainian Community (http://opencart.ua)
 * @license    http://www.gnu.org/copyleft/gpl.html GNU General Public License, Version 3
 */



/**
 * @category   OpenCart
 * @package    OCU TurboSMS
 * @copyright  Copyright (c) 2011 Eugene Kuligin by OpenCart Ukrainian Community (http://opencart.ua)
 * @license    http://www.gnu.org/copyleft/gpl.html GNU General Public License, Version 3
 */

final class OCUTurboSMSGateway
{
    private $_connection;
    private $_error;
    private $_table;
    private $_dlr;

    private $_sign;
    private $_wap;

    public function __construct($host, $login, $password, $db)
    {
        // Connect to remote gateway
        try {
            $this->_connection = new PDO("mysql:host=$host;dbname=$db;charset=UTF8", $login, $password);
            $this->_table = $login;

        } catch (PDOException $e) {
            $this->_error = $e->getMessage();
        }

        // Set transfer encoding
        $this->_connection->query("SET NAMES utf8");

        // Add default DLR
        $this->addDlr('UNSENDED');
        $this->addDlr('ERROR');
        $this->addDlr('SENDED');
        $this->addDlr('ENROUTE');
        $this->addDlr('DELIVRD');
        $this->addDlr('EXPIRED');
        $this->addDlr('DELETED');
        $this->addDlr('UNDELIV');
        $this->addDlr('ACCEPTD');
        $this->addDlr('REJECTD');
        $this->addDlr('UNKNOWN');
        $this->addDlr('RECREDITED');
        $this->addDlr('STOPPED');
        $this->addDlr('REMOVED');

    }



    public function addDlr($status)
    {
        $this->_dlr[] = $status;
    }

    public function getDlr()
    {
        return $this->_dlr;
    }

    public function setSign($sign)
    {
        $this->_sign = $sign;
    }

    public function setWap($wap)
    {
        $this->_wap = $wap;
    }

    public function getConnection()
    {
        return $this->_connection ? $this->_connection : false;
    }

    public function getError()
    {
        return $this->_error ? $this->_error : false;
    }



    public function rowset(array $filter = array(), $rule = 'AND')
    {
        $where = array();

        if (isset($filter['time'])) {
            switch ($filter['time']) {
                case 'today':
                    $where[] = "updated >= FROM_UNIXTIME(" . mktime(0, 0, 0, date('m'), date('d'), date('Y')) .")";
                break;
                case 'tomorrow':
                    $where[] = "updated >= FROM_UNIXTIME(" . mktime(0, 0, 0, date('m'), date('d')-1, date('Y')) .")";
                break;
                case 'week':
                    $where[] = "updated >= FROM_UNIXTIME(" . mktime(0, 0, 0, date('m'), date('d')-7, date('Y')) .")";
                break;
                case 'mount':
                    $where[] = "updated >= FROM_UNIXTIME(" . mktime(0, 0, 0, date('m')-1, date('d'), date('Y')) .")";
                break;
                case 'year':
                    $where[] = "updated >= FROM_UNIXTIME(" . mktime(0, 0, 0, date('m'), date('d'), date('Y')-1) .")";
                break;
            }

        }

        if (isset($filter['dlr_status']) && in_array($filter['dlr_status'], $this->_dlr)) {
            $where[] = "dlr_status = '{$filter['dlr_status']}'";
        }

        if (isset($filter['count']) && $filter['count'] != 'all') {
            $limit = "LIMIT {$filter['count']}";
        } else {
            $limit = "LIMIT 10";
        }

        return $this->_connection->query("SELECT * FROM $this->_table " . (count($where) ? "WHERE " . implode(" $rule ", $where) : false) . " ORDER BY id DESC $limit")
                                 ->fetchAll();
    }


    public function total()
    {
        return $this->_connection->query("SELECT COUNT(*) FROM $this->_table")
                                 ->fetchColumn();
    }


    public function send($number, $message)
    {
        return $this->_connection->exec("INSERT INTO $this->_table ".
                                        "(number, sign, message, send_time, wappush) ".
                                        "VALUES ('$number', '$this->_sign', '$message', NOW(), '$this->_wap')");

    }

    public function remove($id)
    {
        return $this->_connection->exec("DELETE FROM $this->_table WHERE id = $id");
    }
}
