# cd4pe_deployments

#### Table of Contents

1. [Description](#description)
2. [Usage](#usage)
    * [Build your own policy](#build-your-own-policy)
    * [Error handling](#error-handling)
3. [Reference](#reference)
4. [Development](#development)

## Description

This module provides a set of tools, via CD4PE, for creating your own custom CD4PE deployment policies as well as our 4 built-in policies: [Feature branch](plans/feature_branch.pp), [Temporary branch](plans/rolling.pp), [Direct](plans/direct.pp), and [Eventual consistency](plans/eventual_consistency.pp).

## Usage

### Build your own policy

1. Get started with a custom deployment policy by creating a [Puppet Plan] in the `plans/` directory.
2. You'll have access to all of the functions listed in our [REFERENCE.md] to perform deployment operations (e.g. pinning nodes to an environment group or getting information about an environment group)
3. Deployment policies will run inside a CD4PE context with certain environment variables available.

    * `BRANCH`: the name of the branch you are deploying _from_; your pipeline branch
    * `COMMIT`: HEAD commit SHA of the branch you are deploying from
    * `NODE_GROUP_ID`: alpha-numberic ID of the node group you are deploying _to_
    * `REPO_TARGET_BRANCH`: name of the source control branch that represents the target environment
    * `ENVIRONMENT_PREFIX`: if you are deploying to a prefixed environment, this is that prefix
    * `REPO_TYPE`: will either be CONTROL_REPO or MDOULE
    * `DEPLOYMENT_DOMAIN`: domain of the workspace that initiates the deployment
    * `DEPLOYMENT_ID`: unique ID of the deployment
    * `DEPLOYMENT_TOKEN`: the auth token that authenticates deployment tasks against CD4PE
    * `DEPLOYMENT_OWNER`: user that intitiates the deployment

4. Use any of the functions in this module (see [REFERENCE.md] to build your deployment policy.
    ```
    $result = get_node_group('abcd-1234-efgh-56789')

    if($result['error']){
      fail_plan("Could not get node group! ${result[error][message]}")
    }
    ```
5. Take a look at our [built-in policies](plans/) for examples to help you get started.

### Error handling

#### CD4PEFunctionResult

Most functions available in this module will always return a [CD4PEFunctionResult] that contains:
- result
- error: { message, code }

#### Example success result
```ruby
{
  result: {
    approvalDecision: "APPROVED"
  },
  error: nil
}
```

#### Example error result
```ruby
{
  result: nil,
  error: {
    message: "Something went wrong",
    code: "SomeErrorCode",
  }
}
```

#### Error Codes
- `ParameterMissing`
  - The CD4PE API was expecting a parameter that was not provided.
- `ParameterParsing`
  - The CD4PE API was unable to parse the provided parameter value.
- `FunctionFailure`
  - CD4PE was unable to complete the function's primary purpose (e.g. run_puppet() failed to run Puppet)

## Reference

See our [REFERENCE.md] for reference documentation.

## Development

### Getting Started

1. Fork the module repository on GitHub and clone to your workspace

1. Make your changes!

1. Commit your changes and push them to your fork

1. Open a PR against puppetlabs/master

### Testing

TBD


[Puppet Plan]:https://puppet.com/docs/bolt/latest/writing_plans.html
[CD4PEFunctionResult]:lib/puppet_x/puppetlabs/cd4pe_function_result.rb
[REFERENCE.md]:REFERENCE.md
[CONTRIBUTING.md]:CONTRIBUTING.md
