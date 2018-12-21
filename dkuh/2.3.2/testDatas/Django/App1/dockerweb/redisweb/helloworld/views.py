from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.
import redis

def hello(request):
    str=redis.__file__
    str+="<br>"
    r = redis.Redis(host='db', port=6379, db=0)
    info = r.info()
    str+=("Set Hi <br>")
    r.set('Hi', 'HelloWorld-APP1')
    str+=("Get Hi: %s <br>" % r.get('Hi'))
    str+=("Redis Info: <b>")
    str+=("Key: Info Value")
    for key in info:
        str+=("%s: %s <br>" % (key, info[key]))
    return HttpResponse(str)

