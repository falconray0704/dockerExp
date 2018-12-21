#!/bin/bash

set -o nounset
set -o errexit

RunRoot="/opt/dockerExp"
RunHome="${RunRoot}/dkuh"

pull_Images_func()
{
    sudo docker pull haproxy
    sudo docker pull ubuntu
    sudo docker pull redis
    sudo docker pull django
}

clean_containers_func()
{
    sudo docker rm redis-master redis-slave1 redis-slave2 APP1 APP2 HAProxy
}

run_containers_func()
{
    sudo mkdir -p ${RunHome}/2.3.2
    sudo chown -R $USER:$USER ${RunRoot}
    #cp -a ./cfgs ${RunHome}/2.3.2/

    echo "Run redis containers:"
    echo "sudo docker run -it --name redis-master -v ${RunHome}/2.3.2/cfgs/redisM:/cfgs redis /bin/bash"
    echo "sudo docker run -it --name redis-slave1 -v ${RunHome}/2.3.2/cfgs/redisS1:/cfgs --link redis-master:master redis /bin/bash"
    echo "sudo docker run -it --name redis-slave2 -v ${RunHome}/2.3.2/cfgs/redisS2:/cfgs --link redis-master:master redis /bin/bash"

    echo "Run Django containers:"
    echo "sudo docker run -it --name APP1 --link redis-master:db -v ${RunHome}/2.3.2/Django/App1:/usr/src/app django /bin/bash"
    echo "sudo docker run -it --name APP2 --link redis-master:db -v ${RunHome}/2.3.2/Django/App2:/usr/src/app django /bin/bash"

    echo "Run HAProxy containers:"
    echo "sudo docker run -it --name HAProxy --link APP1:APP1 --link APP2:APP2 -p 6301:6301 -v ${RunHome}/2.3.2/HAProxy:/tmp haproxy /bin/bash"
}

run_redis_master_func()
{
    echo "Run redis master container:"
    sudo docker run -it --name redis-master -v $(pwd)/cfgs/redisM:/cfgs redis /bin/bash
}

run_redis_slave1_func()
{
    echo "Run redis slave 1 container:"
    sudo docker run -it --name redis-slave1 -v $(pwd)/cfgs/redisS1:/cfgs --link redis-master:master redis /bin/bash
}

run_redis_slave2_func()
{
    echo "Run redis slave 1 container:"
    sudo docker run -it --name redis-slave2 -v $(pwd)/cfgs/redisS2:/cfgs --link redis-master:master redis /bin/bash
}

run_app1_func()
{
    echo "Run APP1 container:"
    mkdir -p testDatas
    sudo docker run -it --name APP1 --link redis-master:db -v $(pwd)/cfgs/APP1/run.sh:/run.sh -v $(pwd)/testDatas/Django/App1:/usr/src/app django /bin/bash
}

run_app2_func()
{
    echo "Run APP2 container:"
    mkdir -p testDatas
    sudo docker run -it --name APP2 --link redis-master:db -v $(pwd)/cfgs/APP2/run.sh:/run.sh -v $(pwd)/testDatas/Django/App2:/usr/src/app django /bin/bash
}

run_haproxy_func()
{
    echo "Run HAProxy container:"
    mkdir -p testDatas
    sudo docker run -it --name HAProxy --link APP1:APP1 --link APP2:APP2 -p 6301:6301 -v $(pwd)/cfgs/haproxy/run.sh:/run.sh -v $(pwd)/cfgs/haproxy/haproxy.cfg:/usr/local/sbin/haproxy.cfg.org:ro -v $(pwd)/testDatas/HAProxy:/tmp haproxy /bin/bash
}

tips_func()
{
    echo "Running redis master container..."
    echo "./run.sh redisM"
    echo "In container:"
    echo '  cd /cfgs'
    echo '  ./run.sh'
    echo ""

    echo "Running redis slave 1 container..."
    echo "./run.sh redisS1"
    echo "In container:"
    echo '  cd /cfgs'
    echo '  ./run.sh'
    echo ""

    echo "Running redis slave 2 container..."
    echo "./run.sh redisS2"
    echo "In container:"
    echo '  cd /cfgs'
    echo '  ./run.sh'
    echo ""

    echo  "Running APP1 container..."
    echo "./run.sh app1"
    echo "In container:"
    echo '  cd /'
    echo '  ./run.sh'
    echo ""

    echo  "Running APP2 container..."
    echo "./run.sh app2"
    echo "In container:"
    echo '  cd /'
    echo '  ./run.sh'
    echo ""

    echo  "Running HAProxy container..."
    echo "./run.sh haproxy"
    echo "In container:"
    echo '  cd /'
    echo '  ./run.sh'
    echo ""

    echo "Testing with browser:"
    echo "localhost:6301/helloworld"

}

case $1 in
    pull) echo "Pulling images..."
        pull_Images_func
        ;;
    clean) echo "Cleaning all containers..."
        clean_containers_func
        ;;
    run) echo "Run containers..."
        run_containers_func
        ;;
    redisM) echo "Running redis master container..."
        run_redis_master_func
        ;;
    redisS1) echo "Running redis slave 1 container..."
        run_redis_slave1_func
        ;;
    redisS2) echo "Running redis slave 2 container..."
        run_redis_slave2_func
        ;;
    app1) echo  "Running APP1 container..."
        run_app1_func
        ;;
    app2) echo  "Running APP2 container..."
        run_app2_func
        ;;
    haproxy) echo  "Running HAProxy container..."
        run_haproxy_func
        ;;
    help|*) echo "Tips for Demo running:"
        tips_func
        ;;
    *) echo "Unknown cmd: $1"
esac


