Role docker_swarm_proxmox_role
=========
Создание кластера Docker Swarm на Proxmox


Example Playbook
----------------

    ansible-playbook docker_swarm_proxmox_role.yml -i inventory
        ---
	- name: create vm container
	  hosts: nd1
	  roles:
	    - role: proxmox_vm_create_role

	- name: install docker to vm
	  hosts: docker-swarm
	  roles:
	    - role: docker_role

	- name: init docker swarm
	  hosts: docker-swarm
	  roles:
	    - role: docker_swarm_role

	- name: install portainer
	  hosts: docker-swarm-manager
	  roles:
	    - role: docker_portainer_role

License
-------

BSD

Author Information
------------------

Nikolay Karchevskiy
