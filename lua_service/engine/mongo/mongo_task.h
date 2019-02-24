#pragma once

#include <stdint.h>
#include <functional>
#include <bsoncxx/document/value.hpp>
#include <bsoncxx/document/view_or_value.hpp>
#include <mongocxx/client.hpp>
#include "mongo_result.h"

enum eMongoTaskState
{
	eMongoTaskState_Ready,
	eMongoTaskState_Processing,
	eMongoTaskState_Done,
	eMongoTaskState_Count,
};

enum eMongoTask
{
	eMongoTask_FindOne,
	eMongoTask_InsertOne,
	eMongoTask_UpdateOne,
	eMongoTask_DeleteOne,
	eMongoTask_ReplaceOne,

	eMongoTask_FindMany,
	eMongoTask_InsertMany,
	eMongoTask_UpdateMany,
	eMongoTask_DeleteMany,
	eMongoTask_ReplaceMany,

	eMongoTask_Count,
};

class MongoTask
{
public:
	using ResultCbFn = std::function<void(MongoTask *)>;
public:
	MongoTask(eMongoTask task_type, const std::string &db_name, const std::string &coll_name, const bsoncxx::document::view_or_value &filter, const bsoncxx::document::view_or_value &content,
		const bsoncxx::document::view_or_value &opt, ResultCbFn cb_fn);
	MongoTask(eMongoTask task_type, const std::string &db_name, const std::string &coll_name, const bsoncxx::document::view_or_value &filter,
		const std::vector<bsoncxx::document::view_or_value> &contents, const bsoncxx::document::view_or_value &opt, ResultCbFn cb_fn);
	~MongoTask();

	void Process(mongocxx::client &client);
	void HandleResult();

	eMongoTaskState GetState() { return m_state; }
	int GetErrNum() { return m_err_num; }
	const std::string & GetErrMsg() { return m_err_msg; }
	eMongoTask GetTaskType() { return m_task_type; }
	const MongoReuslt & GetResult() { return m_result; }

protected:
	eMongoTaskState m_state = eMongoTaskState_Count;
	int m_err_num = 0;
	std::string m_err_msg;
	eMongoTask m_task_type = eMongoTask_Count;
	std::string m_db_name;
	std::string m_coll_name;
	bsoncxx::document::value *m_filter = nullptr;
	bsoncxx::document::value *m_content = nullptr;
	bsoncxx::document::value *m_opt = nullptr;
	std::vector<bsoncxx::document::value> m_content_vec;
	ResultCbFn m_cb_fn = nullptr;
	MongoReuslt m_result;

protected:
	mongocxx::collection GetColl(mongocxx::client & client);
	static mongocxx::options::find GenFindOpt(bsoncxx::document::view &view);
	static mongocxx::options::insert GenInsertOpt(bsoncxx::document::view &view);
	static mongocxx::options::delete_options GenDeleteOpt(bsoncxx::document::view &view);
	static mongocxx::options::update GenUpdateOpt(bsoncxx::document::view &view);
	void DoTask_FindOne(mongocxx::client &client);
	void DoTask_FindMany(mongocxx::client &client);
	void DoTask_InsertOne(mongocxx::client &client);
	void DoTask_DeleteOne(mongocxx::client &client);
	void DoTask_UpdateOne(mongocxx::client &client);
	void DoTask_ReplaceOne(mongocxx::client &client);
};