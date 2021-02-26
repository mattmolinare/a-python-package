#!/usr/bin/python

import click


@click.command()
def cli():
    """A Python command line interface."""
    click.echo('This is a command line inferface')
