/*
================================================================================
檔案代號:pmc_file
檔案名稱:供应商基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table pmc_file
(
pmc01       varchar2(10) NOT NULL,   /*供应厂商编号                           */
pmc02       varchar2(10),            /*厂商分类                               */
                                     /*廠商分類                               */
pmc03       varchar2(40),            /*简称                                   */
                                     /*簡稱                                   */
pmc04       varchar2(10),            /*付款厂商编号                           */
pmc05       varchar2(1),             /*交易状况                               */
                                     /*Transaction Status                     */
pmc06       varchar2(10),            /*区域编号                               */
                                     /*區域代號                               */
pmc07       varchar2(10),            /*国家编号                               */
                                     /*國別代號                               */
pmc081      varchar2(80),            /*全名 (第一行)                          */
pmc082      varchar2(80),            /*全名 (第二行)                          */
pmc091      varchar2(255),           /*地址(第一行)                           */
pmc092      varchar2(255),           /*地址(第二行)                           */
pmc093      varchar2(255),           /*地址(第三行)                           */
pmc094      varchar2(255),           /*地址(第四行)                           */
pmc095      varchar2(255),           /*地址(第五行)                           */
pmc10       varchar2(40),            /*电话号码                               */
                                     /*電話號碼                               */
pmc11       varchar2(40),            /*传真号码                               */
                                     /*傳真號碼                               */
pmc12       varchar2(40),            /*电传号码                               */
                                     /*電傳號碼                               */
pmc13       varchar2(1),             /*VAT Feature                            */
                                     /*正確值 0/1/2/3/4                       */
                                     /*0.零稅率                               */
                                     /*1.總額型                               */
                                     /*2.加值型                               */
                                     /*3.免稅型                               */
                                     /*4.小規模營業人                         */
pmc14       varchar2(1),             /*资料性质                               */
                                     /*Data Property                          */
                                     /*1.Purchase vender                      */
                                     /*  (Maintain by purchase department)    */
                                     /*  (The vender codes according to code reguler)*/
                                     /*  (Maintainning routine:apmi600)       */
                                     /*2.MISC vender                          */
                                     /*  (Maintain by billing employee)       */
                                     /*  (only use for AP system)             */
                                     /*  (The vender code is suggest to use uniform code)*/
                                     /*  (Maintainning routine:aapi600)       */
                                     /*3.Employee                             */
                                     /*4.Agent                                */
                                     /*5.Media Agent                          */
                                     /*6.Delievery Agent                      */
pmc15       varchar2(10),            /*送货地址                               */
                                     /*送貨地址                               */
pmc16       varchar2(10),            /*帐单地址                               */
                                     /*帳單地址                               */
pmc17       varchar2(10),            /*付款方式                               */
pmc18       varchar2(1),             /*厂商评鉴/ABC 等级                      */
                                     /*廠商評鑑/ABC 等級                      */
pmc19       varchar2(1),             /*厂商评鉴/交货等级                      */
                                     /*廠商評鑑/交貨等級                      */
pmc20       varchar2(1),             /*厂商评鉴/质量等级                      */
                                     /*廠商評鑑/品質等級                      */
pmc21       varchar2(1),             /*厂商评鉴/价格等级                      */
                                     /*廠商評鑑/價格等級                      */
pmc22       varchar2(4),             /*采购币种                               */
                                     /*採購幣別                               */
pmc23       varchar2(1),             /*No Use                                 */
pmc24       varchar2(20),            /*税号                                   */
                                     /*統一編號                               */
pmc25       varchar2(2),             /*付款行事历别                           */
                                     /*付款行事曆別                           */
pmc26       varchar2(24),            /*应付帐款会计科目                       */
                                     /*應付帳款會計科目                       */
pmc27       varchar2(1),             /*票据寄领方式                           */
                                     /*票據寄領方式                           */
                                     /*1.寄出                                 */
                                     /*2.自領                                 */
                                     /*3.其它                                 */
pmc28       number(5),               /*邮资/手续费                            */
                                     /*郵資/手續費                            */
pmc30       varchar2(1),             /*厂商性质                               */
                                     /*廠商性質                               */
                                     /*1.出貨廠商 (Vendor Only)               */
                                     /*2.付款廠商 (Remit-to Only)             */
                                     /*3.兩者     (Vendor 與 Remit-to)        */
pmc40       date,                    /*最近采购日期                           */
                                     /*最近採購日期(供應商)                   */
pmc41       date,                    /*最近退货日期                           */
                                     /*最近退貨日期(供應商)                   */
pmc42       date,                    /*最近交货日期                           */
                                     /*最近交貨日期(供應商)                   */
pmc43       date,                    /*最近凭证日期                           */
                                     /*最近傳票日期(付款商)                   */
pmc44       date,                    /*最近付款日期                           */
                                     /*最近付款日期(付款商)                   */
pmc45       number(13,2),            /*No Use                                 */
pmc46       number(13,2),            /*No Use                                 */
pmc47       varchar2(4),             /*惯用税种                               */
                                     /*慣用稅別                               */
pmc48       varchar2(1),             /*付款票据是否禁止背书                   */
                                     /*付款票據是否禁止背書(Y/N)              */
pmc49       varchar2(20),            /*惯用价格条件                           */
                                     /*慣用價格條件            (97/06/17 modi)*/
pmc50       number(5),               /*现金票据到期日为每月的第几             */
                                     /*現金票據到期日為每月的第幾日           */
pmc51       number(5),               /*远期票据到期日为每月的第几             */
                                     /*遠期票據到期日為每月的第幾日           */
