package Abills::HTML;

use strict;
use vars qw(@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $VERSION
   @_COLORS
   %FORM
   %COOKIES
   $SORT
   $DESC
   $PG
   $PAGE_ROWS
   $OP
   $SELF_URL
);

use Exporter;
$VERSION = 2.00;
@ISA = ('Exporter');

@EXPORT = qw(
   &message
   @_COLORS
   %err_strs
   %FORM
   %COOKIES
   $SORT
   $DESC
   $PG
   $PAGE_ROWS
   $OP
   $SELF_URL
);

@EXPORT_OK = ();
%EXPORT_TAGS = ();

my $bg;
#Hash of url params


#**********************************************************
# Create Object
#**********************************************************
sub new {
  my $class = shift;
  my $self = { };
  bless($self, $class);

  %FORM = form_parse();
  %COOKIES = getCookies();
  $SORT = $FORM{sort} || 1;
  $DESC = ($FORM{desc}) ? 'DESC' : '';
  $PG = $FORM{pg} || 0;
  $OP = $FORM{op} || '';
  $PAGE_ROWS = 25;
  my $prot = ($ENV{HTTPS} =~ /on/i) ? 'https' : 'http' ;
  $SELF_URL = "$prot://$ENV{HTTP_HOST}$ENV{SCRIPT_NAME}";

  @_COLORS = ('#FDE302',  # 0 TH
            '#FFFFFF',  # 1 TD.1
            '#eeeeee',  # 2 TD.2
            '#dddddd',  # 3 TH.sum, TD.sum
            '#E1E1E1',  # 4 border
            '#FFFFFF',  # 5
            '#FFFFFF',  # 6
            '#000088',  # 7 vlink
            '#0000A0',  # 8 Link
            '#000000',  # 9 Text
            '#FFFFFF',  #10 background
           ); #border

  $self->{language} = 'english';
  return $self;
}




#*******************************************************************
# Parse inputs from query
# form_parse()
#*******************************************************************
sub form_parse {
  my $self = shift;
  my $buffer = '';
  my $value='';
  my %FORM = ();
  
if ($ENV{'REQUEST_METHOD'} eq "GET") {
   $buffer= $ENV{'QUERY_STRING'};
 }
elsif ($ENV{'REQUEST_METHOD'} eq "POST") {
   read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
 }

my @pairs = split(/&/, $buffer);

foreach my $pair (@pairs) {
   my ($side, $value) = split(/=/, $pair);
   $value =~ tr/+/ /;
   $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   $value =~ s/<!--(.|\n)*-->//g;
   $value =~ s/<([^>]|\n)*>//g;
   if (defined($FORM{$side})) {
     $FORM{$side} .= ", $value";
    }
   else {
     $FORM{$side} = $value;
    }
 }
 return %FORM;
}


#*******************************************************************
#Set cookies
# setCookie($name, $value, $expiration, $path, $domain, $secure);
#*******************************************************************
sub setCookie {
	# end a set-cookie header with the word secure and the cookie will only
	# be sent through secure connections
	my $self = shift;
	my($name, $value, $expiration, $path, $domain, $secure) = @_;
	print "Set-Cookie: ";
	print ($name, "=", $value, "; expires=\"", $expiration,
		"\"; path=", $path, "; domain=", $domain, "; ", $secure, "\n");
}



#********************************************************************
# get cookie values and return hash of it
#
# getCookies()
#********************************************************************
sub getCookies {
        my $self = shift;
	# cookies are seperated by a semicolon and a space, this will split
	# them and return a hash of cookies
	my(@rawCookies) = split (/; /, $ENV{'HTTP_COOKIE'});
	my(%cookies);

	foreach(@rawCookies){
	    my ($key, $val) = split (/=/,$_);
	    $cookies{$key} = $val;
	} 

	return %cookies; 
}



#*******************************************************************
# menu($type, $main_para,_name, $ex_params, \%menu_hash_ref);
#
# $type
#   0 - horizontal  
#   1 - vertical
# $ex_params - extended params
# $mp_name - Menu parameter name
# $params - hash of menu items
# menu($type, $params);
#*******************************************************************
sub menu {
 my $self = shift;
 my ($type, $mp_name, $ex_params, $menu)=@_;
 my @menu_captions = sort keys %$menu;

 $self->{menu} = "<table width=100%>\n";

if ($type == 1) {

  foreach my $line (@menu_captions) {
    my($n, $file, $k)=split(/:/, $line);
    my $link = ($file eq '') ? "$SELF_URL" : "$file";
    $link .= '?'; 
    $link .= "$mp_name=$k&" if ($k ne '');

    $self->{menu} .= "<tr>";
    if ($FORM{$mp_name} eq $k && $file eq '') {
      $self->{menu} .= "<td bgcolor=$_COLORS[3]><a href='$link$ex_params'><b>". $menu->{"$line"} ."</b></a></td>";
     }
    else {
      $self->{menu} .= "<td><a href='$link'>". $menu->{"$line"} ."</a></td>";
     }
    $self->{menu} .= "</tr>\n";
   }
}
else {
  $self->{menu} .= "<tr bgcolor=$_COLORS[0]>\n";
  
  foreach my $line (@menu_captions) {
    my($n, $file, $k)=split(/:/, $line);
    my $link = ($file eq '') ? "$SELF_URL" : "$file";
    $link .= '?'; 
    $link .= "$mp_name=$k&" if ($k ne '');

    $self->{menu} .= "<th";
    if ($FORM{$mp_name} eq $k && $file eq '') {
      $self->{menu} .= " bgcolor=$_COLORS[3]><a href='$link$ex_params'>". $menu->{"$line"} ."</a></th>";
     }
    else {
      $self->{menu} .= "><a href='$link'>". $menu->{"$line"} ."</a></th>\n";
     }

 }
  $self->{menu} .= "</tr>\n"; 
}

 $self->{menu} .= "</table>\n";


 return $self->{menu};
}



