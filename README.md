------------------------------------------------------------------------
								EricHouse
		All new p2p network with a custom domain naming system
		   in progress. The dev team is hoping to finish
		     the custom naming system in the up coming
			     weeks. For more information about
			        EricHouse please read the 
			             details below.  
------------------------------------------------------------------------

What is EricHouse?

EricHouse is a all new p2p network with anonymous features being
implemented. It is a new private network layer for the current internet
in which we are hoping to have a much more free place to share data, 
ideas, and pretty much anything, because one of our main goals, is
freedom.

What exactly goes on in EricHouse?

Well it is hard to explain. This is a quick summary of how it works. 
Every client on the network is a server and a client, which means it
accepts connections and creates out going connections. Each client on 
the network is known as a 'peer'. The is NO CENTRAL SERVER!!!! It is 
all client based. 

Every peer has its own specialized ID known as a "Destination" which
identifies your client or peer. 
A example of a Destination would be: -EH001-1fcd3062596394
If someone has your destination they can no do SHIT. This
is a completely randomly generated string with no value. Yes it does
identify your client in a special way, but it really has no special 
meaning to it.

How do clients find each other?
There is a file called "peers" with a list of ip addresses of peers
you can connect to. If you want to give back to the network you
should put your ip in there. If someone has your ip they cannot identify
your peer because they are not linked.
When you boot up EricHouse, your peer tries to connect to every peer
on the network.(This may be changed) Once connected to even one peer you
can start browsing the network.

Currently the networks webservers are in development.

How does the domain naming system work?
This is actually most likely not going to be final. We are almost 99.99%
sure this will be changed.
Your website can have any domain you want, as long as you do not overlay
someone elses. If the name is taken then really, do not mess with it. 
Just make a new name. Once you create a domain you must go to the folder
"sites/" and make a file with your domain name like eric.house. Inside 
the file you should put: website name:Destination:port
Example: ping.pong:-EH001-fcfe572795dbc2:1113

Now how does a peer find your host to connect to it? 
It sends a request through the network" Are you peer:Destination"
If the response is yes, then that peer sends you all the information
nessecary to connect to their webserver. 
Here is the catch, if the hoster does not have their ip in your peers 
file then you cannot connect to them. :(
This is because we want this network to be entirly p2p based. Every 
client should be connected to each other in order to give back to your
fellow peers.

Here is the current diagram on how a irc server connection works on the
network:

irc client->EricHouse router->irc server->EricHouse router->irc client

A website connection would look like:
(Router == EricHouse router)

Browser->router->random peers until the host is found ->router->website host->router->Browser

Even without much anonimity that is pretty damn good!

Here is a digram with anonimity which is planned in the upcoming months:

Browser->router->random peers until host is found->router->peer->peer->peer->website host->router->browser


Tunnels

In EricHouse's case a tunnel is taking any connection from the real
internet and routeing it through EricRouter in order to connect to 
it with a custom domain like router.server or whatever you want.


Ofcourse there is LOTS of flaws but that is because the team is trying 
to add all the features in and then clean it up.

At the moment if you run a peer make sure to notify us so we could tell 
everyone about your peer. We are gonna make a system where you can
tell the whole network at once that you are avaible for service.

There is no time limit set as to when this will be complete.
This is expected to take months even years. 


			             
