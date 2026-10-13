/*
================================================================================
檔案代號:vio_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vio_file
(
vio01       varchar2(10) NOT NULL,   /*VIP种类编号                            */
vio02       number(5) NOT NULL,      /*项次                                   */
vio03       varchar2(10),            /*积分使用规则编码                       */
vioacti     varchar2(1)              /*资料有效码                             */
);

alter table vio_file add  constraint vio_pk primary key  (vio01,vio02) enable validate;
grant select on vio_file to tiptopgp;
grant update on vio_file to tiptopgp;
grant delete on vio_file to tiptopgp;
grant insert on vio_file to tiptopgp;
grant index on vio_file to public;
grant select on vio_file to ods;
