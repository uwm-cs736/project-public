#import "@preview/charged-ieee:0.1.3": ieee
#import "@preview/timeliney:0.0.1"

// Canvas: <https://canvas.wisc.edu/courses/412873/discussion_topics/1979599>
// Project Desc: <~>
#set terms(hanging-indent: 0em)

#show: ieee.with(
  title: [Blurring the Boundary Between Serverless and Containerized Deployments For Interactive Webapps],
  authors: (
    (
      name: "Mondo Jiang",
      email: "mondo.jiang@wisc.edu"
    ),
    (
      name: "Shivam Hire",
      email: "hire@wisc.edu"
    ),
    (
      name: "Thinh Nguyen",
      email: "tdnguyen25@wisc.edu"
    ),
  ),
  // JabRef
  bibliography: bibliography("refs.bib"),
)

// state the problem you are planning to solve, the motivation for why this problem is important, your initial plans for approaching the problem, and your proposed methodology for evaluation. 


#show "kind": [kind@link-kind]
#show "Cloudlab": [Cloudlab@Duplyakin2019]
#show "DeathStarBench": [DeathStarBench@Gan2019]
#show "vHive": [vHive@Ustiugov2021]
#show "OpenFaaS": [OpenFaaS@link-openfaas]
#show "Traefix": [Traefix@link-traefix]
#show "Candy": [Candy@link-candy]


= Introduction

Web services have to handle unpredictable changes in demand. The deployment infrastructure have to scale out dynamically as demand fluctuates to keep latencies within acceptable limit.

Traditionally, web services were deployed using VMs @Armbrust:EECS-2009-28 and as containers. To scale out we have to setup a static policy like scale up if CPU > 80% and scale down if CPU < 40%. These kind of policies can cause inefficient resource usage. VMs have a considerable startup time hence we have to keep them on stand-by just in case we get sudden spike in demand. This leads to wastage of resources and money.

In recent years, web apps have also be deployed on serverless offerings since they can scale out instantly and provides fine-grained flexibility. These offerings can also handle bursty traffic more efficiently. However, when compared to VMs, these offerings are more costly leading to increase in operational cost.

We will be exploring how we can combines the two system to get best of the both worlds. We will use VMs for handling normal traffic. But as soon as we see more traffic coming in we will send it serverless functions instead of spinning up new VMs. This delay in scaling out the VM can obviate the need for scaling out (in the case of bursty traffic), or hide the delay of spinning up a VM (without requiring the provider to pre-warm the VM instance).

= Methodology

// https://github.com/uwm-cs744-24spring-project-team/crispy-octo 
// https://github.com/delimitrou/DeathStarBench/tree/master/hotelReservation
// (K8s, Deployment configuration (installation of the load balancer, backing env for faas) (Cloudlab, Google GKE, My machine)

/ Cluster Preparation: Considering the complexity of manually setting up a cluster and the need for a quiet environment, we’ll automate cluster creation and teardown. We’ll start with a local Kubernetes cluster using kind to validate our testing code and deployments. As kind supports simulating multi-node setups, we may also use a Cloudlab cluster depending on experimental needs. Beyond basic container controllers, a serverless runtime solution (e.g., OpenFaaS) will be installed in our cluster. 

/ Baseline Performance Study: We’ll begin with one DeathStarBench or vHive example application. They provide tools for generating workloads and serverless equivalents of the business logic. We’ll develop a standard method to gather basic performance metrics (CPU load, memory usage, QPS) for both forms, which will inform our load-redirection policies between containers and functions.

/ Custom Load Balancer: Depending on subsequent studies, we may modify an existing ingress controller (e.g., nginx, Traefik) or other load balancers without ingress mode (e.g., Candy). Ideally, we’ll leverage libraries supporting custom plugins for load balancing logic. If unavailable, a simple load balancer can be implemented. Determining load distribution among nodes will be a future task.

/ Cost Analysis for Simple Workload: By measuring resource occupancy time, we can estimate the total experiment costs. We’ll start with basic scripts to gather data and convert it into reports for analysis. We'll follow a similar pattern to one of the papers presented in our paper review session@Wu2024. 

/ Further Experiments: If time allows, we’ll run similar tests with varied settings, such as adjusting thresholds for container vs. function selection and changing cluster configurations (e.g., node count, cores per node). This will provide deeper insights into load balancer behavior and the characteristics of each deployment type.

// - Conduct a baseline study of the resource efficiency and performance metrics for classic autoscaling techniques. To start, pick an application from deathstarbench and deploy it on a k8s cluster on cloudlab.
// - Run the same application in its serverless form on an openwhisk cluster on Cloudlab 
// - Implement a load balancer/scheduler that routes requests to the serverless framework as the container gets overloaded.
// - Measure the performance impact of the proposed load-absorption solution.

// - Conduct a cost analysis to understand: when is it cost-efficient to stop using serverless to absorb traffic and spin up a new conatiner?
// - Do a cost analysis for: what is the benefit of using a smaller, less expensive VM if serverless effectively absorbs the load? (A typical rule of thumb suggests selecting the VM size that operates at ~40% CPU utilization for sustained throughput. By leveraging serverless to handle spikes, we could potentially choose smaller VMs, resulting in greater cost efficiency and effective resource utilization.)

= Timeline

/ Week 1: Cluster setup, group study, and proposal preparation.
/ Week 2: Baseline performance study.
/ Weeks 3-4: Development and verification of a custom load balancer.
/ Weeks 5-6: Cost analysis and additional experiments.
