## To install systemd service and clone project repo run 
`./install.sh`

## To run server
`systemctl --user enable --now react_2021.service`

## To see service state 
`systemctl --user list-unit-files react_2021.service`

## To disable server
`systemctl --user disable --now react_2021.service`
