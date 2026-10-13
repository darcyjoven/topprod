/*
================================================================================
檔案代號:lub_file
檔案名稱:费用单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lub_file
(
lub01       varchar2(20) DEFAULT ' ' NOT NULL, /*费用单单号*/
lub02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lub03       varchar2(10),            /*费用编号                               */
lub04       number(20,6) DEFAULT '0',/*税前金额                               */
lub04t      number(20,6) DEFAULT '0',/*含税金额                               */
lub05       varchar2(60),            /*备注                                   */
lub06       varchar2(10),            /*no use 原门店编号                      */
lub07       date,                    /*开始日期                               */
lub08       date,                    /*结束日期                               */
lublegal    varchar2(10) NOT NULL,   /*所属法人                               */
lubplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lub09       varchar2(2),             /*费用类型                               */
lub10       date,                    /*立帐日期                               */
lub11       number(20,6),            /*已收金额                               */
lub12       number(20,6),            /*清算金额                               */
lub13       varchar2(1) DEFAULT ' ' NOT NULL, /*结案否*/
lub14       varchar2(20),            /*财务单号                               */
lub15       varchar2(20),            /*财务待抵单号                           */
lub16       number(5)                /*合同版本号                             */
);

alter table lub_file add  constraint lub_pk primary key  (lub01,lub02) enable validate;
grant select on lub_file to tiptopgp;
grant update on lub_file to tiptopgp;
grant delete on lub_file to tiptopgp;
grant insert on lub_file to tiptopgp;
grant index on lub_file to public;
grant select on lub_file to ods;
