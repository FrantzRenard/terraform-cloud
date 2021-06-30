# declaring all avaialability zones in AWS available
data "aws_availability_zones" "available-zones" {
  state = "available"
}