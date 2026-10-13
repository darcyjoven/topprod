/*
================================================================================
檔案代號:gzln_file
檔案名稱:软件代工开发记录(程序更改档案清单)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gzln_file
(
gzln00      varchar2(20) NOT NULL,   /*审核单号                               */
gzln01      number(5) NOT NULL,      /*项次                                   */
gzln02      number(5) NOT NULL,      /*行序                                   */
gzln03      varchar2(4),             /*系统                                   */
gzln04      varchar2(4),             /*档案类型/目录名称                      */
gzln05      varchar2(255),           /*档案名称                               */
gzln06      varchar2(255),           /*备注                                   */
gzln07      number(5) NOT NULL       /*版次                                   */
);

alter table gzln_file add  constraint gzln_pk primary key  (gzln00,gzln01,gzln07,gzln02) enable validate;
grant select on gzln_file to tiptopgp;
grant update on gzln_file to tiptopgp;
grant delete on gzln_file to tiptopgp;
grant insert on gzln_file to tiptopgp;
grant index on gzln_file to public;
grant select on gzln_file to ods;
