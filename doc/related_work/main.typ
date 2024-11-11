#import "@preview/charged-ieee:0.1.3": ieee
#import "@preview/timeliney:0.0.1"

// Canvas: <https://canvas.wisc.edu/courses/412873/discussion_topics/1979599>
// Project Desc: <~>
#set terms(hanging-indent: 0em)

#show: ieee.with(
  title: [Blurring the Boundary Between Serverless and Containerized Deployments For Interactive Webapps\
  #text(weight: "extrabold")[Related Work Report]],
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


= Related Work

/ Serverless Platform Comparision:  The paper by Li et al.@Li2019 focuses on the architectural blocks that influence the performance of Kubernetes-based open-source serverless platforms, including Knative, Kubeless, Nuclio and OpenFaaS. It offers a deeper understanding of design considerations and their impact on performance and auto-scaling. Kaviani et al.@Kaviani2019 explore the commonality and differences between several serverless computing platforms' interfaces, emphasizing the need for a unified interface to prevent vendor lock-in. They use Knative as a baseline and discuss the challenges and possible directions for serverless platforms to reach commodity status.

/ Containers and serverless: Many previous work has focused on how to use both containers and serverless technologies together to decrease latency and cost while improving scalability. In fact many use containers to implement the serverless paradigm like SOCK@216031. SOCK proposes to use lightweight isolation primitives to aleviate functions sandboxing bootlenecks and Zygote-provisioning with 3-tier caching to improve starup latency. However, they all focus on reducing latency and cost by reducing startup time of serverless functions. As per our knowledge none of them focuses on how to intelligently distribute requests between containers and serverless to take advantage of both worlds. Approaches like SCAR@PEREZ201850 provides a framework which gives an impression of running containers on top of serverless platform. They tried to extend elastic scaling of these platform to other non-traditionally applications like High Throughput Computing applications. However they failed to provide a solution which can achieve scaling while minimizing cost. 

/ Knative : Tran et al.@Tran2024 states the problem with the default auto-scaler in Knative being suboptimal. Knative uses Knative Horizontal Pod Autoscaler (K-HPA) in which it monitors user defined parameters and the load of each services. However, ill-defined values leads to problems such as over-provisioning. So this work provides a solution that builds an optimal profile of each service depending on what it observes. They accomplish this without modifying the code base of Knative via extensions or custom resources. For auto-scaling, there are two schemes. Vertical scaling in which the resource allocation of existing instances are increases, and whereas Horizontal scaling increases the number of instances of a service. This paper introduces a hybrid approach that uses reinforcement learning to implement the hybrid approach. Their results show the hybrid approach achieved better scaling in terms of resources allocation and service latency compared to other methods. This relates to our work in the fact that we are using horizontal scaling when the VMs are overloaded in booting up severless function instances to handle the additional traffic.


// - Conduct a baseline study of the resource efficiency and performance metrics for classic autoscaling techniques. To start, pick an application from deathstarbench and deploy it on a k8s cluster on cloudlab.
// - Run the same application in its serverless form on an openwhisk cluster on Cloudlab 
// - Implement a load balancer/scheduler that routes requests to the serverless framework as the container gets overloaded.
// - Measure the performance impact of the proposed load-absorption solution.

// - Conduct a cost analysis to understand: when is it cost-efficient to stop using serverless to absorb traffic and spin up a new conatiner?
// - Do a cost analysis for: what is the benefit of using a smaller, less expensive VM if serverless effectively absorbs the load? (A typical rule of thumb suggests selecting the VM size that operates at ~40% CPU utilization for sustained throughput. By leveraging serverless to handle spikes, we could potentially choose smaller VMs, resulting in greater cost efficiency and effective resource utilization.)
