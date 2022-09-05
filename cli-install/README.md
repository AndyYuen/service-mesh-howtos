# Install Service Mesh Using the Command-line Interface (CLI)
You can watch this video here:
[![Install Service Mesh Using the CLI](https://img.youtube.com/vi/aAKDL7EqynI/0.jpg)](https://youtu.be/aAKDL7EqynI)
<br />

## 1 Install Using the CLI vs the OpenShift Console
Pros:
* Installation can be automated
* Mesh management can be automated

Cons:
* Not as easy compared to using the OpenShift Console
* Need to create/maintain yaml files for the installation

Both approaches require the use of Kubernetes operators.


## 2 Kubernetes Operators

A Kubernetes operator packages a Kubernetes application to automate installation, updates, and management. The video above shows you how to deploy a Service Mesh using the Service Mesh Operator and add a project that uses the service Mesh.


## 3 Install a Service Mesh Using the CLI
The Service Mesh installation has been automated using a shell script in the <B>scripts</B> folder: <B><I>installServiceMesh.sh</I></B>. The installation involves using the oc command on the provided yaml files to install the operators one at a time and waiting for an operator to finish installation before starting another to avoid potential issues. Operators are created in the following order
* elasticsearch.yaml
* tracing.yaml
* kiali.yaml
* service-mesh.yaml

The script <B><I>setupControlPlaneAndSmmr.sh</I></B> in the <B>scripts</B> folder takes care of configuring a control plane and a Service Mesh Member Roll (SMMR) using the following yaml files:
* basic.yaml (create control plane named basic)
* smmr.yaml (add smmr named default to the control plane)

All yaml files can be found in the <B>manifests</B> folder.

In the demo, I deployed the 'echo' application which I used in the mTLS video. Its yaml file is in the manifests directory. To deploy it, run the following commands while in the cli-install directory):
<pre>
oc new-project echo
oc create -f manifests/mtls1Deployment.yaml
</pre>

You won't see a sidecar container in your deployment because your project is not in the SMMR.

To modify the SMMR to include you project(s), you can use the command:
<pre>
oc edit smmr default -n istio-system
</pre>
to invoke the default editor to edit the SMMR in yaml format as shown in the video.

To trigger a redeplpyment of the echo application after including the echo project in the SMMR, you can run the command:
<pre>
oc patch deployment/echo -p '{"spec":{"template":{"metadata":{"annotations":{"kubectl.kubernetes.io/restartedAt": "'`date -Iseconds`'"}}}}}'
</pre>

## 3 Operators Available for Use
To find out what operators are available, you must login using an account with cluster-admin privilleges first. And run the command:
<pre>
oc get packagemanifests -n openshift-marketplace
</pre>
which lists all availabe operators in the openshift-marketplace namespace.
If you know roughly what you are looking for eg, an operator with name containing 'kiali' you can run:
<pre>
oc get packagemanifests -n openshift-marketplace | grep kiali
</pre>
If not, you can get a sorted list using the command:
<pre>
oc get packagemanifests -n openshift-marketplace | sort
</pre>

To find out more information about a particular operator eg, kiali-ossm, you can run:
<pre>
 oc describe packagemanifests kiali-ossm -n openshift-marketplace
</pre>


Please watch the demo video which walks you through the steps to:
* Install the Service Mesh and its dependent Operators
* Configure a Service Mesh control plane in a project named: <B><I>istio-system</I></B> and a SMMR 
* Deploy a simple echo application, include it in the service mesh by editing the SMMR, trigger a redeployment to inject an ENVOY sidecar container in the application
* Find out about what operators are available and the info about them


<br /><br />
If you want to know how to install the Service Mesh using the OpenShift Console, please go to the top-level folder: <B><I>openshift-console-install</I></B>.
