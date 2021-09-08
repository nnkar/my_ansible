Role install iptables
=========

Удаляет firewalld и устанавливает iptables и ipset.\
Для Ubuntu и CentOS


Role Variables
--------------
rezerv1_ip_host, rezerv2_ip_host - ип для которых открыто ssh \
open_ports_tcp - порты для открытия сразу \
inet_ip_host - внешний ип \
inet_if_host - внешний интерфейс \


Example Playbook
------------

ansible-playbook iptables-role.yml -e w_host=hostname

- name: iptables setting
  hosts: "{{ w_host | default('test') }}" \
  roles:\
    - role: iptables-role}

License
-------

BSD

Author Information
------------------

Nikolay Karchevskiy
