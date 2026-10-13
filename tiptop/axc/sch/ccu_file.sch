/*
================================================================================
檔案代號:ccu_file
檔案名稱:每月拆件式工单元件在制成本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ccu_file
(
ccu01       varchar2(20) NOT NULL,   /*拆件式工单编号                         */
                                     /*拆件式工單編號                         */
ccu02       number(5) NOT NULL,      /*年度                                   */
ccu03       number(5) NOT NULL,      /*月份                                   */
ccu04       varchar2(40) NOT NULL,   /*元件料号                               */
                                     /*元件料號                               */
ccu05       varchar2(1) NOT NULL,    /*元件料号类型                           */
                                     /*元件料號類別 (Purchase/Make/Rework)    */
ccu11       number(15,3) NOT NULL,   /*上月结存数量                           */
                                     /*上月結存數量                           */
ccu12       number(20,6) NOT NULL,   /*上月结存金额(a+b+c+d+e)                */
                                     /*上月結存金額(a+b+c+d+e)                */
ccu12a      number(20,6) NOT NULL,   /*上月结存金额-材料   (a)                */
                                     /*上月結存金額-材料   (a)                */
ccu12b      number(20,6) NOT NULL,   /*上月结存金额-人工   (b)                */
                                     /*上月結存金額-人工   (b)                */
ccu12c      number(20,6) NOT NULL,   /*上月结存金额-制费   (c)                */
                                     /*上月結存金額-製費   (c)                */
ccu12d      number(20,6) NOT NULL,   /*上月结存金额-加工   (d)                */
                                     /*上月結存金額-加工   (d)                */
ccu12e      number(20,6) NOT NULL,   /*上月结存金额-其他   (e)                */
                                     /*上月結存金額-其他   (e)                */
ccu21       number(15,3) NOT NULL,   /*本月投入数量                           */
                                     /*本月投入數量                           */
ccu22       number(20,6) NOT NULL,   /*本月投入金额(a+b+c+d+e)                */
                                     /*本月投入金額(a+b+c+d+e)                */
ccu22a      number(20,6) NOT NULL,   /*本月投入金额-材料   (a)                */
                                     /*本月投入金額-材料   (a)                */
ccu22b      number(20,6) NOT NULL,   /*本月投入金额-人工   (b)                */
                                     /*本月投入金額-人工   (b)                */
ccu22c      number(20,6) NOT NULL,   /*本月投入金额-制费   (c)                */
                                     /*本月投入金額-製費   (c)                */
ccu22d      number(20,6) NOT NULL,   /*本月投入金额-加工   (d)                */
                                     /*本月投入金額-加工   (d)                */
ccu22e      number(20,6) NOT NULL,   /*本月投入金额-其他   (e)                */
                                     /*本月投入金額-其他   (e)                */
ccu31       number(15,3) NOT NULL,   /*本月转出数量 (=半成品入库)             */
                                     /*本月轉出數量 (=半成品入庫)             */
ccu32       number(20,6) NOT NULL,   /*本月转出金额(a+b+c+d+e)                */
                                     /*本月轉出金額(a+b+c+d+e)                */
ccu32a      number(20,6) NOT NULL,   /*本月转出金额-材料   (a)                */
                                     /*本月轉出金額-材料   (a)                */
ccu32b      number(20,6) NOT NULL,   /*本月转出金额-人工   (b)                */
                                     /*本月轉出金額-人工   (b)                */
ccu32c      number(20,6) NOT NULL,   /*本月转出金额-制费   (c)                */
                                     /*本月轉出金額-製費   (c)                */
ccu32d      number(20,6) NOT NULL,   /*本月转出金额-加工   (d)                */
                                     /*本月轉出金額-加工   (d)                */
ccu32e      number(20,6) NOT NULL,   /*本月转出金额-其他   (e)                */
                                     /*本月轉出金額-其他   (e)                */
ccu41       number(15,3) NOT NULL,   /*No Use                                 */
ccu42       number(20,6) NOT NULL,   /*差异拆出金额(a+b+c+d+e)                */
                                     /*差異拆出金額(a+b+c+d+e)                */
ccu42a      number(20,6) NOT NULL,   /*差异拆出金额-材料   (a)                */
                                     /*差異拆出金額-材料   (a)                */
ccu42b      number(20,6) NOT NULL,   /*差异拆出金额-人工   (b)                */
                                     /*差異拆出金額-人工   (b)                */
ccu42c      number(20,6) NOT NULL,   /*差异拆出金额-制费   (c)                */
                                     /*差異拆出金額-製費   (c)                */
ccu42d      number(20,6) NOT NULL,   /*差异拆出金额-加工   (d)                */
                                     /*差異拆出金額-加工   (d)                */
ccu42e      number(20,6) NOT NULL,   /*差异拆出金额-其他   (e)                */
                                     /*差異拆出金額-其他   (e)                */
