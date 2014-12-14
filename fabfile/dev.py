from fabric.api import *

dev_settings = {
    'key_filename': '~/.vagrant.d/insecure_private_key',
    'user': 'vagrant',
}

@task
@roles('dev')
def runserver():
    """Connect to the dev box and start the server."""
    with settings(**dev_settings):
        with cd('/vagrant/src'):
            with prefix('. ../env/bin/activate'):
                run('./manage.py runserver 0.0.0.0:8000')
