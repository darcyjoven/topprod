/*
================================================================================
檔案代號:ooe_file
檔案名稱:款别对应银行编号
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ooe_file
(
ooe01       varchar2(10) DEFAULT ' ' NOT NULL, /*款别编号*/
                                     /*Money No.                              */
                                     /*1:Cash 2:UnionPay Card 3:Check 4:Certificate */
                                     /*5:Certificate 6:Stored-value Card 7:Chong Advance 8:Handwork Virement*/
                                     /*9.Point Instead Of Cash                */
ooe02       varchar2(20)             /*银行编号                               */
);

alter table ooe_file add  constraint ooe_pk primary key  (ooe01) enable validate;
grant select on ooe_file to tiptopgp;
grant update on ooe_file to tiptopgp;
grant delete on ooe_file to tiptopgp;
grant insert on ooe_file to tiptopgp;
grant index on ooe_file to public;
grant select on ooe_file to ods;
