from fabric.api import env

import dev

env.roledefs = {
    'dev': ['10.10.10.10'],
}
