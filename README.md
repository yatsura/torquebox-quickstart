TorqueBox/Immutant Overlay on OpenShift
=========================

Here is a quick way to try out your Ruby and Clojure apps running in
a TorqueBox overlaid with Immutant on OpenShift.

By default, this quickstart will install the latest incremental
version of TorqueBox.

Running on OpenShift
--------------------

Create an account at http://openshift.redhat.com/

Create a jbossas-7 application

    rhc app create -a yourapp -t jbossas-7

Remove the sample app provided by the jbossas-7 cartridge

    cd yourapp
    rm -rf pom.xml src

Add this upstream repo

    git remote add upstream -m master git://github.com/openshift-quickstart/torquebox-quickstart.git
    git pull --no-commit -s recursive -X theirs upstream overlay

Then add, commit, and push your changes

    git add -A .
    git commit -m "My Changes"
    git push

That's it! The first build will take a minute or two, even after the
push completes, so be patient. You should ssh to your app and run
`tail_all` so you'll have something to watch while your app deploys.

When you see `Deployed "your-knob.yml"` and `Deployed
"your-clojure-app.clj"` in the log, point a browser at the following
links (adjusted for your namespace) and you should see a friendly
welcome:

    http://yourapp-$namespace.rhcloud.com/ruby
    http://yourapp-$namespace.rhcloud.com/clojure

Drop in to the `#torquebox` IRC channel on freenode.net if you have any
questions.
