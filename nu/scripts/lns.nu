def get_absolute_path [dir] {
  if ($dir =~ '^/') { return $dir 
} else { return ((pwd) + '/' + $dir) }
}

def main [source?, destination?] {
  if $source  == null {
    echo "Usage: $nu.env.PROGRAM_NAME <target-file-or-directory> [link-location]"
    exit  1
  }
  let source_path = get_absolute_path $source
  let destination = $destination | default '/usr/local/bin'
  if (echo $destination | path type) == 'dir' {
      let destination = ($destination + '/' + $source)

  ln -s $source_path $destination
  print "Soft link created for " + $source + "at " + $destination
  }
}


