# candao-skill

餐道云平台 Claude Code 技能包，包含接口文档生成与 ShowDoc 上传工作流技能。

## 技能列表

| 技能 | 命令 | 功能 |
|------|------|------|
| showdoc-gen-md | `/showdoc-gen-md` | 从 Java 接口代码生成标准 Markdown 接口文档 |
| showdoc-md-upload | `/showdoc-md-upload` | 将本地 Markdown 文档批量上传到 ShowDoc |
| showdoc-publish | `/showdoc-publish` | 生成文档 → 用户确认 → 一键上传，全流程整合 |

---

## AI 自动安装

### Claude Code

将以下提示词发送给 Claude Code，即可自动完成安装与配置：

```
请帮我安装 candao-skill 技能包：
1. 克隆 https://github.com/griftt/candao-skill 到本地临时目录
2. 将 showdoc-gen-md、showdoc-md-upload、showdoc-publish 三个目录复制到 ~/.claude/skills/
3. 询问我的 ShowDoc 地址、用户名和密码，填入 ~/.claude/skills/showdoc-md-upload/config.json
4. 完成后告诉我可以使用 /showdoc-gen-md、/showdoc-md-upload、/showdoc-publish 三个命令
```

### Qoder

将以下提示词发送给 Qoder，即可自动完成安装与配置：

```
请帮我安装 candao-skill 技能包：
1. 克隆 https://github.com/griftt/candao-skill 到本地临时目录
2. 将 .qoder/skills/ 下的 showdoc-gen-md、showdoc-md-upload、showdoc-publish 三个目录复制到 ~/.qoder/skills/
3. 询问我的 ShowDoc 地址、用户名和密码，填入 ~/.qoder/skills/showdoc-md-upload/config.json
4. 完成后告诉我可以使用 /showdoc-gen-md、/showdoc-md-upload、/showdoc-publish 三个命令
```

---

## AI 更新（已安装用户）

技能有新版本时，将以下提示词发送给 Claude Code 或 Qoder 执行更新：

```
请帮我更新 candao-skill 技能包：
1. 进入本地 candao-skill 仓库目录（如不知道路径，先用 find ~ -name "update.sh" -path "*/candao-skill/*" 查找）
2. 运行 bash update.sh
3. 告诉我哪些技能已更新完成
注意：config.json 中的密码配置不会被覆盖
```

### 手动更新

```bash
cd /path/to/candao-skill
bash update.sh
```

---

## 手动安装

将两个技能目录复制到 Claude Code 技能目录下：

```bash
cp -r showdoc-gen-md ~/.claude/skills/
cp -r showdoc-md-upload ~/.claude/skills/
```

配置 ShowDoc 凭证（编辑 `~/.claude/skills/showdoc-md-upload/config.json`）：

```json
{
  "showdoc": {
    "base_url": "https://your-showdoc-host/showdoc/server/",
    "username": "your_username",
    "password": "your_password"
  }
}
```

---

## 使用流程

### 第一步：从代码生成文档

调用 `/showdoc-gen-md`，提供 Java 接口全路径，例如：

```
/showdoc-gen-md com.candao.order.own.api.IOrderOwnBApi#queryOrderProductSalesRecord
```

技能会自动：
1. 查找接口定义（JavaDoc 注释、方法签名）
2. 查找实现类提取请求参数
3. 查找 DTO/Bean 类递归展开嵌套字段
4. 按模板生成 `序号_方法名.md` 文件

生成的文档格式：

```markdown
**接口使用：**
- 查询订单餐品销售记录（分页）

**接口开发：**
- griftt

**渠道开放：**
- Coms

------------

### 接口action：
- `candao.orderOwn.queryOrderProductSalesRecord`

### 参数（content）：
...

### 返回示例：
...
```

#### 接口 action 命名规则

| Java 接口路径 | 生成 action |
|-------------|------------|
| `com.candao.order.own.api.IOrderOwnBApi#getOrderDetail` | `candao.orderOwn.getOrderDetail` |
| `com.candao.store.own.api.IStoreOwnBApi#syncStore` | `candao.storeOwn.syncStore` |
| `com.candao.export.api.IExportBApi#exportOrderList` | `candao.export.exportOrderList` |

---

### 第二步：上传文档到 ShowDoc

调用 `/showdoc-md-upload`，指定本地文件路径和目标分类，例如：

```
上传 docs/order-product-sales/ 下所有文档到商户端API订单系统
```

技能会自动：
1. 读取 `config.json` 登录 ShowDoc 获取 token
2. 查询 ShowDoc 分类树找到目标 cat_id
3. 逐个上传文件，返回每个文档的访问链接

上传成功后返回格式：
```
https://your-showdoc-host/showdoc/web/#/1?page_id=33263
```

---

## 目录结构

```
candao-skill/
├── README.md
├── showdoc-gen-md/
│   ├── SKILL.md              # 技能主文件
│   └── references/
│       └── api_doc.md        # 文档格式模板
└── showdoc-md-upload/
    ├── SKILL.md              # 技能主文件
    └── config.json           # ShowDoc 凭证配置（需填写）
```
