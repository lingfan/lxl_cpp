#include "lua_tcp_listen.h"
#include "lua_tcp_connect.h"

LuaTcpListen::LuaTcpListen()
{
	
}

LuaTcpListen::~LuaTcpListen()
{

}

bool LuaTcpListen::Init(sol::main_table lua_logic)
{
	if (!lua_logic.valid())
		return false;

	m_lua_logic = lua_logic;
	{
		sol::object fn = m_lua_logic.get<sol::object>(LUA_LISTEN_CB_ONCLOSE);
		assert(fn.is<sol::main_protected_function>());
	}
	{
		sol::object fn = m_lua_logic.get<sol::object>(LUA_LISTEN_CB_ONOPEN);
		assert(fn.is<sol::main_protected_function>());
	}
	{
		sol::object fn = m_lua_logic.get<sol::object>(LUA_LISTEN_GEN_CNN);
		assert(fn.is<sol::main_protected_function>());
	}
	return true;
}

void LuaTcpListen::OnClose(int error_num)
{
	m_lua_logic[LUA_LISTEN_CB_ONCLOSE](m_lua_logic, error_num);
}

void LuaTcpListen::OnOpen(int error_num)
{
	m_lua_logic[LUA_LISTEN_CB_ONOPEN](m_lua_logic, error_num);
}

std::shared_ptr<INetConnectHandler> LuaTcpListen::GenConnectorHandler()
{
	std::shared_ptr<INetConnectHandler> ptr = nullptr;
	sol::object ret = m_lua_logic[LUA_LISTEN_GEN_CNN](m_lua_logic);
	if (ret.is<std::shared_ptr<INetConnectHandler>>())
	{
		ptr = ret.as<std::shared_ptr<INetConnectHandler>>();
	}
	return ptr;
}

