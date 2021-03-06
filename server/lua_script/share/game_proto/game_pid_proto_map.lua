
local pid_proto_map =
{
--[[
    {
        [Proto_Const.Proto_Id]=System_Pid.Zone_Service_Rpc_Req,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="RpcRequest"
    },
--]]

    {
        [Proto_Const.Proto_Id]=ProtoId.req_login_game,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="ReqLoginGame"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.rsp_login_game,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="RspLoginGame"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.req_user_login,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="ReqUserLogin"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.rsp_user_login,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="RspUserLogin"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.req_pull_role_digest,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="ReqPullRoleDigest"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.rsp_pull_role_digest,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="RspPullRoleDigest"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.req_create_role,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="ReqCreateRole"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.rsp_create_role,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="RspCreateRole"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.req_launch_role,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="ReqLaunchRole"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.rsp_launch_role,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="RspLaunchRole"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.req_logout_role,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="ReqLogoutRole"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.rsp_logout_role,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="RspLogoutRole"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.req_reconnect,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="ReqReconnect"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.rsp_reconnect,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="RspReconnect"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.req_client_forward_game,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="ReqForwardMsg"

    },
    {
        [Proto_Const.Proto_Id]=ProtoId.req_join_match,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="ReqJoinMatch"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.rsp_join_match,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="RspJoinMatch"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.sync_match_state,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="SyncMatchState"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.req_quit_match,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="ReqQuitMatch"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.rsp_quit_match,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="RspQuitMatch"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.sync_room_state,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="SyncRoomState"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.notify_bind_room,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="NotifyBindRoom"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.notify_unbind_room,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="NotifyUnbindRoom"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.notify_terminate_room,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="NotifyTerminateRoom"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.sync_remote_room_state,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="SyncRemoteRoomState"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.pull_role_data,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="PullRoleData"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.sync_role_data,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="SyncRoleData"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.req_bind_fight,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="ReqBindFight"
    },

    {
        [Proto_Const.Proto_Id]=ProtoId.rsp_bind_fight,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="RspBindFight"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.req_quit_fight,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="ReqQuitFight"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.rsp_quit_fight,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="RspQuitFight"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.pull_fight_state,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="PullFightState"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.sync_fight_state,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="SyncFightState"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.req_fight_opera,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="ReqFightOpera"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.rsp_fight_opera,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="RspFightOpera"
    },
    {
        [Proto_Const.Proto_Id]=ProtoId.sync_roll_point_result,
        [Proto_Const.Proto_Type]=Proto_Const.Pb,
        [Proto_Const.Proto_Name]="SyncRollPointResult"
    },
}


function get_game_pid_proto_map()
    return pid_proto_map
end
