node /jenkins-master.*/ {
    include jenkins
    include firewall
    include maven
    jenkins::plugin {'swarm':}
    jenkins::plugin {'git':}

}
