/*
================================================================================
檔案代號:cfa_file
檔案名稱:移动加权平均成本异动文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cfa_file
(
cfa01       varchar2(40),            /*料号                                   */
cfa02       number(5),               /*序号                                   */
cfa03       varchar2(20),            /*异动指令编号                           */
cfa04       number(5),               /*出入库码                               */
cfa05       varchar2(20) DEFAULT ' ' NOT NULL, /*参考单号*/
cfa06       number(5) DEFAULT '0' NOT NULL, /*参考项次*/
cfa07       number(15,3) DEFAULT '0' NOT NULL, /*异动数量*/
cfa08       number(20,6) DEFAULT '0' NOT NULL, /*异动单价*/
cfa09       number(20,6) DEFAULT '0' NOT NULL, /*异动金额*/
cfa10       number(15,3) DEFAULT '0' NOT NULL, /*结存库存数量*/
cfa11       number(20,6) DEFAULT '0' NOT NULL, /*结存库存金额*/
cfa12       number(20,6),            /*移动加权平均成本                       */
cfa13       number(20,6) DEFAULT '0' NOT NULL, /*结存调整金额*/
cfa14       varchar2(10),            /*仓库                                   */
cfa15       varchar2(10),            /*库位                                   */
cfa16       varchar2(24),            /*批号                                   */
cfa17       varchar2(4),             /*单位                                   */
cfa18       date DEFAULT sysdate NOT NULL, /*异动日期*/
cfalegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
cfaud01     varchar2(255),           /*自订栏位-textedit                      */
cfaud02     varchar2(40),            /*自订字段-文字                          */
cfaud03     varchar2(40),            /*自订字段-文字                          */
cfaud04     varchar2(40),            /*自订字段-文字                          */
cfaud05     varchar2(40),            /*自订字段-文字                          */
cfaud06     varchar2(40),            /*自订字段-文字                          */
cfaud07     number(15,3),            /*自订字段-数值                          */
cfaud08     number(15,3),            /*自订字段-数值                          */
cfaud09     number(15,3),            /*自订字段-数值                          */
cfaud10     number(10),              /*自订字段-整数                          */
cfaud11     number(10),              /*自订字段-整数                          */
cfaud12     number(10),              /*自订字段-整数                          */
cfaud13     date,                    /*自订字段-日期                          */
cfaud14     date,                    /*自订字段-日期                          */
cfaud15     date,                    /*自订字段-日期                          */
cfa00       varchar2(20) DEFAULT ' ' NOT NULL
);

create        index cfa_00 on cfa_file (cfa00);
create        index cfa_01 on cfa_file (cfa01);
alter table cfa_file add  constraint cfa_pk primary key  (cfa00) enable validate;
grant select on cfa_file to tiptopgp;
grant update on cfa_file to tiptopgp;
grant delete on cfa_file to tiptopgp;
grant insert on cfa_file to tiptopgp;
grant index on cfa_file to public;
grant select on cfa_file to ods;
