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
 * @copyright  Copyright (c) 2011 Eugene Kuligin by OpenCart Ukrainian Community (http://www.opencart.ua)
 * @license    http://www.gnu.org/copyleft/gpl.html GNU General Public License, Version 3
 */



/**
 * @category   OpenCart
 * @package    OCU TurboSMS
 * @copyright  Copyright (c) 2011 Eugene Kuligin by OpenCart Ukrainian Community (http://www.opencart.ua)
 * @license    http://www.gnu.org/copyleft/gpl.html GNU General Public License, Version 3
 */

class ControllerModuleOCUTurboSMS extends Controller
{

    private $_gateway;
    private $_error;
    private $_version = '1.0';


    public function index()
    {
        $this->_init();

        // If form is posted & receiving data is valid
        if (count($this->request->post) && $this->_validate()) {

            switch (true) {

                // Filter update
                // case isset($this->request->post['filter_form']):
                // break;

                // List update
                case (isset($this->request->post['list_form']) &&
                      isset($this->request->post['item']) &&
                      isset($this->_gateway)):

                    foreach ($this->request->post['item'] as $id => $value) {
                        $this->_gateway->remove($id);
                    }
                break;

                // Settings update
                case isset($this->request->post['setting_form']):

                    // Remove form id from DB config
                    unset($this->request->post['setting_form']);

                    // Save changes to DB
                    $this->model_setting_setting->editSetting('ocu_turbo_sms',
                                                              $this->request->post);

                    // Set success message
                    $this->session->data['success'] = $this->language->get('ocu_turbo_sms_text_success');

                    // Redirect into the main page
                    $this->redirect($this->url->link('extension/module',
                                                     'token=' . $this->session->data['token'],
                                                     'SSL'));
                break;
            }
        }

        $this->_view();
    }


    private function _breadcrumbs()
    {
        $breadcrumbs[] = array(
            'text'      => $this->language->get('text_home'),
            'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
            'separator' => false
        );
        $breadcrumbs[] = array(
            'text'      => $this->language->get('text_module'),
            'href'      => $this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'),
            'separator' => ' :: '
        );
        $breadcrumbs[] = array(
            'text'      => $this->language->get('heading_title'),
            'href'      => $this->url->link('module/ocu_turbo_sms', 'token=' . $this->session->data['token'], 'SSL'),
            'separator' => ' :: '
        );

        return $breadcrumbs;
    }

    private function _init()
    {
        // Load gateway library
        require_once(DIR_SYSTEM . 'library/ocu_turbo_sms/gateway.php');

        // Load settings
        $this->load->model('setting/setting');

        // Load multilanguage language tools
        $this->load->model('localisation/language');

        // Load language
        foreach ($this->load->language('module/ocu_turbo_sms') as $key => $value) {
            $this->data[$key] = $value;
        }


        // Get saved values
        $setting = $this->model_setting_setting->getSetting('ocu_turbo_sms');

        // Set by default form_values
        foreach ($setting as $key => $value) {
            $this->data['value_' . $key] = $value;
        }

        // If gateway configured and connected, create connection object
        if (count($setting)) {
            $this->_gateway = new OCUTurboSMSGateway($this->data['value_ocu_turbo_sms_host'],
                                                     $this->data['value_ocu_turbo_sms_login'],
                                                     $this->data['value_ocu_turbo_sms_password'],
                                                     $this->data['value_ocu_turbo_sms_db']);
        }
    }

    private function _view()
    {
        // Set title
        $this->document->setTitle($this->language->get('heading_title'));

        // Set view variables
        $this->data['breadcrumbs']     = $this->_breadcrumbs();
        $this->data['error']           = $this->_error;
        $this->data['current_version'] = $this->_version;

        // Coming soon
        $this->data['actual_version']  = $this->_version;


        $this->data['languages']       = $this->model_localisation_language->getLanguages();

        $this->data['url_action']      = $this->url->link('module/ocu_turbo_sms', 'token=' . $this->session->data['token'], 'SSL');
        $this->data['url_cancel']      = $this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL');

        // If we have a new form values from request
        foreach ($this->request->post as $key => $value) {
            $this->data['value_' . $key] = $value;
        }

        // If gateway connection is true, set specific variables
        if ($this->_gateway) {
            $this->data['connect_items'] = $this->_gateway->rowset($this->request->post);
            $this->data['total_items'] = $this->_gateway->total();
            $this->data['dlr'] = $this->_gateway->getDlr();
        }

        // Template rendering
        $this->children = array('common/header', 'common/footer');
        $this->template = 'module/ocu_turbo_sms.tpl';
        $this->response->setOutput($this->render());
    }

    private function _validate()
    {

        switch (true) {

            // Filter update
            case isset($this->request->post['filter_form']):
            break;

            // List update
            case isset($this->request->post['list_form']):
            break;

            // Settings update
            case isset($this->request->post['setting_form']):

                if (!$this->user->hasPermission('modify', 'module/ocu_turbo_sms')) {
                    $this->_error = $this->language->get('ocu_turbo_sms_error_permission');
                    return false;
                }

                // Test required fields
                if (empty($this->request->post['ocu_turbo_sms_host'])) {
                    $this->_error = $this->language->get('ocu_turbo_sms_error_host_field');
                    return false;
                }

                if (empty($this->request->post['ocu_turbo_sms_db'])) {
                    $this->_error = $this->language->get('ocu_turbo_sms_error_database_field');
                    return false;
                }

                if (empty($this->request->post['ocu_turbo_sms_login'])) {
                    $this->_error = $this->language->get('ocu_turbo_sms_error_login_field');
                    return false;
                }

                if (empty($this->request->post['ocu_turbo_sms_password'])) {
                    $this->_error = $this->language->get('ocu_turbo_sms_error_password_field');
                    return false;
                }

                // Test connection
                $gateway = new OCUTurboSMSGateway($this->request->post['ocu_turbo_sms_host'],
                                                 $this->request->post['ocu_turbo_sms_login'],
                                                 $this->request->post['ocu_turbo_sms_password'],
                                                 $this->request->post['ocu_turbo_sms_db']);

                if ($gateway->getError()) {

                    $this->_error = 'Connection error: ' . $gateway->getError();
                    return false;
                }

            break;

            default:
                $this->_error = $this->language->get('ocu_turbo_sms_error_request');
        }

        return true;
    }
}

