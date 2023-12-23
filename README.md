# Shopware 6 production template

This repository contains the production template that enables you to build,
package and deploy Shopware 6 to production shops.

Before initializing:
 - run `$ cp .env .env.local`
 - run `$ id` in the command line
 -  fill in `UID` and `GID` in `.env.local` file with the output data.

If for some reason you're getting the "I have no name" prompt after `make init dev && make sh`, try setting the `ALT_USER` in `.env.local` to `1` and rebuild everything using `make teardown && make init dev`

## Installation and usage instructions

Please refer to the
[documentation](https://developer.shopware.com/docs/guides/installation/template)
for instructions on how to use this template.

## Debugging

> **Note:**
> The debugger support is enabled only in development mode, i.e. the project is built via `make init dev`

### Creating a server configuration in PHPStorm

1. Go to Settings > PHP > Servers.
2. Create a new server configuration.
3. Set the name, `localhost` is the default server name in `.env`.
4. Host: `localhost`, port: `8080`, debugger: `Xdebug`.
5. Use path mappings where the absolute path on the server is `/var/www/html`. Leave the include path unchanged.
6. Save.

If for whatever reason you would like to change the server name, you need to reflect the change in `.env` under `PHP_IDE_CONFIG`. Otherwise, there's nothing to be changed.

> **Note:**
> `PHP_IDE_CONFIG=serverName` always remains the same, don't remove the `serverName` part.

### Listening for incoming requests

There's only little configuration needed for this step.

1. Go to Settings > PHP > Debug.
2. Under "External connections" check "Break at first line in PHP scripts" to validate the configuration.
3. Under "Xdebug" make sure all options are enabled and that at least port 9003 is on the list.
4. Save.

### Trigger value

The last step is to provide a proper trigger value for Xdebug. Doing this manually (passing it with every request, tampering with the session) would be very painful. That's why you can use an Xdebug browser extension that will do it for you.
- [Firefox](https://addons.mozilla.org/en-US/firefox/addon/xdebug-helper-for-firefox/)
- [Chrome](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc)
- [Edge 😬😬😬](https://microsoftedge.microsoft.com/addons/detail/xdebug-helper/ggnngifabofaddiejjeagbaebkejomen)

> **Trivia:**
> By default the trigger value is `""` (an empty string - catch-all for any value). You could fine-tune it in `docker/web/php/conf.d/docker-php-ext-xdebug.ini`.
> 
> The way to go would be to set `xdebug.trigger_value` to something else. It might prove useful if for whatever reason you use two IDE-s or editors and would want to enable debugging in only one of them.

The plugins should work out of the box, you just need to enable them on a specific page. They might work per domain as well. Additional feature regarding the trivia section above is setting the trigger value. Normally you can leave it as it is.

### Finally

Open up your browser and go to the main store page (or any page for that matter). The page should hang and PHPStorm should have created an automatic breakpoint in one of the first lines in `index.php`.
You can now disable the "Break at first line in PHP scripts" option and create your own breakpoints.
