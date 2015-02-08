from fabric.api import *

dev_settings = {
    'key_filename': '~/.vagrant.d/insecure_private_key',
    'user': 'vagrant',
}

def in_site(f):
    def g():
        with settings(**dev_settings):
            with cd('/vagrant/site'):
                with prefix('. ../env/bin/activate'):
                    f()
    g.__name__, g.__doc__ = f.__name__, f.__doc__
    return g

@task
@roles('dev')
@in_site
def runserver():
    """Start the server on the dev box."""
    run('./manage.py runserver 0.0.0.0:8000')

@task
@roles('dev')
@in_site
def syncdb():
    """Sync the DB on the dev box."""
    run('./manage.py syncdb')

@task(default=True)
def start():
    """Start the dev box and the server."""
    local('cd boxes && vagrant up')
    execute(runserver)

@task
def stop():
    """Shut down the dev box."""
    local('cd boxes && vagrant halt')
