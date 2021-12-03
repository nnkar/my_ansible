Role docker_local_repository
=========
Создание локального Docker Registry на Proxmox vm


Example Playbook
----------------

    ansible-playbook docker_local_repository.yml -i inventory
        ---
		- name: create vm container
		hosts: nd1
		roles:
			- role: clone-vm-proxmox-role

		- name: install docker to vm
		hosts: dockerrep
		roles:
			- role: docker_role

		- name: install repository
		hosts: dockerrep
		roles:
			- role: docker_registry_role

License
-------

BSD

Author Information
------------------

Nikolay Karchevskiy
