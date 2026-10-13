/*
================================================================================
檔案代號:obl_file
檔案名稱:产品客户包装档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obl_file
(
obl01       varchar2(40) NOT NULL,   /*产品编号                               */
                                     /*產品編號                               */
obl02       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
obl03       varchar2(15)             /*包装方式                               */
                                     /*包裝方式                               */
);

alter table obl_file add  constraint obl_pk primary key  (obl01,obl02) enable validate;
grant select on obl_file to tiptopgp;
grant update on obl_file to tiptopgp;
grant delete on obl_file to tiptopgp;
grant insert on obl_file to tiptopgp;
grant index on obl_file to public;
grant select on obl_file to ods;
