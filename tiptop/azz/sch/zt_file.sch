/*
================================================================================
檔案代號:zt_file
檔案名稱:档案名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zt_file
(
zt01        varchar2(15) NOT NULL,   /*档案编号                               */
zt02        varchar2(80),            /*档案名称                               */
zt02e       varchar2(80),            /*档案英文名称                           */
zt02c       varchar2(80),            /*档案简体中文名称                       */
zt03        varchar2(3),             /*系统                                   */
zt04        varchar2(4),             /*使用别                                 */
zt05        date,                    /*生成日期                               */
zt06        varchar2(10),            /*生成者                                 */
zt07        varchar2(1),             /*T/S建议 (Table/Synonym)                */
zt08        number(5),               /*No Use                                 */
zt09        varchar2(2),             /*档案类型                               */
zt10        varchar2(1),             /*No Use                                 */
zt11        varchar2(1),             /*No Use                                 */
zt12        varchar2(1),             /*No Use                                 */
zt13        varchar2(1)              /*No Use                                 */
);

alter table zt_file add  constraint zt_pk primary key  (zt01) enable validate;
grant select on zt_file to tiptopgp;
grant update on zt_file to tiptopgp;
grant delete on zt_file to tiptopgp;
grant insert on zt_file to tiptopgp;
grant index on zt_file to public;
grant select on zt_file to ods;
