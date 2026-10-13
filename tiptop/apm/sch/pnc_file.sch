/*
================================================================================
檔案代號:pnc_file
檔案名稱:收货替代群组档
檔案目的:收货替代群组档 假双档
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pnc_file
(
pnc01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号，放单头*/
pnc02       varchar2(10) DEFAULT ' ' NOT NULL, /*供应商,*号代表不区分供应商, */
pnc03       varchar2(40) DEFAULT ' ' NOT NULL, /*可替代料号，放单身*/
pnc04       date DEFAULT sysdate NOT NULL, /*生效日期,放单身*/
pnc05       date                     /*失效日期，放单身                       */
);

alter table pnc_file add  constraint pnc_pk primary key  (pnc01,pnc02,pnc03,pnc04) enable validate;
grant select on pnc_file to tiptopgp;
grant update on pnc_file to tiptopgp;
grant delete on pnc_file to tiptopgp;
grant insert on pnc_file to tiptopgp;
grant index on pnc_file to public;
grant select on pnc_file to ods;
