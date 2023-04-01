# Create Azure Kuberntes Service from Azure Portal

The goal: show required steps to create a complex Azure offering (AKS)

1. Open "create service" view and select Kubernetes Service. Fill in the form:

    1. Create new resource group.

    2. Enter unique within Resource Group AKS name.

    3. Select desired region (based on region might change avaialble VM types, availability zones, kubernetes versions)

    4. Select availability zones (for example, deselect all zones to opt-out from zone-redundancy)

    5. Select desired Kubernetes version (for example, the latest available)

    6. Select primary node pool VM type and count (only one VM could be enough)

    7. Go to Node Pools. Add new `zeropool` without availability zones with any VM type and scale it to 0.

    8. Go to authentication. Explain high-level meaning of each property.

    9. Go to Networking. Stay with default values, but choose Network Policy plugin. Networking stack should be explained at demo `05-core-services_networking`.

    10. Go to Integrations. Stay with defaults.

    11. Skip tags, create AKS.

2. Review created AKS

    1. Enable auto-scaler for `zeropool`.

    2. Note, cloud can also go out of capacity:
        - concrete region can run out of particular VM type
        - or, you could exceed the quota assigned to your account (cloud providers use quota to plan amount of required resources)

        Sometimes you need to choose another region, or another VM type (or use autoscaling with combination of different VM types)

    3. Show Kubernetes resources and Container Insights.

        Note, you might need `Azure Kubernetes Service Cluster Admin Role` and `Azure Kubernetes Service RBAC Cluster Admin` roles to view resources.

    4. Get Kuberentes credentials, for example: `az aks get-credentials --resource-group <RG-NAME> --name <AKS-NAME> --subscription <Subscription-ID>`

    5. Create a test deployment to show how cluster-autoscaler works: `kubectl apply -f ./demo_steps_docs/03-core-services_aks_deployment.yaml`. Use `kubectl get pods` and `kubectl describe pod` to show that pods are created and nodes were requested.

    You can also
      - _watch_ to follow the process of creating new VMs: `kubectl get nodes -owide -w`
      - Open node-pool in azure portal to show how numbers are changing
      - Scale Deployment: `kubectl scale deployment/my-dep --replicas 4`

    When the pods are up and running, consider deleting the deployment to show that Azure _eventually_ deprovision VMs: `kubectl delete -f ./demo_steps_docs/03-core-services_aks_deployment.yaml`

    6. Show created _system resource group_ with VMs and networking stack.
