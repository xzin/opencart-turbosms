<?php echo $header ?>
<style>
  #tabs a {display:inline}
  #tab-status-filter {background:#EFEFEF;border:1px solid #DDDDDD;margin:10px 0;padding:8px}
  #tab-status,#tab-connection,#tab-signature,#tab-admin,#tab-customer,#tab-about {padding:0 10px}
  #tab-status td {padding:5px!important}
  .tab-inner-form {float:left;width:200px;border-right:1px #CCC dotted;margin-right:20px}
  .tab-inner-description {overflow:hidden}
</style>
<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
      <?php echo $breadcrumb['separator'] ?><a href="<?php echo $breadcrumb['href'] ?>"><?php echo $breadcrumb['text'] ?></a>
    <?php } ?>
  </div>
  <?php if ($error) { ?>
    <div class="warning"><?php echo $error; ?></div>
  <?php } ?>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/module.png" /><?php echo $heading_title ?></h1>
      <div class="buttons">
        <a onclick="$('#setting-form').submit();" class="button"><?php echo $button_save ?></a>
        <a onclick="location='<?php echo $url_cancel ?>';" class="button"><?php echo $button_cancel ?></a>
      </div>
    </div>
  <div class="content">
    <div id="tabs" class="htabs">
      <a href="#tab-status" class="selected"><?php echo $ocu_turbo_sms_tab_status ?></a>
      <a href="#tab-connection"><?php echo $ocu_turbo_sms_tab_connection ?></a>
      <a href="#tab-signature"><?php echo $ocu_turbo_sms_tab_signature ?></a>
      <a href="#tab-admin"><?php echo $ocu_turbo_sms_tab_member ?></a>
      <a href="#tab-customer"><?php echo $ocu_turbo_sms_tab_customer ?></a>
      <a href="#tab-about"><?php echo $ocu_turbo_sms_tab_about ?></a>
    </div>
    <div id="tab-status">
      <?php if (isset($connect_items)) { ?>
        <div id="tab-status-filter">
          <form action="<?php echo $url_action ?>" method="post" enctype="multipart/form-data" id="filter-form">
            <?php echo $ocu_turbo_sms_text_send_time ?>:
            <select name="time" onchange="$('#filter-form').submit();">
              <option value=""><?php echo $ocu_turbo_sms_text_all ?></option>
              <option value="today" <?php echo (isset($value_time) && $value_time == 'today' ? 'selected="selected"' : false) ?>><?php echo $ocu_turbo_sms_text_today ?></option>
              <option value="tomorrow" <?php echo (isset($value_time) && $value_time == 'tomorrow' ? 'selected="selected"' : false) ?>><?php echo $ocu_turbo_sms_text_tomorrow ?></option>
              <option value="week" <?php echo (isset($value_time) && $value_time == 'week' ? 'selected="selected"' : false) ?>><?php echo $ocu_turbo_sms_text_last_week ?></option>
              <option value="mount" <?php echo (isset($value_time) && $value_time == 'mount' ? 'selected="selected"' : false) ?>><?php echo $ocu_turbo_sms_text_last_mount ?></option>
              <option value="year" <?php echo (isset($value_time) && $value_time == 'year' ? 'selected="selected"' : false) ?>><?php echo $ocu_turbo_sms_text_last_year ?></option>
            </select>
            <?php echo $ocu_turbo_sms_text_status ?>:
            <select name="dlr_status" onchange="$('#filter-form').submit();">
              <option value=""><?php echo $ocu_turbo_sms_text_all ?></option>
              <?php foreach ($dlr as $dlr) { ?>
                <option value="<?php echo $dlr ?>" <?php echo (isset($value_dlr_status) && $value_dlr_status == $dlr ? 'selected="selected"' : false) ?>><?php echo $dlr ?></option>
              <?php } ?>
            </select>
            <?php echo $ocu_turbo_sms_text_display ?>:
            <select name="count" onchange="$('#filter-form').submit();">
              <option value="10" <?php echo (isset($value_count) && $value_count == '10' ? 'selected="selected"' : false) ?>>10</option>
              <option value="25" <?php echo (isset($value_count) && $value_count == '25' ? 'selected="selected"' : false) ?>>25</option>
              <option value="50" <?php echo (isset($value_count) && $value_count == '50' ? 'selected="selected"' : false) ?>>50</option>
              <option value="100" <?php echo (isset($value_count) && $value_count == '100' ? 'selected="selected"' : false) ?>>100</option>
              <option value="250" <?php echo (isset($value_count) && $value_count == '250' ? 'selected="selected"' : false) ?>>250</option>
              <option value="500" <?php echo (isset($value_count) && $value_count == '500' ? 'selected="selected"' : false) ?>>500</option>
              <option value="all" <?php echo (isset($value_count) && $value_count == 'all' ? 'selected="selected"' : false) ?>><?php echo $ocu_turbo_sms_text_all ?></option>
            </select>
            <input type="hidden" name="filter_form" value="1" />
          </form>
        </div>
        <?php if (count($connect_items)) { ?>
          <form action="<?php echo $url_action ?>" method="post" enctype="multipart/form-data" id="list-form">
            <table class="list">
              <thead>
                <tr>
                  <td><?php echo $ocu_turbo_sms_text_id ?></td>
                  <td><?php echo $ocu_turbo_sms_text_msg_id ?></td>
                  <td><?php echo $ocu_turbo_sms_text_number ?></td>
                  <td><?php echo $ocu_turbo_sms_text_sign ?></td>
                  <td><?php echo $ocu_turbo_sms_text_message ?></td>
                  <td><?php echo $ocu_turbo_sms_text_wappush ?></td>
                  <td><?php echo $ocu_turbo_sms_text_cost ?></td>
                  <td><?php echo $ocu_turbo_sms_text_credits ?></td>
                  <td><?php echo $ocu_turbo_sms_text_send_time ?></td>
                  <td><?php echo $ocu_turbo_sms_text_sended ?></td>
                  <td><?php echo $ocu_turbo_sms_text_updated ?></td>
                  <td><?php echo $ocu_turbo_sms_text_status ?></td>
                  <td><?php echo $ocu_turbo_sms_text_dlr_status ?></td>
                  <td><input type="checkbox" name="mcheck" id="mcheck" value="1" title="<?php echo $ocu_turbo_sms_text_check_all ?>" /></td>
                </tr>
              </thead>
              <tbody>
              <?php $displayed_items = 0 ?>
              <?php foreach ($connect_items as $item) { ?>
              <?php $displayed_items++ ?>
                <tr>
                  <td><?php echo $item['id'] ?></td>
                  <td><?php echo $item['msg_id'] ?></td>
                  <td><?php echo $item['number'] ?></td>
                  <td><?php echo $item['sign'] ?></td>
                  <td><?php echo $item['message'] ?></td>
                  <td><?php echo $item['wappush'] ?></td>
                  <td><?php echo $item['cost'] ?></td>
                  <td><?php echo $item['credits'] ?></td>
                  <td><?php echo $item['send_time'] ?></td>
                  <td><?php echo $item['sended'] ?></td>
                  <td><?php echo $item['updated'] ?></td>
                  <td><?php echo $item['status'] ?></td>
                  <td><?php echo $item['dlr_status'] ?></td>
                  <td><input type="checkbox" name="item[<?php echo $item['id'] ?>]" class="ccheck" value="1" /></td>
                </tr>
              <?php } ?>
              </tbody>
            </table>
            <input type="hidden" name="list_form" value="1" />
          </form>
          <div class="buttons" style="float:right">
            <a onclick="$('#list-form').submit();" class="button"><?php echo $ocu_turbo_sms_text_delete ?></a>
          </div>
          <?php echo $ocu_turbo_sms_text_displayed ?>: <?php echo $displayed_items ?> / <?php echo $total_items ?>
        <?php } else { ?>
          <?php echo $ocu_turbo_sms_text_items_not_found ?>
        <?php } ?>
      <?php } else { ?>
        <?php echo $ocu_turbo_sms_text_welcome ?>
      <?php } ?>
    </div>
      <form action="<?php echo $url_action ?>" method="post" enctype="multipart/form-data" id="setting-form">
        <div id="tab-connection">
          <div class="tab-inner-form">
            <p>
              <label>
                <?php echo $ocu_turbo_sms_text_host ?> <span class="required">*</span><br />
                <input type="text" name="ocu_turbo_sms_host" value="<?php echo (isset($value_ocu_turbo_sms_host) ? $value_ocu_turbo_sms_host : false) ?>" />
              </label>
            </p>
            <p>
              <label>
                <?php echo $ocu_turbo_sms_text_db ?> <span class="required">*</span><br />
                <input type="text" name="ocu_turbo_sms_db" value="<?php echo (isset($value_ocu_turbo_sms_db) ? $value_ocu_turbo_sms_db : false) ?>" />
              </label>
            </p>
            <p>
              <label>
                <?php echo $ocu_turbo_sms_text_login ?> <span class="required">*</span><br />
                <input type="text" name="ocu_turbo_sms_login" value="<?php echo (isset($value_ocu_turbo_sms_login) ? $value_ocu_turbo_sms_login :false) ?>" />
              </label>
            </p>
            <p>
              <label>
                <?php echo $ocu_turbo_sms_text_password ?> <span class="required">*</span><br />
                <input type="password" name="ocu_turbo_sms_password" value="<?php echo (isset($value_ocu_turbo_sms_password) ? $value_ocu_turbo_sms_password : false) ?>" />
              </label>
            </p>
            <p><?php echo ((!$error && !empty($value_ocu_turbo_sms_host) && !empty($value_ocu_turbo_sms_login) && !empty($value_ocu_turbo_sms_password) && !empty($value_ocu_turbo_sms_db)) ? $ocu_turbo_sms_text_connection_established : $ocu_turbo_sms_text_connection_error) ?></p>
          </div>
          <div class="tab-inner-description">
            <p>
              <?php echo $ocu_turbo_sms_text_connection_tab_description ?>
            </p>
          </div>
        </div>
        <div id="tab-signature">
          <div class="tab-inner-form">
            <p>
              <label>
                <?php echo $ocu_turbo_sms_text_signature ?><br />
                <?php foreach ($languages as $language) : ?>
                  <p>
                    <img src="view/image/flags/<?php echo $language['image']; ?>" title="<?php echo $language['name']; ?>" />
                    <textarea name="ocu_turbo_sms_signature[<?php echo $language['code']; ?>]"><?php echo isset($value_ocu_turbo_sms_signature[$language['code']]) ? $value_ocu_turbo_sms_signature[$language['code']] : false; ?></textarea>
                  </p>
                <?php endforeach; ?>
              </label>
            </p>
          </div>
          <div class="tab-inner-description">
            <p>
              <?php echo $ocu_turbo_sms_text_signature_tab_description ?>
            </p>
          </div>
        </div>
        <div id="tab-admin">
          <p>
            <?php echo $ocu_turbo_sms_text_notify_by_sms ?>:
          </p>
          <p>
            <label>
              <input type="checkbox" name="ocu_turbo_sms_admin_new_customer" value="1" <?php echo (isset($value_ocu_turbo_sms_admin_new_customer) ? 'checked="checked"' : false) ?> />
              <?php echo $ocu_turbo_sms_text_admin_new_customer ?>
            </label>
          </p>
          <p>
            <label>
              <input type="checkbox" name="ocu_turbo_sms_admin_new_order" value="1" <?php echo (isset($value_ocu_turbo_sms_admin_new_order) ? 'checked="checked"' : false) ?> />
              <?php echo $ocu_turbo_sms_text_admin_new_order ?>
            </label>
          </p>
          <p>
            <label>
              <input type="checkbox" name="ocu_turbo_sms_admin_new_email" value="1" <?php echo (isset($value_ocu_turbo_sms_admin_new_email) ? 'checked="checked"' : false) ?> />
              <?php echo $ocu_turbo_sms_text_admin_new_email ?>
            </label>
          </p>
          <br />
          <hr />
          <p>
            <label>
              <input type="checkbox" name="ocu_turbo_sms_admin_gareway_connection_error" value="1" <?php echo (isset($value_ocu_turbo_sms_admin_gareway_connection_error) ? 'checked="checked"' : false) ?> />
              <?php echo $ocu_turbo_sms_text_admin_gateway_connection_error ?>
            </label>
          </p>
        </div>
        <div id="tab-customer">
          <p>
            <?php echo $ocu_turbo_sms_text_notify_by_sms ?>:
          </p>
          <p>
            <label>
              <input type="checkbox" name="ocu_turbo_sms_customer_new_order_status" value="1" <?php echo (isset($value_ocu_turbo_sms_customer_new_order_status) ? 'checked="checked"' : false) ?> />
              <?php echo $ocu_turbo_sms_text_customer_new_order_status ?>
            </label>
          </p>
          <p>
            <label>
              <input type="checkbox" name="ocu_turbo_sms_customer_new_register" value="1" <?php echo (isset($value_ocu_turbo_sms_customer_new_register) ? 'checked="checked"' : false) ?> />
              <?php echo $ocu_turbo_sms_text_customer_new_register ?>
            </label>
          </p>
        </div>
        <div id="tab-about">
          <?php echo sprintf($ocu_turbo_sms_text_about_tab_description, $heading_title, date('Y'), $current_version, $actual_version) ?>
        </div>
        <input type="hidden" name="setting_form" value="1" />
      </form>
    </div>
  </div>
</div>

<script type="text/javascript">
<!--
$('#tabs a').tabs();
$("#mcheck").click( function() {
  if($('#mcheck').attr('checked')){
    $('.ccheck').attr('checked', true);
  } else {
    $('.ccheck').attr('checked', false);
  }
});
//-->
</script>

<?php echo $footer ?>
