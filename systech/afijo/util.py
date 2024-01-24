import logging
from dateutil.relativedelta import relativedelta

logger = logging.getLogger(__name__)


def dateToPeriodo(fec):
    if fec is None:
        return None
    periodo = fec
    # logger.info(periodo)
    if periodo.day > 31:
        periodo = periodo.replace(day=1)
        periodo = periodo + relativedelta(months=1)
    else:
        periodo = periodo.replace(day=1)
    return periodo


def diff_meses(fec1, fec2):
    r = relativedelta(fec2, fec1)
    return r.months + (12 * r.years)


def dump(obj):
    for attr in dir(obj):
        print("obj.%s = %r" % (attr, getattr(obj, attr)))
