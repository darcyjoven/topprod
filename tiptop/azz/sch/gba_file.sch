/*
================================================================================
檔案代號:gba_file
檔案名稱:SOP情境资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gba_file
(
gba01       varchar2(10) NOT NULL,   /*SOP编号                                */
gba011      varchar2(500),           /*SOP名称                                */
gba02       varchar2(10) NOT NULL,   /*情境编号                               */
gba021      varchar2(80),            /*说明                                   */
gba03       varchar2(10) NOT NULL,   /*版本                                   */
gba04       varchar2(1) NOT NULL,    /*语言别                                 */
gba05       varchar2(255),           /*作业目的                               */
gba06       varchar2(5),             /*模组编号                               */
gba07       varchar2(80),            /*负责部门                               */
gba08       varchar2(80),            /*负责人员                               */
gba09       date,                    /*制作日期                               */
gba10       varchar2(20),            /*文件档名                               */
gba11       varchar2(255),           /*备注                                   */
gba12       varchar2(255),           /*测试纪录                               */
gba13       varchar2(1),             /*No Use                                 */
gba14       varchar2(1),             /*No Use                                 */
gba15       varchar2(1)              /*No Use                                 */
);

alter table gba_file add  constraint gba_pk primary key  (gba01,gba02,gba03,gba04) enable validate;
grant select on gba_file to tiptopgp;
grant update on gba_file to tiptopgp;
grant delete on gba_file to tiptopgp;
grant insert on gba_file to tiptopgp;
grant index on gba_file to public;
grant select on gba_file to ods;
