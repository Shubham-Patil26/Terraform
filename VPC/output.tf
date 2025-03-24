output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
# output "my_subnet" {
#   value = aws_subnet.my_subnet.id
# }
output "my_subnet" {

  value = aws_subnet.my_subnet

  description = "The created subnet object"

}