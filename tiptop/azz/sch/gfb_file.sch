/*
================================================================================
檔案代號:gfb_file
檔案名稱:客户开发记录
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gfb_file
(
gfb01       varchar2(20) NOT NULL,   /*开发单号                               */
gfb02       varchar2(1),             /*状态码                                 */
gfb03       varchar2(10),            /*程序人员                               */
gfb04       varchar2(20),            /*程序代码                               */
gfb05       date,                    /*预计完成日                             */
gfb06       number(8,4),             /*预计时数                               */
gfb07       date,                    /*实际完成日                             */
gfb08       number(8,4),             /*实际完成时数                           */
gfb09       varchar2(10),            /*验收人员                               */
gfb10       date,                    /*验收完成日                             */
gfb11       varchar2(1500),          /*更新说明                               */
gfb12       varchar2(255),           /*程序资料打包下载位置                   */
gfb13       varchar2(255),           /*数据库打包下载位置                     */
gfb14       varchar2(40),            /*实际更改人员                           */
gfb15       varchar2(40),            /*实际验收人员                           */
gfb16       varchar2(1)              /*客制单位                               */
);

alter table gfb_file add  constraint gfb_pk primary key  (gfb01) enable validate;
grant select on gfb_file to tiptopgp;
grant update on gfb_file to tiptopgp;
grant delete on gfb_file to tiptopgp;
grant insert on gfb_file to tiptopgp;
grant index on gfb_file to public;
grant select on gfb_file to ods;
