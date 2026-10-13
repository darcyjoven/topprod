/*
================================================================================
檔案代號:ocm_file
檔案名稱:产品替代群组资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ocm_file
(
ocm01       varchar2(4) NOT NULL,    /*替代群组                               */
ocm02       varchar2(40) NOT NULL,   /*产品编号                               */
ocm03       date NOT NULL,           /*生效日期                               */
ocm04       date,                    /*失效日期                               */
ocm05       varchar2(10) NOT NULL,   /*客户编号                               */
ocm06       number(5)                /*替代顺序                               */
);

alter table ocm_file add  constraint ocm_pk primary key  (ocm01,ocm02,ocm03,ocm05) enable validate;
grant select on ocm_file to tiptopgp;
grant update on ocm_file to tiptopgp;
grant delete on ocm_file to tiptopgp;
grant insert on ocm_file to tiptopgp;
grant index on ocm_file to public;
grant select on ocm_file to ods;
