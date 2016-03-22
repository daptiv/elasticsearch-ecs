# elasticsearch-ecs
An elastic search docker container intended to be hosted on ecs.  Forked from http://blog.dmcquay.com/devops/2015/09/12/running-elasticsearch-on-aws-ecs.html

The container relies on EC2 discovery to form a cluster, so EC2 instances spun up in the ECS cluster will need to have "ec2:DescribeInstances" EC2 permission.  See: https://github.com/elastic/elasticsearch-cloud-aws .
