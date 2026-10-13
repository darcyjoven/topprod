/*
================================================================================
檔案代號:occg_file
檔案名稱:客户信用额度GLOBAL档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table occg_file
(
occg01      varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
occg02      varchar2(20),            /*税号                                   */
                                     /*統一編號                               */
occg03      number(20,6),            /*信用额度额度                           */
                                     /*信用額度額度                           */
occg04      number(5)                /*信用额度容许超出率                     */
                                     /*信用額度容許超出率                     */
);

create        index occg_02 on occg_file (occg02);
alter table occg_file add  constraint occg_pk primary key  (occg01) enable validate;
grant select on occg_file to tiptopgp;
grant update on occg_file to tiptopgp;
grant delete on occg_file to tiptopgp;
grant insert on occg_file to tiptopgp;
grant index on occg_file to public;
grant select on occg_file to ods;
