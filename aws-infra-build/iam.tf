// IAM ROLES

// BOOTSTRAP IAM ROLE

resource "aws_iam_role" "BootstrapIamRole" {
  name = "${var.infra_name}-bootstrap-role"

  // Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AssumeEC2Service"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "${var.infra_name}-bootstrap-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
                "ec2:Describe*",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "s3:Get*"
            ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }  

  tags = {
   "Name" = "${var.infra_name}-bootstrap-role"
   "kubernetes.io/cluster/${var.infra_name}" = "owned"
  }
}


// MASTER IAM ROLE 

resource "aws_iam_role" "MasterIamRole" {
  name = "${var.infra_name}-master-role"

  // Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AssumeEC2Service"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "${var.infra_name}-master-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteVolume",
                "ec2:Describe*",
                "ec2:DetachVolume",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifyVolume",
                "ec2:RevokeSecurityGroupIngress",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:AttachLoadBalancerToSubnets",
                "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateLoadBalancerPolicy",
                "elasticloadbalancing:CreateLoadBalancerListeners",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:ConfigureHealthCheck",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:DeleteLoadBalancerListeners",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:Describe*",
                "elasticloadbalancing:DetachLoadBalancerFromSubnets",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
                "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
                "kms:DescribeKey"
            ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }  

  tags = {
   "Name" = "${var.infra_name}-master-role"
   "kubernetes.io/cluster/${var.infra_name}" = "owned"
  }
}

// WORKER IAM ROLE 

resource "aws_iam_role" "WorkerIamRole" {
  name = "${var.infra_name}-worker-role"

  // Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AssumeEC2Service"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "${var.infra_name}-master-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
                "ec2:DescribeInstances",
                "ec2:DescribeRegions"
            ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }  

  tags = {
   "Name" = "${var.infra_name}-master-role"
   "kubernetes.io/cluster/${var.infra_name}" = "owned"
  }
}


// Attachin ssm policy to all Roles
resource "aws_iam_policy_attachment" "aws_managed_policy_attachment" {
  name       = "aws-managed-policy-attachment"
  roles      = [aws_iam_role.BootstrapIamRole.name, aws_iam_role.MasterIamRole.name, aws_iam_role.WorkerIamRole.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
