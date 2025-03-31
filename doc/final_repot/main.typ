#import "@preview/charged-ieee:0.1.3": ieee
#import "@preview/timeliney:0.0.1"

// Canvas: <https://canvas.wisc.edu/courses/412873/discussion_topics/1979599>
// Project Desc: <~>
// #set terms(hanging-indent: 0em)

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
  abstract: [
    This study explores the integration of containerized and serverless deployment strategies to optimize the scalability and cost-efficiency of interactive web applications. The report evaluates Kubernetes-based container deployments and Knative-powered serverless deployments using the DeathStarBench HotelReservation application. Experiments were conducted on a CloudLab cluster to assess performance under varying workloads. Results reveal that serverless deployments demonstrate higher latency compared to containers. Conversely, container deployments exhibit lower latency but lack dynamic scalability. The findings highlight the potential for a hybrid approach that combines the rapid scalability of serverless functions with the cost efficiency and performance stability of containers. Future work should address the challenges of hybrid deployment and focus on cost analyses to validate the feasibility of such solutions.
  ]
)

// state the problem you are planning to solve, the motivation for why this problem is important, your initial plans for approaching the problem, and your proposed methodology for evaluation. 


#show "kind": [kind@link-kind]
#show "Cloudlab": [Cloudlab@Duplyakin2019]
#show "DeathStarBench": [DeathStarBench@Gan2019]
#show "vHive": [vHive@Ustiugov2021]
#show "OpenFaaS": [OpenFaaS@link-openfaas]
#show "Traefix": [Traefix@link-traefix]
#show "Candy": [Candy@link-candy]

// To finalize your projects, you need to write up a report. 

// Your report should be no longer than 12 pages, including figures, tables, and references, using 10 point or larger fonts. The paper should be single-spaced (two-column is preferred but not required; we also prefer left and right margin justified instead of ragged).  We suggest you use latex for formatting your paper, but this is optional.  Remember to spell check and read through for grammatical issues.

// Papers must be submitted in PDF. 

// You should submit a report that is similar in style and substance to the conference papers we have been reading.  Your report should have enough detail such that someone else could replicate your ideas and re-run similar experiments. 

// In particular, your report should have the following sections:

// Title and Author List: Pick a title that describes something specific about what you have accomplished
// Abstract: Describe very briefly what you do, how you do it, and the results.
// Introduction: Motivate the problem. Start with generalities, and narrow in on your problem. Describe your approach at a very high level.  Summarize results.  Give an outline of the rest of the paper.
// Background: Describe the knowledge you assuming the reader already has in order to make this document (mostly) self-contained.
// Design and Implementation: Description of what you did/built. Use pictures and words to show what you did.  Think about how to organize what you are doing: start with a high-level description of the design and then give the details of your implementation.
// Methodology: Describe your experimental platform including the hardware, OS version, other software, or useful tools.  Describe your workloads along with any starting state of the system (e.g., cold or warm caches?) and the number of iterations each data point represents.
// Results & Discussion:
// Present a quantitative measure (table or graph) of your results.   (Having enough iterations to show confidence itervals or box-whiskers plots would be great.)
// Include a full description of each experiment and the results. Clearly explain each workload and each graph (along with what is on each axis).
// What questions are you answering?  What is the point of each graph?  How much can you explain each of the results you have measured?  What conclusions can you draw from it?
// Were these your expected results?  Why might there be differences?
// Related Work: You can include the related work report you submitted earlier; update it as needed.
// Conclusion
// -Summarize what you did and how effective it was.
// Bibliography
// -Properly formatted citations for any resources/papers you used
// Feel free to submit this final report before the final due date. 

= Introduction
Web services have to handle unpredictable changes in demand. The deployment infrastructure have to scale out dynamically as demand fluctuates to keep latencies within acceptable limit.

Traditionally, web services were deployed using VMs @Armbrust:EECS-2009-28 and as containers. To scale out we have to setup a static policy like scale up if CPU > 80% and scale down if CPU < 40%. These kind @link-kind of policies can cause inefficient resource usage. VMs have a considerable startup time hence we have to keepthem on stand-by just in case we get sudden spike in demand. This leads to wastage of resources and money.

In recent years, web apps have also be deployed on serverless offerings since they can scale out instantly and provides fine-grained flexibility. These offerings can also handle bursty
traffic more efficiently. However, when compared to VMs, these offerings are more costly leading to increase in operational cost.

