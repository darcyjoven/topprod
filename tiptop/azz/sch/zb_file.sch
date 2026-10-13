/*
================================================================================
檔案代號:zb_file
檔案名稱:DSZ系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zb_file
(
zb00        varchar2(1) NOT NULL,    /*KEY VALUE(0)                           */
zb01        varchar2(1),             /*数据库是否使用 Transaction Log         */
                                     /*資料庫是否使用 Transaction Log (Y/N)   */
zb02        varchar2(1),             /*用户定义方式                           */
                                     /*使用者定義方式 (1)Login user (2)TTY no */
zb03        varchar2(1)              /*日期使用方式                           */
                                     /*日期使用方式 (1)西元 (2)民國           */
                                     /* (0)民國 DBDATE=Y2MD/C1 僅 4.0 版有效  */
                                     /* (1)西元 DBDATE=Y2MD/   .Default.      */
);

alter table zb_file add  constraint zb_pk primary key  (zb00) enable validate;
grant select on zb_file to tiptopgp;
grant update on zb_file to tiptopgp;
grant delete on zb_file to tiptopgp;
grant insert on zb_file to tiptopgp;
grant index on zb_file to public;
grant select on zb_file to ods;
