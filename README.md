# elasticsearch-ecs
An elastic search docker container intended to be hosted on ecs.  Forked from http://blog.dmcquay.com/devops/2015/09/12/running-elasticsearch-on-aws-ecs.html

### Recommended EC2 Permissions

Because the container relies on EC2 discovery to form a cluster,EC2 instances spun up in the ECS cluster will need to be able to make calls to the EC2 service. If your current ECS Instance IAM Role currently isn't granted ec2:DescribeInstances action, you might want to create a new IAM Policy with it.

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
