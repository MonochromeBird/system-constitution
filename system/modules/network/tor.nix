{ pkgs, sandbox, opts, ... }:
{
	packages = with pkgs; [
		# tor intentionally kept
		# as a standalone program
		# and not a service.
		tor
		torsocks
		
		(sandbox.package tor-browser opts.sandbox)
	];

	system = {
		programs.proxychains = {
			enable = true;
			proxyDNS = true;
			chain.type = "dynamic";

			proxies = {
				tor-service-proxy = {
					enable = true;
					type = "socks4";
					host = "127.0.0.1";
					port = 9050;
				};

				tor-browser-proxy = {
					enable = true;
					type = "socks4";
					host = "127.0.0.1";
					port = 9150;
				};
			};
		};
	};
}
