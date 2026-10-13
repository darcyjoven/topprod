/*
================================================================================
檔案代號:lun_file
檔案名稱:待抵变更单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lun_file
(
lun01       varchar2(20) DEFAULT ' ' NOT NULL, /*待抵变更单号*/
lun02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lun03       varchar2(20),            /*待抵单号                               */
lun04       number(5),               /*待抵项次                               */
lun05       varchar2(10),            /*费用编号                               */
lun06       number(20,6),            /*待抵金额                               */
lun07       number(20,6),            /*已冲金额                               */
lun08       number(20,6),            /*已退金额                               */
lunlegal    varchar2(10) NOT NULL,   /*法人                                   */
lunplant    varchar2(10) NOT NULL    /*门店编号                               */
);

alter table lun_file add  constraint lun_pk primary key  (lun01,lun02) enable validate;
grant select on lun_file to tiptopgp;
grant update on lun_file to tiptopgp;
grant delete on lun_file to tiptopgp;
grant insert on lun_file to tiptopgp;
grant index on lun_file to public;
grant select on lun_file to ods;
