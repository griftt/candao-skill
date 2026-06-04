**接口使用：**

- 分页查询餐品

**接口开发：**
- Sky

**渠道开放：**
- Ocrm

------------

### 接口action：
- ` candao.product.queryProductPaging `

### 参数（content）：

|参数名|类型|必传|说明|
|:-------|:-------|:-------|:-------|
| brandId |int | 否 | 品牌id  没有brandIds和brandId则查运营商全部餐品|
| brandIds |array[object] | 否 | 品牌id集合  没有brandIds和brandId 则查运营商全部餐品 |
| uid |int | 否 | 餐品id |
| pids |array[int[] | 否 | 餐品id集合 |
| name |string | 否 | 餐品名称 |
| upc |string | 否 | 餐品UPC |
| memo |string | 否 | 餐品备注 |
| type |int | 否 | 餐品类型 0:全部 1:单品, 2:套餐 |
| inTypes |array[int[] | 否 | 餐品类型集合 1:单品, 2:套餐，3：组合 |
| standard |String | 否 | 规格名称 （propertyType，不传或者传0的时候，该字段为模糊查询特殊要求）|
| propertyType |int | 否 |  0:全部， 1:按规格查询 |
| isRequirement |boolean | 否 | 是否附带特殊要求 true:带, false:不带,null:全部 |
| status |int | 否 | 状态 全部:0 启用：1；停用：2； |
| menuId |int | 否 | 餐单ID |
| fromType |int | 否 | 渠道ID  查询品牌指定渠道餐单餐品 482:抖音团购 |
| pidSort |boolean | 否 | 默认false—-降序 true——升序 |
| isQueryMapping |boolean | 是 | 是否映射码查询 |
| ignoreSelectedTagProduct |boolean | 是 | 是否忽略掉已经选中标签的餐品 |
| mappingCode |String | 否 | 映射码 |
| isFtpProduct |Boolean | 否 | 是否ftp优惠餐品，为true需要传会员的价格 false：非ftp优惠餐品,true：ftp优惠餐品，汉堡王定制化，1118版本后该字段可去掉 |
| preProductType |Integer | 否 | 优惠餐品类型 0：普通餐品 1：Ftp会员餐品 2：第三方会员餐品，不传查询所有，汉堡王定制化 |
| pageNow |int | 是 | 当前页 |
| pageSize |int | 是 | 每页数量 |
|  queryPropertyMode |int| 否 |查询特殊要求模式 0:默认  1:二次筛选，查询多个特殊要求|
|  propertyNames |List<object>| 是 | 选择特殊要求名称集合 queryPropertyMode==1，才有值|
| └ propertyNames |List<string>| 否 | 名称集合 |
| └  propertyType |int| 否 | 1:规格 2:属性 3:多选 4:多组多选 |


### 返回示例：

```
{
    "status": 1,
    "msg": "操作成功",
    "logId": "ffb9e184-9db2-4e85-9d8f-ffebb2196b3e",
    "data": {
        "rows": [
            {
                "uid": 53459,
                "brandId": 1109,
                "name": "大热狗",
                "aliasName": "打印别名",
                "isNew": true,
                "isSpecialty": false,
                "isSpicy": false,
                "isSideDish": false,
                "price": 22.0,
                "startPrice": 12.0,
                "costPrice": 12.0,
                "desc": "描述",
                "isUploadProductVideo": true,
                "type": 1,
                "isRequirement": true,
                "propertyId": 0,
                "property": {
                    "uid": 0,
                    "brandId": 0,
                    "standard": {
                        "uid": 57306,
                        "title": "加辣",
                        "titleEn": "more pungent",
                        "channelType": 3,
                        "type": 1,
                        "items": [
                            {
                                "uid": 68459,
                                "name": "特辣",
                                "nameEn": "",
                                "price": 2.0,
                                "canChooseItemIds": [],
                                "hasChooseLimit": true,
                                "weight": 100.0,
                                "upc": "",
                                "refId": 0,
                                "isSoldOut": false,
                                "hasStock": false,
                                "stockNum": 0,
                                "initNum": 0,
                                "tempCode": 0,
                                "canNotChooseItemIds": []
                            },
                            {
                                "uid": 68460,
                                "name": "微辣",
                                "nameEn": "little pungent",
                                "price": 1.0,
                                "canChooseItemIds": [],
                                "hasChooseLimit": true,
                                "weight": 50.0,
                                "upc": "",
                                "refId": 0,
                                "isSoldOut": false,
                                "hasStock": false,
                                "stockNum": 0,
                                "initNum": 0,
                                "tempCode": 0,
                                "canNotChooseItemIds": []
                            }
                        ],
                        "propertyMemo": ""
                    },
                    "refCommonItemIds": [],
                    "refCommonItemId2PropertyItemIds": {},
                    "proerptyId2NameMap": {},
                    "proerptyId2PropertyNameMap": {},
                    "status": 1
                },
                "serviceType": 2,
                "serviceWeeks": [
                    1,
                    2,
                    3,
                    4,
                    5,
                    6,
                    7
                ],
                "extraServiceTimes": [],
                "tagUid": 0,
                "material": "",
                "mealFee": 1.0,
                "mealFeeMode": 0,
                "mulMealFee": 0.0,
                "part": 0,
                "mealNum": 3,
                "attribute": {
                    "length": 0.0,
                    "width": 0.0,
                    "high": 0.0,
                    "weight": 156.0
                },
                "mealCost": 1.0,
                "materialCost": 111.0,
                "packingCost": 1.0,
                "upc": "asd",
                "isColdchaingoods": true,
                "memo": "更新的",
                "memoSecond": "",
                "propertyTag": "辣",
                "tradeMark": "新鲜",
                "commission": 1.0,
                "taxRate": "",
                "mixNum": 2,
                "productionTime": 1,
                "isOpenVip": false,
                "rank": [],
                "weightMode": 0,
                "oldProductId": 0,
                "PropertyItemList": [
                    {
                        "uid": 68459,
                        "name": "特辣",
                        "nameEn": "",
                        "price": 2.0,
                        "weight": 0.0,
                        "upc": ""
                    },
                    {
                        "uid": 68460,
                        "name": "微辣",
                        "nameEn": "little pungent",
                        "price": 1.0,
                        "weight": 0.0,
                        "upc": ""
                    }
                ],
                "bigTypeId": 0,
                "smallTypeId": 0,
                "brandName": "王老弟",
                "isSoldOut": false,
                "hasStock": false,
                "stockNum": 0,
                "initNum": 0,
                "oldId": 0,
                "isDiscontinue": false,
                "isMinPrice": false,
                "customizedSales": 0,
                "actualSales": 0,
                "weight": 0.0,
                "syncStatus": 0,
                "status": 1,
                "platformKey": "e833ae48bfbd3a7d",
                "createTime": "2019-08-22 16:42:36",
                "createDate": "2019-08-22",
                "updateTime": "2019-10-17 11:43:50",
                "updateDate": "2019-10-17"
            }
        ],
        "pages": 1,
        "total": 1,
        "page": 1,
        "pageSize": 20
    },
    "serverTime": 1571298313851
}
```
|参数名|类型|说明|
|:-------|:-------|:-------|



### 返回参数（data）说明：

|参数名|类型|说明|
|:-------|:-------|:-------|
| status |int  | 1:成功 |
| msg |string  | 返回信息 |
| logId |string  | 无 |
| data |object  | 无 |
| └ brandId | int | 品牌id |
| └ brandName | string | 品牌名称 |
| └ products | object | 餐品列表 |
| 　└ pages |int  | 总页数|
| 　└ total |int  | 总数量
| 　└ page |int  | 无 |
| 　└ pageSize |int  | 无 |
| 　└ rows |array[object]  | 无 |
| 　  └ createOperator |String  | 创建人 |
| 　  └ uid |int  | 餐品id |
|　	 └ extId |String  | 餐品映射码 |
|　	 └ extIdCount |Integer  | 映射码数量(仅运营商配置展示第三方编码有值) |
| 　　└ brandId |int  | 品牌id |
| 　　└ brandName |string  | 品牌名称 |
| 　　└ name |string  | 餐品名称 |
| 　　└ isNew |boolean  | 新品 |
| 　　└ productTagType |int |是  餐品主食/小食标签 0:其他 1:主食 2:小食 ，默认为0 20210902 汉堡王迭代 |
| 　　└ isSpecialty |boolean | 招牌 |
| 　　└ isSpicy |boolean | 辣 |
| 　　└ isSideDish |boolean | 配菜 |
| 　　└ price |float  | 价格 |
| 　　└ mealFee |float  | 餐盒费 |
| 　　└ mealNum |int  | 套餐人数，与系统中的套餐无关，仅用于饿了么用户端套餐活动数据抓取 |
| 　　└ mealCost |float  | 餐盒成本 |
| 　　└ materialCost |float  | 原料成本 |
| 　　└ material |string  | 原料 |
| 　　└ packingCost |float  | 打包成本 |
| 　　└ upc |string  | UPC码 |
| 　　└ isColdchaingoods |boolean  | 是否为冷链商品 |
| 　　└ propertyTag |string  | 属性标签 |
| 　　└ tradeMark |string  | 商品标识 |
| 　　└ commission |float  | 餐品佣金 |
| 　　└ taxRate |string  | 餐品税率 |
| 　　└ taxCategoryCode |string | 餐品税收分类编码(若餐品税率不为空则必填) |
| 　　└ mixNum |int | 最小购买量 |
| 　　└ productionTime |int | 制作时间 |
| 　　└ unit |string | 餐品单位 |
| 　　└ startPrice |int  | 起步价 |
| 　　└ costPrice |int  | 原价 |
| 　　└ desc |string  | 餐品描述 |
| 　　└ logo |string  | logo地址 |
| 　　└ image |string  | 图片地址 |
| 　　└ netContent |string  | 净含量 |
| 　　└ period |int  | 保质期天数 |
| 　　└ txdImageList |array[string]  | 淘鲜达图片地址 |
| 　　└ type |int  | 类型  商家端API-餐单系统-字典说明-ProductTypes|
| 　　└ propertyId |int  | 特殊要求id |
| 　　└ propertyMode |int  | 0：普通 1:饿了么专业模式 |
| 　　└ serviceType |int  | 供应时间类型 商家端API-餐单系统-字典说明-ServiceTypes |
| 　　└ serviceDate |object  | 供应日期 商家端API-餐单系统-字典说明-serviceDate|
| 　　　└ start |string  | 无 |
| 　　　└ end |string  | 无 |
| 　　└ attribute |object  | 餐品的长宽高重量属性|
| 　　　└ length |int  | 长 |
| 　　　└ width |int  | 宽 |
| 　　　└ high |int  | 高 |
| 　　　└ weight |int  | 重量 |
| 　　└ serviceWeeks |array[object]  | 供应星期,商家端API-餐单系统-字典说明-serviceWeeks |
| 　　└ serviceTimes |array[object]  | 供应时间段,商家端API-餐单系统-字典说明-serviceTimes|
| 　　　└ start |string  | 无 |
| 　　　└ end |string  | 无 |
| 　　└ status |int  | 状态 商家端API-餐单系统-字典说明-DataStatus |
| 　　└ platformKey |string  | 无 |
| 　　└ tagUid |int  | 分单标签id |
| 　　└ tagName |string  | 分单标签名称 |
| 　　└ createTime |string  | 创建时间 |
| 　　└ createDate |string  | 创建日期 |
| 　　└ updateTime |string  | 更新时间 |
| 　　└ updateDate |string  | 更新日期 |
| 　　└ combination |object | 餐品组合 |
| 　　　└ types |array[object] | 组合类型 |
| 　　　 └ name |string | 组合类型名称 |
| 　　　 └ nameEn |string | 组合类型英文名 |
| 　　　└ items |array[object] | 组合类型项 |
| 　　   └ combinationTypeKey |string | 组合类型key(格式："typeId_itemId,typeId_itemId") |
| 　　   └ name |string | 组合类型项名称 |
| 　　   └ nameEn |string | 组合类型项英文名 |
| 　　　└ products |array[object] | 组合餐品 |
| 　　   └ productId |int | 餐品ID |
| 　　   └ productName |string | 餐品名称 |
| 　　└ propertyItemList |array[object]  | 餐品规格|
| 　　　└ uid |int  | 规格id |
| 　　　└ name |String  | 规格名 |
| 　　　└ nameEn |String  | 规格英文名|
| 　　　└ price |float  | 价格|
| 　　　└ weight |float  | 重量|
| 　　　└ upc |String  | upc码 |
| 　　└ productCategory |object  |  商品分类 |
| 　　　└ firstPlatCateId |String  |  一级类目id |
| 　　　└ firstPlatCateName |String  |  一级类目名称 |
| 　　　└ secondPlatCateId |String  |  二级类目id |
| 　　　└ secondPlatCateName |String  | 二级类目名称 |
| 　　　└ thirdPlatCateId |String  |  三级类目id |
| 　　　└ thirdPlatCateName |String  |  三级类目名称 |
| 　　└ mappingList |array[object]  | 映射码列表 见http://10.200.102.170/showdoc/web/#/1?page_id=316|
| 　　└ mappingExample |String  | 映射码展示案例（只有一个映射码展示“渠道:映射码”，没有显示“-”，大于一个显示“点击查看”按钮）
| 　　└ mappingIsComplete |Boolean  | 映射码是否已完善
| serverTime |int  | 无 |
