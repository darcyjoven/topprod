/*
================================================================================
檔案代號:lms_file
檔案名稱:合同状态颜色设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lms_file
(
lms01       varchar2(2) DEFAULT ' ' NOT NULL, /*合同状态*/
lms02       varchar2(10),            /*颜色                                   */
lms03       varchar2(30),            /*说明                                   */
lmsacti     varchar2(1),             /*资料有效码                             */
lmscrat     date,                    /*资料创建日                             */
lmsdate     date,                    /*资料更改日                             */
lmsgrup     varchar2(10),            /*资料所有群                             */
lmsmodu     varchar2(10),            /*资料更改者                             */
lmsuser     varchar2(10),            /*资料所有者                             */
lmsorig     varchar2(10),            /*资料建立部门                           */
lmsoriu     varchar2(10)             /*资料建立者                             */
);

alter table lms_file add  constraint lms_pk primary key  (lms01) enable validate;
grant select on lms_file to tiptopgp;
grant update on lms_file to tiptopgp;
grant delete on lms_file to tiptopgp;
grant insert on lms_file to tiptopgp;
grant index on lms_file to public;
grant select on lms_file to ods;