ccu51       number(15,3) NOT NULL,   /*No Use                                 */
ccu52       number(15,3) NOT NULL,   /*No Use                                 */
ccu52a      number(15,3) NOT NULL,   /*No Use                                 */
ccu52b      number(15,3) NOT NULL,   /*No Use                                 */
ccu52c      number(15,3) NOT NULL,   /*No Use                                 */
ccu52d      number(15,3) NOT NULL,   /*No Use                                 */
ccu52e      number(15,3) NOT NULL,   /*No Use                                 */
ccu91       number(15,3) NOT NULL,   /*本月结存数量                           */
                                     /*本月結存數量                           */
ccu92       number(20,6) NOT NULL,   /*本月结存金额(a+b+c+d+e)                */
                                     /*本月結存金額(a+b+c+d+e)                */
ccu92a      number(20,6) NOT NULL,   /*本月结存金额-材料   (a)                */
                                     /*本月結存金額-材料   (a)                */
ccu92b      number(20,6) NOT NULL,   /*本月结存金额-人工   (b)                */
                                     /*本月結存金額-人工   (b)                */
ccu92c      number(20,6) NOT NULL,   /*本月结存金额-制费   (c)                */
                                     /*本月結存金額-製費   (c)                */
ccu92d      number(20,6) NOT NULL,   /*本月结存金额-加工   (d)                */
                                     /*本月結存金額-加工   (d)                */
ccu92e      number(20,6) NOT NULL,   /*本月结存金额-其他   (e)                */
                                     /*本月結存金額-其他   (e)                */
ccuuser     varchar2(10),            /*最近计算人员                           */
                                     /*最近計算人員                           */
ccudate     date,                    /*最近计算日期                           */
                                     /*最近計算日期                           */
ccutime     varchar2(5),             /*最近计算时间                           */
                                     /*最近計算時間                           */
ccu06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
ccu07       varchar2(40) DEFAULT ' ' NOT NULL, /*类型编号(批次号/项目号/利润 */
ccu12f      number(20,6) DEFAULT '0',/*上月结存金额-制费三                    */
ccu12g      number(20,6) DEFAULT '0',/*上月结存金额-制费四                    */
ccu12h      number(20,6) DEFAULT '0',/*上月结存金额-制费五                    */
ccu22f      number(20,6) DEFAULT '0',/*本月投入金额-制费三                    */
ccu22g      number(20,6) DEFAULT '0',/*本月投入金额-制费四                    */
ccu22h      number(20,6) DEFAULT '0',/*本月投入金额-制费五                    */
ccu32f      number(20,6) DEFAULT '0',/*本月转出金额-制费三                    */
ccu32g      number(20,6) DEFAULT '0',/*本月转出金额-制费四                    */
ccu32h      number(20,6) DEFAULT '0',/*本月转出金额-制费五                    */
ccu42f      number(20,6) DEFAULT '0',/*差异输出金额-制费三                    */
ccu42g      number(20,6) DEFAULT '0',/*差异输出金额-制费四                    */
ccu42h      number(20,6) DEFAULT '0',/*差异输出金额-制费五                    */
ccu92f      number(20,6) DEFAULT '0',/*本月结存金额-制费三                    */
ccu92g      number(20,6) DEFAULT '0',/*本月结存金额-制费四                    */
ccu92h      number(20,6) DEFAULT '0',/*本月结存金额-制费五                    */
ccuud01     varchar2(255),           /*自订字段-Textedit                      */
ccuud02     varchar2(40),            /*自订字段-文字                          */
ccuud03     varchar2(40),            /*自订字段-文字                          */
ccuud04     varchar2(40),            /*自订字段-文字                          */
ccuud05     varchar2(40),            /*自订字段-文字                          */
ccuud06     varchar2(40),            /*自订字段-文字                          */
ccuud07     number(15,3),            /*自订字段-数值                          */
ccuud08     number(15,3),            /*自订字段-数值                          */
ccuud09     number(15,3),            /*自订字段-数值                          */
ccuud10     number(10),              /*自订字段-整数                          */
ccuud11     number(10),              /*自订字段-整数                          */
ccuud12     number(10),              /*自订字段-整数                          */
ccuud13     date,                    /*自订字段-日期                          */
ccuud14     date,                    /*自订字段-日期                          */
ccuud15     date,                    /*自订字段-日期                          */
cculegal    varchar2(10) NOT NULL,   /*所属法人                               */
ccuorig     varchar2(10),            /*资料建立部门                           */
ccuoriu     varchar2(10)             /*资料建立者                             */
);

create        index ccu_02 on ccu_file (ccu04);
alter table ccu_file add  constraint ccu_pk primary key  (ccu01,ccu02,ccu03,ccu04,ccu06,ccu07) enable validate;
grant select on ccu_file to tiptopgp;
grant update on ccu_file to tiptopgp;
grant delete on ccu_file to tiptopgp;
grant insert on ccu_file to tiptopgp;
grant index on ccu_file to public;
grant select on ccu_file to ods;
