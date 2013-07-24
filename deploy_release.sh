### get the tag list, and select one ### 

cd hadoop-glusterfs/
git pull
git tag -l
echo "ENTER tagname.."
read TAGNAME 
cd ..

### BUILD THE RELEASE based on tag ###

echo "BUILDING tag $TAGNAME" 

mvn -DskipTests=true clean package -f hadoop-glusterfs/pom.xml

### DEPLOY ###
JARFILE=$(ls hadoop-glusterfs/target/*jar | head -1)

echo "JAR IS $JARFILE"
cp $JARFILE hadoop-glusterfs-$TAGNAME-x.jar

echo "DEPLOY -> $JARFILE -- ?"
ls -l *jar
read x

mvn deploy:deploy-file -Dfile=hadoop-glusterfs-$TAGNAME-x.jar  -DrepositoryId=internal -Durl=file:/root/archivainstall/apache-archiva-1.3.6/data/repositories/internal/ -DgroupId=org.apache.hadoop.fs.glusterfs -DartifactId=glusterfs-hadoop -Dversion=$TAGNAME

echo "REMOVE OLD JARS??"
read x
rm -rf *jar

