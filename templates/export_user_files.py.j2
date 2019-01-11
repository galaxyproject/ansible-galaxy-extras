#!/usr/bin/env python
import glob
import sys
import os
import shutil
import subprocess

if len( sys.argv ) == 2:
    PG_DATA_DIR_DEFAULT = sys.argv[1]
else:
    PG_DATA_DIR_DEFAULT = "/var/lib/postgresql/9.3/main"
PG_DATA_DIR_HOST = os.environ.get("PG_DATA_DIR_HOST", "/export/postgresql/9.3/main/")

def change_path( src ):
    """
        src will be copied to /export/`src` and a symlink will be placed in src pointing to /export/
    """
    if os.path.exists( src ):
        dest = os.path.join( '/export/', src.strip('/') )
        # if destination is empty move all files into /export/ and symlink back to source
        if not os.path.exists( dest ):
            dest_dir = os.path.dirname(dest)
            if not os.path.exists( dest_dir ):
                os.makedirs(dest_dir)
            shutil.move( src, dest )
            os.symlink( dest, src.rstrip('/') )
            os.chown( src, int(os.environ['GALAXY_UID']), int(os.environ['GALAXY_GID']) )
            subprocess.call( 'chown -R %s:%s %s' % ( os.environ['GALAXY_UID'], os.environ['GALAXY_GID'], dest ), shell=True )
        # if destination exists (e.g. continuing a previous session), remove source and symlink
        else:
            if not os.path.realpath( src ) == os.path.realpath( dest ):
                stripped_src = src.rstrip('/')
                if not os.path.islink( stripped_src ):
                    if os.path.isdir( stripped_src ):
                        shutil.rmtree( stripped_src )
                    else:
                        os.unlink( stripped_src )
                    os.symlink( dest, src.rstrip('/') )


def copy_samples(src, dest):
    if not os.path.realpath(src) == os.path.realpath(dest):
        for filename in os.listdir(src):
            if filename.endswith('ml.sample') or filename.endswith('ml.sample_advanced') or filename.endswith('ml.sample_basic'):
                distrib_file = os.path.join(src, filename)
                export_file = os.path.join(dest, filename)
                shutil.copy(distrib_file, export_file)
                os.chown(export_file, int(os.environ['GALAXY_UID']), int(os.environ['GALAXY_GID']))


def _makedir(path):
    if not os.path.exists( path ):
        os.makedirs( path )
    os.chown( path, int(os.environ['GALAXY_UID']), int(os.environ['GALAXY_GID']) )

