#!/bin/bash
git clone https://github.com/glebka35/react_2021
mv start.sh react_2021/
mv react_2021 ~/
mkdir -p  ~/.config/systemd/user/
mv react_2021.service ~/.config/systemd/user/

