﻿using Utopia;
using XLua;

namespace Lua
{
    public class LuaResLoaderProxy 
    {
        ResourceLoaderProxy m_loaderProxy = null;
        public LuaResLoaderProxy()
        {
            m_loaderProxy = ResourceLoaderProxy.Create();
        }

        public ResourceObserver GetLoadedResState(string path)
        {
            return m_loaderProxy.GetLoadedResState(path);
        }
        public ResourceObserver LoadAsset(string path)
        {
            return m_loaderProxy.LoadAsset(path);
        }
        public ResourceObserver AsyncLoadAsset(string path, LuaFunction luaFn)
        {
            return m_loaderProxy.AsyncLoadAsset(path, (string resPath, ResourceObserver ob) =>
            {
                if (null != luaFn)
                {
                    luaFn.Call(resPath, ob);
                }
            });
        }
        public ResourceObserver CoLoadAsset(string path)
        {
            return m_loaderProxy.CoLoadAsset(path);
        }
        public void UnloadAsset(string path)
        {
            m_loaderProxy.UnloadAsset(path);
        }

        public void Release()
        {
            m_loaderProxy.Release();
        }

        public void AsyncLoadScene(string path, bool isAddition,  LuaFunction luaFn)
        {
            m_loaderProxy.AsyncLoadScene(path, isAddition, (ResourceScene.LoadResult ret, string resPath) => {
                if (null != luaFn)
                {
                    luaFn.Call(ret, resPath);
                }
            });
        }
        public ResourceScene CoLoadScene(string path, bool isAddition)
        {
            return m_loaderProxy.CoLoadScene(path, isAddition);
        }
        public void UnloadScene(string path)
        {
            m_loaderProxy.UnloadScene(path);
        }

        public static LuaResLoaderProxy Create()
        {
            return new LuaResLoaderProxy();
        }
    }
}
