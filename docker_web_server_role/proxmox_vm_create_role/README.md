Role docker_swarm_proxmox_role
=========
Создание кластера Docker Swarm на Proxmox


Example Playbook
----------------

    ansible-playbook docker_swarm_proxmox_role.yml -e w_host=node_1
    - name: docker_swarm_proxmox_role
      hosts: "{{ w_host | default('test') }}"
      roles:
         - { role: docker_swarm_proxmox_role }

License
-------

BSD

Author Information
------------------

Nikolay Karchevskiy
