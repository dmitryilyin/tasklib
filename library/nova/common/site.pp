$fuel_settings = parseyaml($::astute_settings_yaml)

$rabbit_hash   = $fuel_settings['rabbit']
$nodes_hash    = $fuel_settings['nodes']
$nova_hash     = $fuel_settings['nova']

$controller = filter_nodes($nodes_hash,'role','controller')
$controller_node_address = $controller[0]['internal_address']
$controller_node_public  = $controller[0]['public_address']

$rabbit_userid   = 'nova'
$rabbit_password = $rabbit_hash['password']

$db_user     = 'nova'
$db_password = $nova_hash['db_password']
$db_name     = 'nova'
$db_host     = '127.0.0.1'

$nova_db = "mysql://${db_user}:${db_password}@${db_host}/${db_name}"

$glance_connection = "${$controller_node_public}:9292"
$rabbit_connection = $controller_node_address

$verbose = true
$debug = $fuel_settings['debug']

class { 'nova':
  sql_connection     => $nova_db,
  rabbit_userid      => $rabbit_userid,
  rabbit_password    => $rabbit_password,
  image_service      => 'nova.image.glance.GlanceImageService',
  glance_api_servers => $glance_connection,
  verbose            => $verbose,
  debug              => $debug,
  rabbit_host        => $rabbit_connection,
  use_syslog         => false,
}

class { 'nova::quota' :
  quota_instances                       => 100,
  quota_cores                           => 100,
  quota_volumes                         => 100,
  quota_gigabytes                       => 1000,
  quota_floating_ips                    => 100,
  quota_metadata_items                  => 1024,
  quota_max_injected_files              => 50,
  quota_max_injected_file_content_bytes => 102400,
  quota_max_injected_file_path_bytes    => 4096
}

nova_config { 'DEFAULT/auto_assign_floating_ip' :   value => $fuel_settings['auto_assign_floating_ip'] }
nova_config { 'DEFAULT/start_guests_on_host_boot' : value => $fuel_settings['start_guests_on_host_boot'] }
nova_config { 'DEFAULT/use_cow_images' :            value => $fuel_settings['use_cow_images'] }
nova_config { 'DEFAULT/compute_scheduler_driver' :  value => $fuel_settings['compute_scheduler_driver'] }

