<FORM ACTION='https://www.portmone.com.ua/secure/gate/pay.php' method='POST' >

<TABLE width='500'cellspacing='0' cellpadding='0' border='0'><TR><TD bgcolor='#E1E1E1'>
<TABLE width='100%' cellspacing='1' cellpadding='0' border='0'>
<tr><td class='odd'>

<table width=100%>
<tr><th class='form_title' colspan=2>Visa / Mastercard (Portmone)</th></tr>


<INPUT TYPE='HIDDEN' NAME='PAYEE_ID' VALUE='$conf{PAYSYS_PORTMONE_PAYEE_ID}' />
<INPUT TYPE='HIDDEN' NAME='PAYEE_NAME' VALUE='$conf{WEB_TITLE}'>
<INPUT TYPE='HIDDEN' NAME='PAYEE_HOME_PAGE_URL' VALUE='$conf{PAYSYS_PORTMONE_HOME_PAGE_URL}'>
<INPUT TYPE='HIDDEN' NAME='SHOPORDERNUMBER' VALUE='$FORM{OPERATION_ID}' />
<INPUT TYPE='HIDDEN' NAME='BILL_AMOUNT' VALUE='$FORM{SUM}' />
<INPUT TYPE='HIDDEN' NAME='DESCRIPTION' VALUE='$FORM{DESCRIBE}' />
<INPUT TYPE='HIDDEN' NAME='OUT_URL' VALUE='https://$ENV{SERVER_NAME}:$ENV{SERVER_PORT}/paysys_check.cgi?index=$FORM{index}&sid=$FORM{sid}' />
<INPUT TYPE='HIDDEN' NAME='LANG' VALUE='%LANG%' />

<input type='hidden' name='UID' value='$LIST_PARAMS{UID}'>
<input type='hidden' name='sid' value='$FORM{sid}'>
<input type='hidden' name='IP' value='$ENV{REMOTE_ADDR}'>
<input type='hidden' name='index' value='$index'>
<input type='hidden' name='PAYMENT_SYSTEM' value='45'>


<input type=hidden name='ADD_PARAM[1][NAME]' value='UID' /> 
<input type=hidden name='ADD_PARAM[1][VALUE]' value='$LIST_PARAMS{UID}' />



<tr><td>ID:</td><td>$FORM{OPERATION_ID}</td></tr>
<tr><td>$_DESCRIBE:</td><td>$FORM{DESCRIBE}</td></tr>
<tr><td>$_SUM:</td><td>$FORM{SUM}</td></tr>

<tr><th colspan=2><INPUT TYPE='submit' NAME='submit' VALUE='$_ADD' /></td></tr>

<tr><th colspan=2 align=center>
<a href='https://secure.privatbank.ua/help/verified_by_visa.html'
<img src='/img/v-visa.gif' width=140 height=75 border=0></a>
<a href='http://www.mastercard.com/ru/personal/ru/cardholderservices/securecode/mastercard_securecode.html'>
<img src='/img/mastercard-sc.gif' width=140 height=75 border=0>
</a>
</td></tr>
</table>

<td></tr></table>
<td></tr></table>

</FORM>



