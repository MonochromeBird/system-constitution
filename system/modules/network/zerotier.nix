{ ... }:
{
	allowedUnfree = [ "zerotierone" ];

	system = {
		services.zerotierone = {
			enable = true;

			localConf = {
				settings = {
					allowTcpFallbackRelay = false;
				};
			};
		};
	};
}
