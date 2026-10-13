/*
================================================================================
檔案代號:cxb_file
檔案名稱:成本月结档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cxb_file
(
cxb01       varchar2(40) NOT NULL,   /*料件编号                               */
cxb02       number(5) NOT NULL,      /*年度                                   */
cxb03       number(5) NOT NULL,      /*期别                                   */
cxb04       date NOT NULL,           /*异动日期                               */
                                     /*單據日期                               */
cxb05       varchar2(8) NOT NULL,    /*异动时间                               */
                                     /*時:分:秒                               */
cxb06       varchar2(20) NOT NULL,   /*异动单号                               */
cxb07       number(5) NOT NULL,      /*项次                                   */
cxb08       number(15,3),            /*期末数量                               */
cxb09       number(20,6),            /*期末金额                               */
cxb091      number(20,6),            /*期末金额-材料                          */
cxb092      number(20,6),            /*期末金额-人工                          */
cxb093      number(20,6),            /*期末金额-制费                          */
cxb094      number(20,6),            /*期末金额-加工                          */
cxb095      number(20,6),            /*期末金额-其他                          */
cxb10       number(15,3),            /*No Use                                 */
cxb11       number(15,3),            /*No Use                                 */
cxb12       varchar2(1),             /*No Use                                 */
cxb010      varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cxb011      varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cxb096      number(20,6) DEFAULT '0',/*期末金额-制费三                        */
cxb097      number(20,6) DEFAULT '0',/*期末金额-制费四                        */
cxb098      number(20,6) DEFAULT '0',/*期末金额-制费五                        */
cxblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index cxb_02 on cxb_file (cxb02,cxb03);
alter table cxb_file add  constraint cxb_pk primary key  (cxb01,cxb010,cxb011,cxb02,cxb03,cxb04,cxb05,cxb06,cxb07) enable validate;
grant select on cxb_file to tiptopgp;
grant update on cxb_file to tiptopgp;
grant delete on cxb_file to tiptopgp;
grant insert on cxb_file to tiptopgp;
grant index on cxb_file to public;
grant select on cxb_file to ods;
