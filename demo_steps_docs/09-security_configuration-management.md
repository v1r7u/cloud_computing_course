# Configuration management

The goal: introduction into configuration-management

Disclaimer: the following section give only a brief introduction into the topics and propose a few low-hanging fruits to get started.

## Common Vulnerabilities and Exposures (CVE)

1. (Almost) all the software has issues (intentional or not).

    - Likely, we are not eager to run application with known issues inside.
    - When an issue is discovered, engineers try to fix it and release a fix/patch.
    - When a patch is released, we have to apply it to get rid of the issue.

2. _Common Vulnerabilities and Exposures_ system provides a standard to describe vulnerable software: ID, description, severity, references.

3. There are tools that helps to compare your software with CVE database to find if your software has any _known_ issue. You can scan your OS, application codebase, container images

4. One of popular _scanners_ is [trivy](https://github.com/aquasecurity/trivy). You can install it to your machine or run inside a container, for example:

    ```sh
    docker run --rm -v ~/.trivy:/root/.cache/ aquasec/trivy:0.40.0 image python:3.9
    ```

    Discalimer: there are a lot of other free and commercial scanners: [Clair](https://github.com/quay/clair), [anchore/grype](https://github.com/anchore/grype), [snyk](https://snyk.io/product/container-vulnerability-management/) to name a few.

    NOTE: `trivy` does not actually dive into packages content, but _trusts_ reported version number. For example, you can update java pom file manually to _trick_ the tool. Thus it's not a reliable runtime protection, but an assistant to understand your software.

5. You can include image-scanning as gate before pushing an image to Container Registry. thus, if container has a known vulnerability - image is not released:

    ```sh
    docker run --rm -v ~/.trivy:/root/.cache/ aquasec/trivy:0.40.0 image --exit-code 1 --no-progress python:3.9

    # get exit-code of last command
    echo $?

    docker run --rm -v ~/.trivy:/root/.cache/ aquasec/trivy:0.40.0 image --exit-code 1 --no-progress alpine:latest

    echo $?
    ```

    You can fail only on critical issues `--severity HIGH,CRITICAL`, ignore unfixed `--ignore-unfixed` or particular CVEs `--ignorefile ~/.trivyignore`.

6. Often, you do not have to fix all the CVEs manually, but change your base image:

    ```sh
    ### buster
    docker run --rm -v ~/.trivy:/root/.cache/ aquasec/trivy:0.40.0 image --exit-code 1 --no-progress python:3.9

    python:3.9 (debian 10.9)
    ========================
    Total: 1729 (UNKNOWN: 0, LOW: 1119, MEDIUM: 335, HIGH: 214, CRITICAL: 61)
    ```

    ```sh
    ### buster-slim
    docker run --rm -v ~/.trivy:/root/.cache/ aquasec/trivy:0.40.0 image --exit-code 1 --no-progress python:3.9-slim

    python:3.9-slim (debian 10.9)
    =============================
    Total: 109 (UNKNOWN: 1, LOW: 74, MEDIUM: 11, HIGH: 21, CRITICAL: 2)
    ```

    ```sh
    ### alpine
    docker run --rm -v ~/.trivy:/root/.cache/ aquasec/trivy:0.40.0 image --exit-code 1 --no-progress python:3.9-alpine

    python:3.9-alpine (alpine 3.13.5)
    =================================
    Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
    ```

    The difference in base images is also amount of used tools: more tools - more issues. For example, compare `python` image sizes:

    ```sh
    $ docker images python
    REPOSITORY   TAG          IMAGE ID       CREATED       SIZE
    python       3.9-slim     afaa64e7c7fe   11 days ago   115MB
    python       3.9          a6a0779c5fb2   11 days ago   886MB
    python       3.9-alpine   95795c6eb47f   2 weeks ago   44.9MB
    ```

## Software supply-chain protection

1. Software supply chain (e.g. code delivery process): write code, build, test, deploy, run, monitor.

2. Build your solution only on top of trusted sources. For example, do not use no-name pip/npm packages or base docker-images. Consider pulling used dependencies to your local package registry instead of pulling from public sources.

3. During writing code you can use [Static Code Analysis](https://en.wikipedia.org/wiki/Static_program_analysis) tools to catch issues earlier. To find a tool for your language, search `static code analysis {your programming language}`. Maybe, the most popular one is [Sonarqube](https://www.sonarqube.org/).

4. Regularly patch your dependencies and run scanners, like `trivy` above.

5. Sign your [commits](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work), [container images](https://docs.docker.com/engine/security/trust/) (or with [cosign](https://docs.sigstore.dev/cosign/signing_with_containers/)).

6. Verify signatures. For example:

    - Github can require signed commits;
    - Container Runtime can _trust_ only particular keys;
    - or you can verify signed container images localy: https://docs.sigstore.dev/cosign/verify/

7. Protect access to your _build_ tools.

8. Use immutable versions whenever is possible.

    For example, container images has immutable id:

    ```sh
    # run image using mutable tag:
    docker run -it --rm python:3.9

    # find image immutable digest:
    docker inspect --format='{{index .RepoDigests 0}}' python:3.9
    # or
    docker images --digests

    # run image by digest instaed of tag:
    # NOTE: likely, at the moment the hash is different, e.g. someone pushed a new image with the same 3.9 tag
    docker run -it --rm python@sha256:f265c5096aa52bdd478d2a5ed097727f51721fda20686523ab1b3038cc7d6417
    ```

## Summary

1. Start from trusted code
2. Scan and sign your code and container images
3. Regularly patch your software
4. Less CVEs - less issues
5. Smaller image -> less tools -> less CVEs
6. Use immutable versions

## Further reading

- [How to Spoof Any User on Github…and What to Do to Prevent It](https://blog.gruntwork.io/how-to-spoof-any-user-on-github-and-what-to-do-to-prevent-it-e237e95b8deb).
- [Supply chain attacks](https://docs.microsoft.com/en-us/windows/security/threat-protection/intelligence/supply-chain-malware) article by Microsoft.
- [Open source maintainer pulls the plug on npm packages colors and faker](https://snyk.io/blog/open-source-npm-packages-colors-faker/)
- [Alpine is evil](https://martinheinz.dev/blog/92), try [chainguard](https://github.com/chainguard-images)
- [Imposter Commits in GitHub Actions](https://www.chainguard.dev/unchained/what-the-fork-imposter-commits-in-github-actions-and-ci-cd)
