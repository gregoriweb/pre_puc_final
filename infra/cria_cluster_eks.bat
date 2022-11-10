eksctl create cluster ^
    --name=kbgregori ^
    --managed ^
    --instance-types=m5.xlarge ^
    --alb-ingress-access --node-private-networking ^
    --region=us-east-2 ^
    --nodes-min=2 --nodes-max=3 ^
    --full-ecr-access ^
    --asg-access ^
    --nodegroup-name=ng-kbgregori ^