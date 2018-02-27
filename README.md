
## Tutorial: Deploying a Shiny Application on EC2 with Docker 

This is a simple tutorial to demonstrate that building a docker image, and running a container based on that image, is possible with no changes between EC2 and a local machine.

## Deployment on AWS EC2
Note: This employs the default AWS Linux AMI

* SSH into the EC2 Node
```bash
ssh -i keyname.pem ec2-user@instance-DNS
```

* Install docker
```bash
sudo yum update -y
sudo yum install -y docker
sudo yum install -y git
```

* Start docker and give permissions to the ec2-user
```bash
sudo service docker start
sudo usermod -a -G docker ec2-user
```

* Close this SSH window and then run the SSH command again, restarting the user account with the updated permissions.

* Git Clone the Repository with the Dockerfile and the application:
```bash
git clone https://github.com/alexcengler/docker-shiny.git
```

* Build the Docker Image





## The Shiny Application

The Shiny Application used for this example visualizes results from the Urban Institute DYNASIM model. Those visualizations [are hosted on our website](https://www.urban.org/policy-centers/cross-center-initiatives/program-retirement-policy/projects/dynasim-visualizing-older-americans-future-well-being/fiscal-health-social-security) with their code available [on our GitHub](https://github.com/UrbanInstitute/dynasim-shiny1).

That application originally built by Aaron Williams, with modeling done by Karen Smith and Aaron Williams.