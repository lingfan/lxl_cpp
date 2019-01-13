#pragma once

#include <stdint.h>
#include "def.h"

class NetBuffer
{
public:
	DATA_STRUCT_API NetBuffer(uint32_t init_size, uint32_t step_size);
	DATA_STRUCT_API NetBuffer(char *buff, uint32_t buff_size, uint32_t step_size);
	DATA_STRUCT_API ~NetBuffer();

	DATA_STRUCT_API uint32_t LeftSpace() { return m_capacity - m_pos; }
	DATA_STRUCT_API uint32_t StepSize() { return m_step_size; }
	DATA_STRUCT_API uint32_t Capacity() { return m_capacity; }
	DATA_STRUCT_API char * Ptr() { return m_buff + m_pos; }
	DATA_STRUCT_API uint32_t Pos() { return m_pos; }
	DATA_STRUCT_API uint32_t Head() { return m_head; }
	DATA_STRUCT_API char * HeadPtr() { return m_buff + m_head; }
	DATA_STRUCT_API uint32_t Size() { return m_pos - m_head; }
	DATA_STRUCT_API void SetPos(uint32_t new_pos);
	DATA_STRUCT_API void SetHead(uint32_t new_head);
	DATA_STRUCT_API void AppendBuff(char *buff, uint32_t len);
	DATA_STRUCT_API void CheckExpend(uint32_t need_capacity);

	template <typename T>
	void Append(T t)
	{
		char *p = (char *)(&t);
		uint32_t len = sizeof(T);
		WriteBuff(p, len);
	}
	DATA_STRUCT_API uint32_t PopBuff(uint32_t pop_len, char **pop_head);
	DATA_STRUCT_API bool ResetHead(char *help_buff, uint32_t buff_len); // buff和buff+head之间的内容丢弃，buff+head和buff+pos之间的内容移动到buff和buff+pos-head
	   
private:
	uint32_t m_init_size = 0;
	uint32_t m_step_size = 0;
	char *m_buff = nullptr;
	uint32_t m_head = 0;
	uint32_t m_capacity = 0; // 容量
	uint32_t m_pos = 0; // 可写入的位置
};
