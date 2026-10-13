/*
================================================================================
檔案代號:lur_file
檔案名稱:终止结算应收明细单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lur_file
(
lur01       varchar2(20) DEFAULT ' ' NOT NULL, /*结算单号*/
lur02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lur03       varchar2(20),            /*费用单号                               */
lur04       number(5),               /*费用单项次                             */
lur05       varchar2(10),            /*费用编号                               */
lur06       varchar2(2),             /*费用类型                               */
lur07       number(20,6),            /*应收金额                               */
lur08       number(20,6),            /*已收金额                               */
lurlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lurplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lur_file add  constraint lur_pk primary key  (lur01,lur02) enable validate;
grant select on lur_file to tiptopgp;
grant update on lur_file to tiptopgp;
grant delete on lur_file to tiptopgp;
grant insert on lur_file to tiptopgp;
grant index on lur_file to public;
grant select on lur_file to ods;
