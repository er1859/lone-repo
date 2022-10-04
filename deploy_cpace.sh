for i in "$@"
do

  if [ $i = 'pull' ]
  then
  sudo cp -r /home/ubuntu/cpact/CPACT_Report_Generation_V1 .
  sudo rm -rf CPACT_Report_Generation_V1/ml CPACT_Report_Generation_V1/visualization
  sudo find CPACT_Report_Generation_V1/. -exec chown m96722:aicadmin {} \;
  cp CPACT_Report_Generation_V1/conf/cpact_common_server.conf CPACT_Report_Generation_V1/conf/cpact.conf
  fi

  if [ $i = 'data' ]
  then
  echo Argument: $i
  tar -czvf data.tar.gz CPACT_Report_Generation_V1/data
  scp -i keys/id_rsa data.tar.gz  pg405y@iracavcopss01.infra.aic.att.net:cpact/
  fi

  if [ $i = 'pkg' ]
  then
  echo "Transferring PKG"
  scp -r -i keys/id_rsa CPACT_Report_Generation_V1 pg405y@iracavcopss01.infra.aic.att.net:cpact/
  fi

  if [ $i = 'image' ]
  then
  echo Argument: $i
  rm cpact.tar.gz

  echo "Building Image"
  sudo docker export $(sudo docker ps -a -f name=cpact -q) | gzip > cpact.tar.gz

  echo "Transferring Image"
  scp -i keys/id_rsa cpact.tar.gz  pg405y@iracavcopss01.infra.aic.att.net:cpact/
  fi

  if [ $i = 'run' ]
  then
  echo "Starting the container"
  sudo docker run -it --name cpact --rm -u m96722 -v $(pwd):/mnt -w /mnt/CPACT_Report_Generation_V1 cpact /bin/bash
  fi

done
