# CHANGELOG

<!--- next entry here -->

## 0.3.0
2020-02-25

### Breaking changes

#### BREAKING CHANGE: Include Env variable in ELB log S3 bucket naming (7a582fc721f772ac79d5e54bd50c9bde7c1acc0f)

Include Env variable in ELB log S3 bucket naming

Datadog side, there should be no impact to the shipped logs. AWS side, ELB logs will no longer be in the same place.

Since I expect datadog logs to be the ones in common use, the expected behavior is preserved at the end of the data pipe, just not in the middle.

If you want to retain your ELB logs in one bucket, please use `aws s3 cp`

Thank you!

COREINF-1565

#### Merge branch 'jimp/change_elb_log_bucket_naming' into 'master' (2d87eee37f093740a312ff94b4ceb5538900f485)

Include Env variable in ELB log S3 bucket naming

See merge request terraform/terraform-aws-datadog!8

## 0.2.0
2020-02-22

### Breaking changes

#### export lambda function name instead of ARN (68fb6dc02e146765ee785ce1a67e7c68608ec5a7)

One can get ARN from function name via
`data "aws_lambda_function"`, but to get function name
out ARM, one needs to apply regexes.

I looked around and nothing seems to be using it

## 0.1.10
2020-02-20

### Fixes

- doc: add troubleshooting steps (f46d6f1e827d3063857f8088909e327c19a7ac4c)

## 0.1.9
2020-02-20

### Fixes

- doc: add provider config (f69f121fc488f03416aa60063edccadbd5af3efc)

## 0.1.8
2020-02-20

### Fixes

- chore: :tada: add QP as maintainer (2ff7ee522f01f8dc7ea9ffb1b2a822fe9f74204e)

## 0.1.7
2020-02-20

### Fixes

- Update README.md (e7c04781e006af3932a9b9720e855fb08f7102b0)

## 0.1.6
2020-02-20

### Fixes

- Update README.md (086c1bf63a56ae26ed13182f125f85de9e9dcba2)

## 0.1.5
2020-01-31

### Fixes

- TOOLS-1197 Create S3 bucket to archive scribd logs ingested by Datadog (62eb79d0ed9e0f8689397590d62b6668af6c38d8)
- Remove creation of S3 bucket and instead output Datadog's iam role (to be used by the module caller to create S3 bucket and set permissions) (037e726c4024ae33bf68254c25f2d399483b3c9c)
- Merge branch 'kamranf/TOOLS-1197' into 'master' (b4d8f24ead8b716f728a8f430ebac849232ac398)

## 0.1.4
2020-01-22

### Fixes

- Merge branch 'sai/add-tags-to-dd-logs' into 'master' (31254522b0f93290e51ba685de1681e711cc351c)
- add namespace and env to DD logs (87baf8fdb541316a1545b2adf00cfa44348820ab)

## 0.1.3
2020-01-22

### Fixes

- Merge branch 'sai/fix-lambda-permission-statement' into 'master' (6cabdf9ad640226ea1bec3124b2e14628d2521ac)
- Fix invalid statement id for lambda permission (96eef8276f3a38d7775693e0025d1478cd347971)

## 0.1.2
2019-11-12

### Fixes

- Donut include other changes (082bc09759413c01470ac6e739a7f3689c794c5f)

## 0.1.0
2019-11-12

### Features

- test release (958cbb2d78c806cf38c7f913e0039c80285f74e3)

### Fixes

- next semver shouldnot collide (a4a84748e5037c49f98f9675856747eb579dd8d4)

## 0.1.0
2019-11-12

### Features

- test release (958cbb2d78c806cf38c7f913e0039c80285f74e3)

## 0.1.0
2019-11-12

### Features

- add release methodology (07860287c5b4616708fd6fe182f96c7891d540d3)
- add release methodology (8f0fa746383ddba5d4c0462433b3ff82fb6f6957)

## 0.0.1
2019-11-11

### Features

- Initial release
