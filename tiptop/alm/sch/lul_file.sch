/*
================================================================================
檔案代號:lul_file
檔案名稱:待抵单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lul_file
(
lul01       varchar2(20) DEFAULT ' ' NOT NULL, /*待抵单号*/
lul02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lul03       varchar2(20),            /*来源单号                               */
lul04       number(5),               /*来源项次                               */
lul05       varchar2(10),            /*费用编号                               */
lul06       number(20,6),            /*待抵金额                               */
lul07       number(20,6),            /*已冲金额                               */
lul08       number(20,6),            /*已退金额                               */
lul09       varchar2(20),            /*费用单号                               */
lul10       number(5),               /*费用单项次                             */
lullegal    varchar2(10) NOT NULL,   /*法人                                   */
lulplant    varchar2(10) NOT NULL    /*门店编号                               */
);

alter table lul_file add  constraint lul_pk primary key  (lul01,lul02) enable validate;
grant select on lul_file to tiptopgp;
grant update on lul_file to tiptopgp;
grant delete on lul_file to tiptopgp;
grant insert on lul_file to tiptopgp;
grant index on lul_file to public;
grant select on lul_file to ods;
