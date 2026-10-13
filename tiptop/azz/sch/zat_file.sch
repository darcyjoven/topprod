/*
================================================================================
檔案代號:zat_file
檔案名稱:动态查询参数设置档案
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zat_file
(
zat01       varchar2(80) NOT NULL,   /*查询单id                               */
zat02       number(5) NOT NULL,      /*序号                                   */
zat03       varchar2(1),             /*打印显示设置                           */
zat04       number(5),               /*查询视窗显示顺序                       */
zat05       varchar2(1),             /*开窗(qbe)                              */
zat06       varchar2(20),            /*查询程序代码                           */
zat07       varchar2(1),             /*小数位设置                             */
zat08       varchar2(1),             /*字段属性                               */
zat09       varchar2(20),            /*币种字段/小数位                        */
zat10       varchar2(1) NOT NULL,    /*客制码                                 */
zat11       varchar2(1),             /*资料转换                               */
zat12       number(10)               /*画面字段宽度                           */
);

alter table zat_file add  constraint zat_pk primary key  (zat01,zat02,zat10) enable validate;
grant select on zat_file to tiptopgp;
grant update on zat_file to tiptopgp;
grant delete on zat_file to tiptopgp;
grant insert on zat_file to tiptopgp;
grant index on zat_file to public;
grant select on zat_file to ods;
