# Henka (Terraform Gradle Plugin)

## Why do I need it? 

The plugin provides an opinionated way of running terraform scripts:
* it creates Terraform remote state in S3, so your state can be reused across your team
* it enforces encryption of your remote state using KMS
* in makes it easy to store multiple remote states for different environments, using different S3 buckets and keys

## What do I need to run it?

To run the plugin:
* terraform has to be installed and available in PATH
* AWS S3 access should be configured either through env variables, default profile credentials or IAM profile
* you need to have valid terraform scripts and environment-specific configuration files
* you need to add the plugin to your `build.gradle` and configure TerraformTask (provided by the plugin)

## What does it do?

The plugin will:
* clean up any remaining terraform state
* initialize remote state or pull from S3 if it already exists
* call terraform with the parameters you provided.

If any parameters are missing

## How do I run it?

To see usage example please check the sample project: https://github.com/rokudev/henka-sample/

`build.gradle` changes:

```
buildscript {
    repositories {
        mavenCentral()
    }
    dependencies {
        classpath "com.roku:gradle-terraform:0.9.7"
    }
}

task terraform(type: com.roku.henka.TerraformTask) {
    description "Runs a terraform script"
    tfDir       = "<path to folder with your terraform scripts>"
    tfVarFile   = "<path to file with terraform variables>"
    tfAction    = "plan" // [ "plan" | "apply" | "refresh"]

    tfConfS3Bucket  = "<S3 bucket to store TF state in>"
    tfConfS3Key     = "<S3 key to store TF state in>"
    tfConfS3Region  = "<S3 region>" // e.g., "us-east-1"
    tfConfS3KmsKey  = "<KMS key ARN to encrypt remote stante>"

    tfAwsAccessKey  = "$System.env.TF_AWS_ACCESS_KEY" // obtain AWS access key from system environment
    tfAwsSecretKey  = "$System.env.TF_AWS_SECRET_KEY" // obtain AWS access key from system environment
}


```

The list of available properties:

|Datatype   |PropertyName           |Description|
|---        |---                    |---|
|String     |tfDir                  |Directory with Terraform scripts |
|String     |tfAction               |Terraform action (plan/refresh/apply)   |
|String     |tfVarFile              |Path to file with environment-specific configuration   |
|String     |tfConfS3Bucket         |Terraform Remote State :: S3 Bucket  |
|String     |tfConfS3Key            |Terraform Remote State :: S3 Key   |
|String     |tfConfS3KmsKey         |Terraform Remote State :: KMS Key ARN to encrypt the remote state   |
|Boolean    |tfFailOnPlanChanges    |If true - rturn with exit code if there are any planned changes. Default - false  |
     

To execute the task, call

```
gradle terraform
```

Alternatively, all or some of terraform task properties can be specified as project properties in terraform command line:

```
gradle terraform -P tfAction="apply" -P tfVarFile="<path to file with TF vars>"

```

## Licensing

Gradle Terraform Plugin is available as open source under the terms of [Apache 2.0 license](http://www.apache.org/licenses/LICENSE-2.0.txt) 

## Contributing

When submitting a PR, please fill in and submit an appropriate Contributor License Agreement:
* [Individual Contributor License Agreement](https://raw.githubusercontent.com/rokudev/henka-sample/master/Roku%20ICLA.txt)
* or [Corporate Contributor License Agreement](https://raw.githubusercontent.com/rokudev/henka/master/Roku%20CCLA.txt)
