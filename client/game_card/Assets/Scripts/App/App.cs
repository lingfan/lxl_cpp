﻿
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Net;
using UnityEngine;

namespace Utopia
{
    public class App
    {        
        bool m_isQuited = false;
        public CoreMain root { get; protected set; }
        public UIRoot uiRoot { get; protected set; }

        public XLua.LuaEnv lua { get; protected set; }
        public TimerModule timer { get { return Core.ins.timer; } }
        public NetModule net { get { return Core.ins.net; } }
        public LogicMgr logicMgr { get; protected set; }
        public AppStateMgr stateMgr { get; protected set; }

        protected App(CoreMain _mono)
        {
            root = _mono;
            uiRoot = GameObject.FindObjectOfType<UIRoot>();
            lua = Lua.LuaUtil.NewLuaEnv();
            logicMgr = new LogicMgr(this);
            stateMgr = new AppStateMgr(this);
        }

        public void Awake()
        {
            stateMgr.ChangeState(EAppState.Init);
        }

        public void Start()
        {
            stateMgr.ChangeState(EAppState.MainLogic);
        }

        public void Update()
        {
            if (m_isQuited)
                return;

            stateMgr.UpdateState();
        }

        public void Quit()
        {
            if (m_isQuited)
                return;

            m_isQuited = true;
            stateMgr.ChangeState(EAppState.Quit);
        }

        public static App ins { get { return m_ins; } }
        protected static App m_ins = null;
        public static void MakeInstance(CoreMain _owner)
        {
            if (null == m_ins)
            {
                m_ins = new App(_owner);
            }
            else
            {
                Debug.LogError("App is single instance, can only make one instance");
            }
        }
    }
}