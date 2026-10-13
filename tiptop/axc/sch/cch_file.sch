/*
================================================================================
檔案代號:cch_file
檔案名稱:每月工单元件在制成本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cch_file
(
cch01       varchar2(40) NOT NULL,   /*工单单号重覆性生产产品成本             */
                                     /*工單編號                               */
cch02       number(5) NOT NULL,      /*年度                                   */
cch03       number(5) NOT NULL,      /*月份                                   */
cch04       varchar2(40) NOT NULL,   /*元件料号                               */
                                     /*元件料號                               */
cch05       varchar2(1) NOT NULL,    /*元件料号类型                           */
                                     /*元件料號類別 (Purchase/Make/Rework)    */
cch11       number(15,3) NOT NULL,   /*上月结存数量                           */
                                     /*上月結存數量                           */
cch12       number(20,6) NOT NULL,   /*上月结存金额(a+b+c+d+e)                */
                                     /*上月結存金額(a+b+c+d+e)                */
cch12a      number(20,6) NOT NULL,   /*上月结存金额-材料   (a)                */
                                     /*上月結存金額-材料   (a)                */
cch12b      number(20,6) NOT NULL,   /*上月结存金额-人工   (b)                */
                                     /*上月結存金額-人工   (b)                */
cch12c      number(20,6) NOT NULL,   /*上月结存金额-制费   (c)                */
                                     /*上月結存金額-製費   (c)                */
cch12d      number(20,6) NOT NULL,   /*上月结存金额-加工   (d)                */
                                     /*上月結存金額-加工   (d)                */
cch12e      number(20,6) NOT NULL,   /*上月结存金额-其他   (e)                */
                                     /*上月結存金額-其他   (e)                */
cch21       number(15,3) NOT NULL,   /*本月投入数量                           */
                                     /*本月投入數量                           */
cch22       number(20,6) NOT NULL,   /*本月投入金额(a+b+c+d+e)                */
                                     /*本月投入金額(a+b+c+d+e)                */
cch22a      number(20,6) NOT NULL,   /*本月投入金额-材料   (a)                */
                                     /*本月投入金額-材料   (a)                */
cch22b      number(20,6) NOT NULL,   /*本月投入金额-人工   (b)                */
                                     /*本月投入金額-人工   (b)                */
cch22c      number(20,6) NOT NULL,   /*本月投入金额-制费   (c)                */
                                     /*本月投入金額-製費   (c)                */
cch22d      number(20,6) NOT NULL,   /*本月投入金额-加工   (d)                */
                                     /*本月投入金額-加工   (d)                */
cch22e      number(20,6) NOT NULL,   /*本月投入金额-其他   (e)                */
                                     /*本月投入金額-其他   (e)                */
cch31       number(15,3) NOT NULL,   /*本月转出数量 (=半成品入库)             */
                                     /*本月轉出數量 (=半成品入庫)             */
cch32       number(20,6) NOT NULL,   /*本月转出金额(a+b+c+d+e)                */
                                     /*本月轉出金額(a+b+c+d+e)                */
cch32a      number(20,6) NOT NULL,   /*本月转出金额-材料   (a)                */
                                     /*本月轉出金額-材料   (a)                */
cch32b      number(20,6) NOT NULL,   /*本月转出金额-人工   (b)                */
                                     /*本月轉出金額-人工   (b)                */
cch32c      number(20,6) NOT NULL,   /*本月转出金额-制费   (c)                */
                                     /*本月轉出金額-製費   (c)                */
cch32d      number(20,6) NOT NULL,   /*本月转出金额-加工   (d)                */
                                     /*本月轉出金額-加工   (d)                */
cch32e      number(20,6) NOT NULL,   /*本月转出金额-其他   (e)                */
                                     /*本月轉出金額-其他   (e)                */
cch41       number(15,3) NOT NULL,   /*差异转出数量                           */
                                     /*差異轉出數量 (標準成本制下的標準差異)  */
cch42       number(20,6) NOT NULL,   /*差异转出金额(a+b+c+d+e)                */
                                     /*差異轉出金額(a+b+c+d+e)                */
cch42a      number(20,6) NOT NULL,   /*差异转出金额-材料   (a)                */
                                     /*差異轉出金額-材料   (a)                */
cch42b      number(20,6) NOT NULL,   /*差异转出金额-人工   (b)                */
                                     /*差異轉出金額-人工   (b)                */
cch42c      number(20,6) NOT NULL,   /*差异转出金额-制费   (c)                */
                                     /*差異轉出金額-製費   (c)                */
cch42d      number(20,6) NOT NULL,   /*差异转出金额-加工   (d)                */
                                     /*差異轉出金額-加工   (d)                */
cch42e      number(20,6) NOT NULL,   /*差异转出金额-其他   (e)                */
                                     /*差異轉出金額-其他   (e)                */
cch51       number(15,3),            /*累计投入数量                           */
                                     /*累計投入數量                           */
