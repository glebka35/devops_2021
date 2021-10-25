nodejs_install:
  cmd:
    - run
    - name: curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - && sudo apt-get install -y nodejs

clone_repo:
  git.latest:
    - name: https://github.com/glebka35/react_2021.git
    - target: /Develop/react_2021

install_packages:
  cmd:
    - run
    - name: cd /Develop/react_2021 && npm install

