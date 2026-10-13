/*
================================================================================
檔案代號:sfd_file
檔案名稱:料表批号明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sfd_file
(
sfd01       varchar2(20) NOT NULL,   /*料表批号(PBI number)                   */
                                     /*料表批號  (PBI number)                 */
                                     /*儲存合併料表的批次編號                 */
                                     /*此號碼可作為工單領/發料及料帳扣除時的  */
                                     /*處理依據                               */
sfd02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
                                     /*儲存該批號歸屬工單順序序號             */
sfd03       varchar2(20),            /*工单编号                               */
                                     /*工單編號                               */
                                     /*儲存該料表批號所屬工單編號             */
sfd91       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂                             */
sfd92       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂                             */
sfd93       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂                             */
sfd94       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂                             */
sfd95       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂                             */
sfd04       number(5),               /*合拼序                                 */
sfd05       number(10),              /*模数                                   */
sfd06       number(10),              /*总模数                                 */
sfd07       varchar2(10),            /*被取代工艺段号                         */
sfd08       varchar2(20),            /*合拼版号                               */
sfdconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
sfd09       varchar2(1) DEFAULT '1' NOT NULL, /*资料类型*/
sfdacti     varchar2(1) DEFAULT ' ' NOT NULL,
sfddate     date,
sfdgrup     varchar2(10),
sfdmodu     varchar2(10),
sfduser     varchar2(10),
sfdorig     varchar2(10),
sfdoriu     varchar2(10)
);

create        index sfd_02 on sfd_file (sfd03);
alter table sfd_file add  constraint sfd_pk primary key  (sfd01,sfd02) enable validate;
grant select on sfd_file to tiptopgp;
grant update on sfd_file to tiptopgp;
grant delete on sfd_file to tiptopgp;
grant insert on sfd_file to tiptopgp;
grant index on sfd_file to public;
grant select on sfd_file to ods;
