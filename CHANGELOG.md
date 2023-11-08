# [3.0.0](https://github.com/YouLend/terraform-aws-datadog/compare/v2.5.0...v3.0.0) (2023-11-08)


### Bug Fixes

* 6764: add eks iam permissions to datadog policy ([215210f](https://github.com/YouLend/terraform-aws-datadog/commit/215210f9cb46c238061c4788e9201ac8d190d3f0))
* 6764: add the dev datadog role in the sts assume role ([518ccfe](https://github.com/YouLend/terraform-aws-datadog/commit/518ccfeee7cb348e3ab443de33f093db8c236e09))
* 6764: remove aws tag filter for rds ([1981c9e](https://github.com/YouLend/terraform-aws-datadog/commit/1981c9eeb16477283cf18823d541a7b9baf03e7a))
* 6764: remove depcreted arguments from s3 ([ece8ee0](https://github.com/YouLend/terraform-aws-datadog/commit/ece8ee0ae8037980dbac6d65d238f4bfaa16569d))
* 6764: remove dev account from sts ([1b8962d](https://github.com/YouLend/terraform-aws-datadog/commit/1b8962df5dd47015d86fe58140324504ef6dc875))
* 6764: remove lifecyle rule ([c4415fd](https://github.com/YouLend/terraform-aws-datadog/commit/c4415fdb3c37d9e602204932b3768bef25f05b56))
* 6764: remove rds tag filter ([3edff7e](https://github.com/YouLend/terraform-aws-datadog/commit/3edff7ef2a2ad286d1d5b33f42c7373d64146576))
* 6764: remove required version in module ([a70a53b](https://github.com/YouLend/terraform-aws-datadog/commit/a70a53bd74ab8cac56af85ab1fd358bcf25bbcf9))
* 6764: remove sts for usprod and dev ([e4e4280](https://github.com/YouLend/terraform-aws-datadog/commit/e4e42809c7dca5ba8c8f3f9e99a7346f693b8cb4))
* 6764: solve merge conflict ([30b4a41](https://github.com/YouLend/terraform-aws-datadog/commit/30b4a41756c1821e5c9286d5bb70c14e54ed48be))
* 6764: solve merge conflict2 ([917b3ae](https://github.com/YouLend/terraform-aws-datadog/commit/917b3ae0ca6f15c46a3d754d0311ea8455b63fb3))
* 6764: test rds namespace tag filter ([3c96389](https://github.com/YouLend/terraform-aws-datadog/commit/3c963898a6f843e7a6abe4fa1bf8f9c03e153795))
* 6764: update the name of elb log bucket ([a1b57aa](https://github.com/YouLend/terraform-aws-datadog/commit/a1b57aa54afffe220ffb74cc005dd727e3cff712))
* 7413: update release tags ([c6d43fa](https://github.com/YouLend/terraform-aws-datadog/commit/c6d43fab7b6ca34c3e036d8f15baba3ab51adde9))
* 7413: update release tags ([17bb1ce](https://github.com/YouLend/terraform-aws-datadog/commit/17bb1ceebe159a33b27d0e2e41993591555b5d52))
* explicitly specify the versions for semantic-release ([#42](https://github.com/YouLend/terraform-aws-datadog/issues/42)) ([09bd8b9](https://github.com/YouLend/terraform-aws-datadog/commit/09bd8b96d3b78c302756e8b05baa2589b71daa4a))
* hosted_tags: making host_tags and filter_tags ([9dbf24f](https://github.com/YouLend/terraform-aws-datadog/commit/9dbf24fdb6b37673e2b5179ad3613d87a34a5ae8))
* restrict aws provider to <4 for this major branch ([#47](https://github.com/YouLend/terraform-aws-datadog/issues/47)) ([07de45a](https://github.com/YouLend/terraform-aws-datadog/commit/07de45adb3ff85fc925a9066dc581248f151fb49))


* feat!: enable support for aws provider 4.0+ (#49) ([5bc98cb](https://github.com/YouLend/terraform-aws-datadog/commit/5bc98cb56b7dd1b697f3bfa64251515d8e8ff61c)), closes [#49](https://github.com/YouLend/terraform-aws-datadog/issues/49)


### Features

* (HEAD: adding waf logging in Datadog ([7c96569](https://github.com/YouLend/terraform-aws-datadog/commit/7c96569c8ed7945b56d0e65d0d19f477c8b8afa8))
* 6764: add cspm_resource_collection_enabled ([e6ce70f](https://github.com/YouLend/terraform-aws-datadog/commit/e6ce70fe05afe5535b4576f2a3d2f9f879437fe6))
* 6764: add cspm_resource_collection_enabled ([02c26a2](https://github.com/YouLend/terraform-aws-datadog/commit/02c26a21756f2d9edc4db6d9c7584451c64b27a8))
* 6764: add dev and usprod in the sts assume role ([5bdfb8d](https://github.com/YouLend/terraform-aws-datadog/commit/5bdfb8d7a295832a568853a78e52181d414e3cf8))
* 6764: add lambda forward function ([543caf4](https://github.com/YouLend/terraform-aws-datadog/commit/543caf4bdd3acdbe74532f209cec60fc58fca4e6))
* 6764: add metrics collection and update iam role ([440d86e](https://github.com/YouLend/terraform-aws-datadog/commit/440d86e714196364b3f7b0864c85f50d0f45a2e7))
* 6764: add rds tag filters ([dbbddc3](https://github.com/YouLend/terraform-aws-datadog/commit/dbbddc3bfaa1c5bc09a71acb519ea420891e87c9))
* 6764: pre-commit ([3b0babe](https://github.com/YouLend/terraform-aws-datadog/commit/3b0babeeecd6812938090a877f90bb0f250ab05a))
* 6764: remove db uat from datadog ([8731628](https://github.com/YouLend/terraform-aws-datadog/commit/87316281f6574b021647fa8bebd3fd034ccd7a46))
* 6764: remove uat db from monitoring ([e57525e](https://github.com/YouLend/terraform-aws-datadog/commit/e57525eae5e8e4b4d73b910a1063988e9c09379d))
* 6764: testing aws tag filter ([de928e1](https://github.com/YouLend/terraform-aws-datadog/commit/de928e1a75f447c7246e4402afc6afbc10546266))
* 6764: testing aws tag filter ([f6fbb9f](https://github.com/YouLend/terraform-aws-datadog/commit/f6fbb9f66fc9c2e0925299fc14f85f43c0b78f2e))
* 7413: terraform required version change to 1.1.0 ([1a2379f](https://github.com/YouLend/terraform-aws-datadog/commit/1a2379f7607693aa79e5bba0cf2a4660e750c746))
* 7413: upgrade Module DataDog v2.5.0 ([28cd263](https://github.com/YouLend/terraform-aws-datadog/commit/28cd26344af18cf7e30ca996e6ac9fb0ac7ce8f6))
* enable support for Datadog provider 3.x ([e42de0e](https://github.com/YouLend/terraform-aws-datadog/commit/e42de0e3ee6217db29251630370244e25debed6b))
* enable support for Terraform 1.1.3 ([#40](https://github.com/YouLend/terraform-aws-datadog/issues/40)) ([51c5279](https://github.com/YouLend/terraform-aws-datadog/commit/51c52792eed5f4b324420429677bbe9b10b0cef0))


### BREAKING CHANGES

* This release drops support for AWS provider <4.0

When updating to this version, the diff will show each of the new resources as needing to be created. However, each of the new aws_s3_bucket_* resources relies on S3 API calls that utilize a PUT action in order to modify the target S3 bucket. Because these API calls adhere to standard HTTP methods for REST APIs, they should handle situations where the target configuration already exists (as noted in the HTTP RFC). Given that this is the case, it's not strictly necessary to import any new aws_s3_bucket_* resources that are a one-to-one translation from previous versions of the AWS provider -- on the next terraform apply, they'll attempt the PUT, and update the state with the results as necessary.

# [3.0.0](https://github.com/scribd/terraform-aws-datadog/compare/v2.7.0...v3.0.0) (2022-04-05)


* feat!: enable support for aws provider 4.0+ (#49) ([5bc98cb](https://github.com/scribd/terraform-aws-datadog/commit/5bc98cb56b7dd1b697f3bfa64251515d8e8ff61c)), closes [#49](https://github.com/scribd/terraform-aws-datadog/issues/49)


### BREAKING CHANGES

* This release drops support for AWS provider <4.0

When updating to this version, the diff will show each of the new resources as needing to be created. However, each of the new aws_s3_bucket_* resources relies on S3 API calls that utilize a PUT action in order to modify the target S3 bucket. Because these API calls adhere to standard HTTP methods for REST APIs, they should handle situations where the target configuration already exists (as noted in the HTTP RFC). Given that this is the case, it's not strictly necessary to import any new aws_s3_bucket_* resources that are a one-to-one translation from previous versions of the AWS provider -- on the next terraform apply, they'll attempt the PUT, and update the state with the results as necessary.

# [2.7.0](https://github.com/scribd/terraform-aws-datadog/compare/v2.6.1...v2.7.0) (2022-03-07)


### Features

* enable support for Datadog provider 3.x ([e42de0e](https://github.com/scribd/terraform-aws-datadog/commit/e42de0e3ee6217db29251630370244e25debed6b))

## [2.6.1](https://github.com/scribd/terraform-aws-datadog/compare/v2.6.0...v2.6.1) (2022-03-07)


### Bug Fixes

* restrict aws provider to <4 for this major branch ([#47](https://github.com/scribd/terraform-aws-datadog/issues/47)) ([07de45a](https://github.com/scribd/terraform-aws-datadog/commit/07de45adb3ff85fc925a9066dc581248f151fb49))

# [2.6.0](https://github.com/scribd/terraform-aws-datadog/compare/v2.5.0...v2.6.0) (2022-01-19)


### Bug Fixes

* explicitly specify the versions for semantic-release ([#42](https://github.com/scribd/terraform-aws-datadog/issues/42)) ([09bd8b9](https://github.com/scribd/terraform-aws-datadog/commit/09bd8b96d3b78c302756e8b05baa2589b71daa4a))


### Features

* enable support for Terraform 1.1.3 ([#40](https://github.com/scribd/terraform-aws-datadog/issues/40)) ([51c5279](https://github.com/scribd/terraform-aws-datadog/commit/51c52792eed5f4b324420429677bbe9b10b0cef0))

# [2.5.0](https://github.com/scribd/terraform-aws-datadog/compare/v2.4.0...v2.5.0) (2021-10-01)


### Features

* added states permissions to dd module's IAM policy ([#38](https://github.com/scribd/terraform-aws-datadog/issues/38)) ([0cb8ab8](https://github.com/scribd/terraform-aws-datadog/commit/0cb8ab8af13c1f7e12b3b4e71556a4773d595ce4))

# [2.4.0](https://github.com/scribd/terraform-aws-datadog/compare/v2.3.1...v2.4.0) (2021-08-25)


### Features

* attach extra iam policies ([#37](https://github.com/scribd/terraform-aws-datadog/issues/37)) ([8411cad](https://github.com/scribd/terraform-aws-datadog/commit/8411cadea20cfb5f113d9ce54c85919eff9a14e6))

## [2.3.1](https://github.com/scribd/terraform-aws-datadog/compare/v2.3.0...v2.3.1) (2021-08-17)


### Bug Fixes

* Merge pull request [#35](https://github.com/scribd/terraform-aws-datadog/issues/35) from scribd/taylorsmcclure/fix-iam-policy-v2 ([7bf7868](https://github.com/scribd/terraform-aws-datadog/commit/7bf78689e90293f4c6510025cce8cc48b8a4dafd))

# [2.3.0](https://github.com/scribd/terraform-aws-datadog/compare/v2.2.0...v2.3.0) (2021-07-14)


### Features

* enable support for Terraform 1.0 ([#32](https://github.com/scribd/terraform-aws-datadog/issues/32)) ([5410502](https://github.com/scribd/terraform-aws-datadog/commit/5410502ac1d9cc6dfc4b3c1c0bbe49895f802570))

# [2.2.0](https://github.com/scribd/terraform-aws-datadog/compare/v2.1.0...v2.2.0) (2021-03-19)


### Features

* enable support for terraform 0.14 ([c65a0d0](https://github.com/scribd/terraform-aws-datadog/commit/c65a0d04f1e7a07cf496002fc149afb9108a5c9f))

# [2.1.0](https://github.com/scribd/terraform-aws-datadog/compare/v2.0.1...v2.1.0) (2021-03-16)


### Features

* changes dd lambda default version from v3.17.0 to v3.27.0 ([8e455a8](https://github.com/scribd/terraform-aws-datadog/commit/8e455a8f217ba398a79be90a9251c59f8eb4b1fe))

## [2.0.1](https://github.com/scribd/terraform-aws-datadog/compare/v2.0.0...v2.0.1) (2021-01-22)


### Bug Fixes

* Add missing cloudwatch:ListMetrics access for AWS integration ([#27](https://github.com/scribd/terraform-aws-datadog/issues/27)) ([f7c80c2](https://github.com/scribd/terraform-aws-datadog/commit/f7c80c2c7a73fa5bf1ab7132c51ff24f3703d611))

# [2.0.0](https://github.com/scribd/terraform-aws-datadog/compare/v1.3.5...v2.0.0) (2020-11-06)


### Features

* drop support for terraform 0.12.x ([be79b7e](https://github.com/scribd/terraform-aws-datadog/commit/be79b7e612b8932dd2d7c062b864a9a5ecff1db6))


### BREAKING CHANGES

* Please use a version constraint for this module
if you are staying on terraform 0.12.x

Example:

```
module "datadog" {
  source  = "scribd/datadog/aws"
  version = "1.3.5"
  # insert the 1 required variable here
}
```

## [1.3.5](https://github.com/scribd/terraform-aws-datadog/compare/v1.3.4...v1.3.5) (2020-11-06)


### Reverts

* Revert "fix: use proper provider source for datadog" ([7240d04](https://github.com/scribd/terraform-aws-datadog/commit/7240d04b0b303948490d7eb099906e8370dfbc35))

## [1.3.4](https://github.com/scribd/terraform-aws-datadog/compare/v1.3.3...v1.3.4) (2020-11-03)


### Bug Fixes

* use proper provider source for datadog ([6f292e7](https://github.com/scribd/terraform-aws-datadog/commit/6f292e7d0b2c277c9751dce1c9806c47b1f22b89))

## [1.3.3](https://github.com/scribd/terraform-aws-datadog/compare/v1.3.2...v1.3.3) (2020-11-03)


### Bug Fixes

* make minimum terraform version requirement an actual minimum ([f39e5e6](https://github.com/scribd/terraform-aws-datadog/commit/f39e5e69bf80b47cd56ce44f4e38e54d114289b9))
* use a range of versions to limit the required versions ([d98714a](https://github.com/scribd/terraform-aws-datadog/commit/d98714af4bc1ffe55d9483eaaf0d8032d8501826))

## [1.3.2](https://github.com/scribd/terraform-aws-datadog/compare/v1.3.1...v1.3.2) (2020-10-29)


### Bug Fixes

* Add cloudtrail:LookupEvents IAM rights ([#19](https://github.com/scribd/terraform-aws-datadog/issues/19)) ([bba2d91](https://github.com/scribd/terraform-aws-datadog/commit/bba2d9104715b5559a8edf8bc8cd445313abaacb))

## [1.3.1](https://github.com/scribd/terraform-aws-datadog/compare/v1.3.0...v1.3.1) (2020-10-25)


### Bug Fixes

* Add missing IAM permissions for new version of log forwarder  ([#18](https://github.com/scribd/terraform-aws-datadog/issues/18)) ([b741a4b](https://github.com/scribd/terraform-aws-datadog/commit/b741a4b565b8ce54b545521700ff7406495df34f))

# [1.3.0](https://github.com/scribd/terraform-aws-datadog/compare/v1.2.1...v1.3.0) (2020-09-02)


### Features

* **log forwarding:** support DdSite option + upgrade default CF template version used ([1e0f7bc](https://github.com/scribd/terraform-aws-datadog/commit/1e0f7bc88f6fef7e0ab3ffc4c11a83daed60e09b))

## [1.2.1](https://github.com/scribd/terraform-aws-datadog/compare/v1.2.0...v1.2.1) (2020-08-10)


### Bug Fixes

* use name_prefix instead of static name to avoid ([36a8077](https://github.com/scribd/terraform-aws-datadog/commit/36a8077e4c527c47be04b423b1bdee0e0bc721fe))

# [1.2.0](https://github.com/scribd/terraform-aws-datadog/compare/v1.1.0...v1.2.0) (2020-07-02)


### Features

* **aws integration:** add options to specify ignored regions and tags to filter out EC2 instances ([#10](https://github.com/scribd/terraform-aws-datadog/issues/10)) ([452a995](https://github.com/scribd/terraform-aws-datadog/commit/452a995d60b06fcef38a41e3b2445097b27e71f6))

# [1.1.0](https://github.com/scribd/terraform-aws-datadog/compare/v1.0.0...v1.1.0) (2020-06-29)


### Features

* add DdApiKey dummy value for CF stack ([c6c7ddd](https://github.com/scribd/terraform-aws-datadog/commit/c6c7ddd201ca921362cfe995544661f8e23d2989))
* **CF:** use datadog supplied CF stack template ([1ecdb22](https://github.com/scribd/terraform-aws-datadog/commit/1ecdb2211b40ac8ceb4299c2f24ed603c1801942))

# 1.0.0 (2020-04-27)


### Bug Fixes

* Also set conditional for ForwarderRole ([d0ecc10](https://github.com/scribd/terraform-aws-datadog/commit/d0ecc10f3bba66be1e236486d4a6fa8b440cf9d4))
* use AWS Secrets Manager instead of supplying API Key parameter ([647e8e9](https://github.com/scribd/terraform-aws-datadog/commit/647e8e9dd8d8d0dc953f64c86fed25ceebf1fead))


### Features

* add EXCLUDE_AT_MATCH env variable to datadog ([05bae6a](https://github.com/scribd/terraform-aws-datadog/commit/05bae6aa446ff485c1f231adcb72623944cbd11f))
* Update AWS DD Forwarder to v3.5.0 ([797da3a](https://github.com/scribd/terraform-aws-datadog/commit/797da3a8a50cbd9b3f09677fc3e1639ffbad7187))

# CHANGELOG

<!--- next entry here -->

- Initial public release
