/*
================================================================================
檔案代號:gcz_file
檔案名稱:CR 报表预览设定单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gcz_file
(
gcz01       varchar2(80) NOT NULL,   /*程序编号                               */
gcz02       varchar2(1) NOT NULL,    /*客制码                                 */
gcz03       varchar2(10) NOT NULL,   /*权限类型                               */
gcz04       varchar2(10) NOT NULL,   /*用户                                   */
gcz05       number(5) NOT NULL,      /*序号                                   */
gcz06       varchar2(1) NOT NULL,    /*语言别                                 */
gcz07       varchar2(80),            /*字段编号                               */
gcz08       varchar2(80),            /*显示名称                               */
gcz09       varchar2(255),           /*备注                                   */
gcz10       number(10),              /*字段宽度                               */
gcz11       varchar2(1),             /*字段属性                               */
gcz12       varchar2(1) DEFAULT 'N', /*隐藏是否                               */
gcz13       number(5)                /*字段顺序                               */
);

alter table gcz_file add  constraint gcz_pk primary key  (gcz01,gcz02,gcz03,gcz04,gcz05,gcz06) enable validate;
grant select on gcz_file to tiptopgp;
grant update on gcz_file to tiptopgp;
grant delete on gcz_file to tiptopgp;
grant insert on gcz_file to tiptopgp;
grant index on gcz_file to public;
grant select on gcz_file to ods;
