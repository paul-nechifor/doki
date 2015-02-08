import os

from fabric.api import env, run, local, execute, task, roles, cd, prefix, \
    settings, lcd

env.roledefs = {
    'dev': ['172.16.10.30'],
}
dev_settings = {
    'key_filename': '~/.vagrant.d/insecure_private_key',
    'user': 'vagrant',
}
root = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..')


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
def up():
    """Start the dev box and the server."""
    with lcd(root):
        local('vagrant up')
    execute(runserver)


@task
def clean():
    """Destroys everything except the source files."""
    with lcd(root):
        local('vagrant destroy -f && rm -fr env .vagrant')
