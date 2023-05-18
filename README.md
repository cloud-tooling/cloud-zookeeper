# cloud-zookeeper
cloud resources for ZooKeeper

FAQs    
    
    1. [How to add new environment to deploy zookeeper deployed](#AddNewEnv)

    2. [How to add new region to deploy zookeeper deployed](#AddNewRegion)

    3. [How can I expand my zookeeper cluster by adding more nodes to existing cluster](#ExpandCluster)


## FAQ ##

## 1. How to add new Node/service to be deployed <a name="AddNewEnv"></a>
    a. Add new Environment under settings and add following Environment variables and its values under it.
        OIDCROLE

    b. Add environemnt under .github/workflows/build.yml
        > <ENV>:
        >   name: Build & Publish to ECR on <ENV> env
        >   if: github.event.pull_request.merged == true && github.ref == 'main'
        >   uses: cloud-tooling/cloud-zookeeper/.github/workflows/zookeeper-build.yml
        >    with:
        >    stagename: <environment name>
        >    region: <region>
        >    shortcode: <region short code>

## 2. How to add new region to deploy zookeeper deployed  <a name="AddNewRegion"></a>
    a. Add environemnt under .github/workflows/build.yml
        > <ENV>:
        >   name: Build & Publish to ECR on QA env <new> region
        >   if: github.event.pull_request.merged == true && github.ref == 'main'
        >   uses: cloud-tooling/cloud-zookeeper/.github/workflows/zookeeper-build.yml
        >    with:
        >    stagename: <environment name>
        >    region: <region>
        >    shortcode: <region short code>

## 3. How can I expand my zookeeper cluster by adding more nodes to existing cluster  <a name="ExpandCluster"></a>
    a. Add new ecs service under cloud-zookeeper-ecs CLUSTER
    
    b. update job "Deploy" in zookeeper-build.yml to new service to deploy task in it.
          -
            name: Render ECS Task Definition-3 in ${{ inputs.stagename }}
            id: task-def-4
            uses: aws-actions/amazon-ecs-render-task-definition@v1
            with:
                task-definition: .github/workflows/task-definition-zoo.json
                container-name: zk-${{ inputs.stagename }}
                image: ${{ needs.build.outputs.image }}
                environment-variables: |
                    ZOO_SERVERS=server.1=zoo-1.zookeeper.local:2888:3888 server.2=zoo-2.zookeeper.local:2888:3888 server.6=zoo-1.zookeeper.local:2888:3888 server.100=0.0.0.0:2888:3888
                    MYID=100

            -
            name: Deploy ZooKeeper Task Definition to Service 4 in ${{ inputs.stagename }}
            uses: aws-actions/amazon-ecs-deploy-task-definition@v1
            with:
                task-definition: ${{ steps.task-def-1.outputs.task-definition }}
                service: zoo-4
                cluster: cloud-zookeeper-ecs 
        - Also update existing environment variables for prior services and add following text
           > server.100=zoo-4.zookeeper.local:2888:3888
           e.g.
           environment-variables: |
            ZOO_SERVERS=server.4=zoo-1.zookeeper.local:2888:3888 server.5=0.0.0.0:2888:3888 server.6=zoo-3.zookeeper.local:2888:3888 server.100=zoo-4.zookeeper.local:2888:3888

![Cloud demo Zookeeper](Zookeeper.png)