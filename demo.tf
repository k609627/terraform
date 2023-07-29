
provider "aws" {
  region     = "ap-south-1"
  access_key = "XXXXXXXXXXXXXX"
  secret_key = "UXXXXXXXXXX0XXXXXXXXXXXX"
}


resource "aws_key_pair" "sah" {
  key_name="Demo0909"
  public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdYVghKqfKSrJf/66FpgVxkbmGWC2IRBhuqapUMlhqKNfomlkCyZ6dQlBCz7+mwsxVvoQFq2rW5VCOP73/7sjexqQjb2JJefpcMHlhObHcXiN6UyBy4VBtihY9I9iAHTgb4SyPJa4IZXdM41sie6+D18Npr1KUo4aWE85ZmEzowf5UmcZ7rVXztINR+qBZYMeCkTpXKRFC6iCYjA8mKY6m13QGHLLdwCYFUPxkR+fSEX57Dqlwv2PkX9GdHXz2E39MCIbhWJYOBLF3crpnT1oOWx2IlUYuSRQfNTHPdJIhDxjWVcJchvtPNJVBIw/3eIkTlDaE4x66u28vx8IGeWQj rsa-key-20230729"

}
resource "aws_instance" "jifeeo" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.sah.key_name}"
  #instance_state = "Running"
  tags = {
    Name = "Assslpha"
  }
}

resource "aws_ebs_volume" "Dem_vol"{
  availability_zone = "${aws_instance.jifeeo.availability_zone}"
  size = 10
  encrypted = "true"
  tags = {
    Name = "Demzy_vol"
  }
}


resource "aws_volume_attachment" "vol_attach"{
  device_name = "/dev/sdf"
  volume_id = aws_ebs_volume.Dem_vol.id
  instance_id = aws_instance.jifeeo.id
}


#output "Device_id"{
# # value = "${aws_ebs_volume.Dem_vol.device_id}"
#}

#output "public_ip"{
#  value="${aws_instance.jifeeo.id}"#*.volume_id[0]}"
#}

#output "public_ip"{
#  value="${aws_instance.jifeeo.root_block_device.*.volume_id[0]}"
#}

