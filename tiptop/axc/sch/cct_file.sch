/*
================================================================================
檔案代號:cct_file
檔案名稱:每月拆件式工单主件在制成本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cct_file
(
cct01       varchar2(20) NOT NULL,   /*拆件式工单编号                         */
                                     /*拆件式工單編號                         */
cct02       number(5) NOT NULL,      /*年度                                   */
cct03       number(5) NOT NULL,      /*月份                                   */
cct04       varchar2(40) NOT NULL,   /*主件料号                               */
                                     /*主件料號                               */
cct11       number(15,3) NOT NULL,   /*No Use                                 */
cct12       number(20,6) NOT NULL,   /*上月结存金额(a+b+c+d+e)                */
                                     /*上月結存金額(a+b+c+d+e)                */
cct12a      number(20,6) NOT NULL,   /*上月结存金额-材料   (a)                */
                                     /*上月結存金額-材料   (a)                */
cct12b      number(20,6) NOT NULL,   /*上月结存金额-人工   (b)                */
                                     /*上月結存金額-人工   (b)                */
cct12c      number(20,6) NOT NULL,   /*上月结存金额-制费   (c)                */
                                     /*上月結存金額-製費   (c)                */
cct12d      number(20,6) NOT NULL,   /*上月结存金额-加工   (d)                */
                                     /*上月結存金額-加工   (d)                */
cct12e      number(20,6) NOT NULL,   /*上月结存金额-其他   (e)                */
                                     /*上月結存金額-其他   (e)                */
cct20       number(15,3) NOT NULL,   /*本月投入工时                           */
                                     /*本月投入工時                           */
cct21       number(15,3) NOT NULL,   /*No Use                                 */
cct22       number(20,6) NOT NULL,   /*本月本階投入金額(a+b+c+d+e)            */
cct22a      number(20,6) NOT NULL,   /*本月本阶投入金额-材料   (a)            */
                                     /*本月本階投入金額-材料   (a)            */
cct22b      number(20,6) NOT NULL,   /*本月本阶投入金额-人工   (b)            */
                                     /*本月本階投入金額-人工   (b)            */
cct22c      number(20,6) NOT NULL,   /*本月本阶投入金额-制费   (c)            */
                                     /*本月本階投入金額-製費   (c)            */
cct22d      number(20,6) NOT NULL,   /*本月本阶投入金额-加工   (d)            */
                                     /*本月本階投入金額-加工   (d)            */
cct22e      number(20,6) NOT NULL,   /*本月本阶投入金额-其他   (e)            */
                                     /*本月本階投入金額-其他   (e)            */
cct23       number(20,6) NOT NULL,   /*本月下阶投入金额(a+b+c+d+e)            */
                                     /*本月下階投入金額(a+b+c+d+e)            */
cct23a      number(20,6) NOT NULL,   /*本月下阶投入金额-材料   (a)            */
                                     /*本月下階投入金額-材料   (a)            */
cct23b      number(20,6) NOT NULL,   /*本月下阶投入金额-人工   (b)            */
                                     /*本月下階投入金額-人工   (b)            */
cct23c      number(20,6) NOT NULL,   /*本月下阶投入金额-制费   (c)            */
                                     /*本月下階投入金額-製費   (c)            */
cct23d      number(20,6) NOT NULL,   /*本月下阶投入金额-加工   (d)            */
                                     /*本月下階投入金額-加工   (d)            */
cct23e      number(20,6) NOT NULL,   /*本月下阶投入金额-其他   (e)            */
                                     /*本月下階投入金額-其他   (e)            */
cct31       number(15,3) NOT NULL,   /*No Use                                 */
cct32       number(20,6) NOT NULL,   /*本月转出金额(a+b+c+d+e)                */
                                     /*本月轉出金額(a+b+c+d+e)                */
cct32a      number(20,6) NOT NULL,   /*本月转出金额-材料   (a)                */
                                     /*本月轉出金額-材料   (a)                */
cct32b      number(20,6) NOT NULL,   /*本月转出金额-人工   (b)                */
                                     /*本月轉出金額-人工   (b)                */
cct32c      number(20,6) NOT NULL,   /*本月转出金额-制费   (c)                */
                                     /*本月轉出金額-製費   (c)                */
cct32d      number(20,6) NOT NULL,   /*本月转出金额-加工   (d)                */
                                     /*本月轉出金額-加工   (d)                */
cct32e      number(20,6) NOT NULL,   /*本月转出金额-其他   (e)                */
                                     /*本月轉出金額-其他   (e)                */
cct41       number(15,3) NOT NULL,   /*No Use                                 */
cct42       number(20,6) NOT NULL,   /*差异转出金额                           */
                                     /*差異轉出金額(結案後期未-(期初+投入-轉出)*/
cct42a      number(20,6) NOT NULL,   /*差异转出金额-材料   (a)                */
                                     /*差異轉出金額-材料   (a)                */
cct42b      number(20,6) NOT NULL,   /*差异转出金额-人工   (b)                */
                                     /*差異轉出金額-人工   (b)                */
cct42c      number(20,6) NOT NULL,   /*差异转出金额-制费   (c)                */
                                     /*差異轉出金額-製費   (c)                */
cct42d      number(20,6) NOT NULL,   /*差异转出金额-加工   (d)                */
                                     /*差異轉出金額-加工   (d)                */
