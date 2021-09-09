Role for Ubuntu
=========
Установка программ и небольшая настройка 

Role Variables
--------------

region: Europe \
city: Samara \
ip_ntp_server: 192.168.1.1

Example Playbook
----------------


    - name: ubuntu install default soft and first setting
      hosts: "{{ w_host | default('test') }}"
      roles:
         - { role: ubuntu-role }

License
-------

BSD

Author Information
------------------

Nikolay Karchevskiy
