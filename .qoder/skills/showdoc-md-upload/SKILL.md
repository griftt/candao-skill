---
name: showdoc-md-upload
description: |
  Upload API documentation to ShowDoc. Use this skill when user wants to:
  - "上传文档到ShowDoc"
  - "发布接口文档到ShowDoc"
  - "同步文档到ShowDoc"
  - "generate doc to ShowDoc"
  - "帮我把xx接口文档发布到ShowDoc"

  This skill handles the full workflow: login → get cookie → upload pages to specified category.
---

# ShowDoc 文档上传工具

将本地Markdown格式的接口文档上传到ShowDoc指定分类。

## ShowDoc API 基础信息

- **Base URL**: `https://qc.can-dao.com:8889/showdoc/server/`
- **Login**: `POST /api/user/login`
- **Save Page**: `POST /api/page/save`

## 目录结构参考 (cat_id)

```
商家端API (cat_id=2)
├── 餐单系统 (cat_id=8)
├── 餐品算价 (cat_id=1199)
└── 同步中心 (cat_id=488)

用户端API (cat_id=1)
├── 餐单系统 (cat_id=39)
└── ...
```

## 凭证管理

**优先顺序**：
1. **文档中的凭证** - 如果用户提供的文档中已包含 `username` 和 `password`，直接使用
2. **配置文件** - 读取 `~/.claude/skills/showdoc-md-upload/config.json`
3. **询问用户** - 以上都没有时，询问用户

**配置文件格式** (`config.json`)：
```json
{
  "showdoc": {
    "base_url": "https://qc.can-dao.com:8889/showdoc/server/",
    "username": "your_username",
    "password": "your_password"
  }
}
```

## 工作流程

### Step 1: 登录获取cookie_token

读取配置文件获取凭证：
```bash
CONFIG=$(cat ~/.claude/skills/showdoc-md-upload/config.json)
USERNAME=$(echo $CONFIG | python3 -c "import json,sys; print(json.load(sys.stdin)['showdoc']['username'])")
PASSWORD=$(echo $CONFIG | python3 -c "import json,sys; print(json.load(sys.stdin)['showdoc']['password'])")
```

登录请求：
```bash
curl -s -i -X POST "${SHOWDOC_BASE}index.php?s=/api/user/login" \
  -H 'accept: application/json, text/plain, */*' \
  -H 'content-type: application/x-www-form-urlencoded;charset=UTF-8' \
  -d "username=${USERNAME}&password=${PASSWORD}&v_code="
```

从响应头的 `Set-Cookie: cookie_token=xxx` 中提取 token。

### Step 2: 读取本地文档

读取用户指定的 `.md` 文件，或批量读取目录下所有 `.md` 文件。

### Step 3: 上传文档到ShowDoc

```bash
curl -s -X POST "${SHOWDOC_BASE}index.php?s=/api/page/save" \
  -H 'accept: application/json, text/plain, */*' \
  -H 'content-type: application/x-www-form-urlencoded;charset=UTF-8' \
  -H "Cookie: cookie_token=${COOKIE_TOKEN}" \
  -d "page_id=0&item_id=${ITEM_ID}&s_number=&page_title=${TITLE}&page_content=${ENCODED_CONTENT}&is_urlencode=1&cat_id=${CAT_ID}"
```

**item_id 取值规则（上传前确定）：**
| 版本 | item_id | 触发条件 |
|------|---------|---------|
| 标准版 | 1 | 默认，未特别说明时 |
| 国际版 | 23 | 用户明确提到"国际版" |

**参数说明：**
| 参数 | 说明 |
|------|------|
| page_id | 0表示新增，非0表示编辑 |
| item_id | 项目ID，见上方取值规则 |
| page_title | 页面标题 |
| page_content | URL编码后的Markdown内容 |
| is_urlencode | 固定为1 |
| cat_id | 分类ID（必填，用户需指定） |

**返回示例：**
```json
{"error_code":0,"data":{"page_id":"33192","page_title":"..."}}
```

**错误处理：**
- `error_code: 10102` → cookie过期，需重新登录
- `error_code: 0` → 成功

### Step 4: 返回正确的URL

上传成功后，返回给用户的URL格式必须是：
```
https://qc.can-dao.com:8889/showdoc/web/#/1?page_id={page_id}
```

例如：`https://qc.can-dao.com:8889/showdoc/web/#/1?page_id=33216`

**注意**：不要使用旧格式 `https://qc.can-dao.com:8889/showdoc/server/index.php?s=/api/page/detail&page_id=xxx`

## 使用方式

用户需提供：
1. **本地文档路径**：单个文件或目录路径
2. **目标分类ID (cat_id)**：用户必须明确指定上传到哪个分类

### 单个文件上传
```
上传 /path/to/doc.md 到 ShowDoc 餐单系统(cat_id=8)
```

### 批量上传目录
```
上传 /path/to/docs/ 下所有文档到 ShowDoc 餐单系统(cat_id=8)
```

## 编码处理

```python
import urllib.parse

def encode_content(content: str) -> str:
    return urllib.parse.quote(content)
```

注意：内容必须URL编码后再传输。
