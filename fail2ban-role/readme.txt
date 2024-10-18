Dependencies

None
Example(s)
Simple

---
- hosts: "{{ w_host | default('test') }}"
  roles:
    - fail2ban-role

Enable sshd filter (with non-default settings)

---
- hosts: "{{ w_host | default('test') }}"
  roles:
    - fail2ban-role
  vars:
    fail2ban_services:
      # In Ubuntu 16.04 this is sshd
      - name: ssh
        port: 2222
        maxretry: 5
        bantime: -1

Add custom filters (from outside the role)

---
- hosts: "{{ w_host | default('test') }}"
  roles:
    - fail2ban-role
  vars:
    fail2ban_filterd_path: ../../../files/fail2ban/etc/fail2ban/filter.d/
    fail2ban_services:
      - name: apache-wordpress-logins
        port: http,https
        filter: apache-wordpress-logins
        logpath: /var/log/apache2/access.log
        maxretry: 5
        findtime: 120
