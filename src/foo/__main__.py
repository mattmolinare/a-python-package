#!/usr/bin/python

import click

import foo


@click.command()
def cli():
    click.echo('This is a command line inferface')
