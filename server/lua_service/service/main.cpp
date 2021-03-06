extern "C" 
{
	#include "lua.h"
	#include "lauxlib.h"
	#include "lualib.h"
}

#if WIN32
#include <WinSock2.h>
#include <direct.h>
#define chdir _chdir
#else
#include <arpa/inet.h>
#include <unistd.h>
#endif

#include "sol/sol.hpp"
#include <signal.h>
#include <memory>
#include "iengine.h"
#include "lua_reg/lua_reg.h"
#include <mongocxx/instance.hpp>
#include "main_impl/main_impl.h"
#include "service_impl/service_base.h"
#include "service_impl/pure_lua_service/pure_lua_service.h"
#include "service_impl/sidecar_service/sidecar_service.h"

#include "r3c.h"
#include "hiredis_vip/hircluster.h"

#include "redis/redis_task_mgr.h"

void QuitGame(int signal)
{
	try_quit_game();
}

int main (int argc, char **argv) 
{
	srand((unsigned int)time(NULL));

#ifdef WIN32
	WSADATA wsa_data;
	WSAStartup(0x0201, &wsa_data);
#endif

	if (false)
	{
		redisClusterContext *rcc = redisClusterConnect("127.0.0.1:7000", REDIS_BLOCK);
		redisReply *reply = (redisReply *)redisClusterCommand(rcc, "set foo 100");
		if (nullptr == reply)
		{
			printf("set foo fail\n");
			return -1;
		}
		freeReplyObject(reply);
		reply = (redisReply *)redisClusterCommand(rcc, "get foo");
		if (nullptr == reply)
		{
			printf("get foo fail\n");
			return -1;
		}
		freeReplyObject(reply);
		redisClusterFree(rcc);
	}

	if (false)
	{
		RedisTaskMgr mgr;
		if (mgr.Start(true, "127.0.0.1:7000", "xiaolzz", 1, 2000, 9000))
		{
			while (true)
			{
				if (true)
				{
					mgr.ExecuteCmd(1, [](RedisTask *task) {
						if (nullptr != task->reply)
						{
							printf("reply 1 %d \n", task->reply->type);
						}
					}, "set foo %d", 100);
				}
				
				if (true)
				{
					std::string cmd = "get foo";
					mgr.ExecuteCmd(1, [](RedisTask *task) {
						if (task->reply)
						{
							printf("reply 2 %d \n", task->reply->type);
						}
					}, cmd);
				}

				if (true)
				{
					std::vector<std::string> cmds = { "foo", "100" };
					mgr.ExecuteCmdBinFormat(1, [](RedisTask *task) {
						if (task->reply)
						{
							printf("reply 3 %d \n", task->reply->type);
						}
					},  "set %b %b", cmds);
				}

				if (true)
				{
					std::vector<std::string> cmds = { "get", "foo" };
					mgr.ExecuteCmdArgv(1, [](RedisTask *task) {
						if (task->reply)
						{
							printf("reply 4 %d \n", task->reply->type);
						}
					}, cmds);
				}

				if (false)
				{
					const char *argv[2] = { "get", "foo" };
					size_t argv_len[2] = { 3, 3 };
					mgr.ExecuteCmdArgv(1, [](RedisTask *task) {
						if (task->reply)
						{
							printf("reply 5 %d \n", task->reply->type);
						}
					}, sizeof(argv)/ sizeof(argv[0]), argv, argv_len);
				}

				mgr.OnFrame();
				static const int SLEEP_SPAN = 25;
				std::this_thread::sleep_for(std::chrono::milliseconds(SLEEP_SPAN));
			}
		}
		mgr.Stop();

	}

	// argv: exe_name work_dir lua_file lua_file_params...
	if (argc <= Args_Index_Min_Value)
	{
		printf("exe_name service_name work_dir data_dir lua_scrip_dir other_params... --lua_args_begin-- lua_params...\n");
		return -10;
	}

	// change work dir
	char *work_dir = argv[Args_Index_WorkDir];
	printf("work dir is %s\n", work_dir);
	if (0 != chdir(work_dir))
	{
		printf("change work dir fail errno %d , dir is %s\n", errno, work_dir);
		return -20;
	}

	std::string service_name = ExtractServiceName(argv[Args_Index_Service_Name]);
	start_log(ELogLevel_Debug, service_name);
	engine_init();

	ServiceBase *service = nullptr;
	// const char *service_name = argv[Args_Index_Service_Name];
	if (nullptr == service && "sidecar" == service_name)
	{
		SidecarService *sidecar_service = new SidecarService();
		service = sidecar_service;
	}
	if (nullptr == service)
	{
		PureLuaService *pure_service = new PureLuaService();
		pure_service->SetFuns("OnNotifyQuitGame", "CheckCanQuitGame");
		service = pure_service;
	}

	void *ls_mem = mempool_malloc(sizeof(sol::state));
	sol::state *ls = new(ls_mem)sol::state(lua_panic_error, LuaAlloc);
	lua_State *L = ls->lua_state();
	sol::main_protected_function::set_default_handler(sol::object(L, sol::in_place, lua_pcall_error));
	service->SetLuaState(L);

#ifdef WIN32
	signal(SIGINT, QuitGame);
	signal(SIGBREAK, QuitGame);
#else
	signal(SIGINT, QuitGame);
	signal(SIGPIPE, SIG_IGN);
#endif

	mongocxx::instance ins{};

	engine_loop_span(100);
	setup_service(service);  
	{
		// setup timer
		const int FLUSH_LOG_SPAN_MS = 10 * 1000;
		timer_firm(std::bind(flush_log), FLUSH_LOG_SPAN_MS, EXECUTE_UNLIMIT_TIMES);
		const int COLLECT_GARBAGE_MS = 30 * 1000;
		timer_firm(std::bind([ls]() {
			ls->collect_garbage();
		}), COLLECT_GARBAGE_MS, EXECUTE_UNLIMIT_TIMES);
	}
	timer_next(std::bind(&ServiceBase::RunService, service, argc, argv), 0);
	service = nullptr; // engine own the service
	engine_loop();
	ls->collect_garbage();
	// mempool_free(ls_mem); ls_mem = nullptr;
	// ls->~state(); ls = nullptr;
	stop_log();
	engine_destroy();
	return 0;
}