#*******************************************************************
# heder off main page
# header()
#*******************************************************************
sub header {
 my $self = shift;
 my($attr)=@_;
 my $admin_name=$ENV{REMOTE_USER};
 my $admin_ip=$ENV{REMOTE_ADDR};
 $self->{header} = "Content-Type: text/html\n\n";

 if ($COOKIES{colors} ne '') {
   @_COLORS = split(/, /, $COOKIES{colors});
  }
 
 if ($COOKIES{language} ne '') {
   $self->{language}=$COOKIES{language};
  }

 my $css = css();


$self->{header} .= q{<!doctype html public "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 <META HTTP-EQUIV="Cache-Control" content="no-cache">
 <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
 <meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
 <meta name="Author" content="Asmodeus">
};

$self->{header} .= $css;
$self->{header} .= q{ <script type="text/javascript" language="javascript">
var confirmMsg  = 'Do you really want delete';
  function confirmLink(theLink, theSqlQuery)
{
    // Confirmation is not required in the configuration file
    if (confirmMsg == '') {
        return true;
    }

    var is_confirmed = confirm(confirmMsg + ' :\n' + theSqlQuery);
    if (is_confirmed) {
        theLink.href += '&is_js_confirmed=1';
    }

    return is_confirmed;
} // end of the 'confirmLink()' function
</script>
<title>~AsmodeuS~ Billing system</title>
</head>} .
"<body bgcolor=$_COLORS[10] text=$_COLORS[9] link=$_COLORS[8]  vlink=$_COLORS[7] leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>";

 return $self->{header};
}

#********************************************************************
#
# css()
#********************************************************************
sub css { 

my $css = "
<style type=\"text/css\">

body {
  background-color: $_COLORS[10];
  color: $_COLORS[9];
  font-family: Arial, Tahoma, Verdana, Helvetica, sans-serif;
  font-size: 14px;
  /* this attribute sets the basis for all the other scrollbar colors (Internet Explorer 5.5+ only) */
}

th.small {
  color: $_COLORS[9];
  font-size: 10px;
  height: 10;
}

td.small {
  color: $_COLORS[9];
  height: 1;
}

th, li {
  color: $_COLORS[9];
  height: 22;
  font-family: Arial, Tahoma, Verdana, Helvetica, sans-serif;
  font-size: 12px;
}

td {
  color: $_COLORS[9];
  font-family: Arial, Tahoma, Verdana, Helvetica, sans-serif;
  height: 20;
  font-size: 14px;
}

form {
  font-family: Tahoma,Verdana,Arial,Helvetica,sans-serif;
  font-size: 12px;
}

.button {
  font-family:  Arial, Tahoma,Verdana, Helvetica, sans-serif;
  background-color: #003366;
  color: #fcdc43;
  font-size: 12px;
  font-weight: bold;
}

input, textarea {
	font-family : Verdana, Arial, sans-serif;
	font-size : 12px;
	color : $_COLORS[9];
	border-color : #9F9F9F;
	border : 1px solid #9F9F9F;
	background : $_COLORS[2];
}

select {
	font-family : Verdana, Arial, sans-serif;
	font-size : 12px;
	color : $_COLORS[9];
	border-color : #C0C0C0;
	border : 1px solid #C0C0C0;
	background : $_COLORS[2];
}

TABLE.border {
  border-color : #99CCFF;
  border-style : solid;
  border-width : 1px;
}
</style>";

 return $css;
}

