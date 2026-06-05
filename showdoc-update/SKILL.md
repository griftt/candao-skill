---
name: showdoc-update
description: |
  更新 ShowDoc 中已有的接口文档。当用户提到"更新接口文档"、"修改showdoc文档"、"重新生成并更新"、"覆盖接口文档"时使用此技能。
  流程：按接口名搜索已有页面 → 确认目标页面 → 重新从代码生成 MD → 用户确认 → 覆盖更新。
---

# ShowDoc 接口文档更新工具

从 Java 代码重新生成接口文档，覆盖更新 ShowDoc 中已有的页面。

## 工作流程总览

```
Step 1: 登录获取 cookie_token
Step 2: 搜索 ShowDoc 找到目标页面
Step 3: 确认目标页面（防止覆错）
Step 4: 重新从代码生成 MD 文档
Step 5: 告知用户文件路径，等待确认
Step 6: 覆盖更新到 ShowDoc
```

---

## Step 1: 登录获取 cookie_token

```bash
CONFIG=$(cat ~/.claude/skills/showdoc-md-upload/config.json)
USERNAME=$(echo $CONFIG | python3 -c "import json,sys; print(json.load(sys.stdin)['showdoc']['username'])")
PASSWORD=$(echo $CONFIG | python3 -c "import json,sys; print(json.load(sys.stdin)['showdoc']['password'])")

RESPONSE=$(curl -s -i -X POST "https://qc.can-dao.com:8889/showdoc/server/index.php?s=/api/user/login" \
  -H 'content-type: application/x-www-form-urlencoded;charset=UTF-8' \
  -d "username=${USERNAME}&password=${PASSWORD}&v_code=")

COOKIE_TOKEN=$(echo "$RESPONSE" | grep -i 'set-cookie' | grep -o 'cookie_token=[^;]*' | cut -d= -f2)
```

---

## Step 2: 搜索 ShowDoc 找到目标页面

**确定 item_id：**

| 版本 | item_id |
|------|---------|
| 标准版（默认） | 1 |
| 国际版 | 23 |

用户未说明时默认 item_id=1。

**用接口名/action 关键词搜索：**

```bash
# keyword 取接口 action 的方法名部分，如 getNearStoreList
SEARCH_RESULT=$(curl -s -X POST "https://qc.can-dao.com:8889/showdoc/server/index.php?s=/api/item/info" \
  -H 'content-type: application/x-www-form-urlencoded;charset=UTF-8' \
  -H "Cookie: cookie_token=${COOKIE_TOKEN}" \
  -d "item_id=${ITEM_ID}&keyword=${KEYWORD}&default_page_id=0")
```

**解析返回结果，提取匹配页面：**

返回数据结构：
```json
{
  "error_code": 0,
  "data": {
    "menu": {
      "pages": [
        {"page_id": "6437", "page_title": "获取附近店列表", "cat_id": "504"}
      ]
    }
  }
}
```

用 python 提取页面列表：
```bash
echo "$SEARCH_RESULT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
pages = data['data']['menu']['pages']
for p in pages:
    print(f\"page_id={p['page_id']} cat_id={p['cat_id']} title={p['page_title']}\")
"
```

---

## Step 3: 确认目标页面

将搜索结果列出给用户确认，**不要自动选择**，必须让用户明确指定：

```
找到以下匹配页面，请确认要更新哪一个：

1. [6437] 获取附近店列表 (cat_id=504)
2. [6438] 获取附近店 (cat_id=504)

请回复编号或 page_id。
```

如果只有一个结果，也需告知用户并等待确认：
```
找到页面：[6437] 获取附近店列表 (cat_id=504)
确认更新这个页面吗？（回复"确认"继续）
```

如果搜索无结果，告知用户并停止：
```
未找到匹配页面，请检查关键词或使用 /showdoc-publish 新建文档。
```

---

## Step 4: 重新从代码生成 MD 文档

用户确认目标页面后，**记录 page_id 和 cat_id**，然后按照 `showdoc-gen-md` skill 的完整流程重新生成文档：

1. 查找接口定义和 JavaDoc 注释
2. 查找实现类提取参数
3. 递归展开嵌套类型
4. 按模板生成 Markdown
5. 执行 Format Self-Check
6. 写入磁盘

---

## Step 5: 告知用户并等待确认

```
文档已重新生成：/path/to/xxx.md
目标页面：[{page_id}] {page_title}

请查看文档后回复"确认更新"，或告知需要修改的内容。
```

**此时不执行任何上传操作，等待用户明确回复。**

---

## Step 6: 覆盖更新到 ShowDoc

用户确认后，使用已记录的 **page_id（非零）** 和 **cat_id** 提交：

```bash
ENCODED_CONTENT=$(python3 -c "
import urllib.parse, sys
print(urllib.parse.quote(open('${MD_FILE}').read()))
")

curl -s -X POST "https://qc.can-dao.com:8889/showdoc/server/index.php?s=/api/page/save" \
  -H 'content-type: application/x-www-form-urlencoded;charset=UTF-8' \
  -H "Cookie: cookie_token=${COOKIE_TOKEN}" \
  -d "page_id=${PAGE_ID}&item_id=${ITEM_ID}&s_number=&page_title=${TITLE}&page_content=${ENCODED_CONTENT}&is_urlencode=1&cat_id=${CAT_ID}"
```

> `page_id` 非零 = 更新已有页面；`cat_id` 沿用搜索结果中的值，保持分类不变。

**返回成功后输出访问链接：**
```
更新成功：https://qc.can-dao.com:8889/showdoc/web/#/1?page_id={page_id}
```

**错误处理：**
- `error_code: 10102` → cookie 过期，重新执行 Step 1 后重试
- `error_code: 0` → 成功

---

## 接口说明

### `/api/item/info` — 搜索页面

| 参数 | 说明 |
|------|------|
| item_id | 项目ID（1=标准版，23=国际版） |
| keyword | 搜索关键词，用接口方法名 |
| default_page_id | 固定传 0 |

### `/api/page/info` — 获取页面详情（可选用于校验）

| 参数 | 说明 |
|------|------|
| page_id | 页面ID |

返回字段包括 `page_title`、`page_content`、`cat_id`、`item_id`，可用于对比新旧内容。