We will be exploring how we can combines the two system to get best of the both worlds. We will use VMs for handling normal traffic. But as soon as we see more traffic coming in we will send it serverless functions instead of spinning up new VMs. This delay in scaling out the VM can obviate the need for scaling out (in the case of bursty traffic), or hide the delay of spinning up a VM (without requiring the provider to pre-warm the VM instance).

= Related Work

/ Serverless Platform Comparision:  The paper by Li et al.@Li2019 focuses on the architectural blocks that influence the performance of Kubernetes-based open-source serverless platforms, including Knative, Kubeless, Nuclio and OpenFaaS. It offers a deeper understanding of design considerations and their impact on performance and auto-scaling. Kaviani et al.@Kaviani2019 explore the commonality and differences between several serverless computing platforms' interfaces, emphasizing the need for a unified interface to prevent vendor lock-in. They use Knative as a baseline and discuss the challenges and possible directions for serverless platforms to reach commodity status.

/ Containers and serverless: Many previous work has focused on how to use both containers and serverless technologies together to decrease latency and cost while improving scalability. In fact many use containers to implement the serverless paradigm like SOCK@216031. SOCK proposes to use lightweight isolation primitives to aleviate functions sandboxing bootlenecks and Zygote-provisioning with 3-tier caching to improve starup latency. However, they all focus on reducing latency and cost by reducing startup time of serverless functions. As per our knowledge none of them focuses on how to intelligently distribute requests between containers and serverless to take advantage of both worlds. Approaches like SCAR@PEREZ201850 provides a framework which gives an impression of running containers on top of serverless platform. They tried to extend elastic scaling of these platform to other non-traditionally applications like High Throughput Computing applications. However they failed to provide a solution which can achieve scaling while minimizing cost. 

/ Knative : Tran et al.@Tran2024 states the problem with the default auto-scaler in Knative being suboptimal. Knative uses Knative Horizontal Pod Autoscaler (K-HPA) in which it monitors user defined parameters and the load of each services. However, ill-defined values leads to problems such as over-provisioning. So this work provides a solution that builds an optimal profile of each service depending on what it observes. They accomplish this without modifying the code base of Knative via extensions or custom resources. For auto-scaling, there are two schemes. Vertical scaling in which the resource allocation of existing instances are increases, and whereas Horizontal scaling increases the number of instances of a service. This paper introduces a hybrid approach that uses reinforcement learning to implement the hybrid approach. Their results show the hybrid approach achieved better scaling in terms of resources allocation and service latency compared to other methods. This relates to our work in the fact that we are using horizontal scaling when the VMs are overloaded in booting up severless function instances to handle the additional traffic.

= Background

== Kubernetes

Kubernetes is an open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications. Born out of the need to manage complex, distributed systems efficiently, Kubernetes has emerged as the de facto standard for container orchestration due to its robustness, flexibility, and extensibility.

In the context of our project, Kubernetes serves as the foundation for deploying and managing our applications. Its auto-scaling capabilities are particularly relevant as we aim to maintain performance during unpredictable demand fluctuations while optimizing resource utilization and cost.

=== Core Concepts

Kubernetes has several key concepts that define its architecture and functionality:

/ Pods: The smallest deployable units that can be created, scheduled, and managed. A pod typically contains one or more containers that are treated as a single entity.

/ Nodes and Masters: Nodes are worker machines in Kubernetes that run the pods. Masters, on the other hand, manage the cluster state and the scheduling of pods across nodes.

/ Services: An abstraction that defines a logical set of Pods and a policy by which to access them, often used to expose an application running on a set of Pods as a network service.

/ Deployments: Manage the declaration and update of application instances. They provide a way to describe the desired state of an application, including the number of replicas, and automatically handle the deployment and scaling of application instances.

/ Namespaces: Provide a way to divide cluster resources between multiple users (where each user may represent a team or project).

These core concepts will be integral to our methodology and will be referenced in later sections of our report as we delve into the specifics of our experiments and findings.

=== Auto-scaling in Kubernetes

Kubernetes support 3 types of autoscaling as given below:

