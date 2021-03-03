#!/usr/bin/python

import click


@click.command()
def cli() -> None:
    """A Python command line interface."""
    click.echo('This is a command line inferface')
