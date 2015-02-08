from fabric.api import env

import dev

env.roledefs = {
    'dev': ['172.16.10.30'],
}
