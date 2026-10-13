/*
================================================================================
檔案代號:ccg_file
檔案名稱:每月工单主件在制成本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ccg_file
(
ccg01       varchar2(40) NOT NULL,   /*工单单号重覆性生产产品成本             */
                                     /*工單編號                               */
ccg02       number(5) NOT NULL,      /*年度                                   */
ccg03       number(5) NOT NULL,      /*月份                                   */
ccg04       varchar2(40) NOT NULL,   /*主件料号                               */
                                     /*主件料號                               */
ccg11       number(15,3) NOT NULL,   /*上月结存数量                           */
                                     /*上月結存數量                           */
ccg12       number(20,6) NOT NULL,   /*上月结存金额(a+b+c+d+e)                */
                                     /*上月結存金額(a+b+c+d+e)                */
ccg12a      number(20,6) NOT NULL,   /*上月结存金额-材料   (a)                */
                                     /*上月結存金額-材料   (a)                */
ccg12b      number(20,6) NOT NULL,   /*上月结存金额-人工   (b)                */
                                     /*上月結存金額-人工   (b)                */
ccg12c      number(20,6) NOT NULL,   /*上月结存金额-制费   (c)                */
                                     /*上月結存金額-製費   (c)                */
ccg12d      number(20,6) NOT NULL,   /*上月结存金额-加工   (d)                */
                                     /*上月結存金額-加工   (d)                */
ccg12e      number(20,6) NOT NULL,   /*上月结存金额-其他   (e)                */
                                     /*上月結存金額-其他   (e)                */
ccg20       number(15,3) NOT NULL,   /*本月投入工时                           */
                                     /*本月投入工時                           */
ccg21       number(15,3) NOT NULL,   /*本月投入数量                           */
                                     /*本月投入數量                           */
ccg22       number(20,6) NOT NULL,   /*本月本階投入金額(a+b+c+d+e)            */
ccg22a      number(20,6) NOT NULL,   /*本月本阶投入金额-材料   (a)            */
                                     /*本月本階投入金額-材料   (a)            */
ccg22b      number(20,6) NOT NULL,   /*本月本阶投入金额-人工   (b)            */
                                     /*本月本階投入金額-人工   (b)            */
ccg22c      number(20,6) NOT NULL,   /*本月本阶投入金额-制费   (c)            */
                                     /*本月本階投入金額-製費   (c)            */
ccg22d      number(20,6) NOT NULL,   /*本月本阶投入金额-加工   (d)            */
                                     /*本月本階投入金額-加工   (d)            */
ccg22e      number(20,6) NOT NULL,   /*本月本阶投入金额-其他   (e)            */
                                     /*本月本階投入金額-其他   (e)            */
ccg23       number(20,6) NOT NULL,   /*本月下阶投入金额(a+b+c+d+e)            */
                                     /*本月下階投入金額(a+b+c+d+e)            */
ccg23a      number(20,6) NOT NULL,   /*本月下阶投入金额-材料   (a)            */
                                     /*本月下階投入金額-材料   (a)            */
ccg23b      number(20,6) NOT NULL,   /*本月下阶投入金额-人工   (b)            */
                                     /*本月下階投入金額-人工   (b)            */
ccg23c      number(20,6) NOT NULL,   /*本月下阶投入金额-制费   (c)            */
                                     /*本月下階投入金額-製費   (c)            */
ccg23d      number(20,6) NOT NULL,   /*本月下阶投入金额-加工   (d)            */
                                     /*本月下階投入金額-加工   (d)            */
ccg23e      number(20,6) NOT NULL,   /*本月下阶投入金额-其他   (e)            */
                                     /*本月下階投入金額-其他   (e)            */
ccg31       number(15,3) NOT NULL,   /*本月转出数量                           */
                                     /*本月轉出數量                           */
ccg32       number(20,6) NOT NULL,   /*本月转出金额(a+b+c+d+e)                */
                                     /*本月轉出金額(a+b+c+d+e)                */
ccg32a      number(20,6) NOT NULL,   /*本月转出金额-材料   (a)                */
                                     /*本月轉出金額-材料   (a)                */
ccg32b      number(20,6) NOT NULL,   /*本月转出金额-人工   (b)                */
                                     /*本月轉出金額-人工   (b)                */
ccg32c      number(20,6) NOT NULL,   /*本月转出金额-制费   (c)                */
                                     /*本月轉出金額-製費   (c)                */
ccg32d      number(20,6) NOT NULL,   /*本月转出金额-加工   (d)                */
                                     /*本月轉出金額-加工   (d)                */
ccg32e      number(20,6) NOT NULL,   /*本月转出金额-其他   (e)                */
                                     /*本月轉出金額-其他   (e)                */
ccg41       number(15,3),            /*差异转出数量                           */
                                     /*差異轉出數量                           */
ccg42       number(20,6) NOT NULL,   /*差异转出金额                           */
                                     /*差異轉出金額 (標準成本制下的標準差異)  */
ccg42a      number(20,6) NOT NULL,   /*差异转出金额-材料   (a)                */
                                     /*差異轉出金額-材料   (a)                */
ccg42b      number(20,6) NOT NULL,   /*差异转出金额-人工   (b)                */
                                     /*差異轉出金額-人工   (b)                */