- The Horizontal Pod Autoscaler (HPA) automatically adjusts the number of pod replicas in a deployment, replica set, or stateful set based on observed resource metrics such as CPU, memory, or custom metrics. It ensures the application can handle varying workloads by scaling out (adding pods) during high demand and scaling in (removing pods) during low demand. HPA is ideal for applications with fluctuating traffic, such as web apps with periodic spikes or background jobs with varying loads.
- The Vertical Pod Autoscaler (VPA) automatically adjusts CPU and memory resource requests and limits for pods to ensure efficient resource utilization. By increasing or decreasing resource allocations, VPA helps avoid over-provisioning (wasting resources) or under-provisioning (causing instability). It’s particularly useful for applications with predictable resource needs or workloads where the exact resource requirements are unknown, and can complement HPA by ensuring individual pods are right-sized. 
- The Cluster Autoscaler dynamically adjusts the number of nodes in a Kubernetes cluster based on pod scheduling needs. It scales up the cluster by adding nodes when pods cannot be scheduled due to insufficient resources, and scales down by removing underutilized nodes to save costs. This is ideal for cloud-based clusters where workloads require burst capacity or temporary scaling to handle large jobs, ensuring the cluster can grow or shrink with workload demands.

We primarily study HPA, but we don't actively implement it in the final experiments.
// According to our initial experiments VPA don't help web app hence we don't give a detail analysis of it.
// - Breakdown in latencies when we scale
// - 2 sec latency for HPA

== Serverless Platforms

=== Knative

// mondo@thinh
Knative is a platform for Kubernetes that streamlines the configuring process for serverless applications. It couples serverless computing with automatic scaling and event-driven architecture. For example, a core component is the Knative Serving in which it supports auto-scaling, traffic splitting, scaling to zero, and revision management. Auto-scaling adjusts in the number of pods depending on the traffic. This is supported with scaling to zero in which when the application is not used, it releases all the resources. Another core component is the Knative Eventing in which it provides a mechanism for a loosely decoupled process of the consumption and production of events. As such Knative is popular for web applications, micro-services, and event-driven applications given these core components. 

Knative is composed of three main components:

/ Knative Serving: This component manages the deployment and scaling of serverless containers. It allows developers to deploy applications without worrying about the underlying infrastructure, as Knative automatically handles the scaling from zero to hundreds or thousands of instances based on demand.

/ Knative Eventing: This component deals with event consumption and production. It provides a loosely decoupled system for event-driven applications, enabling the asynchronous communication between services.

/ Knative Networking: This component, which includes Kourier, manages the networking layer for Knative, providing features like routing and access control.

We mainly use Knative Serving for our experiments.

=== OpenFaaS

// thinh: OpenFaaS
When we first began, we were looking into OpenFaaS for deploying serverless functions of the hotel application. First as an experimental phase, we only used the standalone runtime of OpenFaaS, called faasd. This allows us to mess around with OpenFaaS without having to integrate it into our running Kubernetes cluster, which takes time for configuration. With the faasd engine running, which hosts the serverless functions that can be invoked via a curl request, we start to build some functions. Building the functions entails converting each micro-service into a container. However, we stumbled upon some difficulties in this process. For example, turning each micro-service into a container required a script that intercepts the incoming url request and redirects it to a function call. This script lives inside the container and would be replicated for each container of each micro-service. This is as far as we got because we stumbled upon the fact that Hotel Reservation already had a Knative deployment. As previously mentioned, Knative is another platform for running serverless micro-services. This meant the developers of Hotel Reservation already ported these micro-services into serverless forms, so we did not have to rebuild the wheel.


= Design and Methodology


== Cluster Setup

In this section, we aim to provide a comprehensive overview of the setup and configuration of our Kubernetes clusters, which serve as the foundation for our experiments.
We start with local cluster and a private cluster running in Mondo's personal pc. then switch to cloudlab for a universal testing environment.

=== Local Cluster

To gain hands-on experience with Kubernetes, we initiated our project by setting up local clusters on our development machines. We utilized kind, which facilitates the creation of local Kubernetes clusters using Docker container nodes. This approach allowed each team member to have a personal, safe environment to experiment with Kubernetes configurations and applications without the need for a shared, remote setup.

=== Private Cluster

For a more integrated development experience, we established a private cluster on a Windows 11 machine with WSL (Windows Subsystem for Linux) running Ubuntu 24.04. This private setup provided us with a shared working environment, leveraging an 8-core AMD 5800X processor and a 16GB memory limit. We employed kind to create the base cluster #footnote[kind cluster config: https://github.com/uwm-cs736/project-public/blob/main/cluster/cluster-config.yml] and installed essential tools such as ingress-nginx for managing external access to the services within our cluster and k8s-dashboard for visual cluster management.

To ensure seamless accessibility of our cluster services, we set up a dynamic DNS (DDNS) container. This component updates DNS records to point to the kind cluster container and the ingress entrypoint, allowing us to access our services via a domain name owned by us rather than IP addresses.

