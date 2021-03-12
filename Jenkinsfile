node{
   def app
   stage('checkout scm')
   {
   checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'Jenkins_Git', url: 'https://github.com/VinutnaNandyala/HelloFargate']]])
   }
   stage('build image'){
       sh '''
            #Sets the env for gcloud
            gcloud config set account 'gokulpraveen.sp@cognizant.com'
            gcloud config list
            docker build -t rcgthcdetech1000254229/nodeapp:v1 .
            docker tag rcgthcdetech1000254229/nodeapp:v1 gcr.io/rcgthcdetech1000254229/nodeapp:v1
            '''
     
   }
  
   stage('Image Publish to GCR'){

            withCredentials([[$class: 'FileBinding', credentialsId: "rcgthcdetech", variable: 'rcgthcdetech']]) {
                sh '''
                #Sets the env for gcloud
                gcloud auth activate-service-account --key-file=${rcgthcdetech} --project=rcgthcdetech1000254229
                docker images
                #This gets the Git commit id 
                gcloud config set project rcgthcdetech1000254229
                gcloud auth configure-docker
                #Pushes Docker images into GCR
                docker push gcr.io/rcgthcdetech1000254229/nodeapp:v1
                ''' 
            } 

   }
   stage('Deploy to GKE'){
        
        withCredentials([[$class: 'FileBinding', credentialsId: "rcgthcdetech", variable: 'rcgthcdetech']])
		{
        sh '''
            kubectl version
            gcloud auth activate-service-account --key-file=${rcgthcdetech} --project=rcgthcdetech1000254229
            gcloud config set compute/zone us-central1-a
            gcloud config set compute/region us-central1-a
            gcloud config set project rcgthcdetech1000254229
            #gcloud container clusters create ${GCLOUD_K8S_CLUSTER_NAME} --num-nodes=3
            gcloud container clusters get-credentials devopstraceability
        
            #kubectl get deployments nodeapp
            
            DEPLOY_STATE=`kubectl get deployments|grep "nodeapp " | wc -l`
            if [ $DEPLOY_STATE -eq 1 ]; then 
            #RESULT=$?
            #echo $RESULT
            #if [ $RESULT -eq 0 ]; then
                echo "Deployment already exists! so updating the deployment"
                kubectl set image deployment/nodeapp nodeapp=gcr.io/rcgthcdetech1000254229/nodeapp:v1
                kubectl rollout status deployments nodeapp
            else
                kubectl run nodeapp --image=gcr.io/rcgthcdetech1000254229/nodeapp:v1 --port 8080
                kubectl get pods
                #kubectl expose deployment nodeapp --type="LoadBalancer" --port=80 --target-port=8080 --load-balancer-ip="35.233.183.183"
                kubectl expose deployment nodeapp --type=LoadBalancer --port 80 
                kubectl get service
            fi
            '''
			
        }
        
    }
 
 
}
