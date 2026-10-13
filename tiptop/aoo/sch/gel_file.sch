/*
================================================================================
檔案代號:gel_file
檔案名稱:编码类型资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gel_file
(
gel01       varchar2(10) NOT NULL,   /*编码类型                               */
gel02       number(5) NOT NULL,      /*段次                                   */
gel03       number(5),               /*长度                                   */
gel04       varchar2(1),             /*类型                                   */
gel05       varchar2(10),            /*固定值/独立段编号                      */
gel06       varchar2(80),            /*段次说明                               */
gel07       varchar2(1)              /*名称显示否                             */
);

alter table gel_file add  constraint gel_pk primary key  (gel01,gel02) enable validate;
grant select on gel_file to tiptopgp;
grant update on gel_file to tiptopgp;
grant delete on gel_file to tiptopgp;
grant insert on gel_file to tiptopgp;
grant index on gel_file to public;
grant select on gel_file to ods;