To foster collaboration, we configured a container optimized for SSH access, enabling our team members to connect to the cluster securely. This setup leveraged Docker's internal network to call the Kubernetes API, make it safer to not export cluster directly to the public network.

=== CloudLab <h-cloudlab>

To ensure a stable and standardized testing environment, we opted for CloudLab, which provided us with three 32-core c220g1 machines running Ubuntu 22. This choice was pivotal as it offered a more reliable platform compared to our previous workstations, which suffered from performance instabilities due to multiple layers of virtualization. #footnote[see our CloudLab experiment parameters #link("https://www.cloudlab.us/instantiate.php?profile=79d36573-a099-11ea-b1eb-e4434b2381fc&rerun_instance=6e254017-be52-11ef-af1a-e4434b2381fc")[here].]

We employed the latest version of Kubespray (v2.26.0) to initialize our Kubernetes cluster on CloudLab. However, we encountered several challenges that required us to deviate from the standard setup process:

/ Removing EphemeralNode Flag: We had to remove the EphemeralNode flag from the Kubernetes Feature Gate List, as it was not compatible with the newer version of kubespray and kubernetes.

/ Manual Script Adjustments: After logging into node-0, we manually corrected the CloudLab Kubespray script located at /local/repository/setup-kubespray.sh. Specifically, we removed the redundant line layer3: for metallb, which was causing Kubespray to panic.

/ Rerunning Ansible Playbook: After the necessary adjustments, we reran the Kubespray Ansible playbook and the setup-kubespray.sh script, which ultimately led to a successfully functioning cluster.

/ Enabling MetalLB for Load Balancer Support: Given that Knative's default network layer, Kourier, requires collaboration with a load balancer service type, we chose to enable MetalLB. MetalLB is the only solution that provides load balancer support between nodes in a bare-metal setup like ours, ensuring that our cluster could handle external traffic effectively.

=== Setup Procudure

Our codebase, which is crucial for reproducing our experiments, is hosted on GitHub at *#link("https://github.com/uwm-cs736/project-public")[uwm-cs736/project-public].*

For reproducible experiments, we set up our cluster using Terraform and Helm configurations, along with automated testing scripts. The process to create the initial state for the cluster is detailed below:

==== Preparation: Kubeconfig File Generation

To connect to the Kubernetes cluster from our local machines, we first need to generate a kubeconfig file. This file contains the necessary credentials and configurations to interact with the cluster.

We have a script named export-kube-config.sh located in the cluster/scripts directory that facilitates this process. This script should be executed on the CloudLab node, which already has access to the Kubernetes API thanks to Kubespray.

Once the kubeconfig file is generated, we need to download this file to local machine, then set up our local KUBECONFIG environment variable to point to this new file, allowing us to interact with the cluster from our local development environment.

==== Initial State with Terraform

For establishing the initial state of our cluster, we use Terraform by running terraform apply in the cluster folder (you can also run ./ctf a in the project root folder as a shortcut).

This command installs the Knative operator, Knative serving for HTTP/web workloads, the Knative network layer (Kourier), along with monitoring tools like Prometheus and Grafana, and the Kubernetes dashboard, including their respective service configurations for access.

==== Long-Living Containers for Debugging and Testing

To assist with debugging and running workload tests, we have installed long-living containers such as wrk2 and nettool ( for network diagnostics).

These containers are instrumental in ensuring that our applications perform as expected under various conditions and help us identify and resolve any network-related issues within our cluster. wrk2 also serves as our main entrypoint for generating workloads.

== Metric Collection

In our project, we focused on collecting detailed metrics to evaluate the Kubernetes-based deployments. This section outlines our approach to metric collection, which was conducted exclusively on CloudLab.

=== Tools

We utilized the combination of Prometheus and Grafana for our metric collection and visualization needs. Prometheus is a powerful open-source monitoring system that can scrape and store metrics directly from monitored targets or instruments, while Grafana provides a rich set of visualization tools to analyze and display these metrics.

Combined together, they can save all the metric histories from our experiments, allowing us to analyze them even after the experiments are finished.

=== Data Collection Methodology
/ Direct Collection from Kubernetes Core Components: To ensure accuracy and timeliness, we configured Prometheus to collect data directly from the core components of our Kubernetes cluster. This approach allowed us to monitor key performance indicators such as CPU usage, memory consumption, network I/O, and more.

