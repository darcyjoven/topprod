/*
================================================================================
檔案代號:gdr_file
檔案名稱:XtraGrid 报表样版记录单头文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdr_file
(
gdr00       number(5) DEFAULT '0' NOT NULL,
gdr01       varchar2(20),            /*程序编号                               */
gdr02       varchar2(20),            /*样板编号                               */
gdr03       varchar2(1) DEFAULT ' ' NOT NULL, /*客制否*/
gdr04       varchar2(10),
gdr05       varchar2(10),            /*权限类型                               */
gdr06       varchar2(1) DEFAULT ' ' NOT NULL, /*报表类型*/
gdr07       varchar2(1) DEFAULT ' ' NOT NULL, /*打印签核*/
gdr08       varchar2(1) DEFAULT ' ' NOT NULL, /*打印签核位置*/
gdr09       varchar2(5),             /*行业别                                 */
gdr10       varchar2(1) DEFAULT ' ' NOT NULL,
gdr11       varchar2(1) DEFAULT ' ' NOT NULL,
gdr12       varchar2(1) DEFAULT ' ' NOT NULL,
gdr13       varchar2(1) DEFAULT ' ' NOT NULL,
gdrdate     date,                    /*最近更改日                             */
gdrgrup     varchar2(10),            /*资料所有群                             */
gdrmodu     varchar2(10),            /*资料更改者                             */
gdrorig     varchar2(10),            /*资料建立部门                           */
gdroriu     varchar2(10),            /*资料建立者                             */
gdruser     varchar2(10),            /*资料所有者                             */
gdr14       number(5),
gdr15       varchar2(20),
gdr16       varchar2(500),
gdr17       varchar2(500),
gdr18       varchar2(1000),
gdr19       varchar2(1) DEFAULT ' ' NOT NULL,
gdr20       number(5),
gdr21       number(10)               /*Time Out Setting                       */
);

alter table gdr_file add  constraint gdr_pk primary key  (gdr00) enable validate;
grant select on gdr_file to tiptopgp;
grant update on gdr_file to tiptopgp;
grant delete on gdr_file to tiptopgp;
grant insert on gdr_file to tiptopgp;
grant index on gdr_file to public;
grant select on gdr_file to ods;