#**********************************************************
# table
#**********************************************************
sub table {
 my $class = shift;
 my($attr)=@_;
 my $self = { };

 bless($self, $class);

 
 my $width = (defined($attr->{width})) ? "width=$attr->{width}" : '';
 my $border = (defined($attr->{border})) ? "border=$attr->{border}" : '';

 if (defined($attr->{rows})) {
    my $rows = $attr->{rows};
    foreach my $line (@$rows) {
      $self->addrow(@$line);
     }
  }

 $self->{table} = "<TABLE $width cellspacing=0 cellpadding=0 border=0><TR><TD bgcolor=$_COLORS[4]>
               <TABLE width=100% cellspacing=1 cellpadding=0 border=0>\n";
 $self->{table} .= (defined($attr->{title})) ? $self->table_title($SORT, $DESC, $PG, $OP, $attr->{title}) : '';
 
 if (defined($attr->{cols_align})) {
   $self->{table} .= "<COLGROUP>";
   my $cols_align = $attr->{cols_align};
   foreach my $line (@$cols_align) {
     $self->{table} .= "<COL align=$line>\n";
     <COL align=right>
    }
   $self->{table} .= "</COLGROUP>\n";
  }

 return $self;
}

#*******************************************************************
# addrows()
#*******************************************************************
sub addrow {
  my $self = shift;
  my (@row) = @_;
  $bg = ($bg eq $_COLORS[1]) ? $_COLORS[2] : $_COLORS[1];

  $self->{rows} .= "<tr bgcolor=$bg>";
  foreach my $val (@row) {
     $self->{rows} .= "<td>$val</td>";
   }
  $self->{rows} .= "</tr>\n";
  return $self->{rows};
}


#*******************************************************************
# Show table column  titles
# Arguments 
# $sort - sort column
# $desc - DESC / ASC
# $pg - page id
# $caption - array off caption
#*******************************************************************
sub table_title  {
  my $self = shift;
  my ($sort, $desc, $pg, $op, $caption)=@_;
  my $img='';

  $self->{table_title} = "<tr bgcolor=$_COLORS[0]>";
  my $i=1;
  foreach my $line (@$caption) {
     $self->{table_title} .= "<th>$line ";
     if ($line ne '-') {
         if ($sort != $i) {
             $img = 'sort_none.png';
           }
         elsif ($desc eq 'DESC') {
             $img = 'down_pointer.png';
             $desc='';
           }
         elsif($sort > 0) {
             $img = 'up_pointer.png';
             $desc='DESC';
           }
         $self->{table_title} .= "<a href='$SELF_URL?op=$op&pg=$pg&sort=$i&desc=$desc'>".
            "<img src='../img/$img' width=12 height=10 border=0 title=sort></a>";
       }
     else {
         $self->{table_title} .= "$line";
       }

     $self->{table_title} .= "</th>\n";
     $i++;
   }
 $self->{table_title} .= "</tr>\n";

 return $self->{table_title};
}



#**********************************************************
# show
#**********************************************************
sub show  {
  my $self = shift;	
  $self->{show} .= $self->{table};
  $self->{show} .= $self->{rows}; 
  $self->{show} .= "</table></td></tr></table>\n";
  return $self->{show};
}

#**********************************************************
#
# del_button($op, $del, $message, $attr)
#**********************************************************
sub button {
  my $self = shift;
  my ($name, $params, $message, $attr)=@_;
  my $ex_prams = (defined($attr->{ex_params})) ? $attr->{ex_params} : '';

  my $button = "<A href='$SELF_URL?$params' ".
  "onclick=\"return confirmLink(this, '$message')\">$name</a>";
  return $button;
}


#*******************************************************************
# Show message box
# message($self, $type, $caption, $message)
# $type - info, err
#*******************************************************************
sub message {
 my $type = shift; #info; err
 my $caption = shift;
 my $message = shift;	
 my $head = '';
 
 if ($type eq 'err') {
   $head = "<tr><th bgcolor='#FF0000'>$caption</th></tr>\n";
  }
 elsif ($type eq 'info') {
   $head = "<tr><th bgcolor='$_COLORS[0]'>$caption</th></tr>\n";
  }  
 
print << "[END]";
<table width=400 border=0 cellpadding="0" cellspacing="0">
<tr><td bgcolor=$_COLORS[9]>
<table width=100% border=0 cellpadding="2" cellspacing="1">
<tr><td bgcolor=$_COLORS[1]>

<table width=100%>
$head
<tr><td bgcolor=$_COLORS[1]>$message</td></tr>
</table>

</td></tr>
</table>
</td></tr>
</table>
[END]
}


#*******************************************************************
# Make pages and count total records
# pages($count, $argument)
#*******************************************************************
sub pages {
 my $self = shift;
 my ($count, $argument) = @_;

 my $begin=0;   


 $self->{pages} = '';
 $begin = ($PG - $PAGE_ROWS * 3 < 0) ? 0 : $PG - $PAGE_ROWS * 3;

for(my $i=$begin; ($i<=$count && $i < $PG + $PAGE_ROWS * 10); $i+=$PAGE_ROWS) {
   $self->{pages} .= ($i == $PG) ? "<b>$i</b>:: " : "<a href='$SELF_URL?$argument&pg=$i'>$i</a>:: ";
}
 
 return $self->{pages};
}




1