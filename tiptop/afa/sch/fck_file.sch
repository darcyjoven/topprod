/*
================================================================================
檔案代號:fck_file
檔案名稱:固定资产投资抵减享用年度档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fck_file
(
fck01       varchar2(20) NOT NULL,   /*申请编号                               */
fck02       number(5) NOT NULL,      /*项次                                   */
fck04       number(20,6),            /*抵减金额                               */
fck05       number(5) NOT NULL,      /*享用年度                               */
fckconf     varchar2(1),             /*确认码                                 */
fcklegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fck_file add  constraint fck_pk primary key  (fck01,fck02,fck05) enable validate;
grant select on fck_file to tiptopgp;
grant update on fck_file to tiptopgp;
grant delete on fck_file to tiptopgp;
grant insert on fck_file to tiptopgp;
grant index on fck_file to public;
grant select on fck_file to ods;
