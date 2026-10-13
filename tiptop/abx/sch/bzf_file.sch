/*
================================================================================
檔案代號:bzf_file
檔案名稱:保税机器设备盘点底稿单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bzf_file
(
bzf01       varchar2(10) NOT NULL,   /*盘点编号                               */
bzf02       number(5) NOT NULL,      /*项次                                   */
bzf03       varchar2(20),            /*机器设备编号                           */
bzf04       number(5),               /*序号                                   */
bzf05       number(15,3),            /*结余帐面数量                           */
bzf06       number(15,3),            /*外送数量                               */
bzf07       number(15,3),            /*盘点数量                               */
bzf08       varchar2(255),           /*备注                                   */
bzf09       varchar2(1),             /*No Use                                 */
bzf10       varchar2(1)              /*No Use                                 */
);

alter table bzf_file add  constraint bzf_pk primary key  (bzf01,bzf02) enable validate;
grant select on bzf_file to tiptopgp;
grant update on bzf_file to tiptopgp;
grant delete on bzf_file to tiptopgp;
grant insert on bzf_file to tiptopgp;
grant index on bzf_file to public;
grant select on bzf_file to ods;
