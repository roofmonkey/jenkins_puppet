#Import all of the node defs.  in this case, jenkins, git, gluster

node default {
   include jenkins	
   jenkins::plugin {'swarm':}
   jenkins::plugin {'git':}
   
   include firewall
}

resources { "firewall":
  purge => true
}
