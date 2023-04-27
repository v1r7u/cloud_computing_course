# Policies

The goal: introduction into policies management

1. Policy: system of rules and principal to achieve a rational outcomes.

2. Why do we need policies:

    - A set of agreements/rules that should enforce desired outcome
    - Clouds are monstrously huge and keeping everything in head is impossible - policies can help to track your posture
    - Policy encodes decision, avoid repeating mistakes, comply with legal requirements

3. Try to keep policies as code:

    - codify your rules
    - review and history
    - easier to ensure policies compliance

4. (Almost) each cloud has built-in policy-engines. (Almost) each tool/framework has own policy-engine. There are also open source solutions, for example, [Open Policy Agent](https://www.openpolicyagent.org/), [Checkov](https://github.com/bridgecrewio/checkov), [Polaris](https://github.com/FairwindsOps/polaris) to name a few.

5. You can verify your configuration before release (as a part of ci/cd process or Pull-Request review process) or even in runtime.

6. For example, to scan terraform configuration in this repository with checkov

```sh
ABSOLUTE_PATH_TO_TF=/home/cloudcomp/cloud_computing_course/src/terraform
docker run --volume $ABSOLUTE_PATH_TO_TF:/tf bridgecrew/checkov:2.3.199 --quiet --compact --directory /tf
```