cch52       number(20,6),            /*累计投入金额(a+b+c+d+e)                */
                                     /*累計投入金額(a+b+c+d+e)                */
cch52a      number(20,6),            /*累计投入金额-材料   (a)                */
                                     /*累計投入金額-材料   (a)                */
cch52b      number(20,6),            /*累计投入金额-人工   (b)                */
                                     /*累計投入金額-人工   (b)                */
cch52c      number(20,6),            /*累计投入金额-制费   (c)                */
                                     /*累計投入金額-製費   (c)                */
cch52d      number(20,6),            /*累计投入金额-加工   (d)                */
                                     /*累計投入金額-加工   (d)                */
cch52e      number(20,6),            /*累计投入金额-其他   (e)                */
                                     /*累計投入金額-其他   (e)                */
cch53       number(15,3),            /*累计转出数量                           */
                                     /*累計轉出數量                           */
cch54       number(20,6),            /*累计转出金额(a+b+c+d+e)                */
                                     /*累計轉出金額(a+b+c+d+e)                */
cch54a      number(20,6),            /*累计转出金额-材料   (a)                */
                                     /*累計轉出金額-材料   (a)                */
cch54b      number(20,6),            /*累计转出金额-人工   (b)                */
                                     /*累計轉出金額-人工   (b)                */
cch54c      number(20,6),            /*累计转出金额-制费   (c)                */
                                     /*累計轉出金額-製費   (c)                */
cch54d      number(20,6),            /*累计转出金额-加工   (d)                */
                                     /*累計轉出金額-加工   (d)                */
cch54e      number(20,6),            /*累计转出金额-其他   (e)                */
                                     /*累計轉出金額-其他   (e)                */
cch55       number(15,3),            /*累计超领退数量                         */
                                     /*累計超領退數量                         */
cch56       number(20,6),            /*累计超领退金额(a+b+c+d+e)              */
                                     /*累計超領退金額(a+b+c+d+e)              */
cch56a      number(20,6),            /*累计超领退金额-材料   (a)              */
                                     /*累計超領退金額-材料   (a)              */
cch56b      number(20,6),            /*累计超领退金额-人工   (b)              */
                                     /*累計超領退金額-人工   (b)              */
cch56c      number(20,6),            /*累计超领退金额-制费   (c)              */
                                     /*累計超領退金額-製費   (c)              */
cch56d      number(20,6),            /*累计超领退金额-加工   (d)              */
                                     /*累計超領退金額-加工   (d)              */
cch56e      number(20,6),            /*累计超领退金额-其他   (e)              */
                                     /*累計超領退金額-其他   (e)              */
cch57       number(15,3),            /*本期超领退数量                         */
                                     /*本期超領退數量                         */
cch58       number(20,6),            /*本期超领退金额(a+b+c+d+e)              */
                                     /*本期超領退金額(a+b+c+d+e)              */
cch58a      number(20,6),            /*本期超领退金额-材料   (a)              */
                                     /*本期超領退金額-材料   (a)              */
cch58b      number(20,6),            /*本期超领退金额-人工   (b)              */
                                     /*本期超領退金額-人工   (b)              */
cch58c      number(20,6),            /*本期超领退金额-制费   (c)              */
                                     /*本期超領退金額-製費   (c)              */
cch58d      number(20,6),            /*本期超领退金额-加工   (d)              */
                                     /*本期超領退金額-加工   (d)              */
cch58e      number(20,6),            /*本期超领退金额-其他   (e)              */
                                     /*本期超領退金額-其他   (e)              */
cch59       number(15,3),            /*盘差数量                               */
                                     /*盤差數量                               */
cch60       number(20,6),            /*盘差金额(a+b+c+d+e)                    */
                                     /*盤差金額(a+b+c+d+e)                    */
cch60a      number(20,6),            /*盘差金额-材料   (a)                    */
                                     /*盤差金額-材料   (a)                    */
cch60b      number(20,6),            /*盘差金额-人工   (b)                    */
                                     /*盤差金額-人工   (b)                    */
cch60c      number(20,6),            /*盘差金额-制费   (c)                    */
                                     /*盤差金額-製費   (c)                    */
cch60d      number(20,6),            /*盘差金额-加工   (d)                    */
                                     /*盤差金額-加工   (d)                    */
cch60e      number(20,6),            /*盘差金额-其他   (e)                    */
                                     /*盤差金額-其他   (e)                    */
cch91       number(15,3) NOT NULL,   /*本月结存数量                           */
                                     /*本月結存數量                           */
cch92       number(20,6) NOT NULL,   /*本月结存金额(a+b+c+d+e)                */
                                     /*本月結存金額(a+b+c+d+e)                */
cch92a      number(20,6) NOT NULL,   /*本月结存金额-材料   (a)                */
                                     /*本月結存金額-材料   (a)                */
cch92b      number(20,6) NOT NULL,   /*本月结存金额-人工   (b)                */
                                     /*本月結存金額-人工   (b)                */
cch92c      number(20,6) NOT NULL,   /*本月结存金额-制费   (c)                */
                                     /*本月結存金額-製費   (c)                */
