#!/usr/bin/python

import click


@click.command()
def cli():
    click.echo('This is a command line inferface')
