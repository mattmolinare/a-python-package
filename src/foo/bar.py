"""A Python module."""

from typing import Optional

import numpy as np
import numpy.typing as npt

__all__ = [
    'baz'
]


def baz(
    a: npt.ArrayLike,
    b: Optional[npt.ArrayLike] = None,
) -> np.ndarray:
    """A Python function.

    Here is some math:

    .. math:: a^2 + b^2 = c^2

    Parameters
    ----------
    a : array_like
        An array_like parameter.
    b : None or array_like, optional
        An optional array_like parameter. If None (default), use `a`.

    Returns
    -------
    c : ndarray
        An array.

    Examples
    --------
    >>> a = 3
    >>> b = [4]
    >>> foo.bar.baz(a, b)
    array([5.])
    >>> foo.bar.baz(a)
    4.242640687119285

    """
    if b is None:
        b = a
    return np.hypot(a, b)
