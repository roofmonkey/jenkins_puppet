#Import all of the node defs.  in this case, jenkins, git, gluster

node default {
   include jenkins	
   include wget
   include openjdk

   jenkins::plugin {'swarm':}
   jenkins::plugin {'git':}
      
   include firewall

   include maven
}

resources { "firewall":
  purge => true
}