/ Port-Forwarding for Web Panel Access: To access the web panels of Prometheus and Grafana, we employed port-forwarding. This technique allowed us to securely expose the web interfaces of these tools on our local machines, enabling us to interact with the dashboards without exposing them publicly.

It's important to note that while OpenFaaS is more popular in the community and offer more user friendly features, its integration with Prometheus is not free. This was a significant factor in our decision to abandon OpenFaaS.

== Application Deployment

=== Container Form

#figure(
  image("hotelReservation_architecture.png"),
  caption: [The architecture for HotelReservation application. The frontend is the only HTTP entry point to all the gRPC services. The arrows indicate dependencies.]
) <img-hr>

We adopted the Kubernetes configurations from the DeathStarBench HotelReservation application and made slight changes to them. Since the original configuration did not work correctly, we had to modify the command for each service container to ensure the application runs properly.

The architecture for HotelReservation is shown in @img-hr.

=== Serverless Form

For running workloads in serverless form, we use the Knative deployment provided in Hotel Application. The DeathStarBench repository provided the set of yamls file to deploy. First we started up a Knative cluster and loaded in the yaml files that were provided. These files deploys the microservices of Hotel Application as a set of serverless forms. After deploying these forms, we deploy the wrk (which is a benchmark provided by DeathStarBench repository) container as a Pod in Kubernetes. Afterwards, we enter the container via exec and run the wrk executable while providing it with the endpoint of the frontend that was deployed earlier along with the microservices. Here, the frontend is what users interact with when using the Hotel Application. With the wrk container generating the traffic into frontend, the frontend routes them to the requested micro-services.

#figure(
  image("hotelReservation_knative.png"),
  caption: [The architecture for HotelReservation application in Knative format. The frontend remain normal k8s container form application. Services marked Green are refactored from k8s services to Knative services.]
) <img-hr-k>

As a comparision to contianer form, the serverless form of HotelReservation is shown in @img-hr-k 

== Workload Generation

We want to analyze how the 99th percentile latency changes as number of request/sec increases. 

We provision only one pod and see how latency is distributed using CDF graph. Additionally, we also see how 99th percentile latency changes as we increase the request rate. This will give us an idea of how many request a node can handle.
To generate workload we use wrk2 utility. We use following commands:

```
wrk -D exp -t 1 -c 1 -d 30 -L -s /mixed-workload_type_1.lua -R [request-per-second] <frontend-service-host>
```

The lua script is hosted in our repository as well. #footnote[https://github.com/uwm-cs736/DeathStarBench/blob/master/hotelReservation/wrk2/scripts/hotel-reservation/mixed-workload_type_1.lua]


// Additionally, to track CPU utilization of each container we use the metrics server of kubernetes and following command

= Experiments

We conduct our experiments on the CloudLab cluster as described in @h-cloudlab. We use wrk2 to generate the workload. Since the frontend service remains the same deployment in both forms of the application, we can use the same testing script for both applications.

For each form, we first restore the cluster to its original state by removing the previous test's configuration entities or by recreating the cluster using terraform destroy and terraform create. Then, we run our automation test preparation script #footnote[https://github.com/uwm-cs736/project-public/blob/main/expr/1-container/,  start.sh is for preparation, stop.sh is for tearing down the test, and test.sh is the actual workload.] and wait for the containers to be ready.

After all application components are ready (for the Knative form, this means Knative serving successfully creates the deployment set for each service, even if scaled to zero meaning no pods are running for the service), we run the workload generation script, using different requests per second (rps) settings between 10 to 1000 (specifically, rps = 10, 100, 500, 1000). Wrk2 will give us the latency distribution, and by logging timestamps, we can accurately retrieve metrics from Prometheus for the timeframe during which experiments are running.

For all the service containers, we requested for 100m (0.1 Core) and set a maximum limit of 1000m (1 Core). We enabled hard currency auto scaling rule (containerConcurrency=20#footnote[https://knative.dev/docs/serving/autoscaling/concurrency/#hard-limit]) for Knative form deployments. We disabled HPA for container form.

== Container Form Result
#figure(
  image("container-r100.png", width: 100%),
  caption: [Tail Latency Distributiuon (rps=100)],
) <kubernetes-latency-r100>

In @kubernetes-latency-r100, it is showing the distribution of the latency and it appears that the 99.99% is a great outlier from the rest. However, the latency is miliseconds is rather fast when compared to the proceeding charts in which we scale up the rps.  

#figure(
  image("container-r500.png", width: 100%),
  caption: [Tail Latency Distributiuon (rps=500)],
) <kubernetes-latency-r500>

