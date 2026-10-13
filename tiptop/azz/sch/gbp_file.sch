/*
================================================================================
檔案代號:gbp_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gbp_file
(
gbp01       varchar2(20) NOT NULL,   /*程序编号                               */
gbp02       varchar2(1) NOT NULL,    /*语言别                                 */
gbp03       varchar2(500),           /*作业目的                               */
gbp04       varchar2(1),             /*客制码                                 */
gbp05       varchar2(1),             /*No Use                                 */
gbpuser     varchar2(10),            /*Owner                                  */
gbpgrup     varchar2(10),            /*Group                                  */
gbpmodu     varchar2(10),            /*Modify User                            */
gbpdate     date,                    /*Modify Date                            */
gbporig     varchar2(10),            /*资料建立部门                           */
gbporiu     varchar2(10)             /*资料建立者                             */
);

alter table gbp_file add  constraint gbp_pk primary key  (gbp01,gbp02) enable validate;
grant select on gbp_file to tiptopgp;
grant update on gbp_file to tiptopgp;
grant delete on gbp_file to tiptopgp;
grant insert on gbp_file to tiptopgp;
grant index on gbp_file to public;
grant select on gbp_file to ods;
