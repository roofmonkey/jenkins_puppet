node /jenkins-master.*/ {
    include jenkins
    jenkins::plugin {'swarm':}
    jenkins::plugin {'git':}

}
