resource "aws_s3_bucket" "pedido_novo" {
  bucket = "pedido-novo"
  acl    = "private"
  force_destroy = true

  tags = {
    Name = "pedido-novo"
  }
}

resource "aws_s3_bucket_policy" "pedido_novo_policy" {
  bucket = aws_s3_bucket.pedido_novo.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.pedido_novo.arn}/*"
    }
  ]
}
EOF
}

resource "aws_lambda_function" "email_confirm" {
  filename         = "lambda_email.zip"
  function_name    = "EnviarEmailConfirmacao"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  timeout          = 10

  environment {
    variables = {
      SES_EMAIL = "seu-email-temporario@empresa.com"
    }
  }
}

resource "aws_lambda_permission" "allow_s3_trigger" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_confirm.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.pedido_novo.arn
}

resource "aws_s3_bucket_notification" "pedido_novo_notification" {
  bucket = aws_s3_bucket.pedido_novo.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.email_confirm.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
