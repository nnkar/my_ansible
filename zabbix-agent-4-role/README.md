Role Zabbix-agent 4
=========
Роль заббикс агента + несколько шаблонов для заббикса версия 4

Role Variables
--------------
zabbix_server - ip/dns server zabbix \
zabbix_HostMetadata - для автоматического добавления сервера в заббикс


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - name: Install and configure zabbix-client 
      hosts: "{{ w_host | default('test') }}"
      roles:
         - { role: zabbix-agent-role }

License
-------

BSD

Author Information
------------------

Nikolay Karchevskiy