pmc52       varchar2(255),           /*发票地址                               */
                                     /*發票/折讓單地                          */
pmc53       varchar2(255),           /*寄票地址                               */
                                     /*寄票地                                 */
pmc54       varchar2(10),            /*惯用佣金编号                           */
pmc55       varchar2(20),            /*汇款银行编号                           */
                                     /*匯款銀行編號                           */
pmc56       varchar2(30),            /*银行帐号                               */
                                     /*銀行帳號    char(15)->char(30) 01/12/27*/
pmc901      varchar2(10),            /*出货厂商                               */
                                     /*出貨廠商(外購用)                       */
pmc902      varchar2(1),             /*是否缴交切结书                         */
                                     /*是否繳交切結書                         */
pmc903      varchar2(1),             /*是否为关系人                           */
                                     /*是否為關係人                           */
pmc904      varchar2(10),            /*邮递区号                               */
                                     /*郵遞區號                               */
pmc905      varchar2(1),             /*检验水准                               */
                                     /*檢驗水準 (1.一般  2.特殊)              */
pmc906      varchar2(1),             /*检验程度                               */
                                     /*檢驗程度 (N/T/R)                       */
                                     /*'N':正常                               */
                                     /*'T':加嚴                               */
                                     /*'R':減量                               */
pmc907      varchar2(1),             /*级数                                   */
                                     /*級數                                   */
pmc908      varchar2(10),            /*地区别                                 */
                                     /*使用者自行定義                         */
pmc909      varchar2(30),            /*用户自行定义                           */
                                     /*使用者自行定義                         */
pmc910      varchar2(30),            /*用户自行定义                           */
                                     /*使用者自行定義                         */
pmc911      varchar2(1),             /*惯用语言别                             */
                                     /*慣用語言別 (0/1/2)                     */
                                     /*'0':繁體中文                           */
                                     /*'1':英文                               */
                                     /*'2':簡體中文                           */
pmcacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
pmcuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
pmcgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
pmcmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
pmcdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
pmcud01     varchar2(255),           /*用户自订字段                           */
pmcud02     varchar2(40),            /*用户自订字段                           */
pmcud03     varchar2(40),            /*是否为委外供应商                       */
pmcud04     varchar2(40),            /*用户自订字段                           */
pmcud05     varchar2(40),            /*用户自订字段                           */
pmcud06     varchar2(40),            /*用户自订字段                           */
pmcud07     number(15,3),            /*用户自订字段                           */
pmcud08     number(15,3),            /*用户自订字段                           */
pmcud09     number(15,3),            /*用户自订字段                           */
pmcud10     number(10),              /*用户自订字段                           */
pmcud11     number(10),              /*用户自订字段                           */
pmcud12     number(10),              /*用户自订字段                           */
pmcud13     date,                    /*用户自订字段                           */
pmcud14     date,                    /*用户自订字段                           */
pmcud15     date,                    /*用户自订字段                           */
pmc912      varchar2(1),             /*采购发出/采购变更是否以e-mail          */
pmc1912     varchar2(10),            /*保税入库异动原因代码                   */
pmc1913     varchar2(10),            /*保税仓退异动原因代码                   */
pmc1914     varchar2(10),            /*保税海关监管编号                       */
pmc1915     varchar2(10),            /*保税业务人员                           */
pmc1916     varchar2(10),            /*负责人                                 */
pmc1917     varchar2(6),             /*评核年月                               */
pmc1918     number(15,3),            /*评核分数                               */
pmc1919     varchar2(1),             /*评核等级                               */
pmc1920     varchar2(10) DEFAULT ' ' NOT NULL, /*资料来源*/
pmc1921     number(10),              /*抛转次数                               */
pmc913      varchar2(1),             /*预付金额是否与采购单勾稽               */
pmc281      varchar2(1),             /*手续费内扣/外加                        */
pmc914      varchar2(1) DEFAULT 'N', /*VMI管理否                              */
pmc915      varchar2(10),            /*VMI库存仓库                            */
pmc916      varchar2(10),            /*VMI库存储位                            */
pmc917      varchar2(10),            /*VMI结算仓库                            */
pmc918      varchar2(10),            /*VMI结算储位                            */
pmc919      varchar2(5),             /*VMI结算收货单别                        */
pmc920      varchar2(5),             /*VMI结算入库单别                        */
pmc921      varchar2(5),             /*VMI结算退货单别                        */
pmc922      varchar2(5),             /*VMI库存杂发单别                        */
pmc923      varchar2(5),             /*VMI库存杂收单别                        */
pmc57       varchar2(2),             /*通知书传送方式                         */
pmc58       number(5),               /*送货天数                               */
pmc59       varchar2(2),             /*采购间隔                               */
pmc60       varchar2(8),             /*采购星期                               */
pmc930      varchar2(10),            /*对应营运中心编号                       */
pmccrat     date,
pmcoriu     varchar2(10),            /*资料建立者                             */
pmcorig     varchar2(10),            /*资料建立部门                           */
pmc29       number(5),               /*结帐日                                 */
pmc61       varchar2(1) DEFAULT 'N' NOT NULL /*代印条码*/
);

create        index pmc_02 on pmc_file (pmc03);
create        index pmc_03 on pmc_file (pmc24);
alter table pmc_file add  constraint pmc_pk primary key  (pmc01) enable validate;
grant select on pmc_file to tiptopgp;
grant update on pmc_file to tiptopgp;
grant delete on pmc_file to tiptopgp;
grant insert on pmc_file to tiptopgp;
grant index on pmc_file to public;
grant select on pmc_file to ods;
