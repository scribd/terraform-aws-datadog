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
