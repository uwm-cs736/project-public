#import "@preview/charged-ieee:0.1.3": ieee
#import "@preview/timeliney:0.0.1"

// Canvas: <https://canvas.wisc.edu/courses/412873/discussion_topics/1979599>
// Project Desc: <https://docs.google.com/document/d/1qK0Pijbm0lcc1SI3ZeMZIMgEn0iYsVeOQo3NR814u_Y/edit?tab=t.0#heading=h.pm6zgqidrx64>


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


= Introduction

Web services have historically been deployed on VMs (EC2) and as containers (Kubernetes). For dynamic workloads, both primitives allow users to define autoscaling policies. These policies are typically static (e.g., a policy may specify scaling up when CPU > 80% and scaling down when CPU < 40%). Such policies are also often pessimistic—instances may scale up too quickly and remain active longer than necessary. Prewarming resources results in wasted resource efficiency, while waiting too long to scale results in degraded latencies.  In recent years, web apps have also been deployed on serverless offerings (e.g., Azure Functions, AWS Lambda). Both approaches have advantages: coarse-grained primitives like VMs and containers are more cost-efficient for sustained workloads, while serverless functions provide fine-grained flexibility.

The idea is to use serverless functions to handle bursty traffic, without resorting to immediately scaling up potentially beefy VMs.  This delay in scaling out the VM can obviate the need for scaling out (in the case of bursty traffic), or hide the delay of spinning up a VM (without requiring the provider to pre-warm the VM instance).

= Methodology

// https://github.com/uwm-cs744-24spring-project-team/crispy-octo 
+ Cluster preparation (K8s, Deployment configuration (installation of the load balancer, backing env for faas) (Cloudlab, Google GKE, My machine)
+ Baseline performance study (standard testing code, the application we want to run for both envs, run a simple test but the results don't matter)
// https://github.com/delimitrou/DeathStarBench/tree/master/hotelReservation
+ Implementation/modification on existing ingress controller
  + Baseline again using this new solution
+ Cost analysis for single workload (must scale out/bursty)---

// - Conduct a baseline study of the resource efficiency and performance metrics for classic autoscaling techniques. To start, pick an application from deathstarbench and deploy it on a k8s cluster on cloudlab.
// - Run the same application in its serverless form on an openwhisk cluster on Cloudlab 
// - Implement a load balancer/scheduler that routes requests to the serverless framework as the container gets overloaded.
// - Measure the performance impact of the proposed load-absorption solution.

// - Conduct a cost analysis to understand: when is it cost-efficient to stop using serverless to absorb traffic and spin up a new conatiner?
// - Do a cost analysis for: what is the benefit of using a smaller, less expensive VM if serverless effectively absorbs the load? (A typical rule of thumb suggests selecting the VM size that operates at ~40% CPU utilization for sustained throughput. By leveraging serverless to handle spikes, we could potentially choose smaller VMs, resulting in greater cost efficiency and effective resource utilization.)

= Plan

/ Week 1: complete xxx
/ Week 2: complete xxx
/ Week 3: complete xxx
/ Week 4: complete xxx