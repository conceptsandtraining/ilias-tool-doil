apt_https:
  pkg.installed:
    - name: software-properties-common

php_repo_list:
  cmd.run:
    - name: echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
    - unless: test -f /etc/apt/sources.list.d/php.list

php_repo_key:
  cmd.run:
    - name: wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
    - unless: test -f /etc/apt/trusted.gpg.d/php.gpg

/root/clean-php-packages.sh:
  file.managed:
    - source: salt://php/clean-php-packages.sh
    - user: root
    - group: root
    - mode: 740

clean-php-packages:
  cmd.run:
    - cwd: /root/
    - name: ./clean-php-packages.sh

php8.0:
  pkg.installed:
    - refresh: true
    - pkgs:
      - libapache2-mod-php8.0
      - php-curl
      - php-gd
      - php-json
      - php8.0-mysql
      - php8.0-readline
      - php8.0-xsl
      - php8.0-cli
      - php-zip
      - php-mbstring
      - php8.0-soap
      - php8.0-bcmath
      - php8.0-imap

/root/cleanup.sh:
  file.managed:
    - source: salt://php/cleanup.sh
    - user: root
    - group: root
    - mode: 740

cleanup:
  cmd.run:
    - cwd: /root/
    - name: ./cleanup.sh

a2_disable_php73:
  module.run:
    - name: apache.a2dismod
    - mod: php7.3

a2_enable_php:
  module.run:
    - name: apache.a2enmod
    - mod: php8.0
