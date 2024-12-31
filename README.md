# `S3 Bucket Terraform Project`

This project demonstrates how to create and manage an S3 bucket using Terraform. The S3 bucket will be configured to host a static website.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine
- AWS account with appropriate permissions to create S3 buckets

## Usage

1. **Clone the repository:**

    ```sh
    git clone https://github.com/ShubhamMca88/S3-Bucket-Terraform-AWS.git
    
    cd S3-Bucket-Terraform
    ```

2. **Initialize Terraform:**

    ```sh
    terraform init
    ```

3. **Plan the Terraform deployment:**

    ```sh
    terraform plan
    ```

4. **Apply the Terraform configuration:**

    ```sh
    terraform apply
    ```

5. **Upload your static website:**

    After the S3 bucket is created, you can upload your static website files to the bucket using the AWS CLI or the AWS Management Console.

## Configuration

The Terraform configuration file (`main.tf`) includes the necessary resources to create an S3 bucket and configure it for static website hosting. You can customize the configuration by modifying the variables in the `variables.tf` file.

## Cleanup

To destroy the resources created by Terraform, run:

```sh
terraform destroy
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any changes.

