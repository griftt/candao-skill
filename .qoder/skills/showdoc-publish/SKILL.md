---
name: showdoc-publish
description: |
  从Java代码生成接口文档并发布到ShowDoc的完整流程。当用户提到"生成并上传文档"、"发布接口文档"、"生成文档到showdoc"、"接口文档发布"时使用此技能。
  整合了 showdoc-gen-md 和 showdoc-md-upload 两个技能，在生成文档后暂停等待用户确认，再执行上传。
---

# ShowDoc 一键发布工具

从 Java 接口代码生成 Markdown 文档，用户确认后上传到 ShowDoc。

## 工作流程总览

```
Step 1: 生成 MD 文档（参考 showdoc-gen-md 流程）
Step 2: 告知用户文件路径，等待确认
Step 3: 用户确认后上传到 ShowDoc（参考 showdoc-md-upload 流程）
```

---

## Step 1: 生成 MD 文档

按照 `showdoc-gen-md` skill 的完整流程执行：

1. 在接口文件（如 `IProductBApi.java`）中找到接口定义和 JavaDoc 注释
2. 在实现类中找到请求参数和返回结构
3. 递归展开所有嵌套类型
4. 按模板格式生成 Markdown 文档
5. 执行 Format Self-Check（Step 5 检查项）
6. 将文件写入磁盘，路径建议与接口文件同目录或用户指定位置，文件名格式：`序号_方法名.md`

> 详细生成规则见 showdoc-gen-md skill。

---

## Step 2: 告知用户并等待确认

文档生成写入磁盘后，**停止操作**，告知用户：

```
文档已生成：/path/to/xxx.md
请查看后回复"确认上传"，或告知需要修改的内容。
```

**此时不要继续执行任何上传操作，等待用户明确回复确认。**

---

## Step 3: 用户确认后上传

用户确认后，按照 `showdoc-md-upload` skill 的完整流程执行：

### 确定 item_id

| 版本 | item_id | 触发条件 |
|------|---------|---------|
| 标准版 | 1 | 默认，未特别说明时 |
| 国际版 | 23 | 用户明确提到"国际版" |

### 确认上传目标

如果用户未指定 `cat_id`，**必须询问**上传到哪个分类：

```
请问要上传到 ShowDoc 哪个分类？（需要提供 cat_id）
常用分类参考：
- 餐单系统(cat_id=8)
- 餐品算价(cat_id=1199)
- 同步中心(cat_id=488)
- 用户端餐单(cat_id=39)
```

### 登录获取 cookie_token

```bash
CONFIG=$(cat ~/.claude/skills/showdoc-md-upload/config.json)
USERNAME=$(echo $CONFIG | python3 -c "import json,sys; print(json.load(sys.stdin)['showdoc']['username'])")
PASSWORD=$(echo $CONFIG | python3 -c "import json,sys; print(json.load(sys.stdin)['showdoc']['password'])")

curl -s -i -X POST "https://qc.can-dao.com:8889/showdoc/server/index.php?s=/api/user/login" \
  -H 'content-type: application/x-www-form-urlencoded;charset=UTF-8' \
  -d "username=${USERNAME}&password=${PASSWORD}&v_code="
```

从响应头 `Set-Cookie: cookie_token=xxx` 提取 token。

### 上传文档

```bash
ENCODED_CONTENT=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(open('${MD_FILE}').read()))")

curl -s -X POST "https://qc.can-dao.com:8889/showdoc/server/index.php?s=/api/page/save" \
  -H 'content-type: application/x-www-form-urlencoded;charset=UTF-8' \
  -H "Cookie: cookie_token=${COOKIE_TOKEN}" \
  -d "page_id=0&item_id=${ITEM_ID}&s_number=&page_title=${TITLE}&page_content=${ENCODED_CONTENT}&is_urlencode=1&cat_id=${CAT_ID}"
```

### 返回访问链接

上传成功后返回：
```
https://qc.can-dao.com:8889/showdoc/web/#/1?page_id={page_id}
```

**错误处理：**
- `error_code: 10102` → cookie 过期，重新登录后重试
- `error_code: 0` → 成功