ccg42c      number(20,6) NOT NULL,   /*差异转出金额-制费   (c)                */
                                     /*差異轉出金額-製費   (c)                */
ccg42d      number(20,6) NOT NULL,   /*差异转出金额-加工   (d)                */
                                     /*差異轉出金額-加工   (d)                */
ccg42e      number(20,6) NOT NULL,   /*差异转出金额-其他   (e)                */
                                     /*差異轉出金額-其他   (e)                */
ccg91       number(15,3) NOT NULL,   /*本月结存数量                           */
                                     /*本月結存數量                           */
ccg92       number(20,6) NOT NULL,   /*本月结存金额(a+b+c+d+e)                */
                                     /*本月結存金額(a+b+c+d+e)                */
ccg92a      number(20,6) NOT NULL,   /*本月结存金额-材料   (a)                */
                                     /*本月結存金額-材料   (a)                */
ccg92b      number(20,6) NOT NULL,   /*本月结存金额-人工   (b)                */
                                     /*本月結存金額-人工   (b)                */
ccg92c      number(20,6) NOT NULL,   /*本月结存金额-制费   (c)                */
                                     /*本月結存金額-製費   (c)                */
ccg92d      number(20,6) NOT NULL,   /*本月结存金额-加工   (d)                */
                                     /*本月結存金額-加工   (d)                */
ccg92e      number(20,6) NOT NULL,   /*本月结存金额-其他   (e)                */
                                     /*本月結存金額-其他   (e)                */
ccguser     varchar2(10),            /*最近计算人员                           */
                                     /*最近計算人員                           */
ccgdate     date,                    /*最近计算日期                           */
                                     /*最近計算日期                           */
ccgtime     varchar2(5),             /*最近计算时间                           */
                                     /*最近計算時間                           */
ccg06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
ccg07       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
ccg12f      number(20,6) DEFAULT '0',/*上月结存金额-制费三                    */
ccg12g      number(20,6) DEFAULT '0',/*上月结存金额-制费四                    */
ccg12h      number(20,6) DEFAULT '0',/*上月结存金额-制费五                    */
ccg22f      number(20,6) DEFAULT '0',/*本月本阶投入金额-制费三                */
ccg22g      number(20,6) DEFAULT '0',/*本月本阶投入金额-制费四                */
ccg22h      number(20,6) DEFAULT '0',/*本月本阶投入金额-制费五                */
ccg23f      number(20,6) DEFAULT '0',/*本月下阶投入金额-制费三                */
ccg23g      number(20,6) DEFAULT '0',/*本月下阶投入金额-制费四                */
ccg23h      number(20,6) DEFAULT '0',/*本月下阶投入金额-制费五                */
ccg32f      number(20,6) DEFAULT '0',/*本月转出金额-制费三                    */
ccg32g      number(20,6) DEFAULT '0',/*本月转出金额-制费四                    */
ccg32h      number(20,6) DEFAULT '0',/*本月转出金额-制费五                    */
ccg42f      number(20,6) DEFAULT '0',/*差异输出金额-制费三                    */
ccg42g      number(20,6) DEFAULT '0',/*差异输出金额-制费四                    */
ccg42h      number(20,6) DEFAULT '0',/*差异输出金额-制费五                    */
ccg92f      number(20,6) DEFAULT '0',/*本月结存金额-制费三                    */
ccg92g      number(20,6) DEFAULT '0',/*本月结存金额-制费四                    */
ccg92h      number(20,6) DEFAULT '0',/*本月结存金额-制费五                    */
ccgud01     varchar2(255),           /*自订字段-Textedit                      */
ccgud02     varchar2(40),            /*自订字段-文字                          */
ccgud03     varchar2(40),            /*自订字段-文字                          */
ccgud04     varchar2(40),            /*自订字段-文字                          */
ccgud05     varchar2(40),            /*自订字段-文字                          */
ccgud06     varchar2(40),            /*自订字段-文字                          */
ccgud07     number(15,3),            /*自订字段-数值                          */
ccgud08     number(15,3),            /*自订字段-数值                          */
ccgud09     number(15,3),            /*自订字段-数值                          */
ccgud10     number(10),              /*自订字段-整数                          */
ccgud11     number(10),              /*自订字段-整数                          */
ccgud12     number(10),              /*自订字段-整数                          */
ccgud13     date,                    /*自订字段-日期                          */
ccgud14     date,                    /*自订字段-日期                          */
ccgud15     date,                    /*自订字段-日期                          */
ccglegal    varchar2(10) NOT NULL,   /*所属法人                               */
ccgorig     varchar2(10),            /*资料建立部门                           */
ccgoriu     varchar2(10),            /*资料建立者                             */
ccg311      number(15,3) DEFAULT '0' NOT NULL /*报废量*/
);

create        index ccg_02 on ccg_file (ccg04);
alter table ccg_file add  constraint ccg_pk primary key  (ccg01,ccg02,ccg03,ccg06,ccg07) enable validate;
grant select on ccg_file to tiptopgp;
grant update on ccg_file to tiptopgp;
grant delete on ccg_file to tiptopgp;
grant insert on ccg_file to tiptopgp;
grant index on ccg_file to public;
grant select on ccg_file to ods;