cct42e      number(20,6) NOT NULL,   /*差异转出金额-其他   (e)                */
                                     /*差異轉出金額-其他   (e)                */
cct52       number(15,3) NOT NULL,   /*No Use                                 */
cct52a      number(15,3) NOT NULL,   /*No Use                                 */
cct52b      number(15,3) NOT NULL,   /*No Use                                 */
cct52c      number(15,3) NOT NULL,   /*No Use                                 */
cct52d      number(15,3) NOT NULL,   /*No Use                                 */
cct52e      number(15,3) NOT NULL,   /*No Use                                 */
cct53       number(15,3) NOT NULL,   /*No Use                                 */
cct53a      number(15,3) NOT NULL,   /*No Use                                 */
cct53b      number(15,3) NOT NULL,   /*No Use                                 */
cct53c      number(15,3) NOT NULL,   /*No Use                                 */
cct53d      number(15,3) NOT NULL,   /*No Use                                 */
cct53e      number(15,3) NOT NULL,   /*No Use                                 */
cct91       number(15,3) NOT NULL,   /*No Use                                 */
cct92       number(20,6) NOT NULL,   /*本月结存金额(a+b+c+d+e)                */
                                     /*本月結存金額(a+b+c+d+e)                */
cct92a      number(20,6) NOT NULL,   /*本月结存金额-材料   (a)                */
                                     /*本月結存金額-材料   (a)                */
cct92b      number(20,6) NOT NULL,   /*本月结存金额-人工   (b)                */
                                     /*本月結存金額-人工   (b)                */
cct92c      number(20,6) NOT NULL,   /*本月结存金额-制费   (c)                */
                                     /*本月結存金額-製費   (c)                */
cct92d      number(20,6) NOT NULL,   /*本月结存金额-加工   (d)                */
                                     /*本月結存金額-加工   (d)                */
cct92e      number(20,6) NOT NULL,   /*本月结存金额-其他   (e)                */
                                     /*本月結存金額-其他   (e)                */
cctuser     varchar2(10),            /*最近计算人员                           */
                                     /*最近計算人員                           */
cctdate     date,                    /*最近计算日期                           */
                                     /*最近計算日期                           */
ccttime     varchar2(5),             /*最近计算时间                           */
                                     /*最近計算時間                           */
cct06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cct07       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cct12f      number(20,6) DEFAULT '0',/*上月结存金额-制费三                    */
cct12g      number(20,6) DEFAULT '0',/*上月结存金额-制费四                    */
cct12h      number(20,6) DEFAULT '0',/*上月结存金额-制费五                    */
cct22f      number(20,6) DEFAULT '0',/*本月本阶投入金额-制费三                */
cct22g      number(20,6) DEFAULT '0',/*本月本阶投入金额-制费四                */
cct22h      number(20,6) DEFAULT '0',/*本月本阶投入金额-制费五                */
cct23f      number(20,6) DEFAULT '0',/*本月下阶投入金额-制费三                */
cct23g      number(20,6) DEFAULT '0',/*本月下阶投入金额-制费四                */
cct23h      number(20,6) DEFAULT '0',/*本月下阶投入金额-制费五                */
cct32f      number(20,6) DEFAULT '0',/*本月转出金额-制费三                    */
cct32g      number(20,6) DEFAULT '0',/*本月转出金额-制费四                    */
cct32h      number(20,6) DEFAULT '0',/*本月转出金额-制费五                    */
cct42f      number(20,6) DEFAULT '0',/*差异转出金额-制费三                    */
cct42g      number(20,6) DEFAULT '0',/*差异转出金额-制费四                    */
cct42h      number(20,6) DEFAULT '0',/*差异转出金额-制费五                    */
cct92f      number(20,6) DEFAULT '0',/*本月结存金额-制费三                    */
cct92g      number(20,6) DEFAULT '0',/*本月结存金额-制费四                    */
cct92h      number(20,6) DEFAULT '0',/*本月结存金额-制费五                    */
cctud01     varchar2(255),           /*自订字段-Textedit                      */
cctud02     varchar2(40),            /*自订字段-文字                          */
cctud03     varchar2(40),            /*自订字段-文字                          */
cctud04     varchar2(40),            /*自订字段-文字                          */
cctud05     varchar2(40),            /*自订字段-文字                          */
cctud06     varchar2(40),            /*自订字段-文字                          */
cctud07     number(15,3),            /*自订字段-数值                          */
cctud08     number(15,3),            /*自订字段-数值                          */
cctud09     number(15,3),            /*自订字段-数值                          */
cctud10     number(10),              /*自订字段-整数                          */
cctud11     number(10),              /*自订字段-整数                          */
cctud12     number(10),              /*自订字段-整数                          */
cctud13     date,                    /*自订字段-日期                          */
cctud14     date,                    /*自订字段-日期                          */
cctud15     date,                    /*自订字段-日期                          */
cctlegal    varchar2(10) NOT NULL,   /*所属法人                               */
cctorig     varchar2(10),            /*资料建立部门                           */
cctoriu     varchar2(10)             /*资料建立者                             */
);

create        index cct_02 on cct_file (cct04);
alter table cct_file add  constraint cct_pk primary key  (cct01,cct02,cct03,cct06,cct07) enable validate;
grant select on cct_file to tiptopgp;
grant update on cct_file to tiptopgp;
grant delete on cct_file to tiptopgp;
grant insert on cct_file to tiptopgp;
grant index on cct_file to public;
grant select on cct_file to ods;