if __name__ == "__main__":
    """
        If the '/export/' folder exist, meaning docker was started with '-v /home/foo/bar:/export',
        we will link every file that needs to persist to the host system. Addionaly a file (/.galaxy_save) is
        created that indicates all linking is already done.
        If the user re-starts (with docker start) the container the file /.galaxy_save is found and the linking
        is aborted.
    """

    galaxy_root_dir = os.environ.get('GALAXY_ROOT', '/galaxy-central/')

    galaxy_distrib_paths = {'/galaxy-central/config/': '/export/.distribution_config',
                            '/galaxy-central/lib': '/export/galaxy-central/lib',
                            '/galaxy-central/tools': '/export/galaxy-central/tools'}
    for image_path, export_path in galaxy_distrib_paths.items():
        if os.path.exists(export_path):
            shutil.rmtree(export_path)
        shutil.copytree( image_path, export_path )

    shutil.copy('/galaxy-central/requirements.txt','/export/galaxy-central/requirements.txt')

    _makedir('/export/galaxy-central/')
    _makedir('/export/ftp/')

    change_path( os.path.join(galaxy_root_dir, 'config') )

    # Copy all sample config files to config dir
    # TODO find a way to update plugins/ without breaking user customizations
    config_src = os.path.join(galaxy_root_dir, 'config')
    config_dest = os.path.join('/export/', galaxy_root_dir, 'config')
    copy_samples(config_src, config_dest)

    # Copy all sample files to tool-data dir
    # TODO find a way to update shared/ without breaking user customizations
    tool_data_src = os.path.join(galaxy_root_dir, 'tool-data')
    tool_data_dest = os.path.join('/export/', galaxy_root_dir, 'tool-data')
    copy_samples(tool_data_src, tool_data_dest)

    # TODO find a way to update /export/galaxy-central/display_applications/ without breaking user customizations

    # Copy all files starting with "welcome"
    # This enables a flexible start page design.
    for filename in os.listdir('/export/'):
        if filename.startswith('welcome'):
            export_file = os.path.join( '/export/', filename)
            image_file = os.path.join('/etc/galaxy/web/', filename)
            shutil.copy(export_file, image_file)
            os.chown( image_file, int(os.environ['GALAXY_UID']), int(os.environ['GALAXY_GID']) )

    # copy image defaults to config/<file>.docker_sample to base derivatives on,
    # and if there is a realized version of these files in the export directory
    # replace Galaxy's copy with these. Use symbolic link instead of copying so
    # deployer can update and reload Galaxy and changes will be reflected.
    for config in [ 'galaxy.yml', 'job_conf.xml' ]:
        image_config = os.path.join('/etc/galaxy/', config)
        export_config = os.path.join( '/export/galaxy-central/config', config )
        export_sample = export_config + ".docker_sample"
        shutil.copy(image_config, export_sample)
        if os.path.exists(export_config):
            subprocess.call('ln -s -f %s %s' % (export_config, image_config), shell=True)

    # Update Conda version if needed
    if os.environ.get('GALAXY_AUTO_UPDATE_CONDA', '0') != 0:
        src_conda = '/tool_deps/_conda/'
        dest_conda = '/export/tool_deps/_conda/'
        if os.path.exists(dest_conda) and os.path.realpath(src_conda) != os.path.realpath(dest_conda):
            for subdir in ['bin', 'compiler_compat', 'conda-meta', 'etc', 'include', 'lib', 'share', 'ssl', 'x86_64-conda_cos6-linux-gnu']:
                if os.path.exists(os.path.join(dest_conda, subdir)):
                    shutil.rmtree(os.path.join(dest_conda, subdir))
                subprocess.call('cp -p --preserve -R %s %s' % (os.path.join(src_conda, subdir), os.path.join(dest_conda, subdir)), shell=True)

    change_path( os.path.join(galaxy_root_dir, 'tools.yaml') )
    change_path( os.path.join(galaxy_root_dir, 'integrated_tool_panel.xml') )
    change_path( os.path.join(galaxy_root_dir, 'display_applications') )
    change_path( os.path.join('/tool_deps') )
    change_path( os.path.join(galaxy_root_dir, 'tool-data') )
    change_path( os.path.join(galaxy_root_dir, 'database') )
    change_path( '/shed_tools/' )

    if os.path.exists('/export/reports_htpasswd'):
        shutil.copy('/export/reports_htpasswd', '/etc/nginx/htpasswd')

    try:
        change_path('/var/lib/docker/')
    except:
        # In case of unprivileged access this will result in a "Device or resource busy." error.
        pass

    if not os.path.exists( PG_DATA_DIR_HOST ) or 'PG_VERSION' not in os.listdir( PG_DATA_DIR_HOST ):
        dest_dir = os.path.dirname( PG_DATA_DIR_HOST )
        if not os.path.exists( dest_dir ):
            os.makedirs(dest_dir)
        # User given dbpath, usually a directory from the host machine
        # copy the postgresql data folder to the new location
        subprocess.call('cp -R %s/* %s' % (PG_DATA_DIR_DEFAULT, PG_DATA_DIR_HOST), shell=True)
        os.symlink( os.path.join(os.environ.get('PG_CONF_DIR_DEFAULT'), 'conf.d'), os.path.join(PG_DATA_DIR_HOST, 'conf.d') )
        # copytree needs an non-existing dst dir, how annoying :(
        # shutil.copytree(PG_DATA_DIR_DEFAULT, PG_DATA_DIR_HOST)
        subprocess.call('chown -R postgres:postgres /export/postgresql/', shell=True)
        subprocess.call('chmod -R 0755 /export/', shell=True)
        subprocess.call('chmod -R 0700 %s' % PG_DATA_DIR_HOST, shell=True)
