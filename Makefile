EXTENSION = role_manager
EXTVERSION = $(shell grep default_version $(EXTENSION).control | \
               sed -e "s/default_version[[:space:]]*=[[:space:]]*'\([^']*\)'/\1/")
               
DATA = $(filter-out $(wildcard sql/*--*.sql),$(wildcard sql/*.sql))
PG_CONFIG = pg_config
PG91 = $(shell $(PG_CONFIG) --version | egrep " 8\.| 9\.0" > /dev/null && echo no || echo yes)

ifeq ($(PG91),yes)
all: sql/$(EXTENSION)--$(EXTVERSION).sql

sql/$(EXTENSION)--$(EXTVERSION).sql: sql/functions/*.sql
	cat $^ > $@

DATA = $(wildcard updates/*--*.sql) sql/$(EXTENSION)--$(EXTVERSION).sql
EXTRA_CLEAN = sql/$(EXTENSION)--$(EXTVERSION).sql
endif

PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
