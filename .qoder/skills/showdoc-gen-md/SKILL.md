---
name: showdoc-gen-md
description: 从Java代码生成markdown接口文档。当用户提到"生成接口文档"、"代码转文档"、"接口文档生成"时使用此技能。
triggers:
  - 生成接口文档
  - 代码转文档
  - 接口文档生成
---

# Generate API Doc from Code

Generate markdown API documentation from Java interface code comments and implementation.

## Workflow

### Step 1: Find Interface Definition

Search for the interface method in `IProductBApi.java` or similar API interface files:

```bash
grep -B 10 "methodName" path/to/Interface.java
```

Extract:
- JavaDoc comment (interface description)
- Method signature

### Step 2: Find Implementation

Search in the implementation class (e.g., `ProductBApi.java`):

```bash
grep -A 20 "methodName" path/to/ProductBApi.java
```

Extract:
- Request parameters from `reqData.getAsXxx()`
- Response structure from `RspData.retSuccess()`

### Step 3: Find DTO/Request/Response Classes

For complex parameters, find the corresponding DTO classes:

```bash
# Find request/response classes
find . -name "*Req*.java" -o -name "*Rsp*.java" -o -name "*DTO*.java"

# Read the class to understand field definitions
```

### Step 3.5: Recursively Expand Nested Parameters (CRITICAL)

**IMPORTANT**: 对于每个复杂类型的嵌套对象（如 List\<T\>、Map<K,V> 或自定义对象），必须递归展开其所有层级字段，直到基本类型。

**递归展开规则**：
1. 识别每个嵌套对象的类型
2. 在项目中搜索该类的定义
3. 读取该类的所有字段（包括父类继承的字段）
4. 对于每个复杂类型字段，继续递归展开
5. 使用缩进层级展示嵌套关系

**嵌套层级标识**：
- 第一层：`└ fieldName` (无前缀)
- 第二层：`  └ nestedFieldName`
- 第三层：`    └ deepNestedFieldName`
- 以此类推...

**示例 - OrderProduct 完整展开**：
```
### 餐品参数（OrderProduct）：

|参数名|类型|必传|说明|
|:-------|:-------|:-------|:-------|
| pid | int | 是 | 餐品id |
| name | String | 否 | 餐品名称 |
| price | float | 否 | 餐品单价 |
| listRequirements | List\<ProductRequirements\> | 否 | 特殊要求列表 |
| └ uid | int | 否 | 特殊要求id |
| └ num | int | 否 | 数量 |
| └ propertys | List\<ProductRequirement\> | 否 | 规格/属性列表 |
|    └ uid | int | 否 | 规格id |
|    └ name | String | 否 | 规格名称 |
|    └ items | List\<ProductRequirementItem\> | 否 | 选项列表 |
|       └ uid | int | 否 | 选项id |
|       └ name | String | 否 | 选项名称 |
|       └ price | float | 否 | 加价金额 |
| groups | List\<GroupDataSet\> | 否 | 套餐数据列表 |
|    └ type | String | 否 | 套餐类型 |
|    └ num | int | 否 | 数量 |
|    └ mains | List\<MainArea\> | 否 | 主食区列表 |
|       └ groups | List\<Group\> | 否 | 组列表 |
|          └ products | List\<GroupProduct\> | 否 | 套餐内餐品列表 |
|             └ pid | int | 否 | 餐品id |
|             └ name | String | 否 | 餐品名称 |
| products | List\<OrderProduct\> | 否 | 套餐里的单品列表（递归展开同上） |
```

**常见需要递归展开的嵌套类型**：
- `List<OrderProduct>` → 展开 OrderProduct
- `List<ProductRequirements>` → 展开 ProductRequirements
- `List<GroupDataSet>` → 展开 GroupDataSet → Group → GroupProduct
- `Map<String, Object>` → 列出key类型和value类型说明
- `PaymentDetail` → 展开其所有字段
- `OrderPreferential` → 展开其所有字段

### Step 4: Generate Markdown Document

**IMPORTANT**: 生成的文档格式必须参考模板文件 `references/api_doc.md`。

使用模板文件作为参考，填充以下内容：

```markdown
**接口使用：**

- `{JavaDoc description}`

**接口开发：**

- 当前账号人（默认填写git用户名或系统当前用户）

**渠道开放：**

- {channel name}

------------

### 接口action：
- `{package}.{methodName}`

### 参数（content）：

|参数名|类型|必传|说明|
|:-------|:-------|:-------|:-------|
| fieldName |type | 是/否 | description |
| nestedObject | Object | 否 | 嵌套对象 |
| └ nestedField | String | 否 | 嵌套字段 |
| complexList | List\<NestedType\> | 否 | 嵌套列表 |
|    └ listItemField | int | 否 | 列表项字段 |
|    └ deepNested | NestedDeep | 否 | 深层嵌套 |
|       └ deepField | String | 否 | 深层字段 |

### 嵌套参数说明：

#### NestedType（嵌套类型）

|参数名|类型|必传|说明|
|:-------|:-------|:-------|:-------|
| fieldA | String | 否 | 字段A |
| fieldB | int | 否 | 字段B |

#### NestedDeep（深层嵌套类型）

|参数名|类型|必传|说明|
|:-------|:-------|:-------|:-------|
| deepField | String | 否 | 深层字段 |

### 返回示例：

```json
{
    "status": 1,
    "msg": "操作成功",
    "logId": "xxx",
    "data": {},
    "serverTime": 1234567890
}
```

### 返回参数（data）说明：

|参数名|类型|说明|
|:-------|:-------|:-------|
| fieldName |type | description |

### 附录：字典说明

#### 枚举名称（fieldName）

|值|说明|
|:-------|:-------|
| 0 | 描述 |
| 1 | 描述 |
```

