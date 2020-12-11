owner = "" # your name
region = ""
aws_profile = ""
instance_type = "t2.xlarge"
root_vol_size = 64
key_pair = "" # Place instance key pair here
instance_name = "quick-server"
ssh_cidr_blocks = [
  ""  # Place appropriate cidr blocks as a list of strings here
]
ami = "ami-000e7ce4dd68e7a11" # CentOS 8 base ami for us-east-2 region
# See this link for CentOS AMIs for other regions: https://wiki.centos.org/Cloud/AWS
