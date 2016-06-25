PROJECT = seausers

DEPS = eredis mongodb
dep_eredis = git https://github.com/wooga/eredis.git master #TODO tag
dep_mongodb = git https://github.com/comtihon/mongodb-erlang.git v1.1.2



TEST_DEPS = meck gun
dep_meck = git https://github.com/eproxus/meck.git master

include erlang.mk
