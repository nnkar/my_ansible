Role unifi-controller-role
=========

Установка контроллера unifi на Ubuntu

Example Playbook
----------------

    ansible-playbook unifi-controller-role.yml -e w_host=unifi

    - name: Install and configure unifi-controller-role 
      hosts: "{{ w_host | default('test') }}"
      roles:
         - { role: unifi-controller-role }

License
-------

BSD

Author Information
------------------

Nikolay Karchevskiy