@kubernetes-latency-r500 Shows the latency of container Hotel Reservation application. There appears to be a rather steady increase in latency until the range between 60ms to 70ms in which it is explosive; however, it is less explosive than in @kubernetes-latency-r100. Most likely because the higher rps saturates the average latency so the effect of an explosion is less. For example, here the latency starts at around 30ms, whereas the latency starts around 2ms in @kubernetes-latency-r100. The far range stems from when the containers start to get overloaded on the work.  

#figure(
  image("container-rps.png", width: 100%),
  caption: [Latency explosion for container form of the web application.],
)

Here shows the sudden jump in latency because the auto-scaler is not implemented so there is a clear inflection point in which the workload starts to overwhelm the container (approximately 500 rps). Information such as this could be used to implement the decision making process of when to scale out, i.e. finding the inflection points. However, with more data points instead of 500rps and 1000rps, it might not be a straight line as shown here due to a finer-grained detail.

== Serverless Form Results

#figure(
  image("knative-latency-r100.png", width: 100%),
  caption: [Tail Latency Distribution (rps=100)],
) <knative-latency-r100>


Compare both forms when rps is 100, for Knative shown in @knative-latency-r100, the latency is 10 times slower (from 8ms to 80ms) it is compared to the container variant as shown in @kubernetes-latency-r100.

#figure(
  image("serverless-r500.png", width: 100%),
  caption: [Tail Latency Distribution (rps=500)],
) <knative-latency-r500>

#figure(
  image("serverless-rps.png", width: 100%),
  caption: [Latency compared to requests per second],
) <knative-latency-rps>

After we increase the rps to 500, the application saturates as shown in @knative-latency-r500 and @knative-latency-rps, there is a significant increase in latency, similar to what we observed with the RPS 1000 setting in the container form. This also indicates that our auto-scaling configuration for Knative should be adjusted to suit our future tests.

== Cluster Metrics

#figure(
image("cpu-utilization.png", width: 100%),
  caption: [Shows CPU utilization while the front-end is being tested with a mix workload for serverless recommendation and profile micro-services.],
) <cpu-util-2services>

In @cpu-util-2services, the time range begins when we start the workload and ends shortly after that. The workload consists of 1 thread, 1 connection, for 30 seconds with an increasing (10, 100, 500, 1000) request/sec. Here, the CPU gradually increases as the workload progresses and then diminishes as the workload ends. The workload ran for approximately two minutes. The form factor of the web application is serverless within this time range in the x-axis. 

#figure(
image("working_set_bytes.png", width: 100%),
  caption: [Shows memory working set of wrk pod (the workload appliance to the serverless form services.],
) <wrk-working-set>

@wrk-working-set Shows the bytes in terms of the working set on wrk, which is the program we used to apply a workload to the web application. During this time range, the kubernetes cluster was measuring the performance of serverless workload.

== Knative Scale to Zero

One interesting effect to highlight is the scale-to-zero feature of Knative. During our multiple tests, you can clearly see from @img-stz that after our test ends, the pods are automatically eliminated by Knative. This is not possible with traditional Kubernetes applications as shown in @img-stzn

#figure(
image("scale-to-zero.png", width: 100%),
  caption: [CPU usage of containers across multiple Knative experiments runs. There’s no change in application deployment configuration. All src-\* containers are automatically scaled up and down by Knative Serving. Our workload generation script only hits the recommendation and profile services.],
) <img-stz>


#figure(
  image("scale-not-to-zero.png"),
  caption: [CPU usage of container form applications. After the experiments, the CPU usage almost reaches zero, but they still exist in the cluster if we don't destroy them.]
) <img-stzn>

= Conclusion & Disccusion

We tested both forms of the Hotel Reservation application from DeathStarBench on a CloudLab cluster. The results demonstrate that the serverless form of the application is ten times slower than the container form. Our results indicate the need for future research on the behavior of the autoscaler.

Our original goal for this study was to explore the potential of combining serverless and containerized deployments for web applications. But due to the complexity of kubernetes, it took us a huge amount of time to figure out how to use kubernetes and how to govern a kubernetes cluster.The potential future work should try to combines these two forms together and do a cost analysis, and the researcher should be prepared to face a tough nut to crack.

= Contribution

/ Mondo: Cluster setup, guidance, automating tests.
/ Shivam: Container form application test design, wrk2 workload generation.
/ Thinh: Serverless form application test design. 