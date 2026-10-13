/*
================================================================================
檔案代號:cce_file
檔案名稱:每月工单联产品转出成本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cce_file
(
cce01       varchar2(40) NOT NULL,   /*工单单号重覆性生产产品成本             */
                                     /*工單編號                               */
cce02       number(5) NOT NULL,      /*年度                                   */
cce03       number(5) NOT NULL,      /*月份                                   */
cce04       varchar2(40) NOT NULL,   /*连产品转出料号                         */
                                     /*連產品轉出料號                         */
cce05       varchar2(1) NOT NULL,    /*No Use                                 */
cce11       number(15,3) NOT NULL,   /*No Use                                 */
cce12       number(20,6) NOT NULL,   /*上月结存金额(a+b+c+d+e)                */
                                     /*上月結存金額(a+b+c+d+e)                */
cce12a      number(20,6) NOT NULL,   /*上月结存金额-材料   (a)                */
                                     /*上月結存金額-材料   (a)                */
cce12b      number(20,6) NOT NULL,   /*上月结存金额-人工   (b)                */
                                     /*上月結存金額-人工   (b)                */
cce12c      number(20,6) NOT NULL,   /*上月结存金额-制费   (c)                */
                                     /*上月結存金額-製費   (c)                */
cce12d      number(20,6) NOT NULL,   /*上月结存金额-加工   (d)                */
                                     /*上月結存金額-加工   (d)                */
cce12e      number(20,6) NOT NULL,   /*上月结存金额-其他   (e)                */
                                     /*上月結存金額-其他   (e)                */
cce20       number(15,3) NOT NULL,   /*No Use                                 */
cce21       number(15,3) NOT NULL,   /*本月转出数量                           */
                                     /*本月轉出數量                           */
cce22       number(20,6) NOT NULL,   /*本月本阶转出金额(a+b+c+d+e)            */
                                     /*本月本階轉出金額(a+b+c+d+e)            */
cce22a      number(20,6) NOT NULL,   /*本月本阶转出金额-材料   (a)            */
                                     /*本月本階轉出金額-材料   (a)            */
cce22b      number(20,6) NOT NULL,   /*本月本阶转出金额-人工   (b)            */
                                     /*本月本階轉出金額-人工   (b)            */
cce22c      number(20,6) NOT NULL,   /*本月本阶转出金额-制费   (c)            */
                                     /*本月本階轉出金額-製費   (c)            */
cce22d      number(20,6) NOT NULL,   /*本月本阶转出金额-加工   (d)            */
                                     /*本月本階轉出金額-加工   (d)            */
cce22e      number(20,6) NOT NULL,   /*本月本阶转出金额-其他   (e)            */
                                     /*本月本階轉出金額-其他   (e)            */
cce91       number(15,3) NOT NULL,   /*本月累计结存数量                       */
                                     /*本月累計結存數量                       */
cce92       number(20,6) NOT NULL,   /*本月累计结存金额(a+b+c+d+e)            */
                                     /*本月累計結存金額(a+b+c+d+e)            */
cce92a      number(20,6) NOT NULL,   /*本月累计结存金额-材料   (a)            */
                                     /*本月累計結存金額-材料   (a)            */
cce92b      number(20,6) NOT NULL,   /*本月累计结存金额-人工   (b)            */
                                     /*本月累計結存金額-人工   (b)            */
cce92c      number(20,6) NOT NULL,   /*本月累计结存金额-制费   (c)            */
                                     /*本月累計結存金額-製費   (c)            */
cce92d      number(20,6) NOT NULL,   /*本月累计结存金额-加工   (d)            */
                                     /*本月累計結存金額-加工   (d)            */
cce92e      number(20,6) NOT NULL,   /*本月累计结存金额-其他   (e)            */
                                     /*本月累計結存金額-其他   (e)            */
cceuser     varchar2(10),            /*最近计算人员                           */
ccedate     date,                    /*最近计算日期                           */
ccetime     varchar2(8),             /*最近计算时间                           */
cce06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cce07       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cce12f      number(20,6) DEFAULT '0',/*上月结存金额-制费三                    */
cce12g      number(20,6) DEFAULT '0',/*上月结存金额-制费四                    */
cce12h      number(20,6) DEFAULT '0',/*上月结存金额-制费五                    */
cce22f      number(20,6) DEFAULT '0',/*本月本阶转出金额-制费三                */
cce22g      number(20,6) DEFAULT '0',/*本月本阶转出金额-制费四                */
cce22h      number(20,6) DEFAULT '0',/*本月本阶转出金额-制费五                */
cce92f      number(20,6) DEFAULT '0',/*本月累计结存金额-制费三                */
cce92g      number(20,6) DEFAULT '0',/*本月累计结存金额-制费四                */
cce92h      number(20,6) DEFAULT '0',/*本月累计结存金额-制费五                */
ccelegal    varchar2(10) NOT NULL,   /*所属法人                               */
cceorig     varchar2(10),            /*资料建立部门                           */
cceoriu     varchar2(10)             /*资料建立者                             */
);

create        index cce_02 on cce_file (cce04);
alter table cce_file add  constraint cce_pk primary key  (cce01,cce02,cce03,cce04,cce06,cce07) enable validate;
grant select on cce_file to tiptopgp;
grant update on cce_file to tiptopgp;
grant delete on cce_file to tiptopgp;
grant insert on cce_file to tiptopgp;
grant index on cce_file to public;
grant select on cce_file to ods;
