# Install Service Mesh Using the OpenShift Console
You can watch this video here:
[![Install Service Mesh Using the OpenShift Console](https://img.youtube.com/vi/5haVISAO8z4/0.jpg)](https://youtu.be/5haVISAO8z4)
<br />

## 1 Kubernetes Operators

A Kubernetes operator packages a Kubernetes application to automate installation, updates, and management. The video above shows you how to deploy a Service Mesh using the Service Mesh Operator and add a project that uses the service Mesh.


## 2 Install/Uninstall a Service Mesh Using the Red Hat Service Mesh Operator
The Red Hat OpenShift Service Mesh Operator relies on the following operators:

* OpenShift Elasticsearch Operator
* Red Hat OpenShift distributed tracing platform (Jaeger)
* Kiali Operator by Red Hat

These operators must be installed before installing the Red Hat Service Mesh Operator.


If you want to unistall the Service Mesh, you have to uninstall the operators in the reverse order:

* The Red Hat Service Mesh Operator
* Kiali Operator by Red Hat
* Red Hat OpenShift distributed tracing platform
* OpenShift Elasticsearch Operator

## 3 Creating a Working Service Mesh
After you have successfully installed the Service Mesh operator, you have to configure a Service Mesh Control Plane and a Service Mesh Member Roll (SMMR) to include your Service Mesh projects.

The control plane manages the configuration and policies for the service mesh. The OpenShift Service Mesh Operator installation makes the operator available in all namespaces, so you can install the control plane in any project.

The SMMR defines the projects belonging to a control plane. Any number of projects can be added to a ServiceMeshMemberRoll but a project can be added only to one control plane.



Please watch the demo video which walks you through the steps to:
* Install the Service Mesh and its dependent Operators
* Configure a Service Mesh control plane in a project named: <B><I>istio-system</I></B> and a SMMR 
* Deploy a simple echo application, include it in the service mesh by editing the SMMR, trigger a redeployment to inject an ENVOY sidecar container in the application

In the demo, I deployed the 'echo' application which I used in the mTLS video. The yaml file is in the manifests directory. To deploy it, run the following commands while in the openshift-console-install directory):
<pre>
oc new-project echo
oc create -f manifests/mtls1Deployment.yaml
</pre>

You won't see a sidecar container in your deployment because your project is not in the SMMR.

After you included your project (echo) in the SMMR, as shown in the video, you can trigger a redeplpyment of the echo application by executing the command:
<pre>
oc patch deployment/echo -p '{"spec":{"template":{"metadata":{"annotations":{"kubectl.kubernetes.io/restartedAt": "'`date -Iseconds`'"}}}}}'
</pre>

<br /><br />
If you want to know how to install the Service Mesh using the CLI (Command-line Interface), please go to the top-level folder: <B><I>cli-install</I></B>.
