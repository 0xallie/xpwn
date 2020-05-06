#!/usr/bin/env python3

# Whole script made in Vim :D

# Thanks to the people behind https://github.com/mozilla/libdmg-hfsplus for fixing the dmg binary!
# And of course, thanks to planetbeing for making xpwn!

import os
import sys
import platform
import subprocess
import shutil
import filecmp
import zipfile
import tarfile
from urllib.request import urlretrieve
from urllib.parse import urlsplit

def compile():
	# Check build folder exists, so we can ensure cmake is using correct OpenSSL version

	if os.path.exists('build'):
		shutil.rmtree('build')

	os.mkdir('build')
	os.chdir('build')

	# Begin building inside build folder

	path = '/usr/local/ssl'
	
	cmake_cmd = subprocess.run(
		['cmake',
		 '-DOPENSSL_ROOT_DIR={}'.format(path),
		 '-DOPENSSL_LIBRARIES={}/lib'.format(path),
		 '..'],
		 stdout=subprocess.PIPE,
		 universal_newlines=True)	

	# Make sure OpenSSL never says 1.1.1
	
	if 'OpenSSL' and 'found version "1.1.1"' in cmake_cmd.stdout:
		raise IOError('Oof, some reason we still are using OpenSSL 1.1.1')
	
	make_cmd = subprocess.run(
		['make',
		 'libXPwn.a'],
		 subprocess.PIPE,
		 universal_newlines=True)
		
	# Some reason I still get ld errors on linux and on windows, though we can still build	

	try:
		os.path.exists('common/libcommon.a')
		os.path.exists('ipsw-patch/libxpwn.a')
	except FileNotFoundError as error:
		print('Oof, got error:', error)
	else:
		print('Seems like we built just fine')
	finally:
		print('Do not worry if you see some errors here. Also, do not send me logs/pictures of those errors, I know about them.')

	# Check for existing libcommon.a, libxpwn.a, and xpwn headers in /usr/local
	
	build_common_path = 'common/libcommon.a'
	local_common_path = '/usr/local/lib/libcommon.a'

	if os.path.exists(local_common_path):
		# If identical, don't update
		if filecmp.cmp(build_common_path , local_common_path):
			pass
		else:
			shutil.copyfile(build_common_path, local_common_path)

	build_xpwn_path = 'ipsw-patch/libxpwn.a'
	local_xpwn_path = '/usr/local/lib/libxpwn.a'	

	if os.path.exists(local_xpwn_path):
		# If identical, don't update
	
		if filecmp.cmp(build_xpwn_path , local_xpwn_path):
			pass
		else:
			shutil.copyfile(build_xpwn_path , local_xpwn_path)

	include_path = '/usr/local/include/xpwn'

	if os.path.exists(include_path):
		shutil.rmtree(include_path)
	else:
		os.mkdir(include_path)

	print('Unzipping xpwn headers...')
	zip = zipfile.ZipFile('../xpwn-modified-headers.zip')
	zip.extractall(include_path)

	print('Ok, everything should be done!')


def installOpenSSL():
	cwd = os.getcwd()
	url = 'https://www.openssl.org/source/old/1.0.2/openssl-1.0.2u.tar.gz'
	filename = urlsplit(url).path.split('/')[-1]
	path = '/usr/local/ssl'

	# Check if /usr/local/ssl exists		

	if os.path.exists(path):
		# Check if OpenSSL binary version is 1.0.2
		cmd = subprocess.run(
			['/usr/local/ssl/bin/openssl',
			 'version'],
			 stdout=subprocess.PIPE,
			 universal_newlines=True)

		if 'OpenSSL 1.0.2' in cmd.stdout:
			print('Seems like we are running OpenSSL 1.0.2!')
			
		# OpenSSL 1.1.1 is not compatible with xpwn and will prevent compilation of libxpwn.a

	else:
		# OpenSSL does not exist at /usr/local/ssl
		print('Downloading OpenSSL 1.0.2u')
		urlretrieve(url, filename)

		if os.path.exists('openssl-1.0.2u'):
			shutil.rmtree('openssl-1.0.2u')
	
		try:
			os.path.exists(filename)
		except FileNotFoundError as error:
			print('Oof, got error:', error)			
		else:
			tar = tarfile.open(filename, 'r:gz')
			tar.extractall()
			os.chdir('openssl-1.0.2u')
			subprocess.run(['./config'])
			subprocess.run(['make'])
			subprocess.run(['make', 'install'])

	os.chdir(cwd)


def main():
	installOpenSSL()
	compile()


if __name__ == '__main__':
	main()

