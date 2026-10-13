/*
================================================================================
檔案代號:nmo_file
檔案名稱:票别说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nmo_file
(
nmo01       varchar2(2) NOT NULL,    /*票别                                   */
                                     /*票別                                   */
nmo02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
nmoacti     varchar2(1),             /*有效码                                 */
                                     /*有效碼                                 */
nmouser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nmogrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nmomodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
nmodate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nmoorig     varchar2(10),            /*资料建立部门                           */
nmooriu     varchar2(10)             /*资料建立者                             */
);

alter table nmo_file add  constraint nmo_pk primary key  (nmo01) enable validate;
grant select on nmo_file to tiptopgp;
grant update on nmo_file to tiptopgp;
grant delete on nmo_file to tiptopgp;
grant insert on nmo_file to tiptopgp;
grant index on nmo_file to public;
grant select on nmo_file to ods;
