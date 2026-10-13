/*
================================================================================
檔案代號:rxe_file
檔案名稱:券销售销退明细档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxe_file
(
rxe00       varchar2(2) DEFAULT ' ' NOT NULL, /*单据别*/
rxe01       varchar2(20) DEFAULT ' ' NOT NULL, /*单号*/
rxe02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rxe03       number(5) DEFAULT '0' NOT NULL, /*序*/
rxe04       varchar2(20),            /*券起始编号                             */
rxe05       varchar2(20),            /*券结束编号                             */
rxe06       varchar2(20),            /*券种编号                               */
rxe07       varchar2(10),            /*券面额编号                             */
rxe08       number(20) DEFAULT '0' NOT NULL, /*券张数*/
rxe09       number(20,6) DEFAULT '0' NOT NULL, /*总金额*/
rxelegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rxeplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rxe_file add  constraint rxe_pk primary key  (rxe00,rxe01,rxe02,rxe03) enable validate;
grant select on rxe_file to tiptopgp;
grant update on rxe_file to tiptopgp;
grant delete on rxe_file to tiptopgp;
grant insert on rxe_file to tiptopgp;
grant index on rxe_file to public;
grant select on rxe_file to ods;
