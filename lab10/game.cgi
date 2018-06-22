#!/usr/bin/perl -w

use CGI qw/:all/;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;

$max_number_to_guess = 99;

sub main() {
    # print start of HTML ASAP to assist debugging if there is an error in the script
    print page_header();
    
    # Now tell CGI::Carp to embed any warning in HTML
    warningsToBrowser(1);
	$username = param('username') || '';
	$password = param('password') || '';

	# remove any non-word characters from username 
	# another malicious user could include ../ in username
	$username =~ s/\W//g;
	# limit username to 32 word characters
	$username = substr $username, 0, 32;
	if($password eq "Serect" and -r "/tmp/guess.txt"){
		open  F, '<', '/tmp/guess.txt' or die "Cannnot open guess.txt";
		@session = split /,/, <F>;
		close F;
		@session = () if($session[0] ne $username);
	}
	if(@session){
		$username = $session[0];
		$password = $session[1];	
	}

	if (!$username || !$password) {
		print login_form();
	} else {
		store_data();
		if(!check($username,$password)){
			print "Unknown username!\n<p></p>";
			print login_form();	
		}else{
			$guess = param('guess') || '';
			# remove any non-digit characters from guess
			$guess =~ s/\D//g;
	
			$number_to_guess = param('number_to_guess') || '';
			$number_to_guess =~ s/\D//g;
			$number_to_guess = $session[2] if($session[2]);
		
			if ($number_to_guess eq '') {
				$number_to_guess = 1 + int(rand $max_number_to_guess);
 				print "I've thought of a number\n";
				@session = ();
				push @session, $username;
				push @session, $password;
				push @session, $number_to_guess;
				$str = join ',' , @session;
				open(my $fh, '>', '/tmp/guess.txt');
				print $fh $str;
				close $fh;
				print guess_number_form($username, "Serect", "Please Guess");
			} elsif ($guess eq '') {
				print guess_number_form($username, "Serect", "Please Guess");
			} elsif ($guess == $number_to_guess) {
    				print "You guessed right, it was $number_to_guess.\n";
				pop @session;
				$str = join ',' , @session;
                                open(my $fh, '>', '/tmp/guess.txt');
                                print $fh $str;
    				print new_game_form($username, "Serect");
			} elsif ($guess < $number_to_guess) {
 		   		print "Its higher than $guess.\n";
				print guess_number_form($username, "Serect", "Please Guess");
			} else {
		    		print "Its lower than $guess.\n";
				print guess_number_form($username, "Serect", "Please Guess");
			} 
		}
	}
	
    print page_trailer();
}

# form to allow user to supply username/password 

sub login_form {
	return <<eof;
    <form method="POST" action="">
        Username: <input type="textfield" name="username">
        <p>
        Password: <input type="password" name="password">
         <p>
        <input type="submit" value="Login">
    </form>
eof
}

#
# form to allow user to guess a number
#
# Pass username & password to next invocation as hidden
# field so user doesn't have to login again
#

sub guess_number_form {
	my ($username, $password, $number_to_guess) = @_;
	return <<eof;
    <form method="POST" action="">
    	Enter a guess between 1 and $max_number_to_guess (inclusive):
     	<input type="textfield" name="guess">
     	<input type="hidden" name="username" value="$username">
     	<input type="hidden" name="password" value="$password">
	<input type="hidden" name="number_to_guess" value="$number_to_guess">
     </form>
eof
}

#
# form to allow user to go to a new game
#
sub new_game_form {
	my ($username, $password) = @_;
	return <<eof;
    <form method="POST" action="">
        <input type="submit" value="Play Again">
     	<input type="hidden" name="username" value="$username">
     	<input type="hidden" name="password" value="$password">
    </form>
eof
}



#
# HTML placed at the top of every page
#
sub page_header {
    return <<eof
Content-Type: text/html;charset=utf-8

<!DOCTYPE html>
<html lang="en">
<head>
<title>Guess A Number</title>
</head>
<body>
eof
}


#
# HTML placed at the bottom of every page
#
sub page_trailer {
    return "</body>\n</html>\n";
}

sub store_data{
	foreach my $file (glob "accounts/*"){
		open F, '<', "$file/password" or die "Cannot open $file";
		$name = $file;
		$name =~ s/.*\///g;
		$word = <F>;
		chomp $word;
		$dic{$name} = $word;
		close F;
        }
}

sub check{
	my ($usr, $pwd) = @_ ;
	if(exists $dic{$usr} and $dic{$usr} eq $pwd){
		return 1;
	}else{
		return 0;
	}
}

main();
exit(0);

