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
