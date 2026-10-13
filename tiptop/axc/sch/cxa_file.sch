/*
================================================================================
檔案代號:cxa_file
檔案名稱:库存异动入项资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cxa_file
(
cxa01       varchar2(40) NOT NULL,   /*料件编号                               */
cxa02       number(5) NOT NULL,      /*年度                                   */
cxa03       number(5) NOT NULL,      /*期别                                   */
cxa04       date NOT NULL,           /*异动日期                               */
                                     /*單據日期                               */
cxa05       varchar2(8) NOT NULL,    /*异动时间                               */
                                     /*時:分:秒                               */
cxa06       varchar2(20) NOT NULL,   /*异动单号                               */
cxa07       number(5) NOT NULL,      /*项次                                   */
cxa08       number(15,3),            /*异动数量                               */
cxa09       number(20,6),            /*异动金额                               */
cxa091      number(20,6),            /*异动金额-材料                          */
cxa092      number(20,6),            /*异动金额-人工                          */
cxa093      number(20,6),            /*异动金额-制费                          */
cxa094      number(20,6),            /*异动金额-加工                          */
cxa095      number(20,6),            /*异动金额-其他                          */
cxa10       number(15,3),            /*已耗数量                               */
cxa11       number(20,6),            /*已耗金额                               */
cxa111      number(20,6),            /*已耗金额-材料                          */
cxa112      number(20,6),            /*已耗金额-人工                          */
cxa113      number(20,6),            /*已耗金额-制费                          */
cxa114      number(20,6),            /*已耗金额-加工                          */
cxa115      number(20,6),            /*已耗金额-其他                          */
cxa12       number(15,3),            /*No Use                                 */
cxa13       number(15,3),            /*No Use                                 */
cxa14       number(5),               /*No Use                                 */
cxa15       varchar2(1),             /*代买料件否                             */
cxa010      varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cxa011      varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cxa096      number(20,6) DEFAULT '0',/*异动金额-制费三                        */
cxa097      number(20,6) DEFAULT '0',/*异动金额-制费四                        */
cxa098      number(20,6) DEFAULT '0',/*异动金额-制费五                        */
cxa116      number(20,6) DEFAULT '0',/*已耗金额-制费三                        */
cxa117      number(20,6) DEFAULT '0',/*已耗金额-制费四                        */
cxa118      number(20,6) DEFAULT '0',/*已耗金额-制费五                        */
cxalegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index cxa_02 on cxa_file (cxa02,cxa03);
alter table cxa_file add  constraint cxa_pk primary key  (cxa01,cxa010,cxa011,cxa02,cxa03,cxa04,cxa05,cxa06,cxa07) enable validate;
grant select on cxa_file to tiptopgp;
grant update on cxa_file to tiptopgp;
grant delete on cxa_file to tiptopgp;
grant insert on cxa_file to tiptopgp;
grant index on cxa_file to public;
grant select on cxa_file to ods;