### Step 5: Format Self-Check（生成后必须执行）

文件写入磁盘之前，对生成内容逐项检查。发现问题立即修复，不要跳过。

**① 必须包含以下节（缺一不可）**

| 节标题 | 检查点 |
|--------|--------|
| `**接口使用：**` | 有且仅有一行中文描述 |
| `**接口开发：**` | 填写了 git 用户名 |
| `**渠道开放：**` | 填写了渠道名称 |
| `### 接口action：` | 有且仅有一行 action，格式为 `` - `candao.xxx.method` `` |
| `### 参数（content）：` | 下方是表格，不是散文 |
| `### 返回示例：` | 有 JSON 代码块 |
| `### 返回参数（data）说明：` | 下方是表格，不是散文 |

**② 表格完整性**

- `### 参数（content）：` 即使接口无参数，也必须保留表格，用占位行说明：
  ```
  |参数名|类型|必传|说明|
  |:-------|:-------|:-------|:-------|
  | - | - | - | 无业务参数，xxx 从请求上下文自动获取 |
  ```
- `### 返回参数（data）说明：` 即使 data=null，也必须保留表格，用说明列描述原因：
  ```
  |参数名|类型|说明|
  |:-------|:-------|:-------|
  | - | - | 操作成功时 data 为 null，通过 status=1 判断结果 |
  ```

**③ 禁止出现非标准节**

模板只定义了上表中的节标题。遇到以下情况时，不要新增 `###` 级别的独立节，而是将内容合并进已有节的说明列：

- 参数校验规则 → 合并到 `### 参数（content）：` 表格的「说明」列
- 错误码说明 → 合并到 `### 返回参数（data）说明：` 表格
- 注意事项 → 同上

## Key Patterns

### Interface Method Detection
```
/**
 * 中文描述
 * @param reqData
 * @return
 */
public String methodName(ReqData reqData);
```

### Implementation Parameter Extraction
```java
public String methodName(ReqData reqData) {
    int brandId = reqData.getAsInt("brandId");
    String name = reqData.getAsString("name");
    List<Integer> ids = reqData.getAsList("ids", Integer.class);
    // ...
    return RspData.retSuccess(object);
}
```

### Paging Response Structure
```json
{
    "data": {
        "rows": [],
        "pages": 1,
        "total": 100,
        "page": 1,
        "pageSize": 20
    }
}
```

## Output Fields

| Element | Source |
|---------|--------|
| 接口使用 | JavaDoc注释中的中文描述 |
| 接口开发 | 当前账号人用户名（从git user.name或环境变量获取） |
| 渠道开放 | 从接口包名/类名/注释推断 |
| 接口action | 见下方规则 |
| 文件名 | `序号_方法名.md` |

### 接口action命名规范

将Java接口全路径转换为action名称，规则如下：

**转换公式：**
```
com.candao.{module1}.{module2}.api.I{InterfaceName}Api#methodName
    ↓
candao.{interfaceNameWithoutIAndApi}.{methodName}
```

**转换步骤：**
1. 移除 `com.candao.` 前缀
2. 移除中间路径（如 `order.standard.api.I` 或 `order.own.api.I`）
3. 移除接口名的 `I` 前缀和 `Api` 后缀
4. 将剩余部分转为camelCase作为模块名
5. 用点号连接：模块名.方法名

**示例：**
| Java接口路径 | 转换后action |
|-------------|-------------|
| `com.candao.order.standard.api.IOrderStandardEApi#postOrder` | `candao.orderStandard.postOrder` |
| `com.candao.order.own.api.IOrderOwnBApi#getOrderDetail` | `candao.orderOwn.getOrderDetail` |
| `com.candao.store.own.api.IStoreOwnBApi#syncStore` | `candao.storeOwn.syncStore` |

**注意：** 如果接口路径不符合上述模式，则使用简化规则 `包名.方法名`

## Example

Input JavaDoc:
```java
/**
 * 同步总部餐品库
 * @param reqData
 * @return
 */
public String syncHeadquarterProduct(ReqData reqData);
```

Output file: `03_sync_headquarter_product.md`

```markdown
**接口使用：**

- `同步总部餐品库`

**接口开发：**

- griftt (当前账号人)

**渠道开放：**

- Coms

------------

### 接口action：
- `candao.product.syncHeadquarterProduct`  (假设接口为 IProductApi)

### 参数（content）：

|参数名|类型|必传|说明|
|:-------|:-------|:-------|:-------|
| brandId |int | 是 | 品牌id |
| fromType |int | 是 | 渠道ID |
| ... | | | |

### 返回示例：

```json
{
    "status": 1,
    "msg": "操作成功",
    "data": {
        "taskId": 123456789
    }
}
```
