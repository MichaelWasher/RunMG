# RunMG
The RunMG tool can be used to setup and run a KubeAPIServer instance with the backend configured to be a Must-Gather.

## Quickstart:

1) clone this repository.

2) Replace the Must-Gather directory with a valid OpenShift Must-Gather
~~~
oc adm must-gather --dest-dir=must-gather
~~~

3) Setup the RunMG project
~~~
cd scripts
./setup.sh
~~~

4) Run the Kine Server
~~~
cd scripts
./start_kine.sh
~~~

5) Run the KubeAPI Server
~~~
cd scripts
./start_apiserver.sh
~~~

6) Setup Kubeconfig
~~~
export KUBECONFIG=$(pwd)/pki/kubeconfig
kubectl get pods 
~~~

Note: If you are running this on Mac, the Kube-APIServer that is downloaded is the Linux build. This is easily resolved by placing a Darwin build of the kube-apiserver binary into the `resource/` folder and this will automatically be used. These scripts have been tested on Mac using this method.