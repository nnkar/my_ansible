# my_ansible
заметки для учебы и не только

для генерации хешей паролей пользователя
python3 -c 'import crypt; print(crypt.crypt("ПАРОЛЬ", crypt.mksalt(crypt.METHOD_SHA512)))'