cch92d      number(20,6) NOT NULL,   /*本月结存金额-加工   (d)                */
                                     /*本月結存金額-加工   (d)                */
cch92e      number(20,6) NOT NULL,   /*本月结存金额-其他   (e)                */
                                     /*本月結存金額-其他   (e)                */
cchuser     varchar2(10),            /*最近计算人员                           */
                                     /*最近計算人員                           */
cchdate     date,                    /*最近计算日期                           */
                                     /*最近計算日期                           */
cchtime     varchar2(5),             /*最近计算时间                           */
                                     /*最近計算時間                           */
cch311      number(15,3),            /*报废数量                               */
cch06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cch07       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利*/
cch12f      number(20,6) DEFAULT '0',/*上月结存金额-制费三                    */
cch12g      number(20,6) DEFAULT '0',/*上月结存金额-制费四                    */
cch12h      number(20,6) DEFAULT '0',/*上月结存金额-制费五                    */
cch22f      number(20,6) DEFAULT '0',/*本月投入金额-制费三                    */
cch22g      number(20,6) DEFAULT '0',/*本月投入金额-制费四                    */
cch22h      number(20,6) DEFAULT '0',/*本月投入金额-制费五                    */
cch32f      number(20,6) DEFAULT '0',/*本月转出金额-制费三                    */
cch32g      number(20,6) DEFAULT '0',/*本月转出金额-制费四                    */
cch32h      number(20,6) DEFAULT '0',/*本月转出金额-制费五                    */
cch42f      number(20,6) DEFAULT '0',/*差异转出金额-制费三                    */
cch42g      number(20,6) DEFAULT '0',/*差异转出金额-制费四                    */
cch42h      number(20,6) DEFAULT '0',/*差异转出金额-制费五                    */
cch52f      number(20,6) DEFAULT '0',/*累计投入金额-制费三                    */
cch52g      number(20,6) DEFAULT '0',/*累计投入金额-制费四                    */
cch52h      number(20,6) DEFAULT '0',/*累计投入金额-制费五                    */
cch54f      number(20,6) DEFAULT '0',/*累计转出金额-制费三                    */
cch54g      number(20,6) DEFAULT '0',/*累计转出金额-制费四                    */
cch54h      number(20,6) DEFAULT '0',/*累计转出金额-制费五                    */
cch56f      number(20,6) DEFAULT '0',/*累计超领退金额-制费三                  */
cch56g      number(20,6) DEFAULT '0',/*累计超领退金额-制费四                  */
cch56h      number(20,6) DEFAULT '0',/*累计超领退金额-制费五                  */
cch58f      number(20,6) DEFAULT '0',/*本期超领退金额-制费三                  */
cch58g      number(20,6) DEFAULT '0',/*本期超领退金额-制费四                  */
cch58h      number(20,6) DEFAULT '0',/*本期超领退金额-制费五                  */
cch60f      number(20,6) DEFAULT '0',/*盘差金额-制费三                        */
cch60g      number(20,6) DEFAULT '0',/*盘差金额-制费四                        */
cch60h      number(20,6) DEFAULT '0',/*盘差金额-制费五                        */
cch92f      number(20,6) DEFAULT '0',/*本月结存金额-制费三                    */
cch92g      number(20,6) DEFAULT '0',/*本月结存金额-制费四                    */
cch92h      number(20,6) DEFAULT '0',/*本月结存金额-制费五                    */
cchud01     varchar2(255),           /*自订字段-Textedit                      */
cchud02     varchar2(40),            /*自订字段-文字                          */
cchud03     varchar2(40),            /*自订字段-文字                          */
cchud04     varchar2(40),            /*自订字段-文字                          */
cchud05     varchar2(40),            /*自订字段-文字                          */
cchud06     varchar2(40),            /*自订字段-文字                          */
cchud07     number(15,3),            /*自订字段-数值                          */
cchud08     number(15,3),            /*自订字段-数值                          */
cchud09     number(15,3),            /*自订字段-数值                          */
cchud10     number(10),              /*自订字段-整数                          */
cchud11     number(10),              /*自订字段-整数                          */
cchud12     number(10),              /*自订字段-整数                          */
cchud13     date,                    /*自订字段-日期                          */
cchud14     date,                    /*自订字段-日期                          */
cchud15     date,                    /*自订字段-日期                          */
cchlegal    varchar2(10) NOT NULL,   /*所属法人                               */
cchorig     varchar2(10),            /*资料建立部门                           */
cchoriu     varchar2(10)             /*资料建立者                             */
);

create        index cch_02 on cch_file (cch04);
alter table cch_file add  constraint cch_pk primary key  (cch01,cch02,cch03,cch04,cch06,cch07) enable validate;
grant select on cch_file to tiptopgp;
grant update on cch_file to tiptopgp;
grant delete on cch_file to tiptopgp;
grant insert on cch_file to tiptopgp;
grant index on cch_file to public;
grant select on cch_file to ods;
