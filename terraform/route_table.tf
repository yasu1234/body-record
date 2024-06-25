resource "aws_route_table" "private-1b" {
  propagating_vgws = []
  route            = []
  tags = {
    Name = "プロジェクト-rtb-private2-us-east-1b"
  }
  tags_all = {
    Name = "プロジェクト-rtb-private2-us-east-1b"
  }
  vpc_id = "vpc-0a5d8dd2f75850a61"
}

resource "aws_route_table" "private-1a" {
  propagating_vgws = []
  route            = []
  tags = {
    Name = "プロジェクト-rtb-private1-us-east-1a"
  }
  tags_all = {
    Name = "プロジェクト-rtb-private1-us-east-1a"
  }
  vpc_id = "vpc-0a5d8dd2f75850a61"
}
