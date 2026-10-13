/*
================================================================================
檔案代號:gci_file
檔案名稱:Express 报表清单
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gci_file
(
gci01       varchar2(5) NOT NULL,    /*报表类型                               */
gci02       varchar2(20) NOT NULL,   /*报表 ID                                */
gci03       varchar2(256) NOT NULL,  /*报表名称                               */
gci04       varchar2(256),           /*报表类型                               */
gci05       varchar2(30),            /*报表 Cuid                              */
gci06       varchar2(80),            /*说明                                   */
gci07       varchar2(1)              /*是否为 Express 报表                    */
);

alter table gci_file add  constraint gci_pk primary key  (gci01,gci02) enable validate;
grant select on gci_file to tiptopgp;
grant update on gci_file to tiptopgp;
grant delete on gci_file to tiptopgp;
grant insert on gci_file to tiptopgp;
grant index on gci_file to public;
grant select on gci_file to ods;
