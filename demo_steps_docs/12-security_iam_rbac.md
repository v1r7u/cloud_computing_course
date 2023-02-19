# Identity Access Management

The goal: introduction into identity access management

## Azure Identity Access Management (IAM)

1. Azure Active Directory (AAD) - platform to manage and secure identities (human and not):

    - CRUD operations for identities (users and applications)
    - Aggregate identities into groups
    - CRUD operations for groups
    - Manage identities permissions and authentication methods
    - audit

    AAD manages identities and their access rights to AAD itself.

2. Open AAD single user view and show:

    - sign-ins and main information
    - groups and roles management
    - password and authentication
    - audit

3. Open a Subscription Access Control view:

    - `Check Access`: investigate your and others roles within your subscription scope
    - `Role Assignments`: assign a role to identity or group
    - `Roles`: view end edit roles. Note, pressing on `View` link shows all the role permissions.

4. Role/permission is given to identity within a _scope_. Assignment involves the following steps:

    - Determine who needs access (e.g. find identity): user, application, group
    - Select role
    - Select scope: subscription, resource group, or exact azure resource (service)
    - Assign the role to the identity within the scope

    Azure [role-assignment guide](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-steps).

## Kubernetes Role Based Access Control (RBAC)

Kubernetes uses similar concepts but under slightly different names.

Show all the following steps in minikube: `minikube start -n 2`

NOTE: to use `podman` instead of `docker` as minikube driver, you must run sligtly different commands. The command could be similar to `minikube start --driver=podman --container-runtime=cri-o -n 2`. You could consider running rootless podman (minikube support for rootless is in beta and should be enabled separately `minikube config set rootless true`)

1. Kubernetes could integrate with external Auth-providers (for example, AAD)

2. `Identity` in Kubernetes: User (human), Service Account (application), Group (aggregation)

3. Kubernetes scope consist of two parts: namespace and resource type (note, some resource types are not-namespaced)

4. Kubernetes offers `Role` (inside namespace only) and `ClusterRole` (available in the whole cluster).

    - Kubernetes roles coupled with REST api _verbs_
    - Consist of policies list: which _verb_ is allowed to which resource type

    ```sh
    # get all cluster roles
    kubectl get ClusterRole

    # describe defaul admin role
    kubectl describe ClusterRole admin
    ```

5. Kubernetes can _bind_ `Role` or `ClusterRole` to an `Identity`

    - `Role` could be bind to an `Identity` only in the scope of namespace
    - `ClusterRole` could be bind to an `Identity` cluster-wide or in one namespace only.

    ```sh
    kubectl get clusterrolebindings

    kubectl describe clusterrolebindings ...
    ```

6. There are tools to help navigating RBAC world: 

    - native kubectl:

    ```
    $ kubectl auth can-i delete namespace
    Warning: resource 'namespaces' is not namespace scoped
    yes

    $ kubectl auth can-i delete ns --as joe
    Warning: resource 'namespaces' is not namespace scoped
    no
    ```

    - [who-can](https://github.com/aquasecurity/kubectl-who-can),
    - [rbac-lookup](https://github.com/FairwindsOps/rbac-lookup), 
    - or kubernetes IDEs ([k9s](https://github.com/derailed/k9s), [lens](https://github.com/lensapp/lens), [octant](https://github.com/vmware-tanzu/octant), etc)
