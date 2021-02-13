#!/usr/bin/python

import numpy as np

import foo


class TestBaz:

    def test_result(self):
        a = np.array([3, 5, 8, 7, 20])
        b = np.array([4, 12, 15, 24, 21])
        c = np.array([5, 13, 17, 25, 29])
        assert np.allclose(foo.bar.baz(a, b), c)

    def test_optional_parameter(self):
        rng = np.random.default_rng(0)
        a = rng.random(1000)
        assert np.allclose(foo.bar.baz(a), foo.bar.baz(a, a))
