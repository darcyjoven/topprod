/*
================================================================================
檔案代號:gac_file
檔案名稱:动态查询设置单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gac_file
(
gac01       varchar2(20) NOT NULL,   /*程序编号                               */
gac02       number(5) NOT NULL,      /*字段显示顺序                           */
gac03       number(5) NOT NULL,      /*资料版本                               */
gac04       varchar2(20),            /*资料数据库代码                         */
gac05       varchar2(20),            /*资料资料表名称                         */
gac06       varchar2(20),            /*资料字段名称                           */
gac07       varchar2(1),             /*字段使用类型                           */
gac08       varchar2(10),            /*变更人员zx代码                         */
gac09       number(5),               /*显示字段宽度                           */
gac10       varchar2(1),             /*字段是否回传                           */
gac11       varchar2(1),             /*Table是否为Outer                       */
gac12       varchar2(1) NOT NULL,    /*客制码                                 */
gac13       varchar2(255),           /*字段录入限制设置                       */
gac14       varchar2(1),             /*No Use                                 */
gac15       varchar2(20)             /*串查程序代码                           */
);

alter table gac_file add  constraint gac_pk primary key  (gac01,gac12,gac02,gac03) enable validate;
grant select on gac_file to tiptopgp;
grant update on gac_file to tiptopgp;
grant delete on gac_file to tiptopgp;
grant insert on gac_file to tiptopgp;
grant index on gac_file to public;
grant select on gac_file to ods;
