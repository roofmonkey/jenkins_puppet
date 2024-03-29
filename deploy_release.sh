### get the tag list, and select one ### 

cd /root/archivainstall/glusterfs-hadoop/
git pull
git tag -l

TAGNAME=$1
if [ -z "$1" ]
   then 
      echo "ENTER tagname.."
      read TAGNAME 
fi

#CHECKOUT THE TAG !
git checkout $TAGNAME

cd ..


### BUILD THE RELEASE based on tag ###

echo "BUILDING tag $TAGNAME" 

mvn -DskipTests=true clean package -f glusterfs-hadoop/pom.xml

### DEPLOY ###
JARFILE=$(ls glusterfs-hadoop/target/*jar | head -1)

echo "JAR IS $JARFILE"
cp $JARFILE glusterfs-hadoop-$TAGNAME-x.jar

echo "DEPLOY -> $JARFILE -- ?"
ls -l *jar
#read x
jar -tf $JARFILE 

echo "If above jar looks good, hit enter to proceed" 

mvn deploy:deploy-file -Dfile=glusterfs-hadoop-$TAGNAME-x.jar  -DrepositoryId=internal -Durl=file:/root/archivainstall/apache-archiva-1.3.6/data/repositories/internal/ -DgroupId=org.apache.hadoop.fs.glusterfs -DartifactId=glusterfs-hadoop -Dversion=$TAGNAME

echo "REMOVing OLD JARS"
#read x
rm -rf *jar

echo "DONE!"

tree /root/archivainstall/apache-archiva-1.3.6/data/repositories/internal/
