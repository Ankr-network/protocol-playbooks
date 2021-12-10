## Ansible node deployment

- Requires Ansible 1.2 or newer

These playbooks deploy nodes to remote servers. 

###Example for deploying Ethereum node

1 Navigate to the playbook of project to be launched

2 Edit the `hosts` inventory file with servers, that are going to host the project
```sh
[binance]
127.0.0.1
```

2 Edit the variables in `playbooks/<project-name>/vars`
```sh
network_name: mainnet
sync_mode: full
directory: /data
```

3 Set remote user, hosts and role(Binance) in `site.yml` 
```sh
- hosts: binance
  remote_user: root
  become: yes
  become_method: sudo
  roles:
    - role: binance
```

4 Launch playbook 
```sh
ansible-playbook -i hosts site.yml -v
```

###Local deployment 

To launch ansible locally, add `localhost` to `hosts` and run: 
```sh
ansible-playbook -i hosts site.yml -v --connection=local --ask-become-pass
```

###Add-ons
To install external roles, use these commands:
```sh
ansible-galaxy install fubarhouse.rust
```