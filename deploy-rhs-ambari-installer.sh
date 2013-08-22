#This script will copy the current git master to jenkins, to mock
#a proper jenkins build. And afterwards, it will copy the jenkins current build to archiva as a release. This entire process should actually run inside of jenkins, rather than as a manually run shell script.
 
#### First, define the build location. ####
BUILD_LOCATION=/var/lib/jenkins/workspace/Ambari/rhs-ambari-install-current.tar.gz

####### BUILD THE TAR/GZ FILE ~ THIS SHOULD RUN IN JENKINS (future) ####### 
cd rhs-ambari-installer
git pull
TAGNAME=git describe --tags | sed s/v//g
git archive HEAD | gzip > $JENKINS_LOCATION
cd ..

echo "Done archiving $TAGNAME to $BUILD_LOCATION..." 
ls -altrh $BUILD_LOCATION 

#### NOW RUN SOME TESTS against the tar file (again, should run in jenkins) ##### 
./shelltest.sh ### <-- dummy script.
result=$?
echo "Test result = $result press any key to continue..."
if [[ ! $result == 0 ]]; then
      echo "Tests Passed ! "
      exit 1
fi

echo "TEST PASSED !!!! DEPLOYING $TAGNAME !"
 
### IF TESTS PASSED, we PROCEED WITH THE DEPLOYMENT !!! (yup - jenkins should run this to :) ### 

mvn deploy:deploy-file \
-Dfile=$JENKINS_LOCATION \
-Durl=file:/root/archivainstall/apache-archiva-1.3.6/data/repositories/internal \
-DgroupId=rhbd \
-DartifactId=rhs-ambari-install \
-Dversion=$TAGNAME 

########################################

echo "Done ! The file will now be in archiva at http://23.23.239.119/archiva/repository/internal/rhbd/rhs-ambari-install/"
