/*
================================================================================
檔案代號:ztb_file
檔案名稱:档案名称单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table ztb_file
(
ztb01       varchar2(15) NOT NULL,   /*档案编号                               */
                                     /*Table name                             */
ztb02       varchar2(10) NOT NULL,   /*database name                          */
ztb03       varchar2(30) NOT NULL,   /*字段代码                               */
ztb04       varchar2(20),            /*data type                              */
ztb05       varchar2(1),             /*属性                                   */
ztb06       varchar2(7),             /*中文说明                               */
                                     /*開始 for datetime                      */
ztb07       varchar2(7),             /*英文说明                               */
                                     /*結束 for datetime                      */
ztb08       varchar2(8),             /*简体说明                               */
                                     /*長度                                   */
ztb09       varchar2(1),             /*No Use                                 */
ztb10       number(5),               /*No Use                                 */
ztb11       varchar2(15)             /*缺省值                                 */
);

alter table ztb_file add  constraint ztb_pk primary key  (ztb01,ztb02,ztb03) enable validate;
grant select on ztb_file to tiptopgp;
grant update on ztb_file to tiptopgp;
grant delete on ztb_file to tiptopgp;
grant insert on ztb_file to tiptopgp;
grant index on ztb_file to public;
grant select on ztb_file to ods;
