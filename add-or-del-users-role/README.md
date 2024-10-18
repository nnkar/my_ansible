Role Name
---------

add-or-del-users-role

Role Variables
--------------

Пример переменных, которые надо записать в файл пользователя в папке users (users/testuser)

    delete_user: false
    sudo_enable: True
    sudo_without_pass: True
    vpn_enable: true
    login_user: testuser
    full_name: testuser
    home_dir: /home/{{ login_user }}
    u_shell: /bin/bash
    u_passwd: '$6$2YC.mQwfXl8QPygkO6yD5MRtRdQlNk.6cN00vCph.'
    ssh_key: 
      - 'ssh-rsa gck6kWig7dh0jDCNxY4f6Kxbn6+1Hp8hBzzl+OoKVtyAjECaYKSdF1wqgh8GtAS0h0oPZQz5RRRkXOTR1Zp5tSTsqUeHgrV7 rsa-key'
    w_host:
      - vpnhost # openvpn host с доступом по паролю и без ssh
      - ubatest


 Вызывать заклинанием
 --------------------

     **ansible-playbook add-or-del-users-role.yml -e login_user=testuser -e w_host=testhost**
    
     если в файле пользователя указать хосты, то не нужно в коммандной строке писать
     например
     w_host:
      - evosite
    
     Команда будет такой:
     **ansible-playbook add-or-del-users-role.yml -e login_user=testuser**
    


Example Playbook
----------------

    - name: Role create or delete user
    hosts: "{{ w_host | default('test') }}"

    vars_files:
        - "users/{{ login_user }}"

    roles:
        - role: add-or-del-users-role

License
-------

Free

Author Information
------------------

Nikolay Karchevskiy
