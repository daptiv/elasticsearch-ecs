# elasticsearch-ecs
An elastic search docker container intended to be hosted on ecs.  Forked from http://blog.dmcquay.com/devops/2015/09/12/running-elasticsearch-on-aws-ecs.html

### Recommended EC2 Permissions

Because the container relies on EC2 discovery to form a cluster, EC2 instances spun up in the ECS cluster will need to be able to make calls to the EC2 service. If your current ECS Instance IAM Role currently isn't granted ec2:DescribeInstances action, you might want to create a new IAM Policy with it.

```js
{
    "Statement": [
        {
            "Action": [
                "ec2:DescribeInstances"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        }
    ],
    "Version": "2012-10-17"
}
```

### Sample Task Definition

items marked with {{ }} change between aws accounts, so aren't listed here.  Container memory must be larger than the ES_HEAP_SIZE.

```js
{
  "requiresAttributes": [],
  "taskDefinitionArn": "{{ task definition arn }}",
  "status": "ACTIVE",
  "revision": {{ task definition revision }},
  "containerDefinitions": [
    {
      "volumesFrom": [],
      "memory": 1500,
      "extraHosts": null,
      "dnsServers": null,
      "disableNetworking": null,
      "dnsSearchDomains": null,
      "portMappings": [
        {
          "hostPort": 9200,
          "containerPort": 9200,
          "protocol": "tcp"
        },
        {
          "hostPort": 9300,
          "containerPort": 9300,
          "protocol": "tcp"
        }
      ],
      "hostname": null,
      "essential": true,
      "entryPoint": null,
      "mountPoints": [
        {
          "containerPath": "/usr/share/elasticsearch/data",
          "sourceVolume": "vol00",
          "readOnly": null
        }
      ],
      "name": "elasticsearch",
      "ulimits": null,
      "dockerSecurityOptions": null,
      "environment": [
        {
          "name": "ES_HEAP_SIZE",
          "value": "1g"
        }
      ],
      "links": null,
      "workingDirectory": null,
      "readonlyRootFilesystem": null,
      "image": "daptiv/elasticsearch-ecs:latest",
      "command": [
        "/docker-entrypoint.sh",
        "--discovery.type=ec2",
        "--discovery.ec2.groups={{ name or id of security group assigned to ec2 instances in the cluster ie. sg-1a2b3c4d }}"
      ],
      "user": null,
      "dockerLabels": null,
      "logConfiguration": null,
      "cpu": 300,
      "privileged": null,
      "expanded": true
    }
  ],
  "volumes": [
    {
      "host": {
        "sourcePath": "/var/data/vol00"
      },
      "name": "vol00"
    }
  ],
  "family": "elasticsearch"
}
```

### Mounting a Volume and Making it Available to ECS

The following userdata can be used to mount an EBS volume labelled /dev/sdb to /opt/vol00 on the EC2 instance - which can then be referenced in the task defenition.

```bash
#!/bin/bash
echo ECS_CLUSTER=Elasticsearch >> /etc/ecs/ecs.config

# Mount /dev/sdb EBS volume to /opt/vol00
mkfs -t ext4 /dev/sdb
mkdir /opt/vol00
mount /dev/sdb /opt/vol00
echo "/dev/sdb /opt/vol00 ext4 defaults,nofail 0 2" >> /etc/fstab

# The Docker daemon must be restarted to see the new mount
sudo service docker restart
```
