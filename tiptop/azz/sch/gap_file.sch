/*
================================================================================
檔案代號:gap_file
檔案名稱:程序与ACTION关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gap_file
(
gap01       varchar2(20) NOT NULL,   /*程序代碼                               */
gap02       varchar2(80) NOT NULL,   /*Action 代碼                            */
gap03       varchar2(1),             /*自設註記                               */
gap04       varchar2(1),             /*单身属性注记                           */
gap05       varchar2(1),             /*是否置入topmenu (4tm)                  */
gap06       varchar2(1),             /*Action 是否被抓取的設置旗標            */
gap07       varchar2(1),             /*No Use                                 */
gap08       varchar2(25)             /*快速键                                 */
);

alter table gap_file add  constraint gap_pk primary key  (gap01,gap02) enable validate;
grant select on gap_file to tiptopgp;
grant update on gap_file to tiptopgp;
grant delete on gap_file to tiptopgp;
grant insert on gap_file to tiptopgp;
grant index on gap_file to public;
grant select on gap_file to ods;
