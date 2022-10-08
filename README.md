# vagrant-mysql-master-slave-replication
Playground for testing `mysql` Master-Slave replication with `mariadb`.

# Usage
```
$ git clone git@github.com:13rom/vagrant-mysql-master-slave-replication.git
$ vagrant up
```

# Result
```
==> db-slave: Running provisioner: shell...
    db-slave: Running: /tmp/vagrant-shell20221008-975758-l7pp1j.sh
    db-slave: Setup replication
    db-slave: Create database on master
    db-slave: Create table on master
    db-slave: Test replication:
    db-slave: id	name	surname
    db-slave: 1	Linus	Torvalds
    db-slave: 2	Richard	Stallman
```

# Description
[Vagrantfile](Vagrantfile) creates two virtual machines:
1. db-master
    * IP: 192.168.56.11
1. db-slave
    * IP: 192.168.56.12

And performs provisioning:
* [bootstrap.sh](bootstrap.sh) installs `mariadb-server` on both machines and creates `root` user with remote access to database;

* [master.sh](master.sh) creates replication user on `db-master` and enables replication;
* [slave.sh](slave.sh) enables slave replication on `db-slave`, connects to `db-master` and creates test table;
* The last step is to check the replication. [slave.sh](slave.sh) executes SELECT from master table. 