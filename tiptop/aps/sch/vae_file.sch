/*
================================================================================
檔案代號:vae_file
檔案名稱:aps資源群組
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vae_file
(
vae01       varchar2(60) DEFAULT ' ' NOT NULL, /*资源群组编号*/
vae02       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
vae03       varchar2(60),            /*APS保留字段文字                        */
vae04       varchar2(60),            /*APS保留字段文字                        */
vae05       varchar2(60),            /*APS保留字段文字                        */
vae06       number(9),               /*APS保留字段数值                        */
vae07       number(18,8),            /*APS保留字段浮点数                      */
vae08       number(18,8),            /*APS保留字段浮点数                      */
vae09       date,                    /*APS保留字段日期                        */
vae10       date,                    /*APS保留字段日期                        */
vaelegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vaeplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vae_file add  constraint vae_pk primary key  (vaelegal,vaeplant,vae01,vae02) enable validate;
grant select on vae_file to tiptopgp;
grant update on vae_file to tiptopgp;
grant delete on vae_file to tiptopgp;
grant insert on vae_file to tiptopgp;
grant index on vae_file to public;
grant select on vae_file to ods;
