
<tr><td>ID:</td><td><input type='text' name='MSG_ID' value='%MSG_ID%'/></td></tr>
<tr><td>$_CHAPTERS:</td><td>%CHAPTER_SEL%</td></tr>
<tr><td>$_SUBJECT:</td><td><input type='text' name='SUBJECT' value='%SUBJECT%' size='50'/></td></tr>
<tr><td>$_INNER</td><td><input type=checkbox name=INNER_MSG value=1 %INNER_MSG%></td></tr>
<tr><td>$_MESSAGE</td><td><input type=text name=MESSAGE value='%MESSAGE%' size=45></td></tr>
<tr><td>$_STATE:</td><td>%STATE_SEL%</td></tr>
<tr><td>$_PRIORITY:</td><td>%PRIORITY_SEL%</td></tr>

<TR><TD>$_EXECUTION $_DATE</TD><TD>$_FROM:
<input type=text name='PLAN_FROM_DATE' value='%PLAN_FROM_DATE%' size=12 ID='PLAN_FROM_DATE' > 
<script language=\"JavaScript\">
	var o_cal = new tcal ({	'formname': 'form_search',	'controlname': 'PLAN_FROM_DATE'	});
	
	// individual template parameters can be modified via the calendar variable
	o_cal.a_tpl.yearscroll = false;
	o_cal.a_tpl.weekstart  = 1;
 	o_cal.a_tpl.months     = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
	o_cal.a_tpl.weekdays   = ['Sun', 'Mon', 'Tue', 'Wen', 'Thu', 'Fri', 'Sat'];
</script>

$_TO: <input type=text name='PLAN_TO_DATE' value='%PLAN_TO_DATE%' size=12 ID='PLAN_TO_DATE' > 
<script language=\"JavaScript\">
	var o_cal = new tcal ({	'formname': 'form_search',	'controlname': 'PLAN_TO_DATE'	});
	
	// individual template parameters can be modified via the calendar variable
	o_cal.a_tpl.yearscroll = false;
	o_cal.a_tpl.weekstart  = 1;
 	o_cal.a_tpl.months     = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
	o_cal.a_tpl.weekdays   = ['Sun', 'Mon', 'Tue', 'Wen', 'Thu', 'Fri', 'Sat'];
</script>


</TD></TR>

