# Lover — AI 陪伴聊天应用

本项目以你上传的 `LOVEN_角色与对话修复版.zip` 为基础，保留原有聊天界面与角色、关系阶段、聊天历史、共同回忆、剧情线索等功能，统一品牌为 **Lover**，并整理了 DeepSeek 后端接入与 Render 部署配置。

## 当前版本

- FastAPI 后端：`server.py`
- 前端：`index.html`（保留原有界面与交互）
- DeepSeek Chat Completions：`https://api.deepseek.com/chat/completions`
- 默认模型 ID：`deepseek-flash`（以 DeepSeek 官方模型列表为准）
- API Key 只从服务器环境变量 `AI_API_KEY` 读取
- AI 请求失败会显示错误提示，不会生成本地假回复，也不会把错误伪装成角色回复保存
- 浏览器本地数据仍沿用原项目 `ag_*` localStorage 键名，尽量保留原项目已保存的数据

## 本地运行（Windows）

1. 安装 Python 3.11 或更新版本。
2. 复制 `.env.example` 并命名为 `.env`。
3. 用记事本打开 `.env`，只在 `AI_API_KEY=` 后面填写你自己的 DeepSeek API Key。
4. 双击 `启动_Lover.bat`。
5. 打开 `http://127.0.0.1:8000`。

不要把真实 API Key 发给任何人，也不要提交 `.env`。

## 环境变量

```env
AI_BASE_URL=https://api.deepseek.com
AI_API_KEY=your_deepseek_api_key_here
AI_MODEL=deepseek-flash
```

模型 ID 可在 DeepSeek 官方 API 的 `GET https://api.deepseek.com/models` 查询。当前默认值 `deepseek-flash` 根据官方文档与 2026-11-13 更新记录设置；若控制台模型列表有变化，以控制台/官方接口返回为准。

## Render 部署

仓库根目录已提供 `render.yaml`。创建 Render Web Service 并连接 GitHub 仓库 `LOV-R` 后：

- Build Command：`pip install -r requirements.txt`
- Start Command：`uvicorn server:app --host 0.0.0.0 --port $PORT`
- Health Check Path：`/healthz`

在 Render 服务的 Environment 中添加：
- `AI_BASE_URL` = `https://api.deepseek.com`
- `AI_MODEL` = `deepseek-flash`
- `AI_API_KEY` = 你自己的 DeepSeek API Key（在 Render 控制台直接填写，不要写入仓库）

## 接口

- `GET /healthz`：Render 健康检查
- `GET /api/health`：查看服务是否运行及 AI 配置是否齐全（不会返回密钥）
- `POST /api/chat`：真实 AI 对话
- `POST /api/summarize-plot`：生成可编辑剧情摘要草稿
- `POST /api/suggest-memories`：生成待用户确认的记忆候选

## 数据与限制

- 角色、聊天历史、记忆、关系阶段和剧情线索仍保存在当前浏览器 localStorage；不是云端账号同步。换设备或清理浏览器数据前请使用应用内导出备份。
- 发送的聊天内容会传给 DeepSeek API。请不要在聊天中存放密码、证件号码等敏感信息。
- DeepSeek API 可能需要账户余额；是否可用取决于你的控制台账户、密钥和额度。
- 本仓库配置不能代替真实部署验证；必须在 Render 发布后检查网页、健康检查和真实聊天接口。

## 官方文档

- https://api-docs.deepseek.com/
- https://api-docs.deepseek.com/api/list-models/
- https://api-docs.deepseek.com/api/create-chat-completion/
