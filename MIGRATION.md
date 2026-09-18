# Migration guide

## 3.x to 4.x

Module 4.0.0 moves to Datadog provider 4.x, which **removed** the
`datadog_integration_aws` resource this module was built on. There is no state
upgrader, so every consumer has to migrate state by hand. Read this before you
bump the version.

This applies to you if you set `enable_datadog_aws_integration = true` (the
default). If you only use the module for CloudWatch log shipping
(`enable_datadog_aws_integration = false`), no state migration is needed — bump
the version and go, though check [New defaults](#new-defaults-worth-checking).

### What changed

| | 3.x | 4.x |
| --- | --- | --- |
| Datadog provider | `>= 2.10, < 4` | `~> 4.0` |
| tofu/terraform | `>= 0.13` | `>= 1.1.5` (provider moved to plugin protocol v6) |
| Integration resource | `datadog_integration_aws` | `datadog_integration_aws_account` |

Provider 4.0.0 also removed `datadog_integration_aws_tag_filter`,
`datadog_integration_aws_log_collection` and `datadog_integration_aws_lambda_arn`.
This module never declared those, but if you declare any of them *alongside* this
module in the same stack, they need the same treatment and their settings move
into this module:

| Removed resource | Where its settings go |
| --- | --- |
| `datadog_integration_aws_tag_filter` | `filter_tags` for `AWS/EC2`, `metrics_tag_filters` for any other namespace |
| `datadog_integration_aws_lambda_arn` | `logs_lambda_forwarder_arns` |
| `datadog_integration_aws_log_collection` | `logs_sources` |

Move them in the *same* change as the version bump. The v2 API replaces these
lists wholesale on every apply, so leaving a variable empty does not mean "leave
Datadog alone" — it means "clear it". A stack that drops
`datadog_integration_aws_tag_filter` without populating `metrics_tag_filters`
loses those filters on the first apply, and for `AWS/EC2` that means Datadog
starts importing every host, which shows up on your bill.

### Why you cannot just bump the version

`datadog_integration_aws_account` is a different resource address, so OpenTofu
sees the old resource as gone and the new one as absent. Applying without
migrating state does this:

- **Destroys the AWS integration in Datadog**, taking metric collection with it.
- **Recreates it with a new external ID**, because the ID is generated
  server-side when the integration is created.
- Leaves the IAM role trust policy pointing at the old external ID until the same
  apply updates it, so `sts:AssumeRole` fails in the window between.

Metrics gaps and `Datadog is not authorized to perform action sts:AssumeRole`
follow. Importing avoids all of it: the existing integration is adopted as-is and
keeps its external ID.

### Before you start

- tofu >= 1.1.5. Use >= 1.6 if you want the `import` block form in step 4.
- `DD_API_KEY` and `DD_APP_KEY` exported, or the equivalent `provider "datadog"`
  configuration. The migration reads and writes the Datadog API.
- The AWS account ID the integration covers.
- Confirm nothing else applies this stack while you are mid-migration. Between
  steps 2 and 5 the integration is live in Datadog but unmanaged, and another
  apply from the old code would try to destroy it.

### Migration procedure

Run these from the root module that calls `scribd/datadog/aws`, not from the
module itself. `module.datadog` below is the module's label in your root config —
substitute your own; `tofu state list | grep datadog_integration_aws` prints the
exact address. A `state rm` against a wrong address is a no-op that looks like
success.

#### Step 1 — record what you have

```
tofu state show 'module.datadog.datadog_integration_aws.core[0]'
```

If you have already run `tofu init -upgrade`, that fails with `no schema found
for datadog_integration_aws` — the 4.x provider cannot describe a type it no
longer has. Read it without the schema instead:

```
tofu state pull | jq -r '
  .resources[] | select(.type == "datadog_integration_aws")
  | .instances[].attributes
  | {external_id, excluded_regions, filter_tags, account_specific_namespace_rules}'
```

Keep the output. You need `external_id` to verify the import in step 5, and
`account_specific_namespace_rules`, `excluded_regions` and `filter_tags` to
translate your variables in step 3.

#### Step 2 — drop the old resource from state

```
tofu state rm 'module.datadog.datadog_integration_aws.core[0]'
```

Do this **before** upgrading the provider. `state rm` touches nothing in Datadog
or AWS — it only stops OpenTofu tracking the resource — and it needs no provider
schema, so it works whichever provider version is installed.

Doing it first means the 4.x provider is never asked to reason about a resource
type it no longer has. Datadog's own upgrade guide sequences this the other way
round; this order is safer and the end state is identical.

#### Step 3 — bump the module and translate variables

```terraform
module "datadog" {
  source  = "scribd/datadog/aws"
  version = "~>4"
  # ...
}
```

Translate any variable listed in [Variable changes](#variable-changes). Then:

```
tofu init -upgrade
```

#### Step 4 — import the existing integration

Get the Datadog AWS account config ID for your AWS account, then import it. The
CLI form works on every supported version and leaves nothing behind:

```
tofu import 'module.datadog.datadog_integration_aws_account.core[0]' '<aws-account-config-id>'
```

To find the config ID, either query the API:

```
curl -s -H "DD-API-KEY: $DD_API_KEY" -H "DD-APPLICATION-KEY: $DD_APP_KEY" \
  "https://api.${DD_SITE:-datadoghq.com}/api/v2/integration/aws/accounts?aws_account_id=<your-aws-account-id>" \
  | jq -r '.data[].id'
```

Drop the `| jq` and read the whole response to see the live `metrics_config`,
`logs_config`, `aws_regions`, `account_tags` and `auth_config.external_id` before
you import. That is exactly what the imported state will contain, so it is the
cheapest way to know what step 5 will ask you to reconcile.

Alternatively, on provider >= 4.20.0, let the `datadog_integration_aws_account`
data source look it up and use an `import` block (tofu >= 1.6):

```terraform
data "datadog_integration_aws_account" "existing" {
  aws_account_id = "<your-aws-account-id>"
}

import {
  to = module.datadog.datadog_integration_aws_account.core[0]
  id = data.datadog_integration_aws_account.existing.id
}
```

Remove the `import` block once the import has been applied.

#### Step 5 — reconcile the plan

```
tofu plan
```

The imported state reflects **what is actually configured in Datadog**, including
anything set through the Datadog UI that this module never managed. So the plan
is the first honest picture of the drift, and it is normal for it to show changes
on the first run.

Read the imported values back and set variables until the plan is clean:

```
tofu state show 'module.datadog.datadog_integration_aws_account.core[0]'
```

This is the reliable way to translate `account_specific_namespace_rules` —
the imported `metrics_config.namespace_filters` already expresses your live
configuration in 4.x vocabulary, so copy it into
`metrics_namespace_include_only` or `metrics_namespace_exclude_only` rather than
converting the old map by hand.

Check `external_id` matches what you recorded in step 1. If it does, the IAM
trust policy needs no change and the plan should show no diff on
`aws_iam_role.datadog-integration`.

Pay particular attention to anything the plan wants to **empty**. The v2 API
replaces these lists wholesale, so a variable you leave unset clears the live
value rather than preserving it:

- `metrics_config.tag_filters` → `filter_tags` and `metrics_tag_filters`
- `logs_config.lambda_forwarder.lambdas` / `.sources` → `logs_lambda_forwarder_arns` / `logs_sources`
- `account_tags` → built from `namespace` and `env`, so any tag added in the Datadog UI is dropped
- `traces_config.xray_services` → `xray_include_all` / `xray_services`
- `metrics_config.namespace_filters` → `metrics_namespace_include_only` /
  `metrics_namespace_exclude_only`. Omitting both resets a live `include_only` to
  Datadog's default exclusions — see
  [`account_specific_namespace_rules` to namespace filters](#account_specific_namespace_rules-to-namespace-filters).
- `metrics_config.metric_name_filters` → **not exposed by this module**. If the
  imported state shows any, they can only have come from the Datadog UI or a
  direct API call, since 3.x had no such field. Raise an issue so the variable
  gets added; if you need to proceed first, re-apply the filters through the
  Datadog UI after the apply.

#### Step 6 — apply

```
tofu apply
```

Then confirm in Datadog that the AWS integration is still listed for the account
and that `aws.*` metrics are still arriving.

### Variable changes

| 3.x | 4.x |
| --- | --- |
| `excluded_regions` | `included_regions` |
| `account_specific_namespace_rules` | `metrics_namespace_include_only` / `metrics_namespace_exclude_only` |

`filter_tags` keeps its name and meaning, and now applies to the `AWS/EC2`
namespace.

#### `excluded_regions` to `included_regions`

The v2 AWS integration API has no exclusion form for regions — only "all" or an
explicit list. Exclusions have to be restated as inclusions:

```terraform
# 3.x
excluded_regions = ["ap-east-1", "me-south-1"]

# 4.x — list the regions you actually want
included_regions = ["us-east-1", "us-east-2", "us-west-2"]
```

Leave `included_regions` empty (the default) to collect from all regions. Note
the consequence of an explicit list: a region AWS adds later is not collected
until you add it here.

#### `account_specific_namespace_rules` to namespace filters

These are not the same shape, and converting one into the other mechanically is
the single most destructive mistake available in this migration.

The 3.x variable was a per-namespace **override** map. Per the v1 API, it "only
contains namespaces explicitly configured through API calls, not the
comprehensive enabled or disabled status of all namespaces. If a namespace is
absent from this field, it uses Datadog's internal defaults (all namespaces
enabled by default, except `AWS/SQS`, `AWS/ElasticMapReduce`, and `AWS/Usage`)."

So `{ elasticache = true, network_elb = true, lambda = true }` was collecting
**104 of 107** namespaces, not three. Rewriting it as
`metrics_namespace_include_only = ["AWS/ElastiCache", "AWS/NetworkELB",
"AWS/Lambda"]` silently drops `AWS/EC2`, `AWS/RDS`, `AWS/S3`, `AWS/Logs` and a
hundred others, along with every monitor and dashboard built on them.

The 4.x filters are a single allowlist **or** a single denylist, with no
per-namespace override form:

```terraform
# 4.x — collect only these
metrics_namespace_include_only = ["AWS/EC2", "AWS/Lambda", "AWS/RDS"]

# or — collect everything except these
metrics_namespace_exclude_only = ["AWS/SQS", "AWS/Usage"]
```

Setting both is rejected by the provider at plan time. Leaving both empty gets
Datadog's default of excluding `AWS/SQS`, `AWS/ElasticMapReduce` and `AWS/Usage`.

There *is* a mechanical conversion, but it is not "read the map". Your 4.x
`exclude_only` is:

```
( {"AWS/SQS", "AWS/ElasticMapReduce", "AWS/Usage"}
    ∪ {namespaces your 3.x map set to false} )
  \ {namespaces your 3.x map set to true}
```

Two things this catches that reading the map alone does not:

- `sqs`, `emr` and `usage` are the only namespaces 3.x had off by default, so a
  `true` on any of them was load-bearing — it has to come **out** of the
  exclusion list, not be dropped on the floor.
- The three defaults stay **in** the list unless your map turned them on. Listing
  only your `false` entries starts collecting all three, which is the CloudWatch
  `GetMetricData` cost Datadog excludes them to avoid.

Worked example of a map that exercises both halves of the formula — `sqs = true`
removes a default exclusion, and the two `false` entries add new ones:

```terraform
# 3.x
account_specific_namespace_rules = {
  sqs     = true
  lambda  = true
  ec2     = false
  ec2spot = false
}

# 4.x — four entries: the three defaults, minus SQS, plus the two disabled
metrics_namespace_exclude_only = [
  "AWS/ElasticMapReduce",
  "AWS/Usage",
  "AWS/EC2",
  "AWS/EC2Spot",
]
```

If the formula comes out as exactly the three defaults — your map set nothing to
`false`, and none of those three to `true` — omit both variables and inherit the
default rather than pinning it.

Use the imported state
from step 5 as your source of truth. The table below is for reading your old
config, not for converting it blindly.

#### Two entries that are not namespaces

`account_specific_namespace_rules` accepted two keys that were never CloudWatch
namespaces. They are now first-class variables:

| 3.x key | 4.x variable |
| --- | --- |
| `collect_custom_metrics` | `metrics_collect_custom_metrics` |
| `crawl_alarms` | `metrics_collect_cloudwatch_alarms` |

#### Namespace name mapping

3.x used Datadog's own namespace slugs. 4.x uses CloudWatch namespace names.

| 3.x | 4.x | 3.x | 4.x | 3.x | 4.x | 3.x | 4.x |
|---|---|---|---|---|---|---|---|
| `api_gateway` | `AWS/ApiGateway` | `ec2` | `AWS/EC2` | `mediaconvert` | `AWS/MediaConvert` | `sagemaker` | `AWS/SageMaker` |
| `application_elb` | `AWS/ApplicationELB` | `ec2api` | `AWS/EC2/API` | `medialive` | `AWS/MediaLive` | `sagemakerendpoints` | `/aws/sagemaker/Endpoints` |
| `apprunner` | `AWS/AppRunner` | `ec2spot` | `AWS/EC2Spot` | `mediapackage` | `AWS/MediaPackage` | `sagemakerlabelingjobs` | `AWS/Sagemaker/LabelingJobs` |
| `appstream` | `AWS/AppStream` | `ecr` | `AWS/ECR` | `mediastore` | `AWS/MediaStore` | `sagemakermodelbuildingpipeline` | `AWS/Sagemaker/ModelBuildingPipeline` |
| `appsync` | `AWS/AppSync` | `ecs` | `AWS/ECS` | `mediatailor` | `AWS/MediaTailor` | `sagemakerprocessingjobs` | `/aws/sagemaker/ProcessingJobs` |
| `athena` | `AWS/Athena` | `efs` | `AWS/EFS` | `memorydb` | `AWS/MemoryDB` | `sagemakertrainingjobs` | `/aws/sagemaker/TrainingJobs` |
| `auto_scaling` | `AWS/AutoScaling` | `elasticache` | `AWS/ElastiCache` | `ml` | `AWS/ML` | `sagemakertransformjobs` | `/aws/sagemaker/TransformJobs` |
| `backup` | `AWS/Backup` | `elasticbeanstalk` | `AWS/ElasticBeanstalk` | `mq` | `AWS/AmazonMQ` | `sagemakerworkteam` | `AWS/SageMaker/Workteam` |
| `bedrock` | `AWS/Bedrock` | `elasticinference` | `AWS/ElasticInference` | `msk` | `AWS/Kafka` | `service_quotas` | `AWS/ServiceQuotas` |
| `billing` | `AWS/Billing` | `elastictranscoder` | `AWS/ElasticTranscoder` | `mwaa` | `AmazonMWAA` | `ses` | `AWS/SES` |
| `budgeting` | `AWS/Budgeting` | `elb` | `AWS/ELB` | `nat_gateway` | `AWS/NATGateway` | `shield` | `AWS/DDoSProtection` |
| `certificatemanager` | `AWS/CertificateManager` | `emr` | `AWS/ElasticMapReduce` | `neptune` | `AWS/Neptune` | `sns` | `AWS/SNS` |
| `cloudfront` | `AWS/CloudFront` | `es` | `AWS/ES` | `network_elb` | `AWS/NetworkELB` | `sqs` | `AWS/SQS` |
| `cloudhsm` | `AWS/CloudHSM` | `firehose` | `AWS/Firehose` | `networkfirewall` | `AWS/NetworkFirewall` | `step_functions` | `AWS/States` |
| `cloudsearch` | `AWS/CloudSearch` | `fsx` | `AWS/FSx` | `networkmonitor` | `AWS/NetworkMonitor` | `storage_gateway` | `AWS/StorageGateway` |
| `cloudwatch_events` | `AWS/Events` | `gamelift` | `AWS/GameLift` | `opsworks` | `AWS/OpsWorks` | `swf` | `AWS/SWF` |
| `cloudwatch_logs` | `AWS/Logs` | `globalaccelerator` | `AWS/GlobalAccelerator` | `polly` | `AWS/Polly` | `textract` | `AWS/Textract` |
| `codebuild` | `AWS/CodeBuild` | `glue` | `Glue` | `privatelinkendpoints` | `AWS/PrivateLinkEndpoints` | `transitgateway` | `AWS/TransitGateway` |
| `codewhisperer` | `AWS/CodeWhisperer` | `inspector` | `AWS/Inspector` | `privatelinkservices` | `AWS/PrivateLinkServices` | `translate` | `AWS/Translate` |
| `cognito` | `AWS/Cognito` | `iot` | `AWS/IoT` | `rds` | `AWS/RDS` | `trusted_advisor` | `AWS/TrustedAdvisor` |
| `connect` | `AWS/Connect` | `keyspaces` | `AWS/Cassandra` | `rdsproxy` | `AWS/RDS/Proxy` | `usage` | `AWS/Usage` |
| `directconnect` | `AWS/DX` | `kinesis` | `AWS/Kinesis` | `redshift` | `AWS/Redshift` | `vpn` | `AWS/VPN` |
| `dms` | `AWS/DMS` | `kinesis_analytics` | `AWS/KinesisAnalytics` | `rekognition` | `AWS/Rekognition` | `waf` | `WAF` |
| `documentdb` | `AWS/DocDB` | `kms` | `AWS/KMS` | `route53` | `AWS/Route53` | `wafv2` | `AWS/WAFV2` |
| `dynamodb` | `AWS/DynamoDB` | `lambda` | `AWS/Lambda` | `route53resolver` | `AWS/Route53Resolver` | `workspaces` | `AWS/WorkSpaces` |
| `dynamodbaccelerator` | `AWS/DAX` | `lex` | `AWS/Lex` | `s3` | `AWS/S3` | `xray` | `AWS/X-Ray` |
| `ebs` | `AWS/EBS` | `mediaconnect` | `AWS/MediaConnect` | `s3storagelens` | `AWS/S3/Storage-Lens` | | |

Seven names do **not** take an `AWS/` prefix and are easy to get wrong by
guessing: `Glue`, `AmazonMWAA`, `WAF`, and four SageMaker paths —
`/aws/sagemaker/Endpoints`, `/aws/sagemaker/ProcessingJobs`,
`/aws/sagemaker/TrainingJobs`, `/aws/sagemaker/TransformJobs`.

SageMaker is spelled three ways across the set, and the casing is significant:
`AWS/SageMaker` and `AWS/SageMaker/Workteam`, but `AWS/Sagemaker/LabelingJobs`
and `AWS/Sagemaker/ModelBuildingPipeline`, plus the four lowercase paths above.
Copy these rather than typing them.

`AWS/Config`, `AWS/AOSS`, `AWS/PCS`, `AWS/Network Manager` and
`AWS/EC2/InfrastructurePerformance` are collectable in 4.x but had no 3.x
equivalent.

For the authoritative list rather than this snapshot, use the provider's own data
source:

```terraform
data "datadog_integration_aws_available_namespaces" "all" {}
```

### New defaults worth checking

The 4.x resource exposes settings the 3.x resource did not, so the module now has
variables for them. Defaults follow the provider:

| Variable | Default | Note |
| --- | --- | --- |
| `resources_extended_collection` | `true` | **Check this one against your live config before applying** — see [Resource collection](#resource-collection) below. |
| `resources_cspm_collection` | `false` | Layered on `resources_extended_collection` and requires it. Needs permissions beyond what this module grants — use `extra_policy_arns`. |
| `metrics_enabled` | `true` | |
| `metrics_automute_enabled` | `true` | |
| `metrics_collect_cloudwatch_alarms` | `false` | 3.x `crawl_alarms` |
| `metrics_collect_custom_metrics` | `false` | 3.x `collect_custom_metrics` |
| `xray_include_all` / `xray_services` | `false` / `[]` | No X-Ray trace collection. Mutually exclusive. |
| `logs_lambda_forwarder_arns` / `logs_sources` | `[]` / `[]` | Datadog-side log autosubscription. Empty does not mean "leave Datadog alone" — it clears whatever is configured there on the first apply, so populate these from the imported state if you had `datadog_integration_aws_lambda_arn` or `_log_collection` resources. The CloudWatch subscription filters this module creates from `cloudwatch_log_groups` are separate and unaffected. |
| `metrics_tag_filters` | `{}` | Per-namespace metrics tag filters. New in 4.x — 3.x could only filter `AWS/EC2`, via `filter_tags`. |

One new hard failure: `aws_account_id` must be 12 digits. Leaving it unset while
`enable_datadog_aws_integration` is `true` used to register an empty account;
it now fails the plan.

#### Resource collection

This is the one default that can change behaviour in either direction, so check
it rather than accepting it.

3.x had the same field, as `extended_resource_collection_enabled`, but it was
computed with no default and **this module never set it** — so 3.x sent nothing
and Datadog kept whatever the account already had.

4.x removes that middle ground. `extended_collection` carries a static default of
`true`, so omitting it still sends `true`; there is no "leave it as-is" value.
The first apply therefore asserts a value, in whichever direction disagrees with
the account: `true` against an account currently off turns it on, and `false`
against one currently on turns it off.

Read the live value before you apply, and set the variable to match unless you
actually want to change it:

```
curl -s -H "DD-API-KEY: $DD_API_KEY" -H "DD-APPLICATION-KEY: $DD_APP_KEY" \
  "https://api.${DD_SITE:-datadoghq.com}/api/v2/integration/aws/accounts" \
  | jq -r '.data[] | [.attributes.aws_account_id,
      .attributes.resources_config.extended_collection] | @tsv'
```

The imported state from step 5 shows the same value, so the plan will tell you
too — this just lets you know before you start.

### Rollback

Before you apply in step 6, rollback is pinning `version = "~>3"` again and
re-importing the old resource.

Revert the `module` block's arguments to their 3.x names at the same time as the
version pin. 3.x does not declare `included_regions`, `metrics_*`, `resources_*`,
`logs_*` or `xray_*`, so leaving them in place fails with `An argument named
"included_regions" is not expected here` before `init` or `import` can run.

```
tofu state rm 'module.datadog.datadog_integration_aws_account.core[0]'
tofu init -upgrade
EXTERNAL_ID='<external-id-from-step-1>' \
  tofu import 'module.datadog.datadog_integration_aws.core[0]' '<your-aws-account-id>:datadog-integration-role'
```

The 3.x resource imports by `account_id:role_name`, not by config ID, and it
takes the external ID from an `EXTERNAL_ID` environment variable because the v1
API does not return it. This module always names the role
`datadog-integration-role`.

That external ID is the one thing you cannot recover after the fact, which is
the real reason step 1 is not optional. Nothing in Datadog changed up to this
point, so with it in hand this is a clean revert.

After you apply, rollback means the same steps plus whatever the apply changed in
Datadog, which is why step 5 is worth doing carefully.

### Troubleshooting

**`Datadog is not authorized to perform action sts:AssumeRole`** — the external
ID and the IAM trust policy disagree. Compare `external_id` in state against the
Datadog UI. To force a fresh one:

```
tofu apply -replace='module.datadog.datadog_integration_aws_account.core[0]'
```

**`Invalid Attribute Combination`** — you set both sides of a mutually exclusive
pair: `metrics_namespace_include_only` with `metrics_namespace_exclude_only`, or
`xray_include_all` with `xray_services`. Drop one.

**`invalid aws_account_id`** — `aws_account_id` is unset or not 12 digits while
the integration is enabled.

**`Unsupported attribute` on `external_id`** — you are referencing the 3.x path.
In 4.x it is
`datadog_integration_aws_account.core[0].auth_config.aws_auth_config_role.external_id`,
with no index on the nested blocks.

**Plan wants to destroy and recreate the integration** — the import in step 4 did
not land. Check `tofu state list` includes
`module.datadog.datadog_integration_aws_account.core[0]`. Do not apply.

---

Namespace lists and provider behaviour verified against Datadog provider 4.21.0
on 2026-09-17.
