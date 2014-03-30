---
title: Composing multiple Mojolicious apps with Plack
---

At work, we've built a number of internal web applications to perform various
tasks: data entry, analytics, reporting, and so on.

While their functionalities are diverse and distinct, they tend to share
portions of code larger than what I'd like. For example, the authentication
code is repeated over and over across all the panels: of course we can factor
out the parts that fetch user profiles from the database (and we do), but
having distinct panels we're bound to write the same logic into each of them.

This results in unpleasant experience for final users as well: they have to
login again and again while they use the various applications for their daily
job.

I'd rather like to have the authentication logic in a single point which then
passes the control to the specific application the user asked to use.

[Plack](http://plackperl.org/) is a tool that can help in this situation and
many others.  In particular, one can compose different applications in a single
one, providing also the means to ''wrap'' them with procedures that are
executed for every request, with no need to modify the inner, original
application.

## Basic usage

Let's say we already have two applications written with
[Mojolicious](http://mojolicio.us/): AppTest1 and AppTest2 (these are the names
of the sample apps you can find in the [github
repo](https://github.com/larsen/test-plack-mojolicious) related to this
article).  The Plack tool you need to compose them is
[``Plack::Builder``](http://search.cpan.org/~miyagawa/Plack-1.0030/lib/Plack/Builder.pm).
Here's the code for ``composer.pl``:

```` perl
use Plack::Builder;

use lib 'app_test1/lib';
use lib 'app_test2/lib';

use Mojo::Server::PSGI;
use Data::Dumper;

my $app1, $app2;

{
  my $server = Mojo::Server::PSGI->new;
  $server->load_app('./app_test1/script/app_test1');
  $app1 = sub { $server->run(@_) }
}

{
  my $server = Mojo::Server::PSGI->new;
  $server->load_app('./app_test2/script/app_test2');
  $app2 = sub { $server->run(@_) }
}

builder {
  enable 'Debug';
  mount "/test1" => builder { $app1 };
  mount "/test2" => builder { $app2 };
};
````

I used two bare blocks to prepare, using
[``Mojo::Server::PSGI``](http://search.cpan.org/~sri/Mojolicious-4.91/lib/Mojo/Server/PSGI.pm),
the applications (``$app1`` and ``$app2``) I later used with the composer:
``builder``. I also added another middleware component,
[``Plack::Middleware::Debug``](http://search.cpan.org/~miyagawa/Plack-Middleware-Debug-0.16/lib/Plack/Middleware/Debug.pm),
to show the wrapping technique I was talking about before: in this case Debug
adds useful informations about the application execution.  What is important
is that it does that without touching for the code of the application.

Start the server with ``plackup composer.pl`` to see the results.

![](/images/mojo-apptest1.png "Test application with Debug middleware enabled")

## Managing authentication using middlewares

Now we can solve one the problems I mentioned in the introduction: we can add
an authentication layer that will be common to all the applications composed as
we've seen.  Plack conveniently provides a middleware to do so. Just drop these
lines in the ``builder`` part of ``composer.pl``:

```` perl
enable "Auth::Basic", authenticator => sub {
  my($username, $password) = @_;
  return $username eq 'guest'
      && $password eq 'guest';
};
````

Of course you can write more complex logic for authenticating the user (in my
case, for example, I would look in a user database).

## Communicating with the applications

Authenticating the user is just one half of the task: once the user has entered
the app, we must ensure he can access the resources he's interested in. We need
to authorize him, and I believe this part of the project must be in the
applications, not in the Plack composer.

To do so we must face a problem: authentication happened in a middleware, thus
_outside_ of the application itself: the application can then just assume
someone else checked the identity of the user. But we need more specific
information to decide whether we can serve or not a particular page. It's not
sufficient to know that someone trusted has entered the application: we need to
know as well who he is.  In other words, we need middlewares and applications
to talk to each other.

One way to accomplish that is using session. They not only provide a way to
mantain a state across requests, but also a mean for different layers of the
system (namely Plack middlewares and Mojolicious apps) to communicate.

First, we drop a new line into our composer:

```` perl
enable 'Session', store => Plack::Session::Store->new;
````

Then we modify a little bit the authenticator we already wrote:

```` perl
enable "Auth::Basic", authenticator => sub {
  my($username, $password, $env) = @_;

  if ( $username eq 'guest' && $password eq 'guest' ) {
    $env->{'psgix.session'}->{'username'} = $username;
    return 1;
  }
};
````

And in the application, to fetch the session data:

```` perl
my $session = Plack::Session->new( $self->req->env );
my $username = $session->get('username');
````

![](/images/mojo-apptest1-session.png "Test application with Session middleware enabled")
