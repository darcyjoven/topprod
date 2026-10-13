/*
================================================================================
檔案代號:gbf_file
檔案名稱:程序作业特色维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gbf_file
(
gbf01       varchar2(20) NOT NULL,   /*程序代码                               */
gbf02       varchar2(1) NOT NULL,    /*语言别                                 */
gbf03       number(5) NOT NULL,      /*主项次                                 */
gbf04       number(5) NOT NULL,      /*次项次                                 */
gbf05       varchar2(500),           /*程序特点                               */
gbf06       varchar2(1),             /*No Use                                 */
gbf07       varchar2(1),             /*No Use                                 */
gbfuser     varchar2(10),            /*资料所有者                             */
gbfgrup     varchar2(10),            /*资料建立部门                           */
gbfmodu     varchar2(10),            /*资料更改者                             */
gbfdate     date,                    /*资料建立日期                           */
gbforig     varchar2(10),            /*资料建立部门                           */
gbforiu     varchar2(10)             /*资料建立者                             */
);

alter table gbf_file add  constraint gbf_pk primary key  (gbf01,gbf02,gbf03,gbf04) enable validate;
grant select on gbf_file to tiptopgp;
grant update on gbf_file to tiptopgp;
grant delete on gbf_file to tiptopgp;
grant insert on gbf_file to tiptopgp;
grant index on gbf_file to public;
grant select on gbf_file to ods;
