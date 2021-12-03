Role clone-vm-proxmox-role
=========
Клонирование ВМ в proxmox для контроллера Unifi.

Example Playbook
----------------

    ansible-playbook clone-vm-proxmox-role.yml -e w_host=node_1
    - name: clone-vm-proxmox-role
      hosts: "{{ w_host | default('test') }}"
      roles:
         - { role: clone-vm-proxmox-role }

License
-------

BSD

Author Information
------------------

Nikolay Karchevskiy
