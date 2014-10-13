#!/bin/bash
#

CURRENTUSER=`whoami`

APPLICATION_HOME=/docs/root/cdsws
APP_DIR=${APPLICATION_HOME}/app
LOG_DIR=${APPLICATION_HOME}/log
STANDALONE_DIR=${APPLICATION_HOME}/standalone
DEPLOY_DIR=${APPLICATION_HOME}/standalone/deployments

DATE=`date +%m-%d-%Y:%l:%M:%S`
LOG_FILE=${LOG_DIR}/deploy.log
VERSION_LOG=${LOG_DIR}/version.properties

PROJECTNAME="cdsws"

JAVA_HOME=/usr/java/jdk1.7.0_10
MAVEN_HOME=/usr/local/maven

PATH=${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${PATH}
export PATH

build() {
        # log and date
        VERSION=$1

        if [ -a /docs/env ]
        then
          ENVIRONMENT=`sed '/^\#/d' /docs/env | grep 'environment.name'  | tail -n 1 | cut -d "=" -f2-`
        else
          echo -e "/docs/env file not found!\n"
        fi

        if [ -z $ENVIRONMENT ]
        then
          echo -e "Could not determine environment\n"
          read -s -p "Enter environment for build:" ENVIRONMENT

          if [ -z $ENVIRONMENT ]
          then
            echo "No environment entered, goodbye!"
                exit 1
          fi
        fi

        echo -e "Building for ${ENVIRONMENT} environment"
        #APP_SERVER_HOME=/docs/apps/jboss-eap-6.1-rgnl
        SVN_LOC=svn://ny-coderepos-p01/productdevelopment/cds_ws/tags

        #Check Version
        if [ -z $VERSION ]
                        then
                        echo 'No Version'
                        echo 'Bye ...'
                        exit
        fi

        if [ -a ${LOG_DIR} ]
        then
                echo 'Log directory already exists'
        else
                echo ${LOG_DIR} does not exist. Attempting to create...
                `mkdir  ${LOG_DIR}`
                if [ -d ${LOG_DIR} ]
                then
                        echo Created
                else
                        echo Failed to create ${LOG_DIR}
                fi
        fi

        if [ -a ${STANDALONE_DIR} ]
        then
                echo 'standalone directory already exists'
        else
                echo ${STANDALONE_DIR} does not exist. Attempting to create...
                `mkdir  ${STANDALONE_DIR}`
                if [ -d ${STANDALONE_DIR} ]
                then
                        echo Created
                else
                        echo Failed to create ${STANDALONE_DIR}
                fi
        fi

        if [ -a ${DEPLOY_DIR} ]
        then
                echo 'standalone directory already exists'
        else
                echo ${DEPLOY_DIR} does not exist. Attempting to create...
                `mkdir  ${DEPLOY_DIR}`
                if [ -d ${DEPLOY_DIR} ]
                then
                        echo Created
                else
                        echo Failed to create ${DEPLOY_DIR}
                fi
        fi
		
        if [ -a ${APP_DIR} ]
        then
                echo "Deleting existing ${APP_DIR}"
                rm -rf ${APP_DIR}
        fi

        mkdir ${APP_DIR}

        echo Writing log entry
        echo  ${DATE} -APP- ${PROJECTNAME} -VER- ${VERSION} -ENV- ${ENVIRONMENT} | tee ${LOG_FILE}

        echo "Exporting code from SVN" | tee -a ${LOG_FILE}
        svn export --force ${SVN_LOC}/${VERSION} ${APP_DIR} | tee -a ${LOG_FILE}
        svn export --force ${SVN_LOC}/${VERSION}/serverInstance/ny-internet-q02/standalone ${STANDALONE_DIR} | tee -a ${LOG_FILE}
        echo "Building with Maven; on server ${HOSTNAME}" | tee -a ${LOG_FILE}
        mvn clean package -f ${APP_DIR}/pom.xml -DskipTests -Denvironment=${ENVIRONMENT} -DjbossDeployments=/docs/root/cdsws/standalone/deployments | tee -a ${LOG_FILE}
    echo "${DATE} -APP- ${APPLICATION} -VER- ${VERSION}" >> ${VERSION_LOG}
        return 0
}

deploy(){
  mvn jboss-as:deploy-only -f ${APP_DIR}/pom.xml -DskipTests -Djboss-as.password=$1 | tee -a ${LOG_FILE}
  return 0
}

undeploy(){
  mvn jboss-as:undeploy -f ${APP_DIR}/pom.xml -DskipTests -Djboss-as.password=$1 | tee -a ${LOG_FILE}
  return 0
}

#Checking user
#if [ ${CURRENTUSER} != 'appusr' ]
if [ ${CURRENTUSER} != 'mteng' ]
                then
                echo 'NOT appusr !!!'
                echo 'Bye ...'
                exit
fi
echo "Current user is $CURRENTUSER."

while getopts ":b:duc" opt; do
  case $opt in
        b)
          echo "building"
          build $OPTARG
          ;;
        d)
          echo "deploying"
          read -s -p "JBoss CLI Password:" pwd
          deploy $pwd
          cp /docs/root/cdsws/app/target/cds-ws.war /docs/root/cdsws/standalone/deployments/cds-ws.war
          ;;
        u)
          echo "undeploying"
          read -s -p "JBoss CLI Password:" pwd
          undeploy $pwd
          ;;
        c)
          echo "clean"
          echo "undeploying"
          read -s -p "JBoss CLI Password:" pwd
          undeploy $pwd
          rm -rf /docs/root/cdsws/standalone/deployments/cds-ws.war
          ;;
        *)
          echo "Usage: $0 {-b [TAG NAME] | -d | -u }"
          ;;
  esac
done

shift $(($OPTIND -1))
