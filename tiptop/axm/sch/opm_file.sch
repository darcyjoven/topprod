/*
================================================================================
檔案代號:opm_file
檔案名稱:产品别预计产量单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table opm_file
(
opm01       varchar2(10) NOT NULL,   /*产品别                                 */
                                     /*產品別                                 */
opm02       varchar2(10) NOT NULL,   /*版本                                   */
opm03       number(5) NOT NULL,      /*年度                                   */
opm04       varchar2(1),             /*No Use                                 */
opm05       varchar2(1),             /*No Use                                 */
opm06       varchar2(1),             /*No Use                                 */
opmacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
opmuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
opmgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
opmmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
opmdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
opmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
opmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
opmoriu     varchar2(10),            /*资料建立者                             */
opmorig     varchar2(10)             /*资料建立部门                           */
);

alter table opm_file add  constraint opm_pk primary key  (opm01,opm02,opm03) enable validate;
grant select on opm_file to tiptopgp;
grant update on opm_file to tiptopgp;
grant delete on opm_file to tiptopgp;
grant insert on opm_file to tiptopgp;
grant index on opm_file to public;
grant select on opm_file to ods;
