/*
================================================================================
檔案代號:skr_file
檔案名稱:工单版片资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table skr_file
(
skr01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单单号*/
skr02       number(10) NOT NULL,     /*工艺序号                               */
skr03       number(10) DEFAULT '0' NOT NULL, /*版片序号*/
skr04       varchar2(40) DEFAULT ' ' NOT NULL, /*元件料号*/
skr05       varchar2(10) DEFAULT ' ' NOT NULL, /*部位*/
skr06       number(15,3) DEFAULT '0' NOT NULL, /*单件片数*/
skr07       number(15,3) DEFAULT '0' NOT NULL, /*良品件数*/
skr08       number(15,3),            /*已移转件数                             */
skrplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skrlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table skr_file add  constraint skr_pk primary key  (skr01,skr02,skr03) enable validate;
grant select on skr_file to tiptopgp;
grant update on skr_file to tiptopgp;
grant delete on skr_file to tiptopgp;
grant insert on skr_file to tiptopgp;
grant index on skr_file to public;
grant select on skr_file to ods;
