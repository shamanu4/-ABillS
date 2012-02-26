#!/usr/bin/perl -w
# --
# scripts/rpc-example.pl - soap example client
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: rpc-example.pl,v 1.7 2009/12/22 11:19:52 mb Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use Data::Dumper;
# config
use SOAP::Lite( 'autodispatch', proxy => 'https://127.0.0.1:9443/otrs/rpc.pl' );
my $User = 'soapuser';
my $Pw   = 'soappassword';

my $RPC = Core->new();

# create a new ticket number
print "NOTICE: TicketObject->TicketCreateNumber()\n";
my $TicketNumber = $RPC->Dispatch( $User, $Pw, 'TicketObject', 'TicketCreateNumber' );
print "NOTICE: New Ticket Number is: $TicketNumber\n";

# get ticket attributes
print "NOTICE: TicketObject->TicketGet(TicketID => 1)\n";
my %Ticket = $RPC->Dispatch( $User, $Pw, 'TicketObject', 'TicketGet', TicketID => 1 );
print "NOTICE: Ticket Number is: $Ticket{TicketNumber}\n";
print "NOTICE: Ticket State is:  $Ticket{State}\n";
print "NOTICE: Ticket Queue is:  $Ticket{Queue}\n";

# create a ticket
my %TicketData = (
    Title        => 'rpc-example.pl test ticket',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => 'test',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
print Dumper %TicketData;
print "NOTICE: TicketObject->TicketCreate(%TicketData)\n";
my $TicketID = $RPC->Dispatch( $User, $Pw, 'TicketObject', 'TicketCreate', %TicketData => 1 )
    || die "Failed to create ticket: $!";
print "NOTICE: TicketID is $TicketID\n";

my %ArticleData = (
  TicketID         => $TicketID,
  ArticleType      => 'email-external',                   # email-external|email-internal|phone|fax|...
  SenderType       => 'agent',                           # agent|system|customer
  From             => 'root',  # not required but useful
  To               => 'customer', # not required but useful
  Cc               => '', # not required but useful
  ReplyTo          => '', # not required
  Subject          => 'Test Ticket',          # required
  Body             => "Test Body",                # required
  MessageID        => '',     # not required but useful
  Charset          => 'UTF-8',
  HistoryType      => 'EmailCustomer',                     # EmailCustomer|Move|AddNote|PriorityUpdate|WebRequestCustomer|...
  HistoryComment   => 'Some free text!',
  UserID           => 1,
  NoAgentNotify    => 0,                                 # if you don't want to send agent notifications
  MimeType         => 'text/plain',
  Loop             => 0,
);
my $ArticleID = $RPC->Dispatch(
    $User, $Pw, 'TicketObject', 'ArticleSend', %ArticleData =>1);
print "NOTICE: ArticleID is $ArticleID\n";

my %TicketSearchData = (
Limit=>3,
Result => 'HASH', 
StateType  => 'Open',
OrderBy    => 'Down',
SortBy     => 'Age',
UserID     => 1,
Permission => 'ro',
);
my %searchResult = $RPC->Dispatch( $User, $Pw, 'TicketObject', 'TicketSearch', %TicketSearchData => 1 );
print Dumper(%searchResult);
print "NOTICE: search is %searchResult \n";






exit 0;
# delete the ticket
print "NOTICE: TicketObject->TicketDelete(TicketID => $TicketID)\n";
my $Feedback = $RPC->Dispatch(
    $User, $Pw, 'TicketObject', 'TicketDelete',
    TicketID => $TicketID,
    UserID   => 1
);
my $Message = $Feedback ? 'was successful' : 'was not successful';
print "NOTICE: Delete Ticket with ID $TicketID $Message\n";

# check if the customer exits
print "NOTICE: CustomerUserObject->CustomerName(UserLogin => 'test-user')\n";
my $Name
    = $RPC->Dispatch( $User, $Pw, 'CustomerUserObject', 'CustomerName', UserLogin => 'test' );
$Message = $Name ? 'exists' : 'does not exists';
print "NOTICE: The customer with the login 'test-user' $Message\n";
exit 0;